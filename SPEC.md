# SPEC.md — Wellbeinn Wearable Platform (MVP B2B)

> Documento contrato para generación de scaffolding y features mediante agente de código (Antigravity).
> Versión: 1.0 · Fecha: 2026-05-22 · Owner: candidato CTO

---

## 1. Contexto y objetivos del producto

Wellbeinn es una empresa wellness que lanza un wearable propio (hardware base: módulo E500 white-label) orientado a la **detección temprana de carga psicofisiológica** en entornos laborales. El producto no es un dispositivo médico ni emite diagnósticos: ofrece **indicadores de carga** y **señales tempranas** que permiten a empleados y a sus organizaciones tomar acciones de bienestar antes de que la sobrecarga derive en burnout.

El presente MVP es una **solución B2B multi-tenant** con tres roles jerárquicos (empleado, manager, administrador) y una arquitectura privacy-by-design enforced server-side.

### Objetivos del MVP

1. Demostrar end-to-end el flujo: lectura de datos del wearable → cálculo de score → visibilidad selectiva por rol → acción del manager → recepción y respuesta del empleado → audit log.
2. Probar que el modelo de permisos (privacy-by-design) está enforced en **backend** (reglas de Firestore con tests), no solo en frontend.
3. Validar la arquitectura de codebase única Flutter para mobile (empleado) + web (manager y admin).
4. Establecer la trazabilidad del proceso de ingeniería asistido por IA como artefacto auditable del repositorio.

### No-objetivos del MVP

- No es un producto comercializable: es un assessment técnico con timebox de 5-6 días.
- No incluye integración real con el wearable E500 (stub documentado).
- No incluye validación clínica de las fórmulas de scoring (heurísticas plausibles, explícitamente no validadas).
- No incluye internacionalización completa (i18n preparado estructuralmente, solo `es` y `en` strings clave).

---

## 2. Personas y roles

### 2.1 Empleado

- **Plataforma principal:** móvil Flutter (Android primero; iOS si timebox lo permite).
- **Datos que ve:** su propio score diario (0-100), tendencia 7 días, breakdown opcional de subscores, historial de acciones recibidas, audit log de quién ha accedido a su score.
- **Datos que NO ve:** scores de otros empleados, agregados de equipo.
- **Acciones que puede ejecutar:** activar/desactivar consentimiento de compartir score, pausar recepción de acciones, marcar acciones como `acknowledged` o `dismissed`, responder a `wellness_check`.
- **Lenguaje en UI:** "indicadores de carga", "señales tempranas", "tu día de hoy". Nunca "diagnóstico", "patología", "alerta médica".

### 2.2 Manager

- **Plataforma principal:** web Flutter (panel manager).
- **Datos que ve:** lista de empleados pertenecientes a los equipos que gestiona (`managedTeamIds`), score agregado por empleado (último valor + tendencia), score agregado por equipo. **NUNCA ve healthSamples crudos**.
- **Datos que NO ve:** empleados de equipos no asignados, datos fisiológicos crudos de ningún empleado, scores de empleados con `consent.sharingEnabled = false` (verá al empleado en su lista marcado como "pausado", sin valor numérico).
- **Acciones que puede ejecutar:** disparar cualquiera de las 5 acciones del catálogo hacia un empleado de sus equipos. Ver estado de las acciones que ha enviado (`received` / `acknowledged` / `dismissed`).
- **Restricciones de poder:** no puede modificar consentimientos, no puede reasignar empleados a otros equipos (eso es admin), no recibe notificación cuando un empleado descarta una acción.

### 2.3 Administrador

- **Plataforma principal:** web Flutter (panel admin).
- **Datos que ve:** todos los empleados de su organización, agregados por equipo y a nivel compañía, lista de managers y sus asignaciones.
- **Acciones que puede ejecutar:** todas las del manager (sobre cualquier empleado de la org), más gestión de equipos, asignación manager↔equipo, y visualización del audit log a nivel organización.
- **Restricciones:** no ve empleados de otra organización (multi-tenant enforced en reglas).

---

## 3. User journeys principales

### 3.1 Onboarding del empleado (seed-based para MVP)

1. Empleado abre la app móvil. Pantalla de login con email + password (usuarios pre-creados en seed).
2. Tras login, Firebase Auth devuelve custom claim `{role: "employee", orgId: "wellbeinn"}`.
3. La app monta `EmployeeShell` (decisión arquitectónica 4). El cliente lee `memberships/{uid}` y obtiene `teamId`.
4. Primera pantalla: home con score del día, pull-to-refresh para forzar lectura de nuevos samples del `HealthDataSource` activo (replay en demo).
5. Banner persistente si `consent.sharingEnabled = false`: "Tu score no se está compartiendo. Activa el compartir para que tu manager pueda apoyarte cuando lo necesites." Botón "Activar".

### 3.2 Invitación de empleado (stub en MVP)

- En el MVP se accede como pantalla navegable desde la landing de login: "¿Tienes un código de invitación?".
- La pantalla maqueta el flujo (input de código, botón "Validar") pero al pulsar muestra un dialog: "Función disponible en próximas versiones. Para esta demo, usa las credenciales facilitadas."
- Sirve como artefacto para explicar el diseño de la fase 2 en la demo.

### 3.3 Manager revisa su equipo

