# Technical Debt Registry

Registro profesional de deuda técnica aceptada durante la fase MVP de **BurnoutMeter**. Categorizado para garantizar mantenibilidad y priorizar refactorización futura.

**Última revisión:** Mayo 2026

---

## 📊 Technical Debt Breakdown

### 1. Deuda Aceptada (Intencionalmente Diferida)

#### Fixtures Sintéticas para Wearables
- **Contexto**: `SyntheticHealthDataSource` genera biometría determinística en función del UID. Reemplazó al antiguo `ReplayHealthDataSource` que usaba un JSON estático idéntico para todos los usuarios.
- **Mejora vs anterior**: Ahora cada UID produce valores ligeramente distintos, haciendo los dashboards más realistas.
- **Deuda restante**: Sigue siendo completamente sintético — no hay integración con iOS HealthKit, Android Health Connect ni ninguna API de wearable real.
- **Ruta de migración**: La interfaz abstracta `HealthDataSource` ya existe en el dominio. Crear una implementación concreta `HealthKitDataSource` e inyectarla vía `repository_providers.dart`.

#### Score Calculado Client-Side
- **Contexto**: El score se calcula en el cliente (`ScoringEngine`) y se guarda directamente en Firestore `/scores/`.
- **Regla protectora actual**: Firestore rules permiten que el owner escriba su propio score (`isOwner(request.resource.data.userId)`).
- **Riesgo**: Un cliente modificado puede escribir scores arbitrarios para su propio userId.
- **Migración**: Mover `ScoringEngine` a una Cloud Function que se dispare automáticamente al escribir en `/healthSamples/`.

---

### 2. Deuda de Debug Activa (DEBE ELIMINARSE ANTES DE PRODUCCIÓN)

* **Estado Actual**: ✅ **Totalmente Mitigada y Eliminada**

Todos los elementos de depuración y soporte temporal inyectados durante el diagnóstico del pipeline E2E han sido completamente purgados y eliminados del código fuente de producción:

#### `RouterLogs` en `app_router.dart`
* **Acción realizada**: Se eliminó por completo la clase estática `RouterLogs` y el acumulador global de logs en memoria, previniendo cualquier riesgo de *memory leak* por crecimiento acumulativo. El enrutamiento ahora confía de forma íntegra en la infraestructura asíncrona de `AppLogger`.

#### Widgets de diagnóstico en `login_screen.dart`
* **Acción realizada**: Se eliminaron todos los textos condicionales con keys de testing (`login_error_text`, `login_status_loading`, `login_status_data`, `router_logs_text`) que exponían información del estado interno en la UI de producción.

#### Import circular potencial
* **Acción realizada**: Se eliminó el acoplamiento directo entre la pantalla de login (`login_screen.dart`) y el enrutador (`app_router.dart`) al retirar las dependencias cruzadas de logs temporales, restableciendo el aislamiento estricto entre Presentation y Routing.

---

### 3. Deuda Intencional (Limitaciones del Scope MVP)

#### Visualizaciones de Tendencia Mockeadas
- **Contexto**: Las barras de promedio semanal de frecuencia cardíaca en `EmployeeShell` renderizan arrays estáticos.
- **Estado actual**: La UI del card ya está preparada; usa `fl_chart` para las barras.
- **Deuda**: No refleja consultas históricas reales desde Firestore.
- **Migración**: Implementar `FutureProvider` que consulte `/healthSamples/` agrupando por semana.

#### Audit Logs escritos por el cliente
- **Contexto**: Los audit logs se escriben desde la aplicación cliente en requests de lectura.
- **Protección actual**: Las reglas Firestore son write-once con verificación `actorUserId == request.auth.uid`.
- **Deuda**: Un usuario puede leer datos sin generar un log si bypasea el cliente (e.g., via API directa).
- **Migración**: Mover la escritura de audit logs a Firestore Triggers/Eventarc en backend.

#### OnboardingDialog siempre visible
- **Contexto**: El `OnboardingDialog` se muestra en cada login (no solo el primero).
- **Deuda**: La lógica de "primer login" no está implementada — no hay flag de `hasSeenOnboarding` en Firestore.
- **Migración**: Añadir campo `hasSeenOnboarding: bool` al documento de membership o consent. Leerlo en el shell antes de mostrar el dialog.

#### `orgId` hardcodeada como fallback
- **Contexto**: En `burnout_providers.dart`, cuando no se puede recuperar la membership, se usa `orgId: 'org789'` como fallback.
- **Deuda**: En producción, este fallback generaría consultas incorrectas a Firestore.
- **Migración**: Lanzar un error en lugar de usar un fallback hardcodeado.

---

### 4. Roadmap de Modularización Futura

| Componente | Estado MVP | Estado Producción | Esfuerzo |
|---|---|---|---|
| **ScoringEngine** | Dart puro, client-side | Paquete Dart standalone (`burnoutmeter_scoring`) | Medio |
| **AppLogger** | `print()` wrapper | OpenTelemetry → GCP Cloud Logging / Sentry | Bajo |
| **RBAC** | Roles en Firestore | JWT Custom Claims via Firebase Admin SDK | Alto |
| **Scoring trigger** | Cliente escribe score | Cloud Function dispara en `/healthSamples/` write | Alto |
| **Audit trail** | Cliente escribe log | Firestore Trigger / Eventarc backend | Medio |
| **Wearable source** | Sintético (UID-based) | HealthKit / Health Connect / OAuth Oura/Fitbit | Alto |
| **OnboardingDialog** | Siempre visible | Controlado por flag `hasSeenOnboarding` | Bajo |
| **RouterLogs** | Lista global en memoria | Eliminado | Bajo |

---

## 🛠️ Mitigación de Deuda Activa

Para garantizar que el MVP sea una base de producción sólida:

1. **Aislamiento de contratos**: Los providers de repositorios usan clases abstractas del dominio. Cambiar del emulador a producción real requiere solo añadir una implementación concreta nueva en `/data/` y cambiar el binding en `repository_providers.dart`.

2. **Cálculos deterministas**: El motor clínico está completamente aislado de Flutter. Puede compilarse en Dart puro y ejecutarse en un worker serverless de Node/Dart sin modificar una sola línea de lógica de negocio.

3. **Reglas Firestore como última línea**: Aunque el cliente tenga bugs, las reglas de Firestore bloquean accesos no autorizados a nivel de servidor. Esta doble capa (client guard + server rule) reduce la superficie de ataque.
