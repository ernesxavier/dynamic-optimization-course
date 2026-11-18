# Tarea 4: Programación dinámica (Unidad IV)

> **Entrega:** al inicio de la sesión 21, a mano o en LaTeX, en PDF. Es una
> tarea corta de ejercicios: no se pide código. Puedes usar calculadora y
> comprobar tus resultados con los cuadernos de la unidad, pero se califica
> el desarrollo. El problema A3 es el primer paso de la solución numérica de
> tu proyecto.
>
> **Cubre** las sesiones 15 a 19. Repaso útil: [A.B3](repaso/analisis.md#ab3),
> [A.I5](repaso/analisis.md#ai5), [C.B3](repaso/calculo.md#cb3) y
> [N.I5](repaso/metodos_numericos.md#ni5).
>
> **Reglas.** Puedes discutir con tus compañeros y usar herramientas de IA,
> pero cada quien escribe su solución. En la entrega se puede pedir a
> cualquier estudiante que explique en 5 minutos una parte de su solución;
> lo que no pueda explicar no cuenta (programa, sección Evaluación). En cada
> problema, los pasos intermedios valen tanto como el resultado.

| Problema | Tema | Sesiones | Puntos |
|---|---|---|---|
| A1 | Mantener una carretera regional | 15, 16 | 35 |
| A2 | Limpiar el río, año por año | 16, 18 | 35 |
| A3 | Tu proyecto en forma recursiva | 15, 16, 18 | 30 |
| A4 **[Avanzado]** | La recursión de A2 converge | 16 | Hasta 10 extra (sin pasar de 100) |

---

### A1. Mantener una carretera regional (35 puntos)

Un tramo de carretera está cada año en uno de tres estados: bueno ($B$),
regular ($R$) o malo ($M$). En cada estado da un beneficio anual $b(x)$ (en
millones de pesos, por ahorro de tiempo y de costos de operación). Cada año
la secretaría de obras decide si **no hace nada** o si **lo rehabilita**:

| Estado $x$ | $B$ | $R$ | $M$ |
|---|---|---|---|
| Beneficio $b(x)$ | 10 | 6 | 2 |
| Costo de rehabilitar $c(x)$ | 3 | 5 | 15 |
| Estado siguiente si no se hace nada | $R$ | $M$ | $M$ |
| Estado siguiente si se rehabilita | $B$ | $B$ | $B$ |

El beneficio del año se recibe en el estado en que el tramo empieza el año,
y el factor de descuento es $\beta = 0.9$.

- **(a)** Identifica el estado, el control, la ecuación de movimiento
  $x' = g(x, u)$ y la recompensa $r(x, u)$, y escribe la ecuación de Bellman
  con $n$ años por delante y valor terminal $S = 0$.
- **(b)** Con inducción hacia atrás, calcula $V_1$, $V_2$ y $V_3$ en los
  tres estados y la política con 1, 2 y 3 años por delante. Presenta cada
  paso en una tabla con el valor de las dos acciones. Sigue hasta encontrar
  con cuántos años por delante conviene rehabilitar un tramo en mal estado.
- **(c)** En horizonte infinito, evalúa tres políticas: rehabilitar siempre,
  rehabilitar sólo en $R$ y $M$, y no rehabilitar nunca. Para cada una,
  plantea y resuelve las ecuaciones $v_\sigma = r_\sigma + \beta P_\sigma v_\sigma$
  (sesión 16, sección 5.2). ¿Cuál es mejor? Comprueba que cumple la ecuación
  de Bellman en los tres estados, así que es la óptima.
- **(d)** ¿Hasta qué costo $c(B)$ conviene el mantenimiento preventivo, es
  decir, rehabilitar un tramo que todavía está bueno? ¿Desde qué costo
  $c(M)$ conviene abandonar para siempre un tramo en mal estado?
- **(e)** Compara la política de (b) con la de (c). ¿Por qué un plan con
  pocos años por delante deja de rehabilitar los tramos malos? ¿Qué
  problema de la planeación pública real retrata esto?

### A2. Limpiar el río, año por año (35 puntos)

Es la versión en tiempo discreto del problema A1 de la Tarea 3, sin la norma
que exige limpiar todo al final. La contaminación de la cuenca es $x_t$ y
cada año se limpian $u_t$ toneladas:

$$
\min\ \sum_{t=0}^{n-1}\beta^t\big(ax_t^2 + u_t^2\big)
\qquad\text{sujeto a}\qquad x_{t+1} = x_t - u_t,
$$

con valor terminal $S = 0$.

- **(a)** Con $n$ años por delante, conjetura $V_n(x) = P_nx^2$ (el costo
  mínimo). Muestra que $P_1 = a$, que
  $P_n = a + \dfrac{\beta P_{n-1}}{1 + \beta P_{n-1}}$ y que la política es
  limpiar la fracción $\beta P_{n-1}/(1 + \beta P_{n-1})$ de la
  contaminación.
- **(b)** Con $a = 0.25$ y $\beta = 1$, calcula $P_1$ a $P_4$ y la fracción
  que se limpia con 1, 2, 3 y 4 años por delante. ¿Por qué se limpia menos
  cerca del final? Compara con la Tarea 3, A1, donde la norma exigía
  $x(T) = 0$: ¿cómo cambia el patrón?
- **(c)** En horizonte infinito, $V(x) = Px^2$ con $P$ un punto fijo de la
  recursión de (a). Encuentra $P$ y la fracción que se limpia cada año con
  los datos de (b). Compárala con la versión continua (Tarea 3, A1(e)),
  donde cada año queda la fracción $e^{-\sqrt a}$.
- **(d)** Con la condición de primer orden y el teorema de la envolvente
  (sesión 18, sección 1.2), muestra que la política óptima cumple la
  ecuación de Euler $u_t = \beta\big(ax_{t+1} + u_{t+1}\big)$. Interprétala
  como una comparación entre limpiar una tonelada hoy y limpiarla mañana.
  Verifícala con los números de (c) y $x_0 = 100$.
- **(e)** Con $\beta = 0.95$, ¿se limpia más rápido o más lento que con
  $\beta = 1$? Explica con la ecuación de Euler.

### A3. Tu proyecto en forma recursiva (30 puntos)

Plantea en forma recursiva el problema de tu proyecto (el de la propuesta
de la sesión 12 o el que reformulaste para el avance de la sesión 20). Si tu
problema no se presta, usa uno de los casos del listado del programa y
dilo.

- **(a)** Identifica el estado (o los estados), el control, los controles
  permitidos $\Gamma(x)$, la ecuación de movimiento, la recompensa, el
  factor de descuento y el valor terminal o el horizonte infinito. Si tu
  modelo está en tiempo continuo, discretízalo con un paso $\Delta$:
  $x_{t+1} = x_t + \Delta\thinspace f(x_t, u_t)$ y $\beta = e^{-\rho\Delta}$.
- **(b)** Escribe la ecuación de Bellman.
- **(c)** Si el control es continuo, escribe la condición de primer orden y
  la ecuación de Euler (sesión 18). Si es discreto, di qué compara la
  política en cada estado.
- **(d)** ¿Qué mide $V'(x)$ en tu problema y a qué coestado del principio
  del máximo corresponde (sesión 18, sección 2)?
- **(e)** Para resolverlo con iteración de la función valor, ¿qué malla
  usarías: en qué rango y con cuántos puntos por estado? ¿Cuántos puntos
  tiene la malla completa (sesión 15, sección 5)? ¿Es viable?
- **(f)** Propón un caso particular de tu problema con solución conocida
  (por ejemplo, con utilidad logarítmica y depreciación completa, como en
  la sesión 16, sección 4) que te sirva para verificar el código del
  proyecto.

### A4. [Avanzado] La recursión de A2 converge (hasta 10 puntos extra)

Sea $\phi(P) = a + \beta P/(1 + \beta P)$, con $a > 0$ y $0 < \beta \le 1$.
Muestra que $\phi$ manda $[a, \infty)$ en sí mismo y que ahí
$\lvert\phi'(P)\rvert \le \beta/(1 + \beta a)^2 < 1$, también con $\beta = 1$.
Concluye que $P_n$ converge al punto fijo de A2(c) desde cualquier
$P_0 \ge 0$ ([A.I5](repaso/analisis.md#ai5)). Con $a = 0.25$ y $\beta = 1$,
¿cuántas iteraciones bastan, empezando en $P_1 = a$, para garantizar un
error menor que $10^{-6}$? ¿Por qué aquí la convergencia no depende de que
$\beta < 1$, a diferencia de la sesión 16?
