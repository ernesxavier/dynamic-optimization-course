# Sesión 14: Caso completo: inversión entre dos regiones

> **Cómo usar estas notas.** Ésta es una sesión mixta. La primera mitad
> se da en el pizarrón y sigue estas notas: el modelo, el Hamiltoniano y la
> solución hacia atrás con el tiempo de cambio. La segunda mitad sigue el
> **cuaderno** (`Code/s14_dos_regiones.jl`): la solución con deslizadores,
> la calibración con dos estados de México y la discusión de equidad. El
> **plan de clase** de abajo dice qué se hace en cada momento. En el
> pizarrón van las ecuaciones y los resultados en recuadro; como todo está
> aquí, en clase no hace falta copiar. El cuerpo de las notas es la **ruta
> básica** y se evalúa; las demostraciones y los temas opcionales están al
> final, en **Para profundizar**, y no se ven en clase.
>
> Repaso recomendado: [C.B2](repaso/calculo.md#cb2) (máximos en una
> variable), [E.B2](repaso/estadistica.md#eb2) (tasas de crecimiento con
> datos), [D.I2](repaso/ecuaciones_diferenciales.md#di2) (lineales de
> primer orden), [N.I1](repaso/metodos_numericos.md#ni1) (bisección y
> Newton), [N.I3](repaso/metodos_numericos.md#ni3)
> (DifferentialEquations.jl), [E.I3](repaso/estadistica.md#ei3)
> (calibración) y [N.I7](repaso/metodos_numericos.md#ni7) (datos en Julia);
> para Para profundizar, [D.A3](repaso/ecuaciones_diferenciales.md#da3)
> (existencia y unicidad) y [E.A2](repaso/estadistica.md#ea2) (sensibilidad
> de un modelo calibrado).
>
> Lecturas: Alexiadis (2018), cap. 2. Consulta: Alexiadis (2018), cap. 3;
> Rahman (1963); Intriligator (1964); Takayama (1967).

**Plan de clase** (120 minutos)

| Minutos | Dónde | Qué | Secciones |
|---|---|---|---|
| 0–5 | Pizarra | La pregunta: ¿dónde invertir primero? | 0 |
| 5–15 | Pizarra | El modelo: $\gamma_i = s_iv_i$, el reparto $\theta(t)$ y el objetivo de valor final con su transversalidad | 1 |
| 15–30 | Pizarra | El Hamiltoniano, la función de cambio y los precios sombra; la suficiencia por Arrow | 2 |
| 30–50 | Pizarra | Resolver hacia atrás: la última fase, el tiempo de cambio y la matriz de asignación | 3.1, 3.2 |
| 50–58 | Cuaderno | El modelo con deslizadores: precios sombra, reparto y capital; tiempo de cambio analítico y numérico | Cuaderno, sección 1; notas, 3.3 |
| 58–63 | | Pausa | |
| 63–70 | Cuaderno | Los repartos fijos contra el óptimo | Cuaderno, sección 2 |
| 70–92 | Cuaderno | Dos estados de México: productividades de los datos, ahorros supuestos y la sensibilidad del resultado | Cuaderno, sección 3; notas, 4 y 5 |
| 92–105 | Cuaderno y discusión | Equidad frente a eficiencia: el costo de la equidad | Cuaderno, sección 4; notas, 6 (lectura previa) |
| 105–115 | Parejas, en el cuaderno | Ejercicios de código 1 a 3 | Cuaderno, ejercicios |
| 115–120 | Pizarra | Cierre: de Rahman a Bellman (Unidad IV) | 7 |
| Después | Lectura | La estática comparativa en detalle (4), la advertencia sobre Alexiadis (3.1), el resumen (8), la sección [Avanzado] del cuaderno y Para profundizar | |

**Pregunta de la unidad.** ¿Conviene invertir primero donde se ahorra más o
donde se produce más?

---

## 0. La pregunta

Un gobierno junta el ahorro de dos regiones en un fondo y decide, en cada
momento, qué fracción va a cada una. Una región **ahorra más**: cada peso
invertido ahí genera más ahorro, que vuelve al fondo. La otra **produce
más**: cada peso invertido ahí rinde más producto. Si el objetivo es el
producto nacional al final de un plan de $T$ años, ¿dónde conviene invertir
primero?

Es el modelo de Rahman (1963), resuelto con control óptimo por Intriligator
(1964), con el tiempo de cambio de Takayama (1967); Alexiadis (2018, cap. 2)
lo presenta como base de la política regional. Junta todas las piezas de la
unidad: dos estados con sus precios sombra (sesión 13), un control acotado
con Hamiltoniano lineal y solución bang-bang (sesión 13), transversalidad
(sesión 11) y una calibración con datos de México (sesión 12).

---

## 1. El modelo

### 1.1 Producción, ahorro y reparto

Cada región $i = 1, 2$ tiene capital $K_i$ y produce

$$
Y_i = v_iK_i,
$$

donde $v_i = Y_i/K_i$ es la **productividad del capital** (el inverso de
$K/Y$). Ahorra una fracción fija $s_i$ de su producto, así que el ahorro
nacional es

$$
S = s_1Y_1 + s_2Y_2 = s_1v_1K_1 + s_2v_2K_2 = \gamma_1K_1 + \gamma_2K_2,
\qquad \boxed{\ \gamma_i = s_iv_i\ }
$$

$\gamma_i$ es el ahorro que genera una unidad de capital en la región $i$:
su **tasa interna de crecimiento** (si toda la inversión se quedara en la
región, crecería a la tasa $\gamma_i$). El gobierno reparte el ahorro: una
fracción $\theta(t) \in [0, 1]$ a la región 1 y el resto a la 2 (aquí
$\theta(t)$ es un control, no el parámetro de la utilidad CRRA de las
sesiones 10 y 12; Alexiadis lo llama $\delta$, que en el curso es la
depreciación):

$$
K_1' = \theta S, \qquad K_2' = (1 - \theta)S.
$$

Supuestos: economía cerrada, sin depreciación, sin progreso técnico, y el
capital instalado en una región no se puede mover a la otra (por eso
$\theta \ge 0$ y $1 - \theta \ge 0$).

### 1.2 El objetivo

El gobierno maximiza el producto nacional al final del plan:

$$
\max_{\theta(t) \in [0, 1]}\ Y(T) = v_1K_1(T) + v_2K_2(T).
$$

Es un objetivo de **valor final**: no hay integral. La sesión 11 no tenía
este caso, pero se resuelve igual: con un valor final $\Phi(y(T))$ y $y(T)$
libre, la transversalidad es

$$
\lambda_j(T) = \frac{\partial \Phi}{\partial y_j(T)},
$$

el precio sombra al final es lo que vale una unidad más de estado en el
objetivo ([Para profundizar, P.1](#pp1)). Aquí,

$$
\boxed{\ p_i(T) = \frac{\partial Y(T)}{\partial K_i(T)} = v_i\ }
$$

---

## 2. El Hamiltoniano y la función de cambio

Con coestados $p_1$ y $p_2$ (los precios sombra del capital de cada
región, en unidades de producto final). Son los $\lambda_1$ y $\lambda_2$ de
la sesión 13; se escriben $p_i$, como en Alexiadis (2018), para que las
notas se puedan leer junto con el libro:

$$
H = p_1\theta S + p_2(1 - \theta)S = p_2S + \theta\thinspace(p_1 - p_2)\thinspace S.
$$

$H$ es lineal en $\theta$, y la función de cambio es
$\sigma = (p_1 - p_2)S$. Como $S > 0$:

$$
\boxed{\ \theta^\ast(t) = \begin{cases} 1 & \text{si } p_1(t) > p_2(t): \text{ todo a la región 1}, \cr 0 & \text{si } p_1(t) < p_2(t): \text{ todo a la región 2}. \end{cases}}
$$

**Se invierte en la región donde el capital vale más.** Las ecuaciones de
los coestados son

$$
\boxed{\ p_i' = -\frac{\partial H}{\partial K_i} = -\gamma_i\big(\theta p_1 + (1 - \theta)p_2\big) = -\gamma_i P\ },
\qquad P = \max\lbrace p_1, p_2\rbrace,
$$

con $p_i(T) = v_i$.

**Lectura.** Una unidad de capital en la región $i$ vale por dos cosas: lo
que producirá al final ($v_i$, por la transversalidad) y el ahorro que
genera mientras tanto ($\gamma_i$ por año), que se invierte donde el
capital vale más ($P$). Por eso $p_i' = -\gamma_iP$: cada año que pasa, el
capital de $i$ pierde el valor del ahorro que ya no alcanzará a generar.

**Suficiencia.** $\theta S$ es un producto de control y estado: no es
cóncava en $(K, \theta)$, y Mangasarian no aplica. Pero el Hamiltoniano
maximizado, $H^0 = \max\lbrace p_1, p_2\rbrace(\gamma_1K_1 + \gamma_2K_2)$,
es lineal en $K$: por Arrow, la solución del principio del máximo es el
óptimo (sesión 13, sección 4).

---

## 3. La solución: dónde se invierte primero

### 3.1 Resolver hacia atrás

Se sigue el procedimiento de la sesión 13. Sea $\tau = T - t$ el tiempo que
falta.

**Al final** se invierte en la región con mayor $v_i$, porque
$p_i(T) = v_i$: al final sólo importa cuánto produce el capital.

**Antes**, supón que la región 2 es la más productiva ($v_2 > v_1$), de
modo que la última fase es $\theta = 0$. Con $P = p_2$:

$$
p_2' = -\gamma_2p_2 \ \Rightarrow\ p_2 = v_2e^{\gamma_2\tau},
\qquad
p_1' = -\gamma_1p_2 \ \Rightarrow\ p_1 = v_1 + \frac{\gamma_1}{\gamma_2}v_2\big(e^{\gamma_2\tau} - 1\big).
$$

Hacia atrás, $p_1$ crece a $\gamma_1/\gamma_2$ veces la velocidad de $p_2$.
Hay dos casos.

- **$\gamma_1 \le \gamma_2$**: la región 2 también genera más ahorro. $p_1$
  nunca alcanza a $p_2$, y **toda la inversión va siempre a la región 2**.
- **$\gamma_1 > \gamma_2$**: la región 1 ahorra tanto más que genera más
  ahorro por unidad de capital, aunque produzca menos. $p_1$ alcanza a
  $p_2$ cuando faltan $\tau^\ast$ años, con

$$
\boxed{\ \tau^\ast = \frac{1}{\gamma_2}\ln\frac{v_1(s_1 - s_2)}{\gamma_1 - \gamma_2}\ }
$$

(la derivación está en [P.2](#pp2)). Antes de ese momento, $\theta = 1$:
$p_1' = -\gamma_1p_1$ y $p_2' = -\gamma_2p_1$, y como $\gamma_1 > \gamma_2$,
hacia atrás $p_1$ se aleja de $p_2$: **no hay un segundo cambio**.

El tiempo de cambio es $t^\ast = T - \tau^\ast$. Si $\tau^\ast \ge T$, el
horizonte es demasiado corto para la primera fase y se invierte siempre en
la región 2. Coincide con la proposición 7 de Alexiadis (2018).

**Al leer a Alexiadis (2018, secs. 2.4 y 2.5).** Su tiempo de cambio es
correcto, pero conviene leer con cuidado dos pasos:

- La proposición 1 dice que, antes de $T$, se invierte siempre en la región
  con mayor $\gamma_i$. Eso sólo vale **antes del tiempo de cambio y si el
  horizonte alcanza** ($T > \tau^\ast$); si no, se invierte siempre en la
  región más productiva. Sus tablas 2.1 y 2.2 tienen la misma omisión.
- Dice que basta la suficiencia de Mangasarian porque las ecuaciones son
  lineales. No lo son en $(K, \theta)$: $\theta S$ es un producto de control y
  estado. La suficiencia sale del teorema de Arrow (sección 2).

### 3.2 La matriz de asignación

Con $v_2 > v_1$ (la región 2 produce más):

| | $\gamma_1 \le \gamma_2$ | $\gamma_1 > \gamma_2$ y $T > \tau^\ast$ | $\gamma_1 > \gamma_2$ y $T \le \tau^\ast$ |
|---|---|---|---|
| $\theta^\ast$ en $[0, t^\ast)$ | 0 | **1** | 0 |
| $\theta^\ast$ en $[t^\ast, T]$ | 0 | 0 | 0 |
| Política | Concentrar en 2 | **Primero 1, después 2** | Concentrar en 2 |

Si una región es mejor en las dos cosas (más $v$ y más $\gamma$), recibe
todo siempre. Sólo hay un cambio cuando una región **ahorra** más y la otra
**produce** más.

**Respuesta a la pregunta de la unidad.** Primero se invierte donde el
capital **genera más ahorro** ($\gamma$ mayor), para que el fondo crezca;
al final, donde el capital **produce más** ($v$ mayor), porque lo que
cuenta es el producto al final. El cambio ocurre cuando faltan $\tau^\ast$
años: cuanto más largo el plan, más dura la fase de crecimiento.

### 3.3 Un ejemplo

Con $v_1 = 0.20$, $v_2 = 0.25$, $s_1 = 0.30$ y $s_2 = 0.20$:
$\gamma_1 = 0.060 > \gamma_2 = 0.050$, y
$\tau^\ast = 20\ln(0.02/0.01) = 20\ln 2 \approx 13.9$ años. Con un plan de
30 años, se invierte todo en la región 1 durante 16.1 años y después todo
en la región 2. Con un plan de 10 años, todo en la región 2.

---

## 4. Estática comparativa del tiempo de cambio

$\tau^\ast$ depende de los cuatro parámetros. Con $v_2 > v_1$ y
$\gamma_1 > \gamma_2$ ([P.2](#pp2)):

| Si sube | $\tau^\ast$ (años finales en la región 2) | La fase en la región 1 |
|---|---|---|
| $s_1$ (la región 1 ahorra más) | Baja | Se alarga |
| $s_2$ | Sube | Se acorta |
| $v_1$ | Baja | Se alarga |
| $v_2$ (la región 2 produce más) | Sube | Se acorta |
| $T$ | No cambia | Se alarga lo mismo que $T$ |

Cuando $\gamma_1 \to \gamma_2$ por arriba, $\tau^\ast \to \infty$: la
ventaja de ahorro de la región 1 apenas compensa su desventaja de
productividad, y la fase en la región 1 desaparece. Cerca de ese umbral,
**un cambio pequeño en las tasas de ahorro cambia toda la política**.

---

## 5. Calibración con dos regiones de México

### 5.1 Productividad del capital

No hay series de capital por entidad. El cuaderno aproxima $v_i$ con el
PIB por trabajador (INEGI, sin la minería petrolera; empleo de la OCDE,
2023) y un supuesto explícito: **el capital por trabajador es el mismo en
todos los estados**. Entonces $v_i = Y_i/K_i$ es proporcional al PIB por
trabajador:

$$
v_i = \bar v\thinspace\frac{y_i}{\bar y},
\qquad \bar v = \frac{1}{K/Y} = \frac{1}{3.66} \approx 0.27,
$$

con $\bar y$ el PIB por trabajador nacional y $K/Y$ el de la Penn World
Table (sesión 12). El supuesto exagera las diferencias de $v_i$: los estados
ricos suelen tener también más capital por trabajador, y su $v_i$ real sería
menor que el calibrado.

**Una segunda calibración.** Para medir cuánto importa el supuesto, el
cuaderno permite suponer que el capital por trabajador crece con el
producto por trabajador, $K_i/L_i \propto y_i^{1 - \phi}$. Entonces

$$
v_i = \bar v\thinspace\Big(\frac{y_i}{\bar y}\Big)^{\phi}, \qquad 0 \le \phi \le 1.
$$

Con $\phi = 1$ es el supuesto de arriba; con $\phi = 0$, todos los estados
tienen la misma $v_i$ y sólo el ahorro decide; con $\phi = 1/2$, las
diferencias de $v_i$ son la raíz cuadrada de las de $y_i$.

### 5.2 Ahorro

Las tasas de ahorro por entidad **no se publican**. El cuaderno las fija con
supuestos explícitos alrededor de la tasa nacional (alrededor de 0.19,
sesión 12) y mide cuánto cambia el resultado.

### 5.3 Coahuila y Nuevo León

Con los datos de 2023, $v_{\text{Coah}} = 0.400$ y $v_{\text{NL}} = 0.461$:
Nuevo León produce 15% más por unidad de capital. Con $s_{\text{NL}} = 0.19$
y un plan de 20 años:

| $s_{\text{Coah}}$ | $\gamma_{\text{Coah}}$ vs. $\gamma_{\text{NL}} = 0.0875$ | $\tau^\ast$ | Política |
|---|---|---|---|
| 0.19 | 0.076 < 0.0875 | — | Todo a Nuevo León |
| 0.21 | 0.084 < 0.0875 | — | Todo a Nuevo León |
| 0.22 | 0.088 > 0.0875 | 38.6 años | Todo a Nuevo León (el plan es corto) |
| 0.25 | 0.100 > 0.0875 | 7.5 años | Coahuila 12.5 años, después Nuevo León |

**Lectura.**
- Para que convenga invertir primero en Coahuila, su tasa de ahorro tiene
  que ser más de $v_{\text{NL}}/v_{\text{Coah}} = 1.15$ veces la de Nuevo
  León. Entre 0.22 y 0.25, la política pasa de "nada a Coahuila" a "12 años a
  Coahuila". **La respuesta depende de un parámetro que no se mide**: es la
  pregunta de sensibilidad que el proyecto final debe hacerse con sus
  propios supuestos ([E.A2](repaso/estadistica.md#ea2)).
- Entre estados muy distintos, como Chiapas ($v = 0.11$) y la Ciudad de
  México ($v = 0.53$), Chiapas tendría que ahorrar 4.6 veces más que la
  capital para recibir algo. El modelo de eficiencia **concentra la
  inversión en la región más productiva**.
- Con la segunda calibración y $\phi = 1/2$, el umbral para Coahuila baja
  de 1.15 a $1.15^{1/2} \approx 1.07$ veces el ahorro de Nuevo León: con
  $s_{\text{NL}} = 0.19$, la fase en Coahuila es posible si ahorra más de 0.204
  (y dura más cuanto más largo sea el plan). **El
  supuesto sobre el capital por estado pesa tanto como el del ahorro.**

---

## 6. Equidad frente a eficiencia

*Lectura previa: esta sección se lee antes de clase y se discute en la
última parte de la sesión, con la sección 4 del cuaderno.*

El objetivo $Y(T) = Y_1(T) + Y_2(T)$ sólo mira el total. La política
óptima suele ensanchar la brecha entre regiones: invierte en la más
productiva, que ya es la más rica. Es el dilema de la política regional
(Alexiadis, 2018, cap. 3).

Una forma de incluir la equidad es **pesar** el producto de cada región:

$$
\max\ \omega_1Y_1(T) + \omega_2Y_2(T).
$$

La única diferencia es la transversalidad: $p_i(T) = \omega_iv_i$. Con un
peso mayor en la región pobre, la última fase puede pasar a ella, y el
tiempo de cambio se mueve. El **costo de la equidad** es cuánto producto
nacional se pierde respecto al óptimo de eficiencia; el cuaderno lo calcula
para cada peso. Elegir $\omega$ no es una pregunta técnica: es un juicio de
valor que el modelo hace explícito y cuantifica.

---

## 7. Hacia la programación dinámica

| Idea de esta sesión | Dónde reaparece |
|---|---|
| Resolver hacia atrás desde los precios finales | Inducción hacia atrás en la ecuación de Bellman (sesión 15) |
| Precio sombra del capital de cada región | La derivada de la función valor respecto a cada estado (sesiones 16 y 18) |
| Política que depende del tiempo que falta ($\tau$) | Políticas que dependen del periodo en horizonte finito (sesión 15) |
| Supuestos que no se miden y sensibilidad | Calibración y sensibilidad del proyecto final (Unidad V) |

Rahman (1963), el primero en plantear este problema, no usó el principio
del máximo sino el **principio de optimalidad de Bellman** (Alexiadis,
2018, sec. 2.1): "cualesquiera que sean el estado y las decisiones
iniciales, las decisiones restantes deben ser óptimas para el estado que
resulta de las primeras". Es el punto de partida de la Unidad IV.

---

## 8. Resumen formal

| Concepto | Enunciado | Dónde |
|---|---|---|
| Tasa interna de crecimiento | $\gamma_i = s_iv_i$ | 1.1 |
| Valor final | $p_i(T) = \partial Y(T)/\partial K_i = v_i$ | 1.2 |
| Función de cambio | $\sigma = (p_1 - p_2)S$; se invierte donde el capital vale más | 2 |
| Precios sombra | $p_i' = -\gamma_i\max\lbrace p_1, p_2\rbrace$ | 2 |
| Suficiencia | Arrow: $H^0$ lineal en $K$ | 2 |
| Última fase | La región con mayor $v_i$ | 3.1 |
| Tiempo de cambio | $\tau^\ast = \gamma_2^{-1}\ln\big(v_1(s_1 - s_2)/(\gamma_1 - \gamma_2)\big)$ si $\gamma_1 > \gamma_2$, $v_2 > v_1$ | 3.1 |
| Política | Primero donde se genera más ahorro; al final donde se produce más | 3.2 |
| Calibración | $v_i = \bar v\thinspace y_i/\bar y$; $s_i$ supuestos | 5 |
| Equidad | Pesos $\omega_i$: $p_i(T) = \omega_iv_i$ | 6 |

---

## 9. Ejercicios formales

- **F1.** Resuelve el caso $v_1 > v_2$ y $\gamma_1 < \gamma_2$: muestra que
  se invierte primero en la región 2 y al final en la 1, y encuentra el
  tiempo de cambio.
- **F2.** Muestra que la condición $\gamma_1 > \gamma_2$ con $v_2 > v_1$
  equivale a $s_1/s_2 > v_2/v_1$, y que entonces el argumento del logaritmo
  de $\tau^\ast$ es mayor que 1.
- **F3.** Con el ejemplo de la sección 3.3, calcula $K_1(T)$, $K_2(T)$ e
  $Y(T)$ con $K_1(0) = K_2(0) = 1$ y $T = 30$. Compáralo con un reparto fijo
  $\theta = 1/2$.
- **F4.** Con pesos $\omega_1$, $\omega_2$, deriva el tiempo de cambio
  cuando la última fase es en la región 2 y $\gamma_1 > \gamma_2$.

**Para profundizar** (opcionales)

- **F5.** Deriva $\partial\tau^\ast/\partial s_1$ y
  $\partial\tau^\ast/\partial v_2$ y confirma los signos de la tabla de la
  sección 4 ([P.2](#pp2)).
- **F6.** Supón que el objetivo es el consumo acumulado,
  $\int_0^T \big((1 - s_1)Y_1 + (1 - s_2)Y_2\big)\thinspace dt$. Escribe el
  Hamiltoniano y la transversalidad. ¿Qué cambia en la lógica de la
  solución?
- **F7.** El modelo supone que el capital no se mueve entre regiones. ¿Qué
  pasaría con la política óptima si el capital instalado pudiera
  trasladarse sin costo?

## Para profundizar

Material opcional: demostraciones y temas que no se ven en clase. Cada
apartado indica de qué sección de las notas viene.

<a id="pp1"></a>

### P.1 Transversalidad con valor final (sección 1.2)

Sea el problema $\max\ \Phi(y(T)) + \int_0^T F\thinspace dt$ con $y(T)$
libre. Por el teorema fundamental del cálculo,

$$
\Phi(y(T)) = \Phi(y_0) + \int_0^T \Phi'(y)\thinspace y'\thinspace dt
= \Phi(y_0) + \int_0^T \Phi'(y)\thinspace f(t, y, u)\thinspace dt,
$$

así que el problema equivale a uno sin valor final con integrando
$F + \Phi'(y)f$. Más directo: en la derivación de la sesión 11 (P.1), el
valor final agrega $\Phi'(y(T))\thinspace\Delta y_T$ al término de
frontera, que queda $\big(\Phi'(y(T)) - \lambda(T)\big)\Delta y_T$. Con
$\Delta y_T$ arbitrario, $\lambda(T) = \Phi'(y(T))$. Con varios estados,
$\lambda_j(T) = \partial\Phi/\partial y_j(T)$. $\square$

<a id="pp2"></a>

### P.2 El tiempo de cambio y su estática comparativa (secciones 3 y 4)

**Derivación.** En la última fase, $p_1 = p_2$ cuando

$$
v_1 + \frac{\gamma_1}{\gamma_2}v_2\big(e^{\gamma_2\tau} - 1\big) = v_2e^{\gamma_2\tau}
\iff
v_2e^{\gamma_2\tau}\Big(\frac{\gamma_1}{\gamma_2} - 1\Big) = \frac{\gamma_1}{\gamma_2}v_2 - v_1
\iff
e^{\gamma_2\tau} = \frac{\gamma_1v_2 - \gamma_2v_1}{v_2(\gamma_1 - \gamma_2)}.
$$

Con $\gamma_i = s_iv_i$, el numerador es
$s_1v_1v_2 - s_2v_2v_1 = v_1v_2(s_1 - s_2)$, y queda
$e^{\gamma_2\tau^\ast} = v_1(s_1 - s_2)/(\gamma_1 - \gamma_2)$. El
argumento es mayor que 1 si y sólo si
$v_1(s_1 - s_2) > s_1v_1 - s_2v_2$, es decir, $v_2 > v_1$: hay un
$\tau^\ast > 0$ justo en el caso que se supuso.

**Estática comparativa.** Sea $x = v_1(s_1 - s_2)/(s_1v_1 - s_2v_2)$, de
modo que $\tau^\ast = \ln x/\gamma_2$, con $\gamma_2 = s_2v_2$ que no
depende de $s_1$ ni de $v_1$. Entonces

$$
\frac{\partial x}{\partial s_1}
= \frac{v_1(s_1v_1 - s_2v_2) - v_1(s_1 - s_2)v_1}{(s_1v_1 - s_2v_2)^2}
= -\frac{v_1s_2(v_2 - v_1)}{(\gamma_1 - \gamma_2)^2} < 0,
$$

así que $\tau^\ast$ baja con $s_1$: más ahorro en la región 1 alarga su fase.
Para $s_2$ y $v_2$ hay dos efectos (también están en $\gamma_2$), y el signo
no es inmediato; el ejercicio F5 pide el cálculo para $v_2$. Una revisión
numérica en una malla amplia ($v_1 \in [0.1, 0.5]$, $v_2/v_1 \in [1, 2]$,
$s_2 \in [0.1, 0.3]$, $s_1/s_2 \in [1, 3]$, siempre con
$\gamma_1 > \gamma_2$) da los signos de la tabla en todos los casos.

---

## Referencias

- Alexiadis, S. (2018). *The Dilemma of Regional Policy*. Springer.
  https://doi.org/10.1007/978-3-319-68900-5
- Intriligator, M. D. (1964). Regional allocation of investment: Comment.
  *Quarterly Journal of Economics*, 78(4), 659–662.
  https://doi.org/10.2307/1879665
- Rahman, M. A. (1963). Regional allocation of investment: An aggregative
  study in the theory of development programming. *Quarterly Journal of
  Economics*, 77(1), 26–39. https://doi.org/10.2307/1879370
- Takayama, A. (1967). Regional allocation of investment: A further
  analysis. *Quarterly Journal of Economics*, 81(2), 330–336.
  https://doi.org/10.2307/1879591
