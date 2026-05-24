# Compromisos de Diseño y Trade-offs Arquitecturales

Este documento recoge los compromisos intencionales del prototipo **BurnoutMeter MVP**. Destaca los balances pragmáticos de ingeniería entre capacidad de demostración rápida, velocidad de testing local y patrones escalables de producción.

**Última revisión:** Mayo 2026

---

## ⚖️ Matriz de Trade-offs MVP

| Área Arquitectural | Enfoque MVP Pragmático | Patrón SaaS Producción | Rationale del Compromiso |
| :--- | :--- | :--- | :--- |
| **Ejecución de Scoring** | Calculado client-side; score subido directamente a Firestore `/scores/`. | Manejado server-side via Firebase Functions o microservicios Go/Rust. | **Pragmatismo**: Ejecución client-side permite demos 100% offline con emuladores sin mantener servidores externos. Las reglas Firestore siguen garantizando seguridad de acceso. |
| **Ingesta de Wearables** | `SyntheticHealthDataSource` con varianza determinística por UID. | Integración directa con iOS HealthKit, Android Health Connect y APIs OAuth de Garmin/Oura/Fitbit. | **Foco en Verificación**: Prueba que las matemáticas de scoring y los dashboards de equipo son estructuralmente correctos antes de escribir bridges nativos complejos. |
| **Escritura de Datos** | El cliente escribe scores computados directamente a Firestore. | Vistas read-only para el empleado; scores poblados exclusivamente por workers de backend. | **Simplicidad**: Mantiene el prototipo ligero y garantiza que el test suite de reglas pueda correr completamente aislado. |
| **Telemetría** | `AppLogger` escribiendo trazas ASCII estructuradas a stdout (wrapper de `print()`). | Integración con OpenTelemetry, GCP Cloud Logging, y alertas de Sentry. | **Observabilidad Pragmática**: stdout es fácil de leer en consola local durante demos. Mantiene una capa de abstracción limpia para integraciones de telemetría futuras. |
| **RBAC** | Roles almacenados en Firestore, leídos dinámicamente por las rules. | JWT Custom Claims asignados por Firebase Admin SDK, verificados sin reads adicionales. | **Velocidad de MVP**: Claims de Firestore permiten cambiar roles sin re-emitir tokens. En producción, los custom claims eliminan el read extra por evaluación de regla. |
| **Routing Auth Guards** | GoRouter redirect() con `GoRouterRefreshNotifier` + `ref.read()`. | Idéntico, pero con RBAC guards activos (actualmente dead code). | **Bug activo**: El `return null` prematuro en línea 67 de `app_router.dart` deshabilita los guards de role. Fix simple pero crítico para producción. |
| **Onboarding Dialog** | Se muestra siempre en cada login. | Controlado por flag `hasSeenOnboarding` en Firestore, mostrado solo en primer login. | **Simplicidad de MVP**: Evita añadir campo extra al schema de Membership/Consent para el demo. |
| **Datos de Debug en UI** | `RouterLogs`, keys de test y widgets de estado visible en LoginScreen. | Completamente eliminados antes de release. | **Diagnóstico de CI**: Necesarios durante la investigación del bug E2E. Representan deuda técnica inmediata. |

---

## 🔄 Cambios vs Versión Anterior (Mayo 2026)

### Mejoras Implementadas

| Componente | Antes | Ahora |
|---|---|---|
| **Firestore: Membership write** | `allow write: if isAdmin() \|\| isOwner()` — vulnerable a privilege escalation | `allow create` limitado a `role == 'employee'` + `allow update` limitado a `updatedAt` |
| **GoRouter pattern** | `ref.watch(authStateProvider)` recreaba el GoRouter en cada cambio de estado | `GoRouterRefreshNotifier` + `refreshListenable` — router se crea una vez, se refresca reactivamente |
| **Wearable Source** | `ReplayHealthDataSource` con JSON estático idéntico para todos | `SyntheticHealthDataSource` con varianza determinística por UID |
| **Scores rule: tenant isolation** | Sin verificación de `sameOrg` en reads de manager | `sameOrg(resource.data.orgId)` añadido — impide cross-tenant reads |
| **Audit log create rule** | `allow create: if isAuthenticated()` | `allow create: if isAuthenticated() && request.resource.data.actorUserId == request.auth.uid` |
| **OnboardingDialog** | No existía | Añadido — modal informativo sobre funcionamiento del app |
| **Responsive design** | Solo desktop | Manager/Admin shells adaptados para mobile |

### Trade-offs Nuevos Introducidos en Esta Iteración

#### `RouterLogs` global en memoria
- **Decisión**: Añadir una lista estática global para capturar logs de routing durante debugging E2E.
- **Trade-off**: Solución inmediata para diagnosticar el bug, pero es un memory leak que crece indefinidamente.
- **Resolución pendiente**: Eliminar antes de release.

#### Instrumentación de debug en `LoginScreen`
- **Decisión**: Añadir widgets con `Key(...)` visibles que muestran el estado del `authStateProvider` y los logs del router.
- **Trade-off**: Permitió identificar el problema exacto (DATA state = auth ok, pero no redirección), pero expone información interna.
- **Resolución pendiente**: Eliminar todos los widgets de diagnóstico.

---

## 🛠️ Mitigación de Deuda Arquitectural

Para garantizar que el MVP sea una base de producción sólida:

1. **Aislamiento de Contratos**: Los providers de repositorios usan clases abstractas del dominio. Migrar del emulador a producción real es tan simple como añadir una nueva clase concreta en `/data/` y cambiar el binding del provider en `repository_providers.dart`.

2. **Cálculos Determinísticos**: El motor clínico es completamente independiente de Flutter. Puede compilarse en Dart puro y ejecutarse en un worker serverless Node/Dart sin modificar una sola línea de lógica de negocio.

3. **Doble Capa de Seguridad**: Aunque el cliente tenga bugs de routing, las reglas Firestore bloquean accesos no autorizados a nivel de servidor. Esta arquitectura defense-in-depth reduce la superficie de ataque efectiva.

4. **`autoDispose` en Providers**: Todos los providers de datos críticos (`personalScoreProvider`, `teamScoresProvider`, `consentProvider`, `managerActionsProvider`) son `autoDispose`, liberando memoria y subscripciones Firestore cuando el widget no está montado.
