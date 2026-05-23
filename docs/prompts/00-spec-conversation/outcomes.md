# Outcomes — Tabla de decisiones de la sesión de spec

> Tabla de cierre de la sesión de tech advisory. Cada fila resume una decisión cerrada: alternativas barajadas, razón final, y sección de `SPEC.md` donde se materializa.

**Sesión:** 2026-05-22
**Decisiones cerradas:** 6 principales (con sub-decisiones en 3 y 6)

| # | Decisión | Alternativas barajadas | Razón final | Sección SPEC.md |
|---|---|---|---|---|
| 1 | **Consentimiento binario global + audit log de accesos** | A: binario global. B: granular por destinatario (manager sí/admin no, etc.). C: granular por tipo de dato (score sí/tendencias no). | A captura el 80% del valor narrativo de privacy-by-design sin pagar el coste de complejidad de B o C. El audit log de accesos añade transparencia sin granularidad de toggles. Defendible como decisión de UX en B2B real: granular reduce adopción. | 3.6, 6.3, 8.1 (`consents/`), 12.1 |
| 2 | **Seed completo de usuarios, sin signup en MVP; pantalla de invitación como stub navegable** | A: self-signup con código de invitación. B: admin crea + magic link. C: seed completo. | Implementar invitación end-to-end son 1-1.5 días en un timebox de 5-6. No es el core del assessment (que es el modelo de permisos en backend). Stub navegable permite explicar el diseño en demo sin coste. | 3.1, 3.2, plan día 3 (`seed.ts`) |
| 3a | **`HealthDataSource` con tres implementaciones (synthetic, replay, healthkit-stub); replay como default de demo** | A: solo synthetic. B: solo replay. C: HealthKit real. | El valor está en la interfaz polimorfa, no en cuál es el default. Replay como default da demo determinista. Synthetic muestra que se entienden patrones. HealthKit-stub muestra cómo se enchufa hardware real sin reescribir. | 6.1, estructura de carpetas, assets fixture |
| 3b | **Score único 0-100 en UI, subscores internos en modelo y engine** | A: score único en UI y modelo. B: 4 subscores visibles en UI. C: número único en UI, subscores en modelo. | Razón narrativa: el `ScoringEngine` enseñado en código muestra modelado rico del dominio (4 señales fisiológicas → score derivado). UI simple porque manager con N empleados quiere ver "rojo/verde", no radares. Arquitectura rica por dentro, UX simple por fuera. | 5 (`Score`, `Subscores`), 6.2, 12.3 (MDR: fórmulas no validadas) |
| 4 | **Una codebase Flutter, tres shells por rol (Employee/Manager/Admin); dominio y data compartidos; `presentation/` dividido por rol** | A: app única responsive con `if (isWide)`. B: dos shells por plataforma. C: tres shells por rol. | A produce panels web con apariencia de móvil ampliado (señal visual de mal nivel). B obliga a dos `main.dart` y dos pipelines de build (coste de setup que no hay). C da 90% del beneficio de B con la mitad del coste, y la división por rol encaja mejor que por plataforma con el modelo mental del producto. | 4.5, 4.6, estructura de carpetas, plan día 2 |
| 5 | **Permisos híbridos: custom claim `{role, orgId}` + colección `memberships/{userId}` en Firestore para `teamIds` dinámicos** | A: todo en custom claims. B: todo en Firestore con `get()` en reglas. C: híbrido. | A obliga a logout/login para reasignaciones (demo en vivo se rompe), tiene límite de 1KB en claims, y la lógica de permisos queda diluida entre claim opaco y regla (mala auditabilidad). C deja toda la lógica de permisos legible en `firestore.rules`, soporta reasignación en vivo, escala bien. Compromiso vinculante: 5+ tests con emulador. | 4 (modelo de datos), 8.1, 8.2 (reglas), 10 (testing reglas) |
| 6a | **Catálogo de 5 acciones congeladas (`suggest_break`, `offer_1on1`, `share_resource`, `recommend_time_off`, `wellness_check`), modeladas como `ActionTemplate` parametrizable** | Catálogo rico (10+). Mínimo (3). Medio (5-6). | El catálogo es datos, no código. La arquitectura no cambia entre 3 y 10. En demo se enseñan 2-3. Las 5 cubren espectro completo (fricción, registro emocional, dirección de interacción). Añadir más en producción es seed, no refactor. | 5 (`Action`, `ActionTemplate`), 6.6, 8 |
| 6b | **Manager-initiated como modelo principal; system-suggested diseñado en SPEC pero implementación marcada stretch día 5-6** | A: manager-initiated puro. B: system-suggested + manager-approved como modelo principal. | B implica Cloud Function programada, motor de reglas (conversación de producto por patrón), lógica anti-duplicados, dos estados extra, pantalla extra en manager. Entre día y medio y dos días. Le come tiempo a las reglas de Firestore, que son el ángulo diferenciador. Y si las heurísticas no validadas sugieren mal, la demo empeora. A es más sólido como base; B queda diseñado para defender en entrevista. | 3.4, 6.6, plan día 4 y 5-6 stretch |
| 6c | **Estados de acción transparentes (`received` / `acknowledged` / `dismissed`); manager ve estado real si abre detalle; sin notificación push de dismissions** | Transparente. Opaca (manager nunca ve `dismissed`). | Coherencia con audit log decidido en pregunta 1: simetría entre lo que audita empleado (accesos) y lo que audita manager (estados). Transparencia sin presión: el manager **ve** pero **no es notificado** del rechazo, lo que protege al empleado de dinámicas de poder informales sin opacar el sistema. | 3.5, 5 (`Action.status`), 6.6, 8 (reglas update actions) |

