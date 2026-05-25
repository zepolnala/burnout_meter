# Bootstrapping Stabilization and Release Candidate (RC) Phase

**Fecha:** Mayo 2026
**Objetivo:** Transición del proyecto a modo Release Candidate. Estabilizar, limpiar, documentar, integrar Firebase Crashlytics de forma segura, endurecer reglas de Firestore y preparar la demo técnica de evaluación para el CTO.

## Prompt Recibido

```markdown
Mañana debo presentar BurnoutMeter y quiero entrar en modo “release candidate”.
Tu objetivo ya NO es agregar features nuevas.
Tu objetivo es:
* estabilizar
* limpiar
* endurecer
* documentar
* preparar demo
* preparar narrativa técnica
* dejar el repo impecable para evaluación CTO

# REGLA PRINCIPAL
NO reportes éxito sin validación real. Cada cambio debe ejecutarse, testearse, verificarse, quedar documentado y pushearse al repo.

# OBJETIVOS DEL COMPROMISO
1. Firebase Crashlytics (Platform-safe, async + Flutter boundaries, Riverpod ProviderObserver)
2. Release Candidate Cleanup (Unused imports, warnings, logs, dead code)
3. Validación Full Real (analyze, test, firestore-tests, web-release-build)
4. Demo Validation (Employee/Manager/Admin happy paths)
5. README Final (Startup seed-stage seria)
6. Docs Cleanup (Auditar y actualizar docs/)
7. Prompts Archive (Compilar prompts por fases en docs/prompts/)
8. GitHub Actions final hardening (Workflows verdes estables)
9. Push Final (Commit limpio a main)
```

## Estrategia de Ingeniería Planificada

1. **Crashlytics:**
   - Añadir `firebase_crashlytics` a `pubspec.yaml` de forma segura.
   - Configurar en `lib/main.dart` con interceptores de errores asíncronos (`PlatformDispatcher.instance.onError`) y de framework (`FlutterError.onError`).
   - Crear el custom `AppProviderObserver` para capturar fallos de proveedores Riverpod y enviarlos a Crashlytics.
   - Conectar `AppLogger` para usar Crashlytics como recolector de logs de pan rallado (breadcrumbs) y reportar errores no fatales.
2. **Seguridad y Reglas:**
   - Auditar `/seed_status` y restringir escrituras a `isAuthenticated()`.
   - Validar suite de pruebas `firestore-tests`.
3. **Limpieza RC:**
   - Resolver cualquier advertencia de linter e importaciones muertas en la base de código.
4. **Documentación:**
   - Reescribir el `README.md` a nivel corporativo premium.
   - Actualizar y sincronizar los archivos bajo `docs/`.
   - Redactar nuevas guías: `demo-guide.md`, `troubleshooting.md`, `release-checklist.md`.
5. **Doble verificación de demo (Rama de Integración):**
   - Estabilizar `main` primero.
   - Crear la rama `feature/health-connect-integration` para maquetar de forma robusta y compilar la integración nativa de Google Health Connect en Android, mostrando la modularidad de la arquitectura.
