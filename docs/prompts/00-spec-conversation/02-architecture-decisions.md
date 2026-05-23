# 02 — Architecture Decisions: síntesis de la conversación

> Este documento sintetiza la conversación de tech advisory que produjo `SPEC.md`. Para cada decisión, se documenta: qué se preguntó, qué se cuestionó, qué alternativas se descartaron, y la razón final. El objetivo no es reproducir la conversación literal sino dejar la lógica del razonamiento auditable.

**Sesión:** 2026-05-22
**Modalidad:** preguntas críticas, una a una, sin avanzar hasta respuesta clara
**Total de decisiones cerradas:** 6 (con sub-decisiones en algunas)

---

## Marco común de la conversación

El advisor estableció desde el inicio una tensión recurrente:

> "Cada decisión que tomes tiene que justificarse no solo por 'es lo correcto' sino por 'es lo correcto dado el timebox'. Voy a empujarte hacia recortes agresivos en cosas que normalmente defenderías."

Esto significó que en varias decisiones, el advisor empujó activamente hacia la opción más simple, incluso cuando el candidato proponía la más rica. La conversación se desarrolló como una negociación entre ambición técnica y realismo temporal.

---

## Decisión 1 — Modelo de consentimiento

**Pregunta original:** ¿Qué modelo de consentimiento quieres? Binario global, granular por destinatario, o granular por tipo de dato?

**Alternativas presentadas:**
- A) Consentimiento binario global on/off.
- B) Granular por destinatario (manager sí, admin no, por ejemplo).
- C) Granular por tipo de dato (score sí, tendencias no, etc.).

**Recomendación del advisor:** A + audit log de accesos como matiz. La razón: el 80% del valor narrativo de privacy-by-design se captura con on/off + transparencia de accesos, sin pagar el coste de B o C.

**Decisión final:** A con audit log.

**Cuestionamiento residual del advisor:**
> "Apúntate la narrativa: si te preguntan por qué no granular, la respuesta no es 'no me dio tiempo'. Es 'en un piloto B2B real, el consentimiento granular crea fricción de UX que reduce la adopción; un on/off claro con audit log transparente genera más confianza'."

**Vive en SPEC:** sección 3.6, 6.3, 8.1 (`consents/`), 12.1.

---

## Decisión 2 — Flujo de creación de cuentas

**Pregunta original:** ¿Quién crea las cuentas y cómo entran los empleados?

**Alternativas presentadas:**
- A) Self-signup con código de invitación.
- B) Admin crea, empleado entra por magic link.
- C) Seed completo, sin signup en la demo.

**Recomendación del advisor:** C como base, A documentado y stubbed en UI.

**Argumento del advisor:**
> "Implementar el flujo de invitación end-to-end es 1-1.5 días. En tu timebox eso es 20-25% del tiempo total invertido en algo que no es el core del assessment. El core es el modelo de permisos en backend, no el onboarding."

**Decisión final:** C completa. Pantalla de invitación como stub navegable.

**Vive en SPEC:** sección 3.1, 3.2, plan día 3 (script `seed.ts`).

---

## Decisión 3a — Fuente de datos del wearable

**Pregunta original:** ¿De dónde salen los datos del wearable en la demo?

**Alternativas presentadas:**
- A) Synthetic generator (runtime).
- B) Replay de dataset fijo.
- C) HealthKit/Health Connect real vía paquete `health`.

**Recomendación del advisor:** A + B combinados con interfaz `HealthDataSource` polimorfa; C como stub documentado.

**Argumento clave del advisor:**
> "Lo más valioso aquí no es elegir A vs B, es la interfaz `HealthDataSource` con tres implementaciones. Eso es lo que demuestra que has pensado en cómo enchufar el hardware real luego sin reescribir nada. La demo usa replay (determinista, controlable, cuentas la misma historia siempre); synthetic y healthkit-stub demuestran la arquitectura."

**Decisión final:** las tres implementaciones, replay como default de demo.

**Vive en SPEC:** sección 6.1, estructura de carpetas (`data/sources/health/`), assets fixture.

---

## Decisión 3b — Forma del score (subdecisión)

**Pregunta original:** ¿El score es un único número 0-100 o un vector de subscores desglosado?

**Alternativas presentadas:**
- A) Score único 0-100.
- B) Score compuesto, 4 subscores desglosados visibles.
- C) Score único en UI, subscores internos en modelo y engine.

**Recomendación del advisor:** C, por razones narrativas más que técnicas:

> "En la demo, cuando le enseñes el código del ScoringEngine, quieres que vea que has modelado bien (varias señales fisiológicas → score derivado). Pero en UI quieres simplicidad porque un manager mirando 8 empleados no quiere descifrar radares. Te quedas con lo mejor de A y B: arquitectura rica por dentro, UX simple por fuera."

**Decisión final:** C. Subscores en modelo y engine; UI muestra solo número agregado; pantalla de detalle opcional como stretch.

