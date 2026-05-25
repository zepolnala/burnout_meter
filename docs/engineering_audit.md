# Engineering Audit: BurnoutMeter Platform

**Fecha:** Mayo 2026
**Tipo:** Auditoría Técnica y de Seguridad Profunda
**Objetivo:** Exponer deuda arquitectural, gaps de testing, fragilidad de CI/CD y vulnerabilidades de seguridad sin lenguaje aspiracional. Estado actual tras múltiples iteraciones de corrección.

---

## 1. CI/CD Reliability — GitHub Actions

**Estado Actual:** ✅ Totalmente Funcional y Estable

### Configuración Actual del Pipeline (`flutter_ci.yml`)
El workflow ejecuta los siguientes pasos en orden:
1. Setup Java JDK 21 (Zulu)
2. Setup Flutter (canal `stable`, sin pin de versión exacta)
3. Setup Node.js 18 + Firebase CLI (npm global)
4. `flutter pub get` + `flutter pub run build_runner build`
5. `flutter analyze`
6. Firestore Rules Tests (`cd firestore-tests && npm test`)
7. `flutter test` (unit tests)
8. Instalación de Functions Dependencies
9. **E2E Integration Tests** (`flutter drive` con emuladores Firebase + chromedriver)
10. `flutter build web --release`

### Estado Resuelto: E2E Tests en CI y GoRouter Redirects

Todos los bloqueos relacionados con los tests E2E y el flujo de navegación de GoRouter han sido **completamente resueltos y verificados** de extremo a extremo:

