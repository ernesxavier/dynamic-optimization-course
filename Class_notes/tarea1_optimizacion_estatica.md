# Tarea 1: Optimización estática (Unidad I)

> **Entrega:** al inicio de la sesión 5. **Parte A** (analítica): a mano o
> en LaTeX, en PDF. **Parte B** (código): el cuaderno
> `Code/tarea1_optimizacion_estatica.jl` con tus funciones escritas y
> corriendo de principio a fin. Se acepta la parte B en Python (Jupyter),
> con las mismas funciones y gráficas.
>
> **Cubre** las sesiones 1 a 4. Repaso útil: [C.B2](repaso/calculo.md#cb2),
> [C.I4–I5](repaso/calculo.md#ci4), [C.A1](repaso/calculo.md#ca1),
> [C.A2](repaso/calculo.md#ca2), [L.B4](repaso/algebra_lineal.md#lb4),
> [L.I4](repaso/algebra_lineal.md#li4) y [N.I2](repaso/metodos_numericos.md#ni2).
>
> **Reglas.** Puedes discutir con tus compañeros y usar herramientas de IA,
> pero cada quien escribe su solución. En la entrega se puede pedir a
> cualquier estudiante que explique en 5 minutos una parte de su solución;
> lo que no pueda explicar no cuenta (programa, sección Evaluación). En cada
> problema, los pasos intermedios valen tanto como el resultado.

| Problema | Tema | Sesiones | Puntos |
|---|---|---|---|
| A1 | Gastar hoy o mañana con un límite de endeudamiento | 1, 2, 3 | 20 |
| A2 | Un fondo entre tres regiones | 2, 3 | 20 |
| A3 | Infraestructura y capital privado | 3 | 20 |
| A4 | Un acuífero regional | 1 | 10 |
| B1 | El reparto entre $n$ regiones | 2, 4 | 10 |
| B2 | Estática comparativa con Symbolics.jl | 3, 4 | 10 |
| B3 | El valor de una línea de crédito | 2, 3, 4 | 10 |
| A5 **[Avanzado]** | La función de valor es cóncava | 2, 3 | Hasta 10 extra (sin pasar de 100) |

---

## Parte A: analítica

### A1. Gastar hoy o mañana con un límite de endeudamiento (20 puntos)

El gobierno de una región recibe $y_0$ hoy y $y_1$ mañana, invierte lo que
no gasta a la tasa bruta $R$ y resuelve, como en la sesión 1,

$$
\max_{c_0}\ \ln c_0 + \beta\ln c_1
\qquad\text{sujeto a}\qquad
c_1 = y_1 + R(y_0 - c_0).
$$

Ahora la ley le prohíbe endeudarse: además, $c_0 \le y_0$.

- **(a)** Escribe el lagrangiano con un multiplicador $\mu$ para
  $c_0 \le y_0$ y las condiciones de Kuhn-Tucker. (Sustituye antes la
  restricción de $c_1$, para que quede una sola variable.)
- **(b)** Resuelve por casos. Muestra que la restricción se activa si y sólo
  si $y_1 > \beta R\thinspace y_0$, y da $c_0^\ast$, $c_1^\ast$ y $\mu$ en cada
  caso.
- **(c)** Con $\beta = 0.95$ y $R = 1.05$, resuelve para $y_0 = 60$ y
  $y_1 = 120$, y para $y_0 = 60$ y $y_1 = 50$. ¿En cuál de los dos casos
  sirve la regla de "gastar lo que entra"? Compara con la sesión 1, donde
  esa regla era óptima sólo por casualidad.
- **(d)** Supón que la ley permite endeudarse hasta $L \ge 0$:
  $c_0 \le y_0 + L$. Con el teorema de la envolvente, ¿cuánto vale $V'(L)$
  en $L = 0$ para el caso $y_1 = 120$? ¿A partir de qué $L$ una línea de
  crédito más amplia ya no vale nada? Interpreta $\mu$ en pesos de hoy
  (pista: divide entre la utilidad marginal del gasto).

### A2. Un fondo entre tres regiones (20 puntos)

Un fondo $B$ se reparte entre tres regiones con producto
$f_i(x_i) = a_i\ln(1 + x_i)$, $x_i \ge 0$ y $x_1 + x_2 + x_3 \le B$, con
$a = (4, 2, 1)$.

- **(a)** Escribe las condiciones de Kuhn-Tucker y explica por qué el fondo
  se agota.
- **(b)** Con $B = 3$, encuentra el reparto óptimo y $\lambda$. Muestra que
  las condiciones se cumplen para **las tres** regiones, también para la que
  no recibe nada.
- **(c)** Encuentra los dos umbrales de $B$ a partir de los cuales entra la
  segunda y la tercera región, y escribe $\lambda(B)$ en cada uno de los
  tres tramos. ¿Es continuo?
- **(d)** En el tramo en que reciben las regiones 1 y 2, calcula
  $\partial x_1^\ast/\partial B$ con la regla de Cramer, como en la sesión 3,
  y compáralo con el del tramo en que reciben las tres. ¿Por qué baja?
- **(e)** ¿Por qué el resultado de (c) es una buena noticia para la región
  3 si el fondo crece, y una mala si el fondo se recorta?

### A3. Infraestructura y capital privado (20 puntos)

Una región elige su capital privado $K$, que cuesta $r$ por unidad, y su
infraestructura pública $G$, que cuesta 1 por unidad, para maximizar el
producto neto

$$
V(r) = \max_{K, G}\ AK^\alpha G^\gamma - rK - G,
\qquad A > 0,\quad \alpha, \gamma > 0,\quad \alpha + \gamma < 1.
$$

- **(a)** Escribe las condiciones de primer orden y la hessiana. Muestra
  que la hessiana es definida negativa si y sólo si $\alpha + \gamma < 1$
  ([L.I4](repaso/algebra_lineal.md#li4)). Simplifica escribiendo las
  segundas derivadas en términos de $Y = AK^\alpha G^\gamma$.
- **(b)** **Sin resolver el problema**, usa el teorema de la función
  implícita y la regla de Cramer para obtener el signo de
  $\partial K^\ast/\partial r$ y de $\partial G^\ast/\partial r$. Interpreta:
  ¿por qué un capital privado más caro reduce también la inversión
  **pública**?
- **(c)** Resuelve el problema y verifica tus signos con la fórmula cerrada.
  Calcula las elasticidades de $K^\ast$ y $G^\ast$ respecto de $r$.
- **(d)** Con el teorema de la envolvente, calcula $V'(r)$ y verifícalo con
  la fórmula cerrada.
- **(e)** Con $A = 1$, $\alpha = 0.3$, $\gamma = 0.2$ y $r = 0.1$, calcula
  $K^\ast$, $G^\ast$ y $V$. Si el costo del capital sube de 10% a 11%, ¿en
  qué porcentaje, aproximadamente, cae la inversión en infraestructura?

### A4. Un acuífero regional (10 puntos)

El acuífero de una región agrícola tiene un volumen $x_t$ al inicio de cada
año. Cada año se extrae $q_t \ge 0$ y la lluvia lo recarga en una cantidad
fija $\bar r$; el agua extraída da un beneficio $p\thinspace q_t$ y extraer
cuesta más mientras más bajo está el acuífero, $C(q_t, x_t)$.

- **(a)** Identifica el estado, el control, la ecuación de movimiento, la
  recompensa y una restricción natural. Escribe el problema con horizonte
  $T$ y descuento $\beta$, como en la sesión 1 (sección 2.1).
- **(b)** Con $S = 0$ (el agua que queda en $T$ no vale nada), muestra que
  en el último año conviene extraer hasta que el beneficio marginal iguale
  el costo marginal de ese año, $p = \partial C/\partial q$, y que en un año
  anterior no: ¿qué término adicional aparece si extraer hoy encarece la
  extracción de mañana? Concluye que, salvo por coincidencia, extraer la
  misma cantidad todos los años no es óptimo. (Pista: sigue el argumento de
  la Proposición 2 de la sesión 1.)
- **(c)** ¿Por qué $S = 0$ es un mal supuesto para un acuífero? Propón un
  valor terminal razonable.

### A5. [Avanzado] La función de valor es cóncava (hasta 10 puntos extra)

Sean $f_1, \dots, f_n$ cóncavas y
$V(B) = \max\lbrace\sum_i f_i(x_i) : x \ge 0,\ \sum_i x_i \le B\rbrace$.
Demuestra que $V$ es cóncava en $B$ **sin** suponer que $V$ es
diferenciable. (Pista: toma los repartos óptimos para $B$ y $B'$ y la
combinación convexa de los dos; usa la definición de concavidad de
[C.I2](repaso/calculo.md#ci2).) ¿Qué dice esto sobre $\lambda(B)$ cuando
existe?

---

## Parte B: código

Abre `Code/tarea1_optimizacion_estatica.jl` en Pluto. Cada ejercicio tiene
una **comprobación** que revisa que tu respuesta cumpla las condiciones de
optimalidad o que dos cálculos tuyos coincidan; no la compara con una
solución, así que un "Coincide" no garantiza la calificación completa. Las
gráficas aparecen cuando tus funciones están escritas.

- **B1.** Escribe `reparto(a, B)`, que devuelva el reparto óptimo y
  $\lambda$ para cualquier número de regiones con $f_i = a_i\ln(1 + x_i)$.
  Grafica $x_i(B)$ y $\lambda(B)$ para $a = (4, 2, 1)$ y comprueba los
  umbrales de A2.
- **B2.** Con Symbolics.jl, construye las condiciones de primer orden de
  A3, su jacobiano y la derivada $\partial(K, G)/\partial r$. Compárala con
  la diferencia finita de tu fórmula cerrada.
- **B3.** Escribe `gasto_hoy(y0, y1, β, R, L)` para el problema A1 con línea
  de crédito $L$, y verifica numéricamente que $V'(L) = \mu$. Grafica
  $c_0^\ast$ contra $y_1$ y explica el quiebre.

Cada ejercicio de la parte B termina con una pregunta de interpretación:
respóndela en el propio cuaderno, en dos o tres líneas.