**Nota crítica añadida por el advisor:**
> "En el SPEC voy a dejar explícito que las fórmulas son heurísticas plausibles, no validadas clínicamente. Esto importa para MDR. La respuesta correcta si te preguntan por la validación es 'son heurísticas de demostración; la validación clínica sería el siguiente paso y requeriría un estudio'. No te metas en defender que las fórmulas son correctas; defiende que la arquitectura permite cambiarlas cuando haya validación."

**Vive en SPEC:** sección 5 (`Score`, `Subscores`), 6.2, 12.3.

---

## Decisión 4 — Mobile vs Web: estrategia de codebase

**Pregunta original:** ¿Cuánto código compartes y cuánto separas entre mobile y web?

**Alternativas presentadas:**
- A) Una sola app con responsive layout (`if (isWide)`).
- B) Dos shells separados por plataforma, dominio compartido.
- C) Tres shells separados por **rol**, no por plataforma; dominio y data compartidos.

**Recomendación del advisor:** C, tomando lo mejor de B.

**Argumento clave:**
> "B te obliga a tener dos `main.dart` y dos pipelines de build. Eso es trabajo de setup que no tienes. C te da el 90% del beneficio de B con la mitad del coste, y cuando te pregunten '¿y si un manager quiere consultar desde móvil?', tu respuesta es 'el shell de manager se renderiza también en móvil, no optimizado, pero la arquitectura permite añadir variantes responsive por rol sin reescribir porque la división es por rol, no por plataforma'."

**Argumento contra A:**
> "La app responsive universal en Flutter web casi siempre acaba pareciendo una app móvil ampliada. Un panel de admin con cards de móvil estiradas es exactamente la señal visual de 'esto lo ha hecho alguien que no diferencia plataformas'."

**Decisión final:** C, con `presentation/employee/`, `presentation/manager/`, `presentation/admin/`, `presentation/shared/`.

**Detalle de implementación apuntado:**
> "Hay un `AppShell` que es básicamente un router de routers: hace `authState.when(loading, error, authenticated)` y en el branch authenticated lee el claim y devuelve uno de los tres shells. Esto es trivial con Riverpod pero hay que dejarlo claro en la spec porque es donde un agente de código podría meter la pata."

**Vive en SPEC:** sección 4.5, 4.6, estructura de carpetas, plan día 2.

---

## Decisión 5 — Modelo de permisos en Firestore

**Pregunta original:** ¿Dónde guardas la información de "este manager gestiona estos equipos" para que las reglas de Firestore la consulten?

**Alternativas presentadas:**
- A) Todo en custom claims de Firebase Auth (incluido `teamIds`).
- B) Todo en Firestore, las reglas hacen lecturas con `get()`.
- C) Híbrido: claim mínimo `{role, orgId}` + Firestore para pertenencia dinámica.

**Recomendación del advisor:** C con argumentación reforzada.

**Tres razones contra A:**
1. Reasignación en vivo durante la demo: con A requiere logout/login del manager. Con C es instantáneo.
2. Custom claims limitados a 1KB; en producción real con managers de 5 equipos de 20 personas, el array crece.
3. Auditabilidad: el argumento de venta es "privacy-by-design enforced en backend"; las reglas tienen que ser legibles end-to-end. Con A la lógica se diluye entre claim opaco y regla; con C todo está en la regla.

**Modelo de datos cerrado en la decisión:**
- Custom claim: `{role, orgId}`.
- Colección `memberships/{userId}` con `{role, orgId, teamId, managedTeamIds, updatedAt}`.
- Reglas usan `let membership = get(.../memberships/$(uid))` al inicio y cachean.

**Compromiso vinculante del advisor:**
> "Las reglas tienen que tener tests con el emulador de Firestore. Mínimo cinco casos críticos. Si dices 'tengo reglas' sin tests, es palabra. Si dices 'tengo reglas con tests verdes que demuestran los casos límite', es prueba. No te voy a dejar saltarte esto."

**Decisión final:** C con tests obligatorios.

**Vive en SPEC:** sección 4 (modelo de datos), 8.1 y 8.2 (reglas pseudocódigo), 10 (estrategia testing).

---

## Decisión 6 — Catálogo de acciones (tres sub-decisiones)

Esta decisión fue la más conflictiva de la sesión. El candidato inicialmente eligió tres opciones que el advisor cuestionó frontalmente, forzando una segunda iteración.

### 6a — Tamaño del catálogo de acciones

**Primera respuesta del candidato:** catálogo rico, 10+ acciones.

**Pushback del advisor:**
> "Diez acciones no demuestran nada técnico que tres no demuestren. La arquitectura de ActionService es la misma. Lo que cambia es: diseñar 10 templates, 10 iconos, 10 estados, 10 entradas de seed. Y en la demo enseñas 2 o 3, porque nadie ve 10 acciones en una demo de 15 minutos."

**Segunda iteración:** punto medio, 5-6 acciones.

**Respuesta del advisor:** "Acepto 5, pero elijo yo las 5 con racional, porque el riesgo de '5-6' sin lista es que acabarás en 8."