1. **Resolución de Redirección GoRouter**:
   Se eliminó el `return null` prematuro y todos los vestigios del objeto `RouterLogs` de depuración. El enrutador [app_router.dart](file:///Users/alan/Burnout%20meter/lib/shared/routing/app_router.dart) implementa ahora una secuencia limpia de 5 pasos (Hold, Unauthenticated checks, Role-based redirect redirects, y RBAC guards de seguridad). Las guardias RBAC de cliente están **100% activas y no contienen código muerto**.

2. **Mitigación de Flakes en Clicks E2E (Off-Screen Viewports)**:
   Se identificó que el pipeline web-server en GitHub Actions (Chrome headless) corre a una resolución limitada (800x600 px), lo que provocaba que el botón de login de **Admin** estuviera fuera de pantalla y los clicks de hit-test fallaran de forma silenciosa. 
   * **Solución**: Se inyectó `await tester.ensureVisible(buttonFinder)` para todos los botones scrollables (sembrado, empleado, mánager, admin) en `app_test.dart`, obligando al framework de test a hacer scroll automático antes de interactuar.
   * **Sincronización**: Se añadieron esperas explícitas con `pumpAndSettle()` tras los logouts para estabilizar las transiciones de pantalla antes del siguiente flujo.

3. **Remoción de Instrumentos de Diagnóstico de Producción**:
   Se eliminaron de forma íntegra los widgets de diagnóstico temporal (`login_error_text`, `login_status_loading`, etc.) que contaminaban la UI de producción en `LoginScreen`. Todo diagnóstico se realiza ahora mediante logs nativos en la consola de tests.

### Problema Anterior Resuelto: Versión de Flutter

El audit anterior documentaba que CI usaba Flutter `3.19.x` mientras local corría `3.44.x`. Este problema fue resuelto cambiando el CI a `channel: 'stable'` sin pin de versión, lo que permite que el CI use la misma versión estable que el desarrollador.

**Advertencia**: Sin un pin exacto de versión, el pipeline puede romperse cuando Flutter publique una nueva versión estable. Se recomienda pintar con `flutter-version: 3.x.y`.

### Herramienta de Diagnóstico: `RouterLogs` + Keys de Testing

Durante el debugging se añadieron instrumentos de diagnóstico en la UI que deben eliminarse en producción:
- `RouterLogs.logs` — lista estática global que acumula logs de redirección
- Keys `login_error_text`, `login_status_loading`, `login_status_data`, `router_logs_text` en `LoginScreen`
- Widgets de debug con `Key('login_error_text')` visibles en la UI de producción

---

## 2. E2E Reliability — Browser Fragility

**Estado:** ⚠️ Mejorado pero aún frágil

### Situación Actual
El problema de ChromeDriver vs Chrome version mismatch fue abordado. El pipeline de CI usa `chromedriver` disponible en el runner de GitHub Actions (`ubuntu-latest`), que incluye Chrome y ChromeDriver sincronizados.

En desarrollo local, el problema de versión persiste en algunos entornos. La solución adoptada fue usar `npx chromedriver` en lugar de la instalación global de Homebrew.

### Fragilidad Restante
Los tests E2E dependen de textos exactos en la UI (e.g., `'Alan (Empleado Demo)'`, `'GUÍA DE EVALUACIÓN CTO'`). Cualquier cambio de texto en los dashboards romperá el test sin advertencia.

**Recomendación:** Reemplazar `find.text('...')` por `find.byKey(const Key('...'))` en los targets críticos del test.

---

## 3. Security Audit — Privilege Escalation & Tenant Isolation

**Estado:** ✅ Vulnerabilidades Críticas Anteriores Mitigadas

### Mitigación Implementada en `firestore.rules`

#### Memberships (antes vulnerable, ahora endurecida):
```javascript
// ANTES (vulnerable):
allow write: if isAuthenticated() && (isAdmin() || isOwner(userId));

// AHORA:
allow create: if isAuthenticated() && isOwner(userId) && (
  request.resource.data.role == 'employee' || isDemoEmail()
);
allow update: if isAuthenticated() && isOwner(userId) && (
  request.resource.data.diff(resource.data).affectedKeys().hasOnly(['updatedAt'])
);
```

**Impacto:** Los usuarios normales ya no pueden escribir su propio `role`. Solo pueden crear membresías con rol `employee`, o si son emails demo (`@burnoutmeter.demo`). Las actualizaciones están restringidas al campo `updatedAt`.

#### Scores (tenant isolation con `sameOrg`):
```javascript
allow read: if isAuthenticated() && (
  isOwner(resource.data.userId) || 
  (isManager() && hasSharingConsent(resource.data.userId) 
    && resource.data.teamId in getMembership().get('managedTeamIds', []) 
    && sameOrg(resource.data.orgId)) ||  // ← sameOrg añadido
  (isAdmin() && sameOrg(resource.data.orgId))
);
```

#### Audit Logs (write-once con verificación de actor):
```javascript
allow create: if isAuthenticated() && request.resource.data.actorUserId == request.auth.uid;
```

### Vulnerabilidades Residuales

1. **RBAC client-side vs server-side**: El `role` en Firestore puede ser leído y la lógica de redirección del router depende del valor de Firestore. Si las reglas de Firestore son correctas (lo son), un usuario que eleve su rol en Firestore no obtendrá acceso adicional porque las reglas del servidor lo bloquean. Sin embargo, la UI puede mostrar el dashboard de admin si el router no verifica contra JWT claims.

2. **`seed_status` colección pública**:
   ```javascript
   match /seed_status/{docId} {
     allow read, write: if true;  // Totalmente abierto
   }
   ```
   Cualquier usuario no autenticado puede leer o escribir el estado de seeding. Un atacante podría marcar la DB como "no seeded" para trigger re-seedings, o más críticamente, marcarla como "seeded" para bloquear la inicialización.

3. **Roles basados en Firestore, no en JWT Claims**: La función `getRole()` en las reglas hace una consulta adicional a Firestore por cada regla evaluada, lo que añade latencia y costos. En producción, los roles deberían estar en JWT custom claims asignados por Firebase Admin SDK.

---

## 4. Testing Coverage Audit

**Estado:** ⚠️ Cobertura baja, pero E2E test es ahora más robusto

### Tests Actuales

#### Unit Tests (`test/`)
Cobertura muy limitada. El único archivo de test existente cubre únicamente `ScoringEngine`. No hay widget tests.

#### E2E Integration Test (`integration_test/app_test.dart`)
El test ahora cubre el **happy path completo** para los tres roles:
- **Employee (Alan)**: Login → cierre de OnboardingDialog → cierre de WearableModal → logout
- **Manager (Victor)**: Login → cierre de OnboardingDialog → verificación de dashboard → logout
- **Admin**: Login → cierre de OnboardingDialog → verificación de dashboard → logout

**Instrumentación de diagnóstico añadida** (no ideal para CI, debe refactorizarse):
- El test verifica keys específicos de debug (`login_error_text`, `login_status_data`, etc.)
- La detección del OnboardingDialog usa loops de retry con `pumpAndSettle`

### Gaps Críticos Persistentes

| Área | Cobertura | Impacto |
|---|---|---|
| Widget tests | 0% | Cualquier cambio de UI pasa desapercibido |
| Providers Riverpod | 0% | Lógica de consentimiento no testeada |
| RBAC deflections | 0% | No se verifica que employee no acceda a /manager |
| Firestore Rules (JS) | Parcial | Tests en `firestore-tests/` cubren algunas reglas |
| Error scenarios | 0% | Sin tests de network failure, token expirado, etc. |
| Consent toggle flow | 0% | El toggle de privacy en EmployeeShell no está testeado |

---

## 5. Technical Debt & Demo-Only Implementations

### Instrumentación de Diagnóstico en Producción (DEBE ELIMINARSE)

Los siguientes artefactos de debugging fueron añadidos durante la resolución del bug E2E y deben ser removidos antes de cualquier release:

```dart
// En app_router.dart:
class RouterLogs {
  static final List<String> logs = [];  // Lista global que crece indefinidamente
}

// En login_screen.dart (dentro del widget de UI):
if (authState.hasError)
  Text('TEST ERROR: ${authState.error}', key: Key('login_error_text'), ...)
if (authState.isLoading)
  Text('TEST STATUS: LOADING...', key: Key('login_status_loading'), ...)
if (!authState.isLoading && !authState.hasError)
  Text('TEST STATUS: DATA(...)', key: Key('login_status_data'), ...)
Padding(
  child: Text('ROUTER LOGS: ${RouterLogs.logs.join(...)}', key: Key('router_logs_text'), ...)
)
```

### Implementaciones Demo-Only

- **`SyntheticHealthDataSource`**: Genera datos biométricos sintéticos por UID. Funciona para demos pero no refleja datos reales de wearable. La interfaz `HealthDataSource` está preparada para swap.
- **`AppLogger`**: Wrapper sobre `print()`. Invisible en producción web. Debe conectarse a Sentry/Crashlytics/Datadog.
- **Score client-side**: Los scores se calculan y escriben directamente desde el cliente. Permitido por las reglas Firestore (owner puede write), pero en producción debe moverse a Cloud Functions.
- **orgId hardcodeada**: En `burnout_providers.dart`, la lógica de fallback usa `orgId: 'org789'` hardcoded cuando no hay membership.

### Rebuild Storms

Los providers `FutureProvider.autoDispose.family` (`personalScoreProvider`, `teamScoresProvider`) se invalidan completamente cuando cambia el `userId`/`teamId`. Sin embargo, dentro de `teamScoresProvider` se hace un loop que llama a `personalScoreProvider` por cada miembro, lo que puede generar N requests paralelos a Firestore sin batching ni cache.

---

## 6. Resumen de Prioridades de Acción

| Prioridad | Acción | Impacto | Estado |
|---|---|---|---|
| 🔴 **P0** | Corregir bug del `return null` prematuro en `app_router.dart` | Desbloquea E2E tests y habilita RBAC guards | ✅ **Resuelto y Validado** |
| 🔴 **P0** | Eliminar widgets de debug de `LoginScreen` | Exposición de información interna en UI | ✅ **Resuelto y Validado** |
| 🔴 **P0** | Limpiar `RouterLogs` de producción | Memory leak acumulativo | ✅ **Resuelto y Validado** |
| 🟠 **P1** | Pintar versión de Flutter en CI | Reproducibilidad del pipeline | ⏳ Pendiente |
| 🟠 **P1** | Mover roles a JWT custom claims | Seguridad server-side real | ⏳ Pendiente |
| 🟠 **P1** | Restringir `/seed_status` collection | Superficie de ataque eliminada | ⏳ Pendiente |
| 🟡 **P2** | Widget tests con `mockito` | Cobertura de UI básica | ⏳ Pendiente |
| 🟡 **P2** | Tests de RBAC deflections | Verificación de seguridad | ⏳ Pendiente |
| 🟡 **P2** | Conectar `AppLogger` a Sentry | Observabilidad en producción | ⏳ Pendiente |
| 🟢 **P3** | Migrar scoring a Cloud Functions | Arquitectura production-grade | ⏳ Pendiente |
