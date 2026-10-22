# Notas de repaso

Estas notas reúnen las herramientas matemáticas que usa el curso. **No hay
que leerlas de corrido**: la tabla de abajo dice qué repasar antes de cada
sesión.

Las figuras de `figuras/` se generan con `Code/figuras_repaso.jl`.

## Cómo están organizadas

Cada área tiene tres niveles:

| Nivel | Para qué sirve |
|---|---|
| **Básico (B)** | Lo que se supone sabido al empezar el curso |
| **Intermedio (I)** | Lo necesario para seguir las clases, las tareas y las notas formales |
| **Avanzado (A)** | Lo necesario para los puntos **[Avanzado]**: demostraciones y extensiones |

Cada concepto tiene una clave: **área.nivel + número**. Por ejemplo,
**[D.I2](ecuaciones_diferenciales.md#di2)** es el segundo concepto intermedio de
ecuaciones diferenciales (las lineales con coeficientes variables). Las
claves son enlaces: llevan directamente al concepto. Cada área termina con un
**autodiagnóstico** de 10 preguntas con respuestas.

| Clave | Área | Archivo |
|---|---|---|
| **C** | Cálculo de una y varias variables | [calculo.md](calculo.md) |
| **L** | Álgebra lineal | [algebra_lineal.md](algebra_lineal.md) |
| **D** | Ecuaciones diferenciales y en diferencias | [ecuaciones_diferenciales.md](ecuaciones_diferenciales.md) |
| **A** | Análisis: sucesiones, convergencia, conjuntos y puntos fijos | [analisis.md](analisis.md) |
| **N** | Métodos numéricos | [metodos_numericos.md](metodos_numericos.md) |
| **E** | Estadística y datos | [estadistica.md](estadistica.md) |

## Qué repasar antes de cada sesión

Basta con las claves B e I para seguir la clase y hacer las tareas. Para los
puntos [Avanzado], añade las A. Las sesiones 20 a 24 (proyecto) usan la
última fila.

Si no sabes por dónde empezar, resuelve el [diagnóstico de
matemáticas](diagnostico_inicial.md) de la sesión 1: diez preguntas que dicen
qué claves B te conviene repasar.

| Ses. | Tema | Básico | Intermedio | Avanzado |
|---|---|---|---|---|
| 1 | Diagnóstico | Todo el nivel B: es lo que mide el [diagnóstico](diagnostico_inicial.md) | — | — |
| 2 | Lagrange y Kuhn-Tucker | [C.B1–B2](calculo.md#cb1), [C.B5](calculo.md#cb5), [L.B1](algebra_lineal.md#lb1), [L.B3](algebra_lineal.md#lb3) | [C.I1–I2](calculo.md#ci1), [C.I5](calculo.md#ci5), [C.I7](calculo.md#ci7), [L.I4–I5](algebra_lineal.md#li4), [A.I2–I3](analisis.md#ai2), [N.I2](metodos_numericos.md#ni2) | [C.A1](calculo.md#ca1), [L.A3](algebra_lineal.md#la3), [N.A4](metodos_numericos.md#na4) |
| 3 | Envolvente y estática comparativa | [C.B1](calculo.md#cb1), [C.B5](calculo.md#cb5), [L.B2–B4](algebra_lineal.md#lb2) | [C.I3–I6](calculo.md#ci3), [L.I6](algebra_lineal.md#li6), [N.I2](metodos_numericos.md#ni2) | [C.A2](calculo.md#ca2) |
| 4 | Laboratorio 0 | [N.B1–B4](metodos_numericos.md#nb1) | [N.I2](metodos_numericos.md#ni2) | [N.A4](metodos_numericos.md#na4) |
| 5 | Primer orden y convergencia | [C.B1](calculo.md#cb1), [C.B3](calculo.md#cb3), [D.B1–B4](ecuaciones_diferenciales.md#db1), [E.B2–B3](estadistica.md#eb2) | [D.I1–I2](ecuaciones_diferenciales.md#di1), [E.I2](estadistica.md#ei2), [N.I7](metodos_numericos.md#ni7) | [E.A1](estadistica.md#ea1) |
| 6 | Diagramas de fase y ecuaciones en diferencias | [D.B1–B2](ecuaciones_diferenciales.md#db1), [A.B2](analisis.md#ab2) | [D.I1](ecuaciones_diferenciales.md#di1), [D.I4](ecuaciones_diferenciales.md#di4), [A.I5](analisis.md#ai5) | — |
| 7 | Sistemas lineales | [L.B1–B3](algebra_lineal.md#lb1) | [C.I7](calculo.md#ci7), [L.I1–I3](algebra_lineal.md#li1), [L.I6](algebra_lineal.md#li6), [D.I3](ecuaciones_diferenciales.md#di3), [D.I5](ecuaciones_diferenciales.md#di5) | [L.A1–A2](algebra_lineal.md#la1), [D.A1](ecuaciones_diferenciales.md#da1), [D.A5](ecuaciones_diferenciales.md#da5) |
| 8 | Estabilidad no lineal | — | [C.I7](calculo.md#ci7), [L.I1–I2](algebra_lineal.md#li1), [L.I6](algebra_lineal.md#li6), [D.I6](ecuaciones_diferenciales.md#di6) | [D.A2](ecuaciones_diferenciales.md#da2), [D.A4](ecuaciones_diferenciales.md#da4) |
| 9 | Laboratorio 1 | [D.B3](ecuaciones_diferenciales.md#db3), [N.B1–B3](metodos_numericos.md#nb1) | [N.I3](metodos_numericos.md#ni3), [N.I6](metodos_numericos.md#ni6) | [N.A3](metodos_numericos.md#na3) |
| 10 | Del cálculo de variaciones al Hamiltoniano | [C.B1–B4](calculo.md#cb1) | [C.I6–I7](calculo.md#ci6), [D.I3](ecuaciones_diferenciales.md#di3) | [C.A3](calculo.md#ca3) |
| 11 | Principio del máximo | [C.B2](calculo.md#cb2), [C.B4](calculo.md#cb4) | [C.I2–I3](calculo.md#ci2), [C.I6](calculo.md#ci6), [D.I2](ecuaciones_diferenciales.md#di2), [D.I7](ecuaciones_diferenciales.md#di7) | [C.A3](calculo.md#ca3), [D.A3](ecuaciones_diferenciales.md#da3), [N.A1](metodos_numericos.md#na1) |
| 12 | Horizonte infinito y Ramsey | [C.B3–B4](calculo.md#cb3), [A.B3](analisis.md#ab3), [E.B2](estadistica.md#eb2) | [L.I1–I2](algebra_lineal.md#li1), [D.I2](ecuaciones_diferenciales.md#di2), [D.I6–I7](ecuaciones_diferenciales.md#di6), [N.I1](metodos_numericos.md#ni1), [N.I3](metodos_numericos.md#ni3), [E.I3](estadistica.md#ei3), [N.I7](metodos_numericos.md#ni7) | [D.A2](ecuaciones_diferenciales.md#da2), [A.A5](analisis.md#aa5), [N.A1](metodos_numericos.md#na1) |
| 13 | Varias variables, bang-bang | [C.B2](calculo.md#cb2) | [C.I2](calculo.md#ci2), [L.I4](algebra_lineal.md#li4) | [C.A4](calculo.md#ca4) |
| 14 | Caso: dos regiones | [C.B2](calculo.md#cb2), [E.B2](estadistica.md#eb2) | [D.I2](ecuaciones_diferenciales.md#di2), [N.I1](metodos_numericos.md#ni1), [N.I3](metodos_numericos.md#ni3), [E.I3](estadistica.md#ei3), [N.I7](metodos_numericos.md#ni7) | [D.A3](ecuaciones_diferenciales.md#da3), [E.A2](estadistica.md#ea2) |
| 15 | Bellman, horizonte finito | [C.B3](calculo.md#cb3), [A.B3](analisis.md#ab3) | [A.I1–I3](analisis.md#ai1), [N.I5](metodos_numericos.md#ni5) | [L.A4](algebra_lineal.md#la4) |
| 16 | Bellman, horizonte infinito | [A.B2–B3](analisis.md#ab2), [N.B4](metodos_numericos.md#nb4) | [C.I2](calculo.md#ci2), [A.I1](analisis.md#ai1), [A.I3–I5](analisis.md#ai3), [N.I4–I6](metodos_numericos.md#ni4) | [C.A2](calculo.md#ca2), [C.A4](calculo.md#ca4), [L.A2](algebra_lineal.md#la2), [L.A4](algebra_lineal.md#la4), [A.A1–A4](analisis.md#aa1), [N.A2](metodos_numericos.md#na2) |
| 17 | Laboratorio 2 | [N.B1–B3](metodos_numericos.md#nb1) | [A.I4](analisis.md#ai4), [N.I4–I6](metodos_numericos.md#ni4) | [A.A2](analisis.md#aa2) |
| 18 | Control óptimo frente a PD | [C.B3](calculo.md#cb3) | — | [C.A2](calculo.md#ca2), [D.A5](ecuaciones_diferenciales.md#da5) |
| 19 | Laboratorio 3 | [N.B1–B3](metodos_numericos.md#nb1), [E.B1](estadistica.md#eb1) | [D.I7](ecuaciones_diferenciales.md#di7), [N.I1](metodos_numericos.md#ni1), [N.I3](metodos_numericos.md#ni3), [E.I1](estadistica.md#ei1) | [N.A1](metodos_numericos.md#na1), [L.A4](algebra_lineal.md#la4) |
| — | Proyecto final | [E.B2–B3](estadistica.md#eb2) | [E.I2–I3](estadistica.md#ei2), [N.I7](metodos_numericos.md#ni7) | [E.A2](estadistica.md#ea2) |

## Notación

Convenciones que se usan en todas las notas:

- $\dot x = dx/dt$ es la derivada respecto del tiempo continuo; $x_t$ es el
  valor en el periodo $t$ en tiempo discreto.
- $f_x$ o $f_i$ es la derivada parcial; $\nabla f$ es el gradiente,
  $\nabla^2 f$ la hessiana y $J$ el jacobiano.
- $x^\ast$ es un óptimo o un equilibrio, según el contexto.
- Vectores en minúscula ($x$, $v$), matrices en mayúscula ($A$, $P$);
  $A^\top$ es la transpuesta y $\mathbf 1$ el vector de unos.
- $\ln$ es el logaritmo natural (`log` en Julia).
- $\mathbb{E}[X]$ es el valor esperado y $\mathbb{E}[X \mid Y]$ el esperado
  condicional ([E.B1](estadistica.md#eb1), [E.I1](estadistica.md#ei1)); $\hat b$
  es la estimación de $b$ con datos. La pendiente de una regresión se escribe
  $b$, para no confundirla con la velocidad de convergencia $\beta$
  ([E.A1](estadistica.md#ea1)).
- En tiempo continuo se descuenta con $e^{-\rho t}$ (tasa $\rho$); en tiempo
  discreto, con $\beta^t$ (factor $\beta$). Coinciden si $\beta = e^{-\rho}$.
- $\max$ es un valor y $\arg\max$ el punto donde se alcanza; $\sup$ se usa
  cuando no se sabe si el máximo se alcanza ([A.I1](analisis.md#ai1)).
- $\lVert\cdot\rVert_\infty$ es la norma del supremo: el máximo valor absoluto
  de un vector o de una función ([A.I4](analisis.md#ai4)).

**Símbolos con más de un significado.** Cada tema conserva las letras de su
literatura, para facilitar la lectura de los textos. El contexto casi
siempre decide; en caso de duda, esta tabla dice dónde aparece cada uso.

| Símbolo | Significados | Dónde |
|---|---|---|
| $\lambda$ | Multiplicador de Lagrange · coestado $\lambda(t)$ · eigenvalor | [C.I5](calculo.md#ci5) · sesión 11, [D.I7](ecuaciones_diferenciales.md#di7) · [L.I1](algebra_lineal.md#li1) |
| $\mu$ | Coestado a valor corriente, $\mu = \lambda e^{\rho t}$ | sesión 12, [A.A5](analisis.md#aa5) |
| $\rho$ | Tasa de descuento · radio espectral $\rho(A)$ | [C.B3](calculo.md#cb3) · [L.A2](algebra_lineal.md#la2) |
| $\beta$ | Factor de descuento · velocidad de convergencia regional | [C.B3](calculo.md#cb3), [A.B3](analisis.md#ab3) · [D.I1](ecuaciones_diferenciales.md#di1) |
| $\delta$ | Depreciación · control de reparto $\delta \in [0, 1]$ del caso de dos regiones | [D.I4](ecuaciones_diferenciales.md#di4), [D.I6](ecuaciones_diferenciales.md#di6) · sesión 14 |
| $\tau$ | Traza de una matriz · tiempo que falta para el final después del cambio, $T - t^\ast$ | [L.I1](algebra_lineal.md#li1), [D.I5](ecuaciones_diferenciales.md#di5) · sesión 14 |
| $\Delta$ | Determinante · paso de tiempo $\Delta t$ | [L.I1](algebra_lineal.md#li1), [D.I5](ecuaciones_diferenciales.md#di5) · [D.B3](ecuaciones_diferenciales.md#db3) |
| $T$ | Horizonte · operador de Bellman $Tv$ | sesiones 10–15 · [A.A3](analisis.md#aa3) |
| $H$, $\bar H$ | Hamiltoniano · hessiana orlada | [C.I3](calculo.md#ci3) · [L.I5](algebra_lineal.md#li5) |
| $\theta$ | Parámetro CRRA (inverso de la elasticidad de sustitución) · peso de una combinación convexa | [D.I6](ecuaciones_diferenciales.md#di6) · [C.I2](calculo.md#ci2) |
| $\alpha$ | Participación del capital en $k^\alpha$ · parámetro genérico | [C.B5](calculo.md#cb5), [D.I4](ecuaciones_diferenciales.md#di4) · [C.I4](calculo.md#ci4), [C.A2](calculo.md#ca2) |
| $\gamma$ | $\gamma_i = s_iv_i$ en el caso de dos regiones · tasa de una ecuación lineal | sesión 14 · [D.I2](ecuaciones_diferenciales.md#di2) |
| $V$, $v$ | Valor óptimo o función valor · función de Liapunov · productividad $v_i$ del caso de dos regiones · valor $v_\sigma$ de una política | [C.I5](calculo.md#ci5), [A.B1](analisis.md#ab1) · [D.A4](ecuaciones_diferenciales.md#da4) · sesión 14 · [L.A2](algebra_lineal.md#la2) |
| $\sigma$ | Función de política | [A.B1](analisis.md#ab1), [N.A2](metodos_numericos.md#na2) |
| $J$ | Jacobiano · funcional $J[y]$ | [L.I6](algebra_lineal.md#li6) · [C.A3](calculo.md#ca3) |
| $P$, $p$ | Matriz de eigenvectores · matriz de transición · precios sombra $p_i$ del caso de dos regiones | [L.I2](algebra_lineal.md#li2) · [L.A4](algebra_lineal.md#la4) · [D.I2](ecuaciones_diferenciales.md#di2), sesión 14 |
| $c$ | Consumo · constante de una restricción $g(x) = c$ | [D.I6](ecuaciones_diferenciales.md#di6) · [C.I5](calculo.md#ci5) |
| $h$ | Desviación respecto de un punto · paso de un método numérico | [C.I7](calculo.md#ci7), [L.I6](algebra_lineal.md#li6) · [N.I6](metodos_numericos.md#ni6) |
| $\varepsilon$, $\epsilon$ | Elasticidad · perturbación o tolerancia · precisión de la máquina | [C.B1](calculo.md#cb1) · [C.A3](calculo.md#ca3), [A.A2](analisis.md#aa2) · [N.A4](metodos_numericos.md#na4) |