**Las 5 acciones congeladas:**
1. `suggest_break` — pausa breve hoy. Baja fricción.
2. `offer_1on1` — conversación 1:1. Relacional.
3. `share_resource` — recurso (artículo, audio, ejercicio). Contenido.
4. `recommend_time_off` — sugerir día libre. Alta fricción, solo patrones serios.
5. `wellness_check` — "¿cómo estás?" con respuesta opcional 1-5. Check-in.

**Racional del set:** cubre espectro baja↔alta fricción, individual↔relacional, dar↔preguntar. Cualquier acción real es variante de una de estas cinco. `escalate_to_hr` (admin-only) descartada explícitamente: tentadora pero abre caja de pandora (¿qué ve RRHH?, ¿cuarto rol?). No vale la pena.

**Decisión final 6a:** 5 acciones congeladas, modeladas como `ActionTemplate` parametrizable.

### 6b — Manager-initiated vs system-suggested

**Primera respuesta del candidato:** system-suggested, manager-approved.

**Pushback del advisor (fuerte):**
> "Esta es la más peligrosa. Implica Cloud Function programada, motor de reglas (cada patrón es una conversación de producto), lógica anti-duplicados, cinco estados en lugar de tres, pantalla extra en panel manager. Entre día y medio y dos días. Te lo come del lado backend, que es donde tienes que tener calidad para defender las reglas. Y si el sistema sugiere mal (y va a sugerir mal porque las heurísticas no están validadas), la demo se vuelve 'el sistema sugiere raro y el manager descarta'. Peor que manager-initiated puro."

**Segunda iteración:** manager-initiated como base.

**Decisión final 6b:** manager-initiated como modelo principal. System-suggested **diseñado en spec con estados, función, motor conceptual**, pero implementación marcada como **stretch día 5-6**.

### 6c — Capacidad del empleado de rechazar/silenciar

**Respuesta del candidato (aceptada sin objeción):** sí, el empleado puede rechazar y silenciar.

**Matiz pendiente forzado por el advisor:** ¿el manager ve el estado `dismissed`?

**Opciones presentadas:**
- Transparente: manager ve `dismissed` si abre el detalle, sin notif push.
- Opaca: manager solo ve `received` o `acknowledged`; dismiss invisible.

**Decisión final 6c:** transparente. Coherente con audit log decidido en pregunta 1: simetría entre lo que el empleado audita y lo que el manager audita.

**Estados finales:** `sent → received → acknowledged | dismissed`. Sin notificación push de dismissions.

**Vive en SPEC:** sección 3.4, 3.5, 5 (`Action`, `ActionTemplate`), 6.6, 8 (reglas de actions), plan día 4 y 5.

---

## Decisiones implícitas no negociadas

Algunas decisiones del prompt original fueron aceptadas por el advisor sin cuestionar, y por tanto se documentan aquí como aceptadas implícitamente:

| Decisión implícita | Razón de no-cuestionamiento |
|---|---|
| Flutter como stack principal | Encaja con codebase única mobile+web y con perfil del candidato (intermedio Flutter). |
| Firebase como backend | Encaja con timebox (zero setup vs custom backend) y con necesidad de reglas declarativas auditables. |
| Riverpod sobre Bloc/Provider/GetX | Acertado para el caso; advisor confirmó en sección 4.1 sin debate. |
| go_router | Estándar de facto Flutter, sin alternativa relevante en timebox. |
| Drift sobre Hive | Justificado por necesidad de queries con joins sobre series temporales. |
| fl_chart | Estándar Flutter para charts; sin alternativa relevante. |

---

## Avisos finales emitidos por el advisor antes de generar el SPEC

**Aviso 1 — sobre timebox:**
> "El día crítico es el 3-4 (Firestore + reglas + tests). Si ese día se va de madre, sacrificas system-suggested, pantalla de detalle de subscores, y HealthKit real (ya stubbed). En el plan voy a marcar qué se cae primero, para que en la demo digas 'decidí recortar X porque Y', no 'no me dio tiempo a X'."

**Aviso 2 — sobre trazabilidad de IA:**
> "El SPEC va a incluir una sub-sección de 'AI usage trail' con la estructura de `docs/prompts/` para fases siguientes. No voy a inventar los prompts de scaffolding/features — los harás tú con Antigravity — pero sí dejo la convención de carpetas y nombres. Esto es lo que diferencia 'le pedí cosas a una IA' de 'tengo un proceso de ingeniería con IA'."

**Aviso 3 — sobre quién genera los documentos de trazabilidad:**

Cuando el candidato preguntó si se podía pedir a Antigravity que generara los cuatro documentos, el advisor rechazó:

> "Estos cuatro documentos son el contrato sobre el que Antigravity va a generar código. Si Antigravity los genera, estás pidiéndole al mismo agente que escriba el contrato y que lo cumpla, y eso rompe el bucle de control que vendes como diferenciador. La trazabilidad del uso de IA en tu repo solo tiene valor si hay separación clara entre quién decide (tú, con un advisor) y quién ejecuta (Antigravity)."

Los cuatro documentos (este incluido) son por tanto **output directo de la sesión de advisory**, no generados por agente de código.

---

**Fin del documento 02.**