1. Manager abre el panel web, login con sus credenciales seedeadas.
2. Custom claim resuelve `{role: "manager", orgId: "wellbeinn"}`. Se monta `ManagerShell`.
3. Cliente lee `memberships/{uid}` y obtiene `managedTeamIds: ["team_eng"]`.
4. Pantalla principal: lista de empleados de `team_eng`, cada uno con su último score, indicador de tendencia (subiendo/bajando/estable), y badge si tienen consent pausado.
5. Filtros: por estado (todos / en zona normal / señales tempranas), por equipo (si gestiona varios).
6. Click sobre empleado abre detalle: score actual, gráfica 7 días, breakdown de subscores (sin datos fisiológicos crudos), botón "Enviar acción".

### 3.4 Manager dispara una acción

1. Desde el detalle del empleado, manager pulsa "Enviar acción".
2. Modal con las 5 acciones del catálogo, descripción de cada una.
3. Manager selecciona (ej: `offer_1on1`), opcionalmente añade nota libre (140 chars), confirma.
4. Cliente escribe en `actions/{actionId}` con `fromUserId`, `toUserId`, `type`, `note`, `sentAt`, `status: "sent"`.
5. Cloud Function `onActionCreated` se dispara: registra entrada en `auditLog`, opcionalmente envía push (FCM) si está habilitado para el empleado.
6. Manager vuelve al detalle, ve la acción en "Acciones enviadas" con estado `sent`.

### 3.5 Empleado recibe acción

1. Si la app está abierta: stream de Firestore sobre `actions/` filtrado por `toUserId == uid` y `status in [sent, received]` actualiza la UI en vivo. Aparece bottom sheet con la acción.
2. Si la app está cerrada y push está habilitado: notificación FCM con deep link a la pantalla de acción.
3. Empleado lee la acción. Estado pasa automáticamente a `received` (Cloud Function `onActionRead` actualiza).
4. Empleado puede: pulsar "Gracias, lo tendré en cuenta" → `acknowledged`. Pulsar "Ahora no" → `dismissed`. En `wellness_check` además puede responder en escala 1-5.
5. El cambio de estado es visible para el manager en su panel (transparencia, decisión 6c).
6. Empleado no recibe presión: no hay recordatorios, no hay re-envíos automáticos.

### 3.6 Empleado pausa el compartir

1. Empleado entra en pestaña "Privacidad" del menú.
2. Ve dos toggles:
   - **Compartir mi score con mi organización** (controla `consent.sharingEnabled`)
   - **Recibir acciones de mi manager** (controla `consent.actionsEnabled`)
3. Al desactivar el primero, dialog de confirmación: "Tu manager dejará de ver tu score. Seguirás registrando datos para tu uso personal. Puedes reactivarlo en cualquier momento."
4. Cambio se escribe en `consents/{uid}`, se añade entrada a `consents/{uid}.history[]`.
5. Cloud Function `onConsentChanged` registra evento en `auditLog`.
6. Próxima vez que manager abra su panel, el empleado aparece marcado como "pausado", sin score visible.

### 3.7 Admin revisa la compañía

1. Admin login, claim `{role: "admin", orgId: "wellbeinn"}`. Se monta `AdminShell`.
2. Pantalla principal: dashboard de organización con número de empleados activos, % con consent activo, score medio agregado (solo si N >= 5 por equipo, para evitar identificación), distribución por equipos.
3. Tabs secundarios: "Equipos" (lista de equipos, manager asignado, número de miembros), "Personas" (lista plana de todos los empleados con scores), "Audit Log" (lecturas de scores, acciones enviadas, cambios de consent).
4. Admin puede pulsar sobre un equipo → lista de empleados de ese equipo → detalle de empleado (idéntico al que ve el manager).
5. Admin puede gestionar asignaciones: añadir manager a un equipo, mover empleado entre equipos (con confirmación, queda registrado en audit log).

---

## 4. Decisiones arquitectónicas

### 4.1 State management: Riverpod

**Decisión:** `flutter_riverpod` v2.x con `riverpod_generator` para code generation.

**Justificación:**
- Inmutabilidad y composición natural de providers, alineado con la separación domain/data/presentation.
- `AsyncValue` resuelve los tres estados (loading/data/error) de manera uniforme para todos los streams de Firestore.
- `ref.invalidate` y `ref.listen` permiten reactividad sin Bloc-style boilerplate.
- Code generation reduce errores de typo en `Provider`/`StateNotifierProvider`.

**Alternativas descartadas:**
- **Bloc:** más verboso, más ceremonia para el timebox.
- **Provider (legacy):** menos seguro en tipos, sin code generation moderna.
- **GetX:** anti-patrón en producción seria, no negociable.

### 4.2 Capas (Clean-ish Architecture)

Tres capas, con dependencia unidireccional `presentation → domain ← data`:

- **`domain/`** — entidades inmutables (`User`, `Score`, `Action`, `Consent`, `Team`, `Membership`), value objects, casos de uso (`ComputeScoreUseCase`, `SendActionUseCase`, `UpdateConsentUseCase`), interfaces de repositorio (`ScoreRepository`, `ActionRepository`, etc.). Cero dependencias externas (Firebase, Flutter, paquetes).
- **`data/`** — implementaciones de los repositorios contra Firebase y caché local Drift, modelos de datos serializables (`UserDto`, `ScoreDto`...), mappers DTO↔entidad, `HealthDataSource` con tres implementaciones (synthetic/replay/healthkit-stub).
- **`presentation/`** — widgets, pantallas, providers de Riverpod, `go_router` config. Subdividida por rol (`employee/`, `manager/`, `admin/`, `shared/`).

