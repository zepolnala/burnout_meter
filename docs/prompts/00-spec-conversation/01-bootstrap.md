# 01 — Bootstrap: prompt inicial de la sesión de spec

> Este documento archiva el prompt original con el que se inició la sesión de tech advisory que produjo `SPEC.md`. Se conserva tal cual fue enviado, sin reescritura posterior, para garantizar la trazabilidad del proceso.

**Fecha:** 2026-05-22
**Modelo:** Claude (Anthropic), sesión de tech advisory
**Rol asignado al modelo:** Tech advisor senior. No escribe código. Hace preguntas, cuestiona decisiones, estructura la spec final.
**Output esperado:** `SPEC.md` + tres documentos de trazabilidad en `docs/prompts/00-spec-conversation/`.

---

## Prompt original

Voy a construir una app Flutter como assessment para un puesto de CTO
en una empresa wellness (Wellbeinn) que lanza un wearable.

El producto es una solución B2B de detección temprana de carga
psicofisiológica (burnout) con TRES roles jerárquicos:

ROL EMPLEADO (app móvil Flutter):
- Recibe datos del wearable (simulados en este prototipo)
- Ve su propio índice de carga diaria
- Recibe notificaciones in-app de su manager o admin con acciones
  sugeridas
- Tiene control total sobre qué datos comparte y con quién
- Puede pausar el compartir o desvincularse cuando quiera

ROL MANAGER (panel web, mismo proyecto Flutter compilado a web):
- Ve a los empleados de SUS equipos asignados
- Ve scores agregados, NUNCA datos fisiológicos crudos
- Puede disparar acciones predefinidas hacia un empleado de su equipo
- No puede ver empleados fuera de su equipo

ROL ADMIN (panel web, mismo Flutter):
- Ve a TODOS los empleados de la organización
- Ve agregados por equipo y a nivel compañía
- Puede disparar acciones hacia cualquier empleado de la organización
- Gestiona equipos y asignación manager-equipo

Modelo organizacional:
- Estructura multi-tenant (preparada para varias organizaciones),
  pero la demo seedea solo UNA organización
- Equipos planos dentro de la organización (no jerarquía profunda)
- RBAC simple con 3 roles fijos
- Un manager puede gestionar varios equipos
- Un empleado pertenece a un único equipo

Principios no negociables del producto:
- Privacy-by-design: ni manager ni admin ven datos fisiológicos
  crudos. Solo scores derivados, y solo si el empleado lo ha
  consentido explícitamente.
- El empleado siempre puede pausar el compartir o desvincularse.
- Lenguaje cuidadoso: nunca "diagnóstico", siempre "indicadores
  de carga" o "señales tempranas".
- Las reglas de seguridad del backend (Firestore) son la verdad
  del modelo de permisos, no el frontend.

Necesito construir un documento SPEC.md que será el contrato sobre
el que un agente de código (Antigravity) generará el scaffolding
y las features.

Tu rol: actúas como tech advisor senior. NO escribes código.
Me haces preguntas, me retas decisiones, y al final estructuras
la spec en un documento markdown bien organizado.

La SPEC.md debe cubrir:
1. Contexto y objetivos del producto
2. Personas y roles detallados (employee, manager, admin)
3. User journeys principales (mínimo: onboarding empleado,
   invitación, manager revisa equipo, manager dispara acción,
   empleado recibe acción, empleado pausa el compartir,
   admin revisa compañía)
4. Decisiones arquitectónicas con justificación:
   - State management (Riverpod)
   - Capas (domain, data, presentation)
   - Navegación (go_router con guardas por rol)
   - Persistencia local (Drift o Hive)
   - Codebase única Flutter para mobile + web
   - Estrategia para separar/compartir UI entre mobile y web
5. Modelo de datos canónico (todas las entidades con sus campos)
6. Interfaces clave:
   - HealthDataSource (synthetic, replay, healthkit stub)
   - ScoringEngine
   - ConsentManager
   - NotificationService
   - OrganizationService (gestión de teams, members, roles)
   - ActionService (catálogo de acciones, envío, recepción)
7. Stack y dependencias justificadas
8. Modelo de datos del backend (Firestore):
   - Colecciones y estructura
   - Reglas de seguridad pseudocódigo (qué puede leer/escribir
     cada rol bajo qué condiciones) - ESTO ES CRÍTICO, dedícale
     espacio
   - Cloud Functions necesarias (envío de notificaciones,
     agregaciones, etc.)
9. Estructura de carpetas del proyecto
10. Estrategia de testing (qué se testea, qué no, por qué)
11. Lo que NO se construye y por qué (alcance fuera explícito)
12. Mapa de cumplimiento:
    - GDPR (consentimiento, derecho al olvido, portabilidad)
    - Contexto laboral español (LOPD, ley de riesgos psicosociales)
    - Mención de MDR (no aplica al ser herramienta de bienestar
      no diagnóstica, pero documentar dónde estaría el límite)
13. Plan de implementación por días (tengo 5-6 días reales)

Restricción importante sobre trazabilidad:
Al final de la conversación, además del SPEC.md, generarás
TRES documentos para guardar en /docs/prompts/00-spec-conversation/:

a) 01-bootstrap.md — este prompt inicial, tal cual.
b) 02-architecture-decisions.md — síntesis de la conversación:
   qué pregunté, qué me cuestionaste, qué decidimos y por qué.
c) outcomes.md — tabla con: Decisión | Alternativas | Razón final
   | Sección de SPEC.md donde vive.

Empieza preguntándome las 6 decisiones más críticas que necesitas
saber para no improvisar. Una pregunta cada vez. No avances hasta
tener respuesta clara.

Stack que estoy considerando (cuestiónalo si no encaja):
- Flutter 3.x para mobile (Android primero, iOS si sobra tiempo)
  y web (panel manager + admin)
- Riverpod para state management
- go_router para navegación con guardas por rol
- Firebase: Auth (con custom claims para roles), Firestore,
  Functions (envío de notificaciones, agregaciones),
  Cloud Messaging (notificaciones push opcional, in-app prioritario)
- Drift (SQLite) para cache local del empleado
- Paquete `health` para HealthKit/Health Connect stub
- Charts: fl_chart

Contexto del proyecto:
- Hardware real: E500 white-label chino
- El MVP actual lo hizo el CTO actual (Victor) con Claude Code
  en 1 mes
- Victor va a evaluar el código, valora pragmatismo y pilotaje
  de IA, no purismo
- Mi nivel Flutter: intermedio (cursos, no producción)
- Ángulos diferenciadores del assessment:
  (a) privacy-by-design real, enforced en backend
  (b) caso de uso B2B con jerarquía que ellos no han explotado
  (c) trazabilidad completa del uso de IA en el repo

Empieza ahora con la primera pregunta crítica.

---

**Notas sobre el bootstrap:**

- El prompt restringe explícitamente al modelo a no escribir código, forzando un modo socrático de elicitación de decisiones.
- El timebox de 5-6 días se hace explícito desde el inicio para que las recomendaciones se calibren a esa restricción.
- El stack se presenta como hipótesis cuestionable, no como dado. El modelo acepta el stack base sin objeciones, lo que se documenta como decisión implícita.
- Se exige trazabilidad de la conversación en tres documentos. Este es el primero.