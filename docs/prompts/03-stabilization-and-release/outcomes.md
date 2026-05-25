# Outcomes — Estabilización y Cierre de la Fase Release Candidate

**Fecha:** Mayo 2026
**Resultados:** Fase completada con éxito. Repositorio estabilizado, reglas validadas, Crashlytics integrado de forma limpia, y documentación convertida a nivel corporativo premium.

## 1. Decisiones Cerradas y Logros Técnicos

| # | Decisión/Cambio | Razón Técnica / Implementación | Validación Real |
|---|---|---|---|
| 1 | **Integración de Crashlytics Platform-Safe** | Se añadió `firebase_crashlytics: ^3.5.7`. Se inicializa en `lib/main.dart` de forma segura. La recolección se activa únicamente fuera de desarrollo y de emuladores (`!kDebugMode && !useEmulator`) para evitar ruido. | Compila y se inicializa sin errores en el arranque. |
| 2 | **Límites de Error Globales (Async + Sync)** | Se configuró `FlutterError.onError` para capturar crashes de la UI del framework, y `PlatformDispatcher.instance.onError` para capturar excepciones asíncronas no capturadas. Ambos reportan como fatal. | Verificado mediante simulación de excepciones. |
| 3 | **Observabilidad de Proveedores (Riverpod)** | Se implementó `AppProviderObserver` en `lib/shared/logging/app_provider_observer.dart` y se registró en la raíz de `ProviderScope`. Todos los fallos de providers se envían automáticamente como errores no fatales a Crashlytics. | Verificado; logs de Riverpod en consola activos. |
| 4 | **Logs Integrados como Breadcrumbs** | Se actualizó `AppLogger` (`app_logger.dart`) para inyectar cada log de consola como breadcrumb en `FirebaseCrashlytics.instance.log(message)`. El método `AppLogger.error` captura opcionalmente un error y stack trace y los reporta automáticamente a Crashlytics. | Integración completa en el logger transversal de la app. |
| 5 | **Endurecimiento de Reglas Firestore** | Se modificó la regla `/seed_status/{docId}` en `firestore.rules` restringiendo las escrituras a `allow write: if isAuthenticated();`. Esto impide que atacantes externos manipulen el estado de seeding sin credenciales, mientras que el script de inicio sigue funcionando perfectamente al estar autenticado como usuario demo. | Suite `firestore-tests` verificada en verde. |
| 6 | **Refactor de Utilidades Obsoletas** | Se actualizó `test/verify_manager_flow.dart` reemplazando los nombres de colección antiguos (`burnout_memberships` y `burnout_scores`) por los nombres de producción planos (`memberships` y `scores`). | El archivo ahora es consistente con las colecciones reales de la base de datos. |

## 2. Validación de Calidad

* **Linter Estático:** `flutter analyze` reporta `No issues found!`.
* **Pruebas Unitarias de Scoring:** `flutter test` pasa 100% en verde con todas las heurísticas validadas.
* **Alineación de Documentación:** Todos los archivos en `docs/` se han re-auditado y armonizado para que no haya contradicciones regulatorias ni técnicas con el código fuente.
