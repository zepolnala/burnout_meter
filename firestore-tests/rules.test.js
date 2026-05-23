const { initializeTestEnvironment, assertSucceeds, assertFails } = require('@firebase/rules-unit-testing');
const fs = require('fs');
const path = require('path');

describe('Firestore Security Rules Compliance Tests', () => {
  let testEnv;

  before(async () => {
    testEnv = await initializeTestEnvironment({
      projectId: 'demo-burnoutmeter',
      firestore: {
        rules: fs.readFileSync(path.resolve(__dirname, '../firestore.rules'), 'utf8'),
        host: '127.0.0.1',
        port: 8080,
      },
    });
  });

  beforeEach(async () => {
    await testEnv.clearFirestore();
  });

  after(async () => {
    await testEnv.cleanup();
  });

  // Helpers to seed documents with security rules disabled
  async function seedDoc(collection, docId, data) {
    await testEnv.withSecurityRulesDisabled(async (context) => {
      const db = context.firestore();
      await db.collection(collection).doc(docId).set(data);
    });
  }

  // --- TESTS SECTION ---

  describe('1. Raw Biometrics (healthSamples) Separation', () => {
    it('✅ Employee can read and write their own raw biometrics', async () => {
      const db = testEnv.authenticatedContext('emp123').firestore();
      const ref = db.collection('healthSamples').doc('sampleA');

      // Writing own data
      await assertSucceeds(ref.set({
        id: 'sampleA',
        userId: 'emp123',
        type: 'heart_rate',
        value: 75.0,
      }));

      // Reading own data
      await assertSucceeds(ref.get());
    });

    it('❌ Employee CANNOT read another employee\'s biometrics', async () => {
      await seedDoc('healthSamples', 'sampleB', {
        id: 'sampleB',
        userId: 'emp456',
        type: 'heart_rate',
        value: 80.0,
      });

      const db = testEnv.authenticatedContext('emp123').firestore();
      const ref = db.collection('healthSamples').doc('sampleB');

      await assertFails(ref.get());
    });

    it('❌ Manager CANNOT read employee\'s raw healthSamples (Privacy-by-Design)', async () => {
      // Even if the employee is on their team, managers are blocked from raw signals!
      await seedDoc('healthSamples', 'sampleB', {
        id: 'sampleB',
        userId: 'emp456',
        type: 'heart_rate',
        value: 80.0,
      });

      const db = testEnv.authenticatedContext('mgrEng', {
        role: 'manager',
        orgId: 'org789',
      }).firestore();
      const ref = db.collection('healthSamples').doc('sampleB');

      await assertFails(ref.get());
    });
  });

  describe('2. Employee Burnout Scores & Consent Sharing', () => {
    beforeEach(async () => {
      // Seed employee membership
      await seedDoc('memberships', 'emp123', {
        userId: 'emp123',
        orgId: 'org789',
        teamId: 'teamEng',
        role: 'employee',
      });
      // Seed manager membership with managedTeamIds
      await seedDoc('memberships', 'mgrEng', {
        userId: 'mgrEng',
        orgId: 'org789',
        role: 'manager',
        managedTeamIds: ['teamEng'],
      });
    });

    it('✅ Employee can read their own calculated burnout score', async () => {
      await seedDoc('scores', 'scoreA', {
        id: 'scoreA',
        userId: 'emp123',
        teamId: 'teamEng',
        orgId: 'org789',
        burnoutIndex: 35.0,
      });

      const db = testEnv.authenticatedContext('emp123').firestore();
      await assertSucceeds(db.collection('scores').doc('scoreA').get());
    });

    it('❌ Employee CANNOT read another employee\'s burnout score', async () => {
      await seedDoc('scores', 'scoreB', {
        id: 'scoreB',
        userId: 'emp456',
        teamId: 'teamEng',
        orgId: 'org789',
        burnoutIndex: 45.0,
      });

      const db = testEnv.authenticatedContext('emp123').firestore();
      await assertFails(db.collection('scores').doc('scoreB').get());
    });

    it('✅ Manager can read team employee\'s score if sharingEnabled == true', async () => {
      // 1. Seed consent sharing = true
      await seedDoc('consents', 'emp123', {
        userId: 'emp123',
        sharingEnabled: true,
        actionsEnabled: true,
      });
      // 2. Seed score
      await seedDoc('scores', 'scoreA', {
        id: 'scoreA',
        userId: 'emp123',
        teamId: 'teamEng',
        orgId: 'org789',
        burnoutIndex: 35.0,
      });

      const db = testEnv.authenticatedContext('mgrEng', {
        role: 'manager',
        orgId: 'org789',
      }).firestore();

      await assertSucceeds(db.collection('scores').doc('scoreA').get());
    });

    it('❌ Manager CANNOT read team employee\'s score if sharingEnabled == false (Consent Enforced)', async () => {
      // 1. Seed consent sharing = false
      await seedDoc('consents', 'emp123', {
        userId: 'emp123',
        sharingEnabled: false,
        actionsEnabled: true,
      });
      // 2. Seed score
      await seedDoc('scores', 'scoreA', {
        id: 'scoreA',
        userId: 'emp123',
        teamId: 'teamEng',
        orgId: 'org789',
        burnoutIndex: 35.0,
      });

      const db = testEnv.authenticatedContext('mgrEng', {
        role: 'manager',
        orgId: 'org789',
      }).firestore();

      await assertFails(db.collection('scores').doc('scoreA').get());
    });

    it('❌ Manager CANNOT read employee score of another team', async () => {
      // Employee is in Customer Success team
      await seedDoc('memberships', 'empCS', {
        userId: 'empCS',
        orgId: 'org789',
        teamId: 'teamCS',
        role: 'employee',
      });
      await seedDoc('consents', 'empCS', {
        userId: 'empCS',
        sharingEnabled: true,
      });
      await seedDoc('scores', 'scoreCS', {
        id: 'scoreCS',
        userId: 'empCS',
        teamId: 'teamCS',
        orgId: 'org789',
        burnoutIndex: 40.0,
      });

      // Manager managing teamEng tries to read CS employee
      const db = testEnv.authenticatedContext('mgrEng', {
        role: 'manager',
        orgId: 'org789',
      }).firestore();

      await assertFails(db.collection('scores').doc('scoreCS').get());
    });
  });

  describe('2.5 Privilege Escalation Prevention', () => {
    it('❌ Normal User CANNOT create Admin membership', async () => {
      const db = testEnv.authenticatedContext('attackerUid', { email: 'hacker@gmail.com' }).firestore();
      
      await assertFails(db.collection('memberships').doc('attackerUid').set({
        userId: 'attackerUid',
        role: 'admin',
        orgId: 'org123'
      }));
    });

    it('✅ Demo User CAN create Admin membership', async () => {
      const db = testEnv.authenticatedContext('demoAdmUid', { email: 'ceo@burnoutmeter.demo' }).firestore();
      
      await assertSucceeds(db.collection('memberships').doc('demoAdmUid').set({
        userId: 'demoAdmUid',
        role: 'admin',
        orgId: 'org123'
      }));
    });

    it('❌ User CANNOT update their role after creation', async () => {
      // Seed legit employee profile
      await seedDoc('memberships', 'empSpoof', {
        userId: 'empSpoof',
        role: 'employee',
        orgId: 'org123'
      });

      const db = testEnv.authenticatedContext('empSpoof', { email: 'hacker@gmail.com' }).firestore();
      
      // Attempting to escalate privileges
      await assertFails(db.collection('memberships').doc('empSpoof').update({
        role: 'manager',
        managedTeamIds: ['team1']
      }));
    });
  });

  describe('3. Multi-Tenant Separation', () => {
    it('✅ Admin can read memberships within own organization', async () => {
      // Seed the admin membership
      await seedDoc('memberships', 'adm789', {
        userId: 'adm789',
        orgId: 'org789',
        role: 'admin',
      });

      await seedDoc('memberships', 'someUser', {
        userId: 'someUser',
        orgId: 'org789',
        role: 'employee',
      });

      const db = testEnv.authenticatedContext('adm789').firestore();
      await assertSucceeds(db.collection('memberships').doc('someUser').get());
    });

    it('❌ Admin CANNOT read memberships from another organization', async () => {
      // Seed the admin membership
      await seedDoc('memberships', 'adm789', {
        userId: 'adm789',
        orgId: 'org789',
        role: 'admin',
      });

      await seedDoc('memberships', 'otherUser', {
        userId: 'otherUser',
        orgId: 'orgOther',
        role: 'employee',
      });

      const db = testEnv.authenticatedContext('adm789').firestore();
      await assertFails(db.collection('memberships').doc('otherUser').get());
    });

    it('❌ Manager CANNOT read scores from other organization (Tenant Bypass Prevention)', async () => {
      // 1. Seed manager in OrgA
      await seedDoc('memberships', 'mgrOrgA', {
        userId: 'mgrOrgA',
        orgId: 'OrgA',
        role: 'manager',
        managedTeamIds: ['teamAlpha']
      });

      // 2. Seed Employee in OrgB with the same teamId (spoof) and sharingEnabled
      await seedDoc('memberships', 'empOrgB', {
        userId: 'empOrgB',
        orgId: 'OrgB',
        role: 'employee',
        teamId: 'teamAlpha'
      });
      await seedDoc('consents', 'empOrgB', {
        userId: 'empOrgB',
        sharingEnabled: true
      });
      await seedDoc('scores', 'scoreOrgB', {
        id: 'scoreOrgB',
        userId: 'empOrgB',
        teamId: 'teamAlpha',
        orgId: 'OrgB',
        burnoutIndex: 50.0
      });

      // Manager from OrgA attempts to read score from OrgB due to matching teamId
      const db = testEnv.authenticatedContext('mgrOrgA').firestore();
      await assertFails(db.collection('scores').doc('scoreOrgB').get());
    });
  });

  describe('4. Security Audit Log Ledger (Write-Once)', () => {
    it('✅ Authenticated user can append audit log', async () => {
      const db = testEnv.authenticatedContext('emp123').firestore();
      await assertSucceeds(db.collection('audit_logs').doc('logA').set({
        id: 'logA',
        actorUserId: 'emp123',
        actorRole: 'employee',
        actionType: 'update_consent',
        orgId: 'org789',
        timestamp: new Date().toISOString(),
      }));
    });

    it('❌ NO user can update or delete an audit log (Immutability Enforced)', async () => {
      await seedDoc('audit_logs', 'logA', {
        id: 'logA',
        actorUserId: 'emp123',
        actorRole: 'employee',
        actionType: 'update_consent',
        orgId: 'org789',
      });

      const db = testEnv.authenticatedContext('adm789', {
        role: 'admin',
        orgId: 'org789',
      }).firestore();

      // Attempting to modify
      await assertFails(db.collection('audit_logs').doc('logA').update({
        actionType: 'malicious_modification',
      }));

      // Attempting to delete
      await assertFails(db.collection('audit_logs').doc('logA').delete());
    });
  });
});