**Justificación del recorte:** no se aplica Clean Architecture canónica completa (sin entities-vs-models-vs-DTOs separados). Se simplifica a "entidad de dominio + DTO de capa de datos" porque el timebox no permite más capas sin pagar coste de boilerplate.

### 4.3 Navegación: `go_router` con guardas por rol

- Un único `GoRouter` instanciado a partir del rol del usuario autenticado.
- Tres árboles de rutas separados (uno por shell), montados condicionalmente.
- Guarda raíz: si no autenticado → `/login`. Si autenticado, según rol → ruta inicial del shell correspondiente.
- Deep linking habilitado para acciones (`/action/{actionId}`) — útil para FCM.

### 4.4 Persistencia local: Drift (SQLite)

**Decisión:** Drift sobre Hive, para el empleado.

**Justificación:**
- El empleado necesita persistir histórico de `HealthSample` y `Score` localmente para mostrar tendencias offline.
- Drift permite queries con joins y agregaciones (útil para "score medio últimos 7 días" sin cargar todo en memoria).
- Schema versionado y migraciones explícitas, importante para futuras versiones.
- Hive sería más rápido de implementar pero limita a key-value, mal encaje para series temporales.

Manager y admin **no** tienen caché local relevante (panel web, datos siempre desde Firestore en stream). Eventual offline-first para web queda fuera de alcance.

### 4.5 Codebase única Flutter para mobile + web

**Decisión:** una app Flutter, tres shells por rol (no por plataforma).

**Justificación detallada:**
- Entry point único `main.dart` → `AppShell` que observa estado de auth.
- En `authenticated`, lee custom claim `role` y monta:
  - `role == employee` → `EmployeeShell` (UX optimizada móvil)
  - `role == manager` → `ManagerShell` (UX optimizada web)
  - `role == admin` → `AdminShell` (UX optimizada web)
- Domain y data **completamente compartidos** entre los tres shells.
- `presentation/` se divide:
  - `presentation/employee/` — pantallas del empleado.
  - `presentation/manager/` — pantallas del manager.
  - `presentation/admin/` — pantallas del admin.
  - `presentation/shared/` — widgets transversales (botón estándar, `ScoreBadge`, `ConsentBanner`, etc.).
- **Consecuencia explícita:** abrir el shell de manager en móvil funcionalmente funciona pero no está optimizado visualmente. Esto se documenta como decisión consciente, no como bug. La arquitectura permite añadir variantes responsive por rol en el futuro sin reescribir.

### 4.6 Separación/compartición UI entre mobile y web

- Widgets de `presentation/shared/` deben ser responsive-aware (`LayoutBuilder` o `MediaQuery` cuando sea estrictamente necesario), pero la mayoría de la responsividad se resuelve por **qué shell se monta**, no por `if (isWide)` dentro de un widget.
- Charts (`fl_chart`): mismo widget en mobile y web, configurado con dimensiones adaptativas.
- Navegación: bottom navigation bar en `EmployeeShell` (mobile pattern), side navigation rail en `ManagerShell` y `AdminShell` (web pattern).

---

## 5. Modelo de datos canónico

Todas las entidades son inmutables (Freezed). Los campos marcados `nullable?` admiten ausencia.

### `User`
id: String (= Firebase Auth uid)
email: String
displayName: String
orgId: String
createdAt: DateTime
photoUrl: String?

### `Membership`
userId: String
orgId: String
role: enum { employee, manager, admin }
teamId: String?         // solo si role == employee
managedTeamIds: List<String>  // solo si role == manager
updatedAt: DateTime

### `Organization`
id: String
name: String
createdAt: DateTime
settings: OrgSettings

### `OrgSettings`
minAggregationN: int (default 5)  // mínimo de empleados por equipo para mostrar agregados anonimizados
pushNotificationsEnabled: bool

### `Team`
id: String
orgId: String
name: String
createdAt: DateTime
memberCount: int (denormalized)

### `HealthSample` (privado del empleado, jamás expuesto a otros roles)
id: String
userId: String
recordedAt: DateTime
hrv: double?
heartRate: double?
sleepMinutes: int?
activityLevel: double?
source: enum { synthetic, replay, healthkit }

### `Score`
userId: String
date: Date (YYYY-MM-DD)
value: int (0-100)
subscores: Subscores
computedAt: DateTime
confidence: double (0.0-1.0)
sampleCount: int   // cuántos HealthSample alimentaron este score

### `Subscores`
sleep: int (0-100)
recovery: int (0-100)
stress: int (0-100)
load: int (0-100)

### `Consent`
userId: String
sharingEnabled: bool
actionsEnabled: bool
updatedAt: DateTime
history: List<ConsentChange>

### `ConsentChange`
changedAt: DateTime
field: enum { sharing, actions }
newValue: bool

### `Action`
id: String
fromUserId: String
toUserId: String
orgId: String
type: enum { suggest_break, offer_1on1, share_resource, recommend_time_off, wellness_check }
note: String?  (max 140 chars)
sentAt: DateTime
status: enum { sent, received, acknowledged, dismissed }
statusUpdatedAt: DateTime
response: ActionResponse?  // solo si type == wellness_check y status == acknowledged

### `ActionResponse`
scale: int (1-5)  // solo wellness_check
respondedAt: DateTime