---

## Decisiones implícitas (aceptadas sin cuestionar)

| Decisión | Vive en SPEC.md |
|---|---|
| Flutter como stack principal | 4.5, 7 |
| Firebase como backend (Auth, Firestore, Functions, FCM opcional) | 7, 8 |
| Riverpod para state management | 4.1, 7 |
| `go_router` para navegación | 4.3, 7 |
| Drift para persistencia local (sobre Hive) | 4.4, 7 |
| `fl_chart` para gráficas | 7, 3 (journeys) |
| Paquete `health` para stub HealthKit/Health Connect | 6.1, 7 |
| Freezed + json_serializable para entidades/DTOs | 4.2, 7 |
| Multi-tenant preparado pero demo con UNA organización | 1, 8.1 |
| RBAC simple con 3 roles fijos | 2, 5 (`Membership.role`) |
| Lenguaje "indicadores"/"señales tempranas", nunca "diagnóstico" | 12.3, comentarios in-code |

---

## Decisiones diferidas a fases posteriores

Estas decisiones no se cerraron en esta sesión y se aplazaron explícitamente al momento de implementar la feature correspondiente o a un fork de la spec en v2.

| Decisión diferida | Por qué se difiere | Dónde queda anotada |
|---|---|---|
| Diseño visual concreto (paleta, tipografía, espaciados) | No bloquea SPEC; se decide al construir `presentation/shared/theme/`. Usar paleta sobria, no consumer. | Estructura de carpetas (theme/) |
| Reglas exactas de `aggregateTeamScores` (umbrales de anonimización, ventanas temporales) | Depende de validación con stakeholders reales; en MVP, agregar solo si N ≥ 5. | 2.3 (`OrgSettings.minAggregationN`), 8.3 |
| Heurísticas exactas del motor `suggestActions` (qué patrones disparan qué sugerencia) | Stretch día 5-6. Si no se implementa, queda como diseño conceptual en sección 8.3. | 8.3 (stretch), 11 |
| Estrategia de migración de datos para v2 (cuando se introduzca `pendingInvitations`) | Fuera de scope MVP. | 11 |
| Decisión final de iOS vs solo Android | Stretch día 6. Android prioritario. | 11, plan día 6 |
| Política de retención de `healthSamples` | No bloquea MVP demo. En producción, definir TTL (probablemente 90-180 días según GDPR data minimization). | 12.1 (a documentar en v2) |
| Idiomas adicionales a `es`/`en` | Estructura i18n preparada; traducciones adicionales son trabajo de localización. | 11 |

---

## Próximos artefactos esperados en el repo

Tras esta sesión, el flujo de trabajo previsto en `docs/prompts/` es:

docs/prompts/
├── 00-spec-conversation/        ✅ Esta sesión (generada)
│   ├── 01-bootstrap.md
│   ├── 02-architecture-decisions.md
│   └── outcomes.md
├── 01-scaffolding/              ⏳ Pendiente — prompts a Antigravity para estructura
├── 02-features/                 ⏳ Pendiente — prompts por feature mayor
│   ├── auth-and-shells/
│   ├── health-data-source/
│   ├── scoring-engine/
│   ├── consent-manager/
│   ├── actions-flow/
│   └── admin-dashboard/
├── 03-firestore-rules/          ⏳ Pendiente — prompts para diseño y tests de reglas
└── 99-debugging/                ⏳ Pendiente — prompts de depuración cuando surjan

**Regla del proceso:** cada subcarpeta debe contener mínimo un `01-bootstrap.md` (prompt enviado al agente) y un `outcomes.md` (qué se generó, qué se aceptó, qué se modificó manualmente, qué problemas surgieron). Esto convierte el repositorio en un artefacto auditable del proceso de ingeniería asistido por IA, no solo del producto final.

---

**Fin de outcomes.md.**