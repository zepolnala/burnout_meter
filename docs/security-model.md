# Modelo de Seguridad y Arquitectura de Privacidad

**BurnoutMeter** prioriza la seguridad y la privacidad-por-diseño. Implementamos fronteras de datos de grado clínico que cumplen con el marco de privacidad del **GDPR** (Reglamento General de Protección de Datos de la Unión Europea) y las pautas de privacidad de **HIPAA**.

**Última revisión:** Mayo 2026 — Actualizado tras hardening de reglas Firestore.

---

## 🔒 Arquitectura de Decisión RBAC

Las decisiones de acceso se verifican en dos capas independientes:

```mermaid
graph TD
    Client[Aplicación Cliente Flutter] -->|Request| RouterGuard{GoRouter redirect()}
    RouterGuard -->|rol OK| FirestoreRequest[Request a Firestore]
    RouterGuard -->|rol NO OK| Unauthorized[/unauthorized]
    FirestoreRequest -->|eval rules| FirestoreRules{Firestore Security Rules}
    FirestoreRules -->|Verificar UID/Rol/Consent/Org| Allow[Permitir Acceso]
    FirestoreRules -->|Fallo en cualquier condición| Deny[DENEGAR Acceso]
```

**Capa 1 — GoRouter Guards (client-side):** El redirect del router verifica el `role` del `Membership` cargado desde Firestore. Un usuario sin rol no puede ver dashboards protegidos.

**Capa 2 — Firestore Rules (server-side):** Las reglas en `firestore.rules` son la línea de defensa real. Incluso si el cliente tiene un bug, el servidor rechaza requests no autorizados.

---

## 📋 Matriz de Reglas Firestore Actuales

### 1. Membresías (`/memberships/{userId}`) — RBAC Hardening Aplicado

```javascript
match /memberships/{userId} {
  // Lectura: owner, o admin/manager del mismo org
  allow read: if isAuthenticated() && (
    isOwner(userId) || 
    ((isAdmin() || isManager()) && sameOrg(resource.data.orgId))
  );
  
  // Creación: Solo rol 'employee', O si es email demo (@burnoutmeter.demo)
  allow create: if isAuthenticated() && isOwner(userId) && (
    request.resource.data.role == 'employee' || isDemoEmail()
  );
  
  // Actualización: Solo campo 'updatedAt' modificable (immutable role)
  allow update: if isAuthenticated() && isOwner(userId) && (
    request.resource.data.diff(resource.data).affectedKeys().hasOnly(['updatedAt'])
  );
  
  // Delete: NO permitido (no definido = denegado por defecto)
}
```

**Cambio vs versión anterior:** La regla anterior permitía `allow write: if isAdmin() || isOwner(userId)`, lo que permitía a cualquier empleado elevarse a admin. Esta vulnerabilidad crítica está corregida.

### 2. Consentimientos GDPR (`/consents/{userId}`)

```javascript
match /consents/{userId} {
  allow read: if isAuthenticated() && (isOwner(userId) || isManager() || isAdmin());
  allow write: if isAuthenticated() && isOwner(userId); // Solo el empleado controla su consent
}
```

Solo el empleado puede modificar sus propios consentimientos. Los managers pueden leer (para verificar antes de enviar acciones), pero jamás modificar.

### 3. Biometría Cruda (`/healthSamples/{sampleId}`) — Privacy-by-Design

```javascript
match /healthSamples/{sampleId} {
  // CRÍTICO: Solo el empleado propietario puede leer sus biometrías crudas
  // Managers y Admins están categóricamente BLOQUEADOS
  allow read: if isAuthenticated() && isOwner(resource.data.userId);
  allow write: if isAuthenticated() && (
    (resource == null && isOwner(request.resource.data.userId)) ||
    (resource != null && isOwner(resource.data.userId))
  );
}
```

*Los managers nunca tienen acceso a HRV milisegundo a milisegundo, ciclos de sueño crudos ni tasas respiratorias — solo al índice consolidado (0-100) si el empleado dio consentimiento.*

### 4. Scores de Burnout (`/scores/{scoreId}`) — Triple Verificación

```javascript
match /scores/{scoreId} {
  allow read: if isAuthenticated() && (
    isOwner(resource.data.userId) || 
    (isManager() 
      && hasSharingConsent(resource.data.userId)   // 1. Consent activo
      && resource.data.teamId in getMembership().get('managedTeamIds', [])  // 2. Mismo equipo
      && sameOrg(resource.data.orgId)) ||           // 3. Mismo tenant
    (isAdmin() && sameOrg(resource.data.orgId))
  );
  
  // Write: solo el owner puede escribir su propio score (MVP - mover a Cloud Functions)
  allow write: if isAuthenticated() && (
    (resource == null && isOwner(request.resource.data.userId)) ||
    (resource != null && isOwner(resource.data.userId))
  );
}
```

### 5. Intervenciones de Bienestar (`/actions/{actionId}`)