### `ActionTemplate` (catálogo, seedeado)
type: enum (las 5 categorías)
titleKey: String  // clave i18n
bodyKey: String   // clave i18n
iconName: String
requiredRole: enum { manager, admin }  // todas son manager por defecto en MVP
defaultEnabled: bool

### `AuditLogEntry`
id: String
orgId: String
actorUserId: String
actorRole: enum { employee, manager, admin, system }
action: enum { score_read, action_sent, consent_changed, membership_changed, team_changed }
targetUserId: String?
targetResourceId: String?
metadata: Map<String, dynamic>
occurredAt: DateTime

---

## 6. Interfaces clave

### 6.1 `HealthDataSource`

```dart
abstract class HealthDataSource {
  Stream<HealthSample> samples();
  Future<List<HealthSample>> samplesInRange(DateTime from, DateTime to);
  Future<void> initialize();
  HealthSourceType get type;
}
```

Implementaciones:
- `SyntheticHealthDataSource` — genera samples en runtime con patrones (baseline + ruido gaussiano + picos programables). Útil para desarrollo y para tests.
- `ReplayHealthDataSource` — lee fixture JSON desde `assets/fixtures/employee_week.json`, reproduce acelerado (configurable: 1 día real = 1 minuto demo). **Default para la demo.**
- `HealthKitDataSource` — stub que lanza `UnimplementedError("HealthKit integration scheduled for v2 with E500 SDK")`. Documentado en README como next-step.

Selección en runtime mediante provider Riverpod con flag de configuración (`AppConfig.healthSource`).

### 6.2 `ScoringEngine`

```dart
abstract class ScoringEngine {
  Score compute(List<HealthSample> samplesForDay, {Score? previousDayScore});
}
```

Implementación `DefaultScoringEngine`:
- Calcula los 4 subscores como funciones puras de los samples del día (+ score del día anterior para `load`).
- Score global = media ponderada `0.30*sleep + 0.25*recovery + 0.25*stress + 0.20*load`.
- `confidence` = función de `sampleCount` (a más samples, más confianza, capped en 1.0).
- **Las fórmulas son heurísticas explícitamente no validadas clínicamente.** Documentado in-code y en sección 12 (MDR).

### 6.3 `ConsentManager`

```dart
abstract class ConsentManager {
  Future<Consent> current();
  Stream<Consent> watch();
  Future<void> setSharing(bool enabled);
  Future<void> setActions(bool enabled);
  Future<List<ConsentChange>> history();
}
```

Toda mutación añade entrada a `history` y dispara `AuditLogEntry` vía Cloud Function (no desde cliente, para que sea no manipulable).

### 6.4 `NotificationService`

```dart
abstract class NotificationService {
  Stream<Action> incoming();
  Future<void> markReceived(String actionId);
  Future<void> acknowledge(String actionId, {ActionResponse? response});
  Future<void> dismiss(String actionId);
}
```

Implementación basada en streams de Firestore + FCM opcional para push cuando app cerrada.

### 6.5 `OrganizationService`

```dart
abstract class OrganizationService {
  Future<Organization> current();
  Stream<List<Team>> teams();
  Stream<List<Membership>> teamMembers(String teamId);
  Future<void> assignManagerToTeam(String managerUserId, String teamId);
  Future<void> moveEmployeeToTeam(String employeeUserId, String teamId);
  Future<void> createTeam(String name);
}
```

Solo admin puede invocar mutaciones; enforced en reglas Firestore.

### 6.6 `ActionService`

```dart
abstract class ActionService {
  List<ActionTemplate> catalog();
  Future<void> send({
    required String toUserId,
    required ActionType type,
    String? note,
  });
  Stream<List<Action>> sentByMe();
  Stream<List<Action>> receivedByMe();
}
```

---

## 7. Stack y dependencias justificadas

| Paquete | Versión target | Razón |
|---|---|---|
| `flutter` | 3.x | Framework base |
| `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_messaging`, `cloud_functions` | latest | Backend integrado, Auth con custom claims, Firestore con reglas, FCM opcional, callable functions |
| `flutter_riverpod`, `riverpod_generator`, `riverpod_annotation` | 2.x | State management (decisión 4.1) |
| `go_router` | 14.x | Navegación con guardas (decisión 4.3) |
| `drift`, `drift_flutter`, `sqlite3_flutter_libs` | latest | Persistencia local empleado (decisión 4.4) |
| `freezed`, `freezed_annotation`, `json_serializable` | latest | Entidades inmutables, DTOs |
| `fl_chart` | latest | Gráficas de score 7 días y agregados |
| `health` | latest | Stub HealthKit/Health Connect (no integrado en MVP) |
| `intl` | latest | i18n estructural |
| `flutter_lints`, `custom_lint`, `riverpod_lint` | latest | Calidad de código |

Dev dependencies: `build_runner`, `mocktail`, `fake_cloud_firestore` para tests.

---

## 8. Modelo de datos del backend (Firestore)

### 8.1 Colecciones y estructura
/organizations/{orgId}
/organizations/{orgId}/teams/{teamId}
/organizations/{orgId}/auditLog/{entryId}
/users/{userId}                          // perfil público no sensible
/memberships/{userId}                    // role, teamId, managedTeamIds, orgId
/consents/{userId}                       // sharingEnabled, actionsEnabled, history
/scores/{userId}/daily/{YYYY-MM-DD}      // scores derivados, accesibles bajo reglas
/healthSamples/{userId}/raw/{sampleId}   // datos crudos, SOLO el propio empleado
/actions/{actionId}                      // acciones manager → empleado
/actionTemplates/{type}                  // catálogo seedeado

