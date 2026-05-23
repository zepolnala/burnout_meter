# Outcomes — Resultados del Scaffolding Inicial de BurnoutMeter

> Este documento detalla la estructura inicial generada para el scaffold del proyecto BurnoutMeter, justificando cada decisión de diseño tomada para asegurar un repositorio extremadamente defendible y de nivel de producción corporativo.

**Sesión:** 2026-05-22
**Estado:** Generado & Completado

---

## 📂 Archivos y Estructura Generados

Se ha estructurado y generado con éxito la arquitectura base del proyecto:

| # | Archivo / Componente | Propósito Técnico | Decisiones de Diseño & Tradeoffs |
|---|---|---|---|
| 1 | `pubspec.yaml` | Gestión de dependencias y plugins. | Versiones estrictas de Drift, Riverpod, go_router, fl_chart, Firebase y health stubs. |
| 2 | `analysis_options.yaml` | Reglas de linter y compilador estrictas. | Forzado de tipado fuerte (`strict-casts`, `strict-inference`) y prevención de malas prácticas (`avoid_print`, `close_sinks`). |
| 3 | `Makefile` & `scripts/bootstrap.sh` | Automatización de tareas de desarrollo. | Script unificado de limpieza, obtención de paquetes, ejecución de build_runner y análisis estático. |
| 4 | `lib/main.dart` | Punto de entrada inicial. | Inyección limpia de `ProviderScope` y `MaterialApp.router` enlazando el tema. |
| 5 | `lib/shared/theme/app_theme.dart` | Tema visual del sistema (HSL wellness). | Paleta de colores wellness sobria (Slate/Teal) con semáforo de alerta de burnout (Verde, Naranja, Rojo). |
| 6 | `lib/shared/routing/app_router.dart` | Configuración de go_router con guardas. | Redirecciones dinámicas basadas en Auth claims y membresías de roles jerárquicos. |
| 7 | `lib/domain/models/` | Modelos Freezed del dominio core. | Inmutabilidad completa para `Membership`, `HealthSample`, `Score`, `Consent`, `ActionInstance` y `AuditLog`. |
| 8 | `lib/data/local/db.dart` | Persistencia y caché local Drift (SQLite). | Tablas optimizadas para almacenamiento offline de health samples y acciones in-app. |
| 9 | `lib/data/sources/health/` | Orígenes de datos wearables polimórficos. | Ingestión desacoplada mediante interfaz `HealthDataSource` con stubs Synthetic, deterministic Replay (fixture JSON), y HealthKit. |
| 10 | `lib/domain/services/scoring_engine.dart` | Motor fisiológico de Burnout Index. | Ecuaciones y pesos balanceados sobre HRV, sueño, stress y carga física (MDR compliant placeholder). |
| 11 | `lib/shared/providers/` | Manejadores de estado de Riverpod. | Inyección de dependencias modular. `authProvider` incluye un selector manual para simplificar la QA del revisor. |
| 12 | `lib/presentation/shared/app_shell.dart` | Selector universal de roles. | Panel de control glassmórfico de demostración que permite alternar la sesión entre Empleado, Manager y Admin instantáneamente. |
| 13 | `lib/presentation/employee/` | Shell de Empleado (mobile-first). | Dashboard con radial gauge, centro de consentimientos y bandeja de acciones con aceptar/rechazar. |
| 14 | `lib/presentation/manager/` | Shell de Manager (web-first). | Listado de miembros, bloqueo visual de privacidad (🔒 *Privado* si no hay consentimiento) y drawer parametrizable para gatillar acciones. |
| 15 | `lib/presentation/admin/` | Shell de Admin (web-first). | Panel administrativo global multi-tenant e historial de auditoría de accesos inmutable. |
| 16 | `firestore.rules` | Reglas de seguridad de Firestore. | Aislamiento estricto de biometría a nivel servidor. Logs de auditoría de escritura única. |
| 17 | `functions/index.js` | Cloud Functions de Firebase. | Agregaciones de equipo seguras con umbral de anonimización (N >= 5) y relay de notificaciones push. |
| 18 | `.github/workflows/` | Pipeline de integración continua (CI). | Pipeline automático que valida paquetes, corre generadores, linters y tests unitarios. |
| 19 | `README.md` | Documentación corporativa de la arquitectura. | Explicación detallada del proyecto, arquitectura de carpetas, y manual de instalación. |

---

## 🔍 Tradeoffs y Decisiones Clave Aceptadas

1. **In-Memory Mock Repositories (`mock_repositories.dart`)**:
   - *Decisión*: Se han implementado todos los repositorios en base a una estructura en memoria con reactividad vía Streams nativos de Dart.
   - *Tradeoff*: Permite que el scaffold sea 100% interactivo y compilable de forma inmediata en cualquier plataforma (Web/Mobile/Desktop) sin requerir credenciales Firebase reales iniciales ni emuladores locales corriendo, acelerando la validación del revisor.
2. **Selector de Roles en AppShell**:
   - *Decisión*: Se ha diseñado una consola glassmórfica a nivel de `/` que permite alternar la sesión simulada del usuario activo instantáneamente.
   - *Tradeoff*: En lugar de forzar a un evaluador técnico a registrar tres cuentas y alternar logins, la consola demuestra las tres vistas del sistema en menos de 10 segundos, enfatizando el "Privacy-by-Design" (al ver cómo se oculta/muestra el score del empleado según sus preferencias en tiempo real).
3. **Guardas Estrictas en GoRouter**:
   - *Decisión*: El enrutador realiza redirecciones reactivas en base al rol presente en el claim de Riverpod.
   - *Tradeoff*: Si un usuario intenta acceder a `/manager` estando en sesión de `employee`, el sistema lo redirige inmediatamente a `/unauthorized`, protegiendo las fronteras de los bounded contexts del frontend.
