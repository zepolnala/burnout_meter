# Algoritmo de Burnout: Fundamento Científico y Fórmulas Fisiológicas

Este documento detalla el fundamento clínico, las ecuaciones biométricas y los criterios de cumplimiento normativo que gobiernan el motor de cálculo de **BurnoutMeter B2B** (`ScoringEngine`). 

La plataforma está diseñada bajo el modelo de **Software como Dispositivo Médico (SaMD)**, orientado a la detección temprana del agotamiento psicofisiológico en entornos corporativos de alta demanda.

---

## 🧬 1. Fundamentos Fisiológicos y Wearables

El core de BurnoutMeter radica en monitorizar cómo el sistema nervioso autónomo (SNA) responde a la carga de trabajo diaria. El SNA regula las funciones involuntarias a través de dos ramas en constante equilibrio dinámico:

### A. Tono Parasimpático y Recuperación: HRV RMSSD (ms)
- **Concepto**: La variabilidad de la frecuencia cardíaca (HRV) mide la fluctuación milisegundo a milisegundo entre latidos sucesivos. BurnoutMeter utiliza la métrica **RMSSD** (Root Mean Square of Successive Differences), que cuantifica de forma directa la actividad vagal (parasimpática).
- **Importancia Clínica**: Un HRV RMSSD elevado denota flexibilidad cardiovascular y un estado de óptima recuperación y resiliencia al estrés. Por el contrario, un HRV persistentemente deprimido (<30ms) es un indicador contrastado de fatiga crónica y fracaso en el sistema de autorregulación del organismo.

### B. Recuperación Cognitiva: Duración del Sueño (Horas)
- **Concepto**: El cerebro y el tejido periférico requieren de ciclos estables de sueño no REM y REM para eliminar metabolitos y consolidar la homeostasis sináptica.
- **Decaimiento No Lineal**: Estudios de medicina del sueño demuestran que el impacto cognitivo por falta de sueño no decae de manera lineal. Dormir 4 horas no es "un poco peor" que dormir 7 horas; produce un desplome de la función psicomotora y cardiovascular exponencialmente severo.

### C. Activación Simpática: Frecuencia Respiratoria (RR) y Pulso (HR)
- **Concepto**: Ante una amenaza percibida o sobrecarga de tareas (estrés simpático), el organismo activa la respuesta de "lucha o huida". 
- **Indicadores**:
  - **Frecuencia Respiratoria (RR)**: Una tasa superior a 18 respiraciones por minuto en reposo denota hiperventilación subclínica y estimulación simpática.
  - **Ritmo Cardíaco en Reposo (RHR)**: Pulsaciones en reposo elevadas (>75 bpm) indican que el corazón debe realizar mayor esfuerzo debido a la persistencia de hormonas del estrés (cortisol y adrenalina).

---

## 🧮 2. Ecuaciones del Scoring Engine

El motor calcula cuatro subscores intermedios (0-100) para derivar un **Índice Consolidado de Burnout** balanceado.

### 1. Subscore de Sueño ($S_{sleep}$)
El óptimo fisiológico se establece entre las 7.2 y 8.5 horas. Se penaliza drásticamente la privación de sueño aplicando una curva exponencial y el exceso de sueño de forma lineal:

$$
S_{sleep} = 
\begin{cases} 
100 & \text{si } 7.2 \le H_{sleep} \le 9.0 \\
\left(\frac{H_{sleep}}{7.2}\right)^2 \times 100 & \text{si } H_{sleep} < 7.2 \quad \text{(Decaimiento Exponencial)} \\
\left(\frac{9.0}{H_{sleep}}\right) \times 100 & \text{si } H_{sleep} > 9.0 \quad \text{(Penalización por hipersomnia)}
\end{cases}
$$

*Nota: El resultado final se limita al rango $[0.0, 100.0]$.*

### 2. Subscore de Recuperación ($S_{recovery}$)
Cuantifica la suficiencia del tono parasimpático basándose en un umbral óptimo de referencia de $80\text{ ms}$ de HRV RMSSD:

$$
S_{recovery} = \left(\frac{HRV_{RMSSD}}{80.0}\right) \times 100
$$

*Nota: Limitado al rango $[0.0, 100.0]$.*

### 3. Subscore de Estrés ($S_{stress}$)
Combina el aumento del ritmo cardíaco en reposo y las desviaciones respiratorias. Asume una línea base de $55\text{ bpm}$ de pulso y $12\text{ breaths/min}$ de tasa respiratoria como relajación completa:

$$
\text{HR\_Factor} = \frac{HR_{bpm} - 55.0}{45.0} \times 100
$$
$$
\text{Resp\_Factor} = \frac{RR_{cpm} - 12.0}{8.0} \times 100
$$
$$
S_{stress} = (\text{HR\_Factor} \times 0.6) + (\text{Resp\_Factor} \times 0.4)
$$

*Nota: Limitado al rango $[0.0, 100.0]$.*

### 4. Subscore de Carga Física ($S_{load}$)
Calcula el estrés cardiovascular acumulado durante el día:

$$
S_{load} = \frac{HR_{bpm} - 50.0}{45.0} \times 100
$$

*Nota: Limitado al rango $[0.0, 100.0]$.*

### 5. Índice de Burnout Consolidado ($I_{burnout}$)
La ecuación definitiva pondera las deudas de recuperación de forma que el Estrés Simpático actúe como disparador directo de riesgo, amplificado por la falta de descanso físico:

$$
\text{Sleep\_Debt} = 100.0 - S_{sleep}
$$
$$
\text{Recovery\_Debt} = 100.0 - S_{recovery}
$$
$$
I_{burnout} = (S_{stress} \times 0.40) + (\text{Recovery\_Debt} \times 0.30) + (\text{Sleep\_Debt} \times 0.20) + (S_{load} \times 0.10)
$$

---

## 📊 3. Niveles de Riesgo y Acciones Sugeridas

| Rango de Score | Categoría | Estado de Salud | Acción Recomendada |
| :---: | :---: | :---: | :--- |
| **0 - 39** | **Estable / Sano** | Óptimo balance autonómico, sueño reparador. | Continuar rutinas saludables de descanso. |
| **40 - 74** | **Moderado / Carga** | Fatiga acumulada, HRV deprimido temporalmente. | Programar pausas de 15 minutos, priorizar sueño. |
| **75 - 100** | **Crítico / Burnout** | Inversión del tono autonómico, privación severa. | Ofrecer día de descanso o charla informal 1:1. |

---

## 🩺 4. Regulación Médica (SaMD) y Cumplimiento

Dado que el algoritmo utiliza parámetros biométricos sensibles para evaluar el bienestar en el trabajo, el sistema se cataloga bajo las guías de la **FDA** y de la directiva europea **CE-MDR** como **Software as a Medical Device (SaMD) Clase IIa**:

1. **Inmutabilidad de Umbrales**: Los coeficientes y pesos de las ecuaciones fisiológicas (ej. el divisor de $80\text{ ms}$ en HRV) representan especificaciones clínicas validadas. Cualquier modificación de estas variables debe ser sometida a un control de cambios de diseño (Design Control File Audit) para mantener la certificación.
2. **Trazabilidad GDPR**: En cumplimiento con la privacidad del empleado, el manager solo accede al índice final ($I_{burnout}$) y bajo explícito consentimiento. Las variables biológicas crudas ($HRV$, $S_{sleep}$) permanecen estrictamente cifradas en el dispositivo local, garantizando la soberanía de los datos de salud del trabajador.