### 8.2 Reglas de seguridad (pseudocódigo)

> **Esta sección es crítica.** Las reglas son la verdad del modelo de permisos. El frontend asume reglas correctas; las reglas no asumen frontend correcto.

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Helpers
    function isAuthed() {
      return request.auth != null;
    }
    function uid() { return request.auth.uid; }
    function claim(field) { return request.auth.token[field]; }

    function loadMembership() {
      return get(/databases/$(database)/documents/memberships/$(uid())).data;
    }

    function isEmployee(m) { return m.role == 'employee'; }
    function isManager(m)  { return m.role == 'manager'; }
    function isAdmin(m)    { return m.role == 'admin'; }
    function sameOrg(m, otherOrgId) { return m.orgId == otherOrgId; }

    function managerOfTeam(m, teamId) {
      return isManager(m) && teamId in m.managedTeamIds;
    }
    function managerOfEmployee(m, employeeUid) {
      let targetMembership = get(/databases/$(database)/documents/memberships/$(employeeUid)).data;
      return isManager(m)
        && targetMembership.orgId == m.orgId
        && targetMembership.teamId in m.managedTeamIds;
    }

    function consentSharing(employeeUid) {
      return get(/databases/$(database)/documents/consents/$(employeeUid)).data.sharingEnabled == true;
    }
    function consentActions(employeeUid) {
      return get(/databases/$(database)/documents/consents/$(employeeUid)).data.actionsEnabled == true;
    }

    // ───────── healthSamples: SOLO el propio empleado ─────────
    match /healthSamples/{userId}/raw/{sampleId} {
      allow read, write: if isAuthed() && uid() == userId;
      // Manager y admin NUNCA leen healthSamples, ni siquiera con consent.
    }

    // ───────── scores: empleado siempre; manager/admin solo con consent ─────────
    match /scores/{userId}/daily/{date} {
      allow read: if isAuthed() && (
        uid() == userId
        || (
          let m = loadMembership();
          consentSharing(userId) && (
            isAdmin(m) && sameOrg(m, get(/databases/$(database)/documents/memberships/$(userId)).data.orgId)
            || managerOfEmployee(m, userId)
          )
        )
      );
      allow write: if false; // solo Cloud Function (admin SDK bypass)
    }

    // ───────── consents: solo el propio empleado escribe; admin lee ─────────
    match /consents/{userId} {
      allow read: if isAuthed() && (
        uid() == userId
        || (let m = loadMembership(); isAdmin(m))
      );
      allow write: if isAuthed() && uid() == userId;
    }

    // ───────── memberships: solo admin escribe; cada uno lee la suya ─────────
    match /memberships/{userId} {
      allow read: if isAuthed() && (
        uid() == userId
        || (let m = loadMembership(); isAdmin(m) || isManager(m))
      );
      allow create, update: if isAuthed() &&
        (let m = loadMembership(); isAdmin(m) && sameOrg(m, request.resource.data.orgId));
      allow delete: if false;
    }

    // ───────── actions: manager dispara hacia empleado de su equipo ─────────
    match /actions/{actionId} {
      allow create: if isAuthed() && (
        let m = loadMembership();
        request.resource.data.fromUserId == uid()
        && (
          (isManager(m) && managerOfEmployee(m, request.resource.data.toUserId))
          || (isAdmin(m) && sameOrg(m, get(/databases/$(database)/documents/memberships/$(request.resource.data.toUserId)).data.orgId))
        )
        && consentActions(request.resource.data.toUserId)
      );
      allow read: if isAuthed() && (
        resource.data.fromUserId == uid() || resource.data.toUserId == uid()
        || (let m = loadMembership(); isAdmin(m) && sameOrg(m, resource.data.orgId))
      );
      allow update: if isAuthed()
        && resource.data.toUserId == uid()
        && request.resource.data.diff(resource.data).affectedKeys()
             .hasOnly(['status', 'statusUpdatedAt', 'response']);
      allow delete: if false;
    }

    // ───────── teams: lectura amplia dentro de la org; escritura solo admin ─────────
    match /organizations/{orgId}/teams/{teamId} {
      allow read: if isAuthed() && (let m = loadMembership(); m.orgId == orgId);
      allow write: if isAuthed() && (let m = loadMembership(); isAdmin(m) && m.orgId == orgId);
    }

    // ───────── auditLog: solo lectura admin; escritura solo Cloud Function ─────────
    match /organizations/{orgId}/auditLog/{entryId} {
      allow read: if isAuthed() && (let m = loadMembership(); isAdmin(m) && m.orgId == orgId);
      allow write: if false;
    }
  }
}
```

### 8.3 Cloud Functions necesarias

| Función | Trigger | Responsabilidad |
|---|---|---|
| `onUserCreated` | Auth `user.create` | Asignar custom claim `{role, orgId}` desde `pendingInvitations` o seed |
| `onActionCreated` | Firestore `actions/{actionId}` `onCreate` | Registrar en auditLog; opcionalmente disparar FCM al `toUserId` |
| `onActionStatusChanged` | Firestore `actions/{actionId}` `onUpdate` | Registrar cambio de estado en auditLog |
| `onConsentChanged` | Firestore `consents/{userId}` `onUpdate` | Registrar en auditLog |
| `onMembershipChanged` | Firestore `memberships/{userId}` `onWrite` | Registrar en auditLog; sincronizar custom claim si role cambia |
| `onScoreRead` | Callable function | Endpoint para registrar lectura de score por manager/admin (frontend la llama tras leer). Alternativa: regla audit-only (Firestore no soporta hooks de read nativamente) |
| `aggregateTeamScores` | Pub/Sub schedule diario 02:00 | Calcula `teamScoreAggregates/{teamId}/{date}` para dashboard manager/admin |
| **`suggestActions`** (stretch día 5-6) | Pub/Sub schedule diario 06:00 | Detecta patrones, crea `actions/` con `status: "suggested"` para revisión del manager |

> Sobre `onScoreRead`: Firestore no permite hooks de lectura. La estrategia es que el cliente del manager/admin invoque la callable function tras cada lectura sensible. No es perfecto (un cliente malicioso podría saltársela), pero combinada con las reglas (que ya impiden lecturas no autorizadas) cubre el caso de audit log honesto. Alternativa más estricta: forzar todas las lecturas de score de manager/admin a través de una callable, eliminando lectura directa. **Decisión MVP:** lectura directa + callable de audit, documentado como compromiso conocido.

---

## 9. Estructura de carpetas del proyecto
wellbeinn/
├── android/                          # config nativa Android
├── ios/                              # config nativa iOS (stretch)
├── web/                              # entry web
├── lib/
│   ├── main.dart
│   ├── app.dart                      # AppShell, decide qué shell montar
│   ├── config/
│   │   ├── app_config.dart           # flags (health source, env)
│   │   └── firebase_options.dart
│   ├── domain/
│   │   ├── entities/                 # User, Score, Action, Consent, Team, Membership, ...
│   │   ├── value_objects/
│   │   ├── repositories/             # interfaces
│   │   └── use_cases/
│   ├── data/
│   │   ├── dtos/
│   │   ├── mappers/
│   │   ├── repositories/             # implementaciones Firestore
│   │   ├── sources/
│   │   │   ├── health/
│   │   │   │   ├── health_data_source.dart
│   │   │   │   ├── synthetic_health_data_source.dart
│   │   │   │   ├── replay_health_data_source.dart
│   │   │   │   └── healthkit_health_data_source.dart
│   │   │   └── local/
│   │   │       └── drift_database.dart
│   │   └── scoring/
│   │       └── default_scoring_engine.dart
│   ├── presentation/
│   │   ├── shared/
│   │   │   ├── widgets/              # ScoreBadge, ConsentBanner, ...
│   │   │   ├── theme/
│   │   │   └── providers/            # auth, current_user
│   │   ├── employee/
│   │   │   ├── shell.dart
│   │   │   ├── routes.dart
│   │   │   └── screens/
│   │   ├── manager/
│   │   │   ├── shell.dart
│   │   │   ├── routes.dart
│   │   │   └── screens/
│   │   └── admin/
│   │       ├── shell.dart
│   │       ├── routes.dart
│   │       └── screens/
│   └── l10n/
│       ├── app_es.arb
│       └── app_en.arb
├── assets/
│   ├── fixtures/
│   │   └── employee_week.json        # replay fixture
│   └── icons/
├── functions/                        # Cloud Functions (Node 20)
│   ├── src/
│   │   ├── onUserCreated.ts
│   │   ├── onActionCreated.ts
│   │   ├── onActionStatusChanged.ts
│   │   ├── onConsentChanged.ts
│   │   ├── onMembershipChanged.ts
│   │   ├── onScoreRead.ts
│   │   ├── aggregateTeamScores.ts
│   │   └── suggestActions.ts         # stretch
│   ├── package.json
│   └── tsconfig.json
├── firestore.rules
├── firestore.indexes.json
├── test/
│   ├── domain/                       # tests unitarios casos de uso, scoring
│   ├── data/                         # tests de repos con fake_cloud_firestore
│   └── widget/                       # smoke tests pantallas clave
├── integration_test/                 # 1-2 happy paths e2e
├── firestore_rules_test/             # tests de reglas con emulador (JS)
│   ├── package.json
│   └── rules.test.js
├── scripts/
│   ├── seed.ts                       # script de seed multi-org/teams/users
│   └── generate_fixture.py           # genera assets/fixtures/employee_week.json
├── docs/
│   ├── prompts/
│   │   ├── 00-spec-conversation/
│   │   │   ├── 01-bootstrap.md
│   │   │   ├── 02-architecture-decisions.md
│   │   │   └── outcomes.md
│   │   ├── 01-scaffolding/           # próximas fases
│   │   ├── 02-features/
│   │   └── 03-firestore-rules/
│   └── architecture.md
├── pubspec.yaml
├── firebase.json
└── README.md

---

## 10. Estrategia de testing

### Qué se testea (en orden de prioridad)

1. **Reglas de Firestore con emulador (`firestore_rules_test/`):** mínimo 5 tests críticos:
   - Manager NO puede leer empleado de otro equipo.
   - Manager NO puede leer `healthSamples` ni siquiera de su propio equipo.
   - Manager NO ve score si empleado tiene `sharingEnabled = false`.
   - Admin NO puede leer empleados de otra organización.
   - Manager NO puede crear acción hacia empleado fuera de sus `managedTeamIds`.

2. **Scoring engine (`test/domain/scoring/`):** tests unitarios de `DefaultScoringEngine`:
   - Score válido en rango 0-100.
   - Confidence aumenta con sampleCount.
   - Subscores se calculan correctamente con samples sintéticos conocidos.

3. **Casos de uso críticos (`test/domain/use_cases/`):**
   - `SendActionUseCase` rechaza si consent.actionsEnabled = false (validación cliente, redundante con reglas).
   - `UpdateConsentUseCase` añade entry a history.

4. **Smoke tests de pantallas clave (`test/widget/`):** una pantalla por shell, renderiza sin throw con state mockeado.

5. **1-2 integration tests (`integration_test/`):** happy path "empleado login → ve score" y "manager login → ve empleado de su equipo".

### Qué NO se testea (y por qué)

- **UI exhaustiva:** timebox no lo permite. Smoke tests cubren regresiones gruesas.
- **Cloud Functions completas:** se cubren manualmente en demo. En producción real, tests con `firebase-functions-test`.
- **`HealthDataSource` synthetic:** es deterministicamente impredecible por diseño (incluye ruido aleatorio); el replay sí se testea indirectamente al testear scoring.
- **i18n:** estructural, no se valida traducción.

---

## 11. Lo que NO se construye y por qué

| No construido | Razón |
|---|---|
| Flujo de invitación end-to-end | Decisión 2: seed en demo, stub en UI. Defendible como decisión de timebox. |
| Integración real con wearable E500 | Hardware no disponible; stub `HealthKitDataSource` con `UnimplementedError`. |
| Validación clínica de fórmulas de scoring | Fuera de scope; requiere estudio con N participantes. Las fórmulas son heurísticas explícitas. |
| Catálogo de acciones extendido (>5) | Decisión 6a: 5 acciones cubren el espectro; añadir más es datos, no código. |
| System-suggested actions | Decisión 6b: stretch días 5-6. Diseñado en spec, implementación en stub. |
| iOS build | Stretch si timebox lo permite. Android prioritario. |
| Onboarding interactivo del empleado | Login directo a home; tutorial fuera de scope. |
| Exportación de datos del empleado (GDPR portabilidad) | Documentado en sección 12, implementación postergada. Pseudocódigo en Cloud Function `exportUserData`. |
| Right-to-be-forgotten end-to-end | Documentado en sección 12, requiere Cloud Function `deleteUserData` con borrado en cascada. Postergado. |
| Push notifications FCM | Implementación condicional. In-app stream prioritario, FCM si timebox sobra. |
| Internacionalización completa | Solo `es` y `en` con strings críticos. |
| Dashboard analytics avanzado | Agregados básicos suficientes para demo. |

---

## 12. Mapa de cumplimiento

### 12.1 GDPR

| Principio | Aplicación en el MVP |
|---|---|
| **Consentimiento explícito** | `consents/{userId}.sharingEnabled` debe estar `true` para que score sea visible a terceros. Default `false` para empleados nuevos (opt-in, no opt-out). |
| **Minimización de datos** | Manager y admin nunca acceden a `healthSamples` crudos. Solo `Score` derivado. Reglas Firestore enforced. |
| **Derecho de acceso** | Empleado ve su propio `auditLog` (quién ha accedido a su score, cuándo). Implementado vía vista en pantalla "Privacidad". |
| **Derecho al olvido** | **Documentado, no implementado en MVP.** Pseudocódigo en `functions/src/deleteUserData.ts`: borra `users/{uid}`, `memberships/{uid}`, `consents/{uid}`, `scores/{uid}/daily/*`, `healthSamples/{uid}/raw/*`, anonimiza `actions` donde aparece como `from` o `to`, entry en `auditLog`. |
| **Portabilidad de datos** | **Documentado, no implementado.** Pseudocódigo `exportUserData.ts`: genera JSON con todas las entidades del empleado. |
| **Privacy-by-design** | Frame nuclear del producto, enforced en backend (reglas Firestore) no solo en UI. |
| **Privacy-by-default** | `sharingEnabled = false` al crear empleado. Opt-in explícito requerido. |

### 12.2 Contexto laboral español

| Norma | Aplicación |
|---|---|
| **LOPDGDD (LO 3/2018)** | Subsumida por GDPR; consentimiento informado, derecho de información. La pantalla "Privacidad" del empleado incluye texto claro de qué se recoge, quién accede, cómo pausar. |
| **Ley 31/1995 de Prevención de Riesgos Laborales** | Los datos psicofisiológicos se consideran "vigilancia de la salud" en contextos laborales, requieren consentimiento expreso (Art. 22). El producto está diseñado para que el empleado controle el flujo end-to-end, alineado con esta exigencia. |
| **Estatuto de los Trabajadores Art. 20bis (derechos digitales)** | Empleado puede desconectar el compartir y la recepción de acciones, sin penalización. Reglas Firestore impiden enviar acciones si `actionsEnabled = false`. |
| **Comité de empresa / representación legal** | Documentado como requisito previo a despliegue real: acuerdo colectivo o consulta con RLT antes de activar el producto en una organización. No bloqueante para MVP demo. |

### 12.3 MDR (Reglamento de Productos Sanitarios)

Wellbeinn **NO** es un producto sanitario y por tanto NO está sujeto a MDR (Reglamento UE 2017/745) en su forma actual. Esta clasificación se sostiene mientras:

- El producto presente **indicadores de bienestar / carga**, no diagnósticos.
- No haga claims sobre detección, prevención o tratamiento de enfermedad.
- Las acciones sugeridas sean de bienestar general (pausa, conversación, recurso), no intervenciones clínicas.
- No proporcione recomendaciones individualizadas que sustituyan criterio médico.

**Dónde está el límite:** si en una versión futura el producto añadiera (a) detección explícita de patología (ej. "señal de trastorno de ansiedad"), (b) recomendaciones terapéuticas individualizadas, o (c) integración con historia clínica electrónica, entraría en el ámbito MDR clase IIa como mínimo, requiriendo marcado CE médico y certificación notificada. Esta línea se documenta en producto para evitar feature creep regulatorio.

**En el código:** comentarios in-line en `DefaultScoringEngine` y en strings de UI dejan explícito que las salidas son "indicadores", "señales tempranas", nunca "diagnósticos". Lint personalizado opcional para evitar terminología clínica en `presentation/`.

---

## 13. Plan de implementación (5-6 días)

> Plan optimista. La regla de oro: si al final del día 3 las reglas de Firestore no están sólidas con tests, sacrificar features de la 6 en adelante.

### Día 1 — Cimientos
- Setup repo, Flutter project, Firebase project, emuladores.
- `firebase_options.dart`, `pubspec.yaml` con dependencias clave.
- Estructura de carpetas completa.
- Modelo de datos en `domain/entities/` con Freezed (todas las entidades sección 5).
- DTOs y mappers básicos.
- Drift database setup con tablas `health_samples` y `scores`.
- **Entregable visible:** app arranca, pantalla de login dummy.

### Día 2 — Auth, shells, routing
- Firebase Auth con email/password.
- Custom claims (asignados manualmente vía Firebase Admin SDK en script `seed.ts`).
- `AppShell` con detección de rol y montaje de los tres shells.
- `go_router` con rutas mínimas por shell.
- Pantallas placeholder por shell para demostrar separación.
- **Entregable visible:** login con tres usuarios distintos lleva a tres shells distintos.

### Día 3 — **Día crítico**: Firestore + reglas + seed
- `firestore.rules` completas (sección 8.2).
- Tests de reglas con emulador (mínimo 5, sección 10).
- Script `seed.ts`: 1 org, 2 teams, 1 admin, 2 managers, 4-6 empleados, consents iniciales, ActionTemplates.
- Generador de fixture `generate_fixture.py` y `assets/fixtures/employee_week.json`.
- `HealthDataSource` con las tres implementaciones (replay funcional, synthetic funcional, healthkit stub).
- `DefaultScoringEngine` implementado.
- **Entregable visible:** seed corre limpio, tests de reglas pasan en verde.

### Día 4 — Empleado completo
- Login real.
- Home con score del día, gráfica 7 días (fl_chart).
- Pantalla "Privacidad" con dos toggles, audit log de accesos.
- Recepción de acciones (stream de Firestore), bottom sheet con acción, estados `received/acknowledged/dismissed`.
- Cloud Function `onActionCreated`, `onConsentChanged`.
- **Entregable visible:** flujo completo empleado end-to-end.

### Día 5 — Manager y Admin
- `ManagerShell`: lista de empleados de sus equipos, detalle, envío de acción.
- `AdminShell`: dashboard org, lista de equipos, gestión manager↔team, audit log.
- Cloud Function `aggregateTeamScores` (diaria; en demo, se invoca manualmente vía callable).
- Pulido visual.
- **Entregable visible:** los tres roles funcionan completos.

### Día 6 — Pulido, stretch, demo
- Fix de bugs visibles.
- Si timebox sobra (en este orden):
  1. iOS build.
  2. FCM push notifications.
  3. `suggestActions` Cloud Function (system-suggested stretch).
  4. Pantalla de detalle de subscores en empleado.
- Grabación de demo de 5-10 min con narrativa: empleado login → ve score → manager login → ve equipo → dispara acción → empleado recibe → empleado pausa → manager ya no ve → admin ve audit log.
- README final con instrucciones de ejecución, decisiones clave, links a `docs/prompts/`.

### Triage de recortes (si vas mal a partir del día 4)

| Prioridad de sacrificio | Qué cae |
|---|---|
| 1 (cae primero) | `suggestActions` Cloud Function |
| 2 | Pantalla detalle de subscores |
| 3 | iOS build |
| 4 | FCM push (vale con in-app stream) |
| 5 | Audit log en admin (vale solo lectura, sin filtros) |
| **No negociable** | Reglas de Firestore + tests, los 3 shells funcionando, flujo de acción end-to-end |

---

## Anexo: trazabilidad de uso de IA

Este SPEC es el primer artefacto del proceso de ingeniería asistido por IA del proyecto. Convención de carpetas:
docs/prompts/
├── 00-spec-conversation/        # esta conversación (ya generada)
├── 01-scaffolding/              # prompts para Antigravity generar estructura
├── 02-features/                 # prompts por feature mayor
├── 03-firestore-rules/          # prompts para diseñar/refinar reglas
└── 99-debugging/                # prompts de depuración relevantes

Cada carpeta contiene mínimo:
- `01-bootstrap.md` — prompt inicial enviado al agente.
- `outcomes.md` — qué se generó, qué se aceptó, qué se modificó manualmente.

Esto convierte el repositorio en un artefacto auditable del proceso, no solo del producto.

---

**Fin de SPEC.md v1.0.**