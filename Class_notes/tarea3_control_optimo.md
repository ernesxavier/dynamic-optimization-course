# Tarea 3: Control óptimo (Unidad III)

> **Entrega:** al inicio de la sesión 15, a mano o en LaTeX, en PDF. Es una
> tarea de ejercicios: no se pide código. Puedes usar calculadora y
> comprobar tus resultados con los cuadernos de la unidad, pero se califica
> el desarrollo.
>
> **Cubre** las sesiones 10 a 14. Repaso útil: [C.B2](repaso/calculo.md#cb2),
> [C.B4](repaso/calculo.md#cb4),
> [D.I2](repaso/ecuaciones_diferenciales.md#di2),
> [D.I3](repaso/ecuaciones_diferenciales.md#di3),
> [A.A5](repaso/analisis.md#aa5) y [C.A4](repaso/calculo.md#ca4).
>
> **Reglas.** Puedes discutir con tus compañeros y usar herramientas de IA,
> pero cada quien escribe su solución. En la entrega se puede pedir a
> cualquier estudiante que explique en 5 minutos una parte de su solución;
> lo que no pueda explicar no cuenta (programa, sección Evaluación). En cada
> problema, los pasos intermedios valen tanto como el resultado.

| Problema | Tema | Sesiones | Puntos |
|---|---|---|---|
| A1 | Limpiar un río: dos caminos | 10 | 20 |
| A2 | Emisiones y el precio sombra de la contaminación | 11 | 25 |
| A3 | Crecimiento sin rendimientos decrecientes: el modelo AK | 12 | 25 |
| A4 | Dos regiones con depreciación | 13, 14 | 30 |
| A5 **[Avanzado]** | Más de dos regiones | 14 | Hasta 10 extra (sin pasar de 100) |

---

### A1. Limpiar un río: dos caminos (20 puntos)

La contaminación acumulada en la cuenca de un río es $x(t)$ (en toneladas).
Cada año cuesta $ax^2$ en daños, y limpiar rápido es caro: la velocidad de
limpieza $x'$ (negativa) cuesta $(x')^2$. La norma exige que la cuenca quede
limpia en $T$ años:

$$
\min\ \int_0^T \Big(ax^2 + (x')^2\Big)\thinspace dt
\qquad\text{con}\qquad x(0) = x_0,\quad x(T) = 0.
$$

- **(a)** Escribe la ecuación de Euler y su solución general
  ([D.I3](repaso/ecuaciones_diferenciales.md#di3)). ¿La extremal es un
  mínimo? (Pista: sesión 10, sección 2.5; aquí se minimiza.)
- **(b)** Con $a = 0.25$, $x_0 = 100$ y $T = 4$, muestra que
  $x^\ast(t) = x_0\sinh\big(\sqrt a\thinspace(T - t)\big)/\sinh\big(\sqrt a\thinspace T\big)$
  y calcula $x^\ast(1)$, $x^\ast(2)$ y $x^\ast(3)$. ¿Qué fracción de la
  contaminación se limpia el primer año?
- **(c)** Muestra que, sobre una extremal,
  $\int_0^T \big(ax^2 + (x')^2\big)\thinspace dt = \big[x\thinspace x'\big]_0^T$.
  (Pista: integra $(x')^2$ por partes y usa la ecuación de Euler.) Calcula
  el costo de la limpieza óptima y compáralo con el de una limpieza a
  velocidad constante, $x(t) = x_0(1 - t/T)$. ¿Por qué la limpieza óptima
  avanza más rápido al principio?
- **(d)** Plantea el mismo problema como control óptimo, con $u = x'$ y el
  objetivo $\max \int_0^T -\big(ax^2 + u^2\big)\thinspace dt$. Escribe el
  Hamiltoniano y sus condiciones, y comprueba que dan la ecuación de Euler
  de (a). Con los datos de (b), calcula $\lambda(0)$ y verifica que
  $\lambda(0) = dV/dx_0$, donde $V(x_0)$ es menos el costo mínimo.
  Interpreta $\lambda(0)$ en pesos por tonelada.
- **(e)** ¿A qué tiende $x^\ast(t)$ cuando $T \to \infty$? Muestra que la
  contaminación se limpia entonces a una tasa constante. ¿De qué depende esa
  tasa y por qué?

### A2. Emisiones y el precio sombra de la contaminación (25 puntos)

Una región emite $e(t)$ al año, y producir con esas emisiones le da un
beneficio $B(e) = e - e^2/2$. Las emisiones se acumulan en un acervo de
contaminación $P$, que se disipa a la tasa $\delta$, y el acervo causa un
daño $dP$ al año. Sin descuento y con $P(T)$ libre:

$$
\max_{e}\ \int_0^T \Big(e - \frac{e^2}{2} - dP\Big)\thinspace dt
\qquad\text{sujeto a}\qquad P' = e - \delta P,\quad P(0) = P_0.
$$

- **(a)** Escribe el Hamiltoniano y las condiciones del principio del
  máximo. ¿Qué signo esperas que tenga $\lambda$, y por qué?
- **(b)** Resuelve la ecuación del coestado con la transversalidad
  ([D.I2](repaso/ecuaciones_diferenciales.md#di2)) y muestra que
  $e^\ast(t) = 1 - \dfrac{d}{\delta}\Big(1 - e^{-\delta(T - t)}\Big)$.
- **(c)** Muestra que
  $-\lambda(t) = \int_t^T d\thinspace e^{-\delta(s - t)}\thinspace ds$ y
  explica por qué $-\lambda(t)$ es el impuesto óptimo por unidad emitida:
  ¿qué mide? (Sesión 11, sección 4.2.) ¿Por qué baja a cero en $T$? ¿Es
  creíble ese final para una región real?
- **(d)** Con $d = 0.02$, $\delta = 0.1$ y $T = 50$, calcula el impuesto y
  las emisiones en $t = 0$, 25, 40 y 50. Las emisiones óptimas no dependen
  de $P_0$: ¿por qué? (Pista: ¿de qué depende el daño marginal?)
- **(e)** Las emisiones no pueden ser negativas. Escribe el máximo del
  Hamiltoniano sobre $e \ge 0$. ¿Qué condición sobre $d$, $\delta$ y $T$
  garantiza que $e^\ast(t) > 0$ en todo el horizonte?
- **(f)** Si una norma exige $P(T) \le \bar P$, escribe la condición de
  transversalidad (sesión 11, sección 3). ¿Qué signo tiene $\lambda(T)$
  cuando la norma está activa, y qué le pasa al impuesto al final del
  horizonte?

### A3. Crecimiento sin rendimientos decrecientes: el modelo AK (25 puntos)

Una región con capital $k$ (físico y humano, en sentido amplio) produce
$Ak$: el capital no tiene rendimientos decrecientes. La población es
constante y el planificador resuelve

$$
\max_c\ \int_0^\infty e^{-\rho t}\thinspace\frac{c^{1-\theta} - 1}{1 - \theta}\thinspace dt
\qquad\text{sujeto a}\qquad k' = Ak - \delta k - c,\quad k(0) = k_0,
$$

con $A > \delta + \rho$.

- **(a)** Escribe el Hamiltoniano a valor presente y sus condiciones.
  Muestra que $c'/c = (A - \delta - \rho)/\theta$ es constante. ¿Por qué
  este modelo no tiene estado estacionario, a diferencia del de Ramsey?
- **(b)** Conjetura que $c = \varphi k$ con $\varphi$ constante. Muestra que
  $k$ crece a la misma tasa que $c$ si y sólo si
  $\varphi = \big(\rho - (1 - \theta)(A - \delta)\big)/\theta$. Muestra que
  la transversalidad, $\lim_{t\to\infty} e^{-\rho t}\mu(t)k(t) = 0$, se
  cumple si y sólo si $\varphi > 0$ ([A.A5](repaso/analisis.md#aa5)). ¿Qué
  pasa si $\varphi \le 0$?
- **(c)** Con $A = 0.15$, $\delta = 0.05$ y $\rho = 0.03$, calcula la tasa de
  crecimiento, $\varphi$ y la tasa de ahorro $s = 1 - c/(Ak)$, con
  $\theta = 1$, 2 y 4. ¿Cómo influye $\theta$ y por qué? ¿Te parece realista
  la tasa de ahorro? ¿Qué supuesto del modelo la explica?
- **(d)** Dos regiones tienen los mismos $A$, $\delta$, $\rho$ y $\theta$,
  pero una empieza con la mitad del capital de la otra. ¿Qué pasa con la
  razón de sus productos a lo largo del tiempo? ¿Hay convergencia $\beta$?
  Compara con el modelo de Ramsey (sesión 12, sección 4.6) y con lo que se
  encontró para los estados de México (sesión 5, sección 4).
- **(e)** Si una región tiene un $A$ mayor (por ejemplo, mejor
  infraestructura), ¿qué pasa con la brecha entre ella y las demás?
  Interpreta para la política regional.

### A4. Dos regiones con depreciación (30 puntos)

En el modelo de la sesión 14, supón que el capital de las dos regiones se
deprecia a la misma tasa $\delta > 0$:

$$
K_1' = \theta S - \delta K_1,
\qquad
K_2' = (1 - \theta)S - \delta K_2,
\qquad
S = \gamma_1K_1 + \gamma_2K_2,
\qquad
\max_{\theta(t) \in [0, 1]}\ Y(T) = v_1K_1(T) + v_2K_2(T).
$$

- **(a)** Escribe el Hamiltoniano, la función de cambio, las ecuaciones de
  los coestados $p_1$ y $p_2$ y su transversalidad.
- **(b)** Sea $q_i(t) = e^{\delta(T - t)}p_i(t)$. Muestra que $q_1$ y $q_2$
  cumplen las ecuaciones de los coestados **sin** depreciación de la sesión
  14, con $q_i(T) = v_i$. Concluye que el tiempo de cambio no depende de
  $\delta$. Interpreta: ¿qué cambia la depreciación y qué no?
- **(c)** Con $s_1 = 0.3$, $v_1 = 0.2$, $s_2 = 0.15$ y $v_2 = 0.3$, calcula
  $\gamma_1$ y $\gamma_2$, di en qué región se invierte primero y calcula
  cuántos años antes del final se cambia de región. Describe la política
  óptima con $T = 10$ y con $T = 30$.
- **(d)** Una política sube la tasa de ahorro de la región 2. ¿Desde qué
  valor de $s_2$ ya no hay cambio, y dónde se invierte entonces todo el
  tiempo? Interpreta.
- **(e)** Muestra que se cumple la condición de suficiencia de Arrow
  (sesión 13, sección 4.2), así que la política de (c) es óptima.

### A5. [Avanzado] Más de dos regiones (hasta 10 puntos extra)

En el modelo de la sesión 14 (sin depreciación) con $n$ regiones, el
gobierno reparte el ahorro $S = \sum_i\gamma_iK_i$ con fracciones
$\theta_i \ge 0$, $\sum_i\theta_i = 1$, y maximiza
$Y(T) = \sum_iv_iK_i(T)$.

- Muestra que $p_i(t) = v_i + \gamma_iI(t)$, con
  $I(t) = \int_t^T \max_jp_j(s)\thinspace ds$, la misma $I$ para todas las
  regiones. Concluye que en cada momento se invierte en la región cuya
  recta $v_i + \gamma_iI$ es la más alta, y que, yendo hacia atrás desde
  $T$, el orden de las regiones lo da la envolvente superior de esas
  rectas.
- Con las regiones 1 y 2 de A4(c) y una región 3 con $v_3 = 0.25$ y
  $\gamma_3 = 0.05$, muestra que la región 3 nunca recibe inversión, aunque
  su producto y su ahorro están entre los de las otras dos. ¿Qué $\gamma_3$
  le haría falta para recibir inversión en algún momento?