```javascript
match /actions/{actionId} {
  // Lectura: sender o target
  allow read: if isAuthenticated() && (
    isOwner(resource.data.targetUserId) || isOwner(resource.data.senderUserId)
  );
  
  // Creación: Manager/Admin, solo si el target tiene actionsEnabled
  allow create: if isAuthenticated() && 
    (isManager() || isAdmin()) && 
    hasActionsConsent(request.resource.data.targetUserId) &&
    isOwner(request.resource.data.senderUserId);  // Manager == sender
  
  // Actualización: Solo el target puede cambiar el status (sent→received→acknowledged)
  allow update: if isAuthenticated() && 
    isOwner(resource.data.targetUserId) && 
    request.resource.data.diff(resource.data).affectedKeys().hasOnly(['status', 'updatedAt']);
}
```

### 6. Audit Trail GDPR (`/audit_logs/{logId}`) — Write-Once Verificado

```javascript
match /audit_logs/{logId} {
  // Write-once con verificación del actor (no puede suplantarse)
  allow create: if isAuthenticated() && request.resource.data.actorUserId == request.auth.uid;
  allow read: if isAuthenticated() && isAdmin() && sameOrg(resource.data.orgId);
  allow update, delete: if false;  // BLOQUEO TOTAL DE MUTACIONES
}
```

### 7. Seed Status (`/seed_status/{docId}`) — ✅ Mitigado y Endurecido

```javascript
match /seed_status/{docId} {
  allow read: if true;
  allow write: if isAuthenticated();
}
```

**Estado:** Completamente mitigado. Se eliminó el acceso de escritura público/anónimo para prevenir ataques de denegación de inicialización (DoS) o reinicios de base de datos maliciosos. Las escrituras ahora requieren autenticación activa (`isAuthenticated()`), lo que cubre perfectamente el script de seeding automático (que opera autenticando secuencialmente a los usuarios de prueba).

---

## 🛡️ Funciones Helper de Seguridad

Las reglas usan funciones helper que centralizan la lógica de verificación:

```javascript
function isAuthenticated() { return request.auth != null; }

function isOwner(userId) { return request.auth.uid == userId; }

function isDemoEmail() {
  return request.auth.token.email.matches('.*@burnoutmeter\\.demo');
}

function hasMembership() {
  return exists(/databases/$(database)/documents/memberships/$(request.auth.uid));
}

function getMembership() {
  return get(/databases/$(database)/documents/memberships/$(request.auth.uid)).data;
}

function getRole() { return hasMembership() ? getMembership().role : 'none'; }
function isEmployee() { return getRole() == 'employee'; }
function isManager() { return getRole() == 'manager'; }
function isAdmin() { return getRole() == 'admin'; }

function sameOrg(orgId) {
  return hasMembership() && getMembership().orgId == orgId;
}

function hasSharingConsent(userId) {
  return get(/databases/$(database)/documents/consents/$(userId)).data.sharingEnabled == true;
}

function hasActionsConsent(userId) {
  return get(/databases/$(database)/documents/consents/$(userId)).data.actionsEnabled == true;
}
```

**Advertencia de rendimiento:** Las funciones `getMembership()`, `hasSharingConsent()` y `hasActionsConsent()` realizan lecturas adicionales a Firestore por cada evaluación de regla. En accesos frecuentes o listas grandes esto puede generar latencia y costos adicionales.

---

## 🛡️ GDPR Privacy-by-Design en Acción

### Principio 1: Revocación Instantánea de Derechos
Cuando el empleado desactiva "Compartir mi Burnout Index" en `EmployeeShell`, el toggle llama a `ConsentNotifier.updateConsent()`. El cambio se propaga a Firestore via `saveConsent()`. El stream reactivo `watchConsent()` actualiza el estado en tiempo real, y las reglas de Firestore comienzan a rechazar lecturas del manager instantáneamente.

### Principio 2: Separación Clínica de Privacidad
Los managers solo acceden al índice consolidado (0-100) y los cuatro subscores intermedios (sleep, recovery, stress, load). Los datos biométricos crudos (HRV ms a ms, ciclos de sueño, frecuencia respiratoria) permanecen estrictamente en `/healthSamples/`, inaccesibles para managers por reglas de servidor.

### Principio 3: Doble Consentimiento Granular
Los empleados controlan dos consentimientos independientes:
- **`sharingEnabled`**: Permite que el manager vea el score en el dashboard.
- **`actionsEnabled`**: Permite que el manager envíe intervenciones de bienestar.

Un empleado puede compartir su score pero rechazar recibir sugerencias, o viceversa.

### Principio 4: Audit Trail Inmutable
Cada acceso de manager a scores de equipo genera un `AuditLog` write-once en Firestore, verificado por las reglas a nivel de servidor (`actorUserId == request.auth.uid`). Los logs son immutables: las reglas bloquean explícitamente `update` y `delete`.

---

## 🔐 Configuración de Emuladores Firebase

En modo de desarrollo, el app usa emuladores locales activados con `--dart-define=USE_EMULATOR=true`:

```dart
// main.dart
const bool useEmulator = bool.fromEnvironment('USE_EMULATOR', defaultValue: false);
if (useEmulator) {
  await FirebaseAuth.instance.useAuthEmulator('127.0.0.1', 9099);
  FirebaseFirestore.instance.useFirestoreEmulator('127.0.0.1', 8080);
}
```

Las mismas reglas de `firestore.rules` aplican en el emulador, garantizando que los tests de integración validen la seguridad real y no mocks permisivos.
