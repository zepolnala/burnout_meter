# Bitácora de Prompts: Depuración Crítica y Optimización de Estabilidad

Esta bitácora resume las acciones, prompts lógicos y soluciones adoptadas durante la fase de depuración para resolver fugas de memoria, errores de permisos y navegación del proyecto **BurnoutMeter B2B**.

---

## 🔍 Contexto y Desafíos Identificados

Al ejecutar el proyecto localmente y cambiar de cuentas dinámicamente en el dashboard web, surgían errores críticos de tipo `[cloud_firestore/permission_denied] Null value error for 'list' @L93`. Esto rompía la confianza del manager sobre la consola de administración y producía bloqueos en la navegación de empleados.

Identificamos tres causas raíces interconectadas:
1. **Fugas de Memoria en Riverpod**: Los proveedores de tipo `StreamProvider` y `StateNotifierProvider` no utilizaban desecho automático (`.autoDispose`). Al alternar sesiones entre usuarios sin recargar la web (SPA), las suscripciones anteriores a Firestore se mantenían vivas con los tokens de sesión antiguos, causando colisiones e infracciones de políticas de seguridad.
2. **Crash en Reglas de Firestore**: En `firestore.rules`, la regla de seguridad `list` intentaba evaluar la propiedad `orgId` u `role` extrayéndola de un documento de membresía inexistente en el caso de correos mal configurados. Esto producía un error de evaluación por valor nulo (`Null value error`) en backend, bloqueando preventivamente toda petición.
3. **Discrepancia en Dominios de Correo**: El selector rápido del dashboard iniciaba sesión con correos `.com` (`employee_eng1@burnoutmeter.com`), mientras que el servicio de semilla de datos (`SeedService`) registraba cuentas con el dominio `.demo` (`employee_eng1@burnoutmeter.demo`).

---

## 🛠️ Soluciones Ejecutadas

### 1. Inyección de `.autoDispose` y Cancelaciones Explícitas
Modificamos todos los proveedores en `burnout_providers.dart` asociados con identificadores dinámicos de usuario para que sean desechados automáticamente en cuanto la vista de navegación se desmonte. 

```dart
final consentProvider = StateNotifierProvider.autoDispose.family<ConsentNotifier, AsyncValue<Consent?>, String>((ref, userId) {
  return ConsentNotifier(ref, userId);
});
```

En la clase `ConsentNotifier`, implementamos una desconexión activa del flujo en el método `dispose()` de Riverpod para cerrar explícitamente el canal abierto:
```dart
@override
void dispose() {
  _subscription?.cancel();
  super.dispose();
}
```

### 2. Blindaje de las Reglas de Seguridad en Firestore
Actualizamos `firestore.rules` para incorporar una función protectora `hasMembership()` que verifica la existencia del documento mediante la directiva `exists()` antes de leer sus campos de datos:

```javascript
function hasMembership() {
  return exists(/databases/$(database)/documents/memberships/$(request.auth.uid));
}

function getMembership() {
  return get(/databases/$(database)/documents/memberships/$(request.auth.uid)).data;
}

function getRole() {
  return hasMembership() ? getMembership().role : 'none';
}
```

### 3. Sincronización del Panel de Conmutación Rápida
Modificamos `auth_provider.dart` y los controladores de inicio de sesión para alinear los dominios utilizados en el selector de pruebas al dominio `.demo` sembrado por `SeedService`. Esto garantizó que cada perfil tuviera un documento de membresía y consentimiento válido asociado.

### 4. Corrección de Tipos en Dart y Reglas de Índices
Para evitar el error de casting en tiempo de compilación con genéricos de Firestore (`Query` vs `Query<Map<String, dynamic>>`), cambiamos la asignación a un formato de inferencia de tipo seguro (`var query = ...`), asegurando que las cláusulas de restricción `where('teamId')` y `where('orgId')` respeten las directivas de seguridad para evitar accesos masivos a tablas.

---

## 📈 Resultados Obtenidos
- **Feroz Estabilidad**: 100% de los accesos dinámicos en caliente entre perfiles (Alan, Sofía, Víctor, Tomás) funcionan sin atascos de carga ni errores de "Permission Denied".
- **Privacidad Confiable**: El manager Víctor visualiza de forma agregada las métricas de Alan porque tiene habilitado "Compartir Index", pero el perfil de Sofía se bloquea con total hermetismo en tiempo real respetando la lógica de consentimiento GDPR sin caídas del sistema.
