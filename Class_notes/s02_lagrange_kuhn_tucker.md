# Sesión 2: Lagrange, concavidad y Kuhn-Tucker. Notas formales

> **Cómo leer estas notas.** Siguen el orden del programa: primero se explora
> en el cuaderno (`Code/s02_lagrange_kuhn_tucker.jl`), después se formaliza
> aquí. Lo que no tiene marca se ve en clase y se evalúa. Las secciones y
> demostraciones marcadas **[Avanzado]** son opcionales.
>
> Repaso recomendado: [C.B2](repaso/calculo.md#cb2) (máximos en una
> variable), [C.B5](repaso/calculo.md#cb5) (gradiente),
> [C.I1](repaso/calculo.md#ci1) (hessiana), [C.I2](repaso/calculo.md#ci2)
> (concavidad), [C.I5](repaso/calculo.md#ci5) (Lagrange),
> [L.I4](repaso/algebra_lineal.md#li4) (definitud) y
> [L.I5](repaso/algebra_lineal.md#li5) (hessiana orlada); para los puntos
> [Avanzado], [C.A1](repaso/calculo.md#ca1),
> [L.A3](repaso/algebra_lineal.md#la3) y [A.I3](repaso/analisis.md#ai3).
>
> Lecturas: Chiang y Wainwright (2006), caps. 11–13.

**Pregunta del bloque.** Un gobierno tiene un fondo $B$ para invertir en dos
regiones. ¿Cómo debe repartirlo? ¿Conviene siempre dar algo a cada región?

---

## 1. El problema de las dos regiones

Cada peso invertido en la región $i$ produce, con rendimientos decrecientes,

$$
f_i(x_i) = a_i\ln(1 + x_i), \qquad a_i > 0,
$$

donde $x_i \ge 0$ es la inversión y $a_i$ mide la productividad de la región.
El planificador resuelve

$$
\max_{x_1, x_2}\ a_1\ln(1 + x_1) + a_2\ln(1 + x_2)
\qquad\text{sujeto a}\qquad x_1 + x_2 \le B,\quad x_1 \ge 0,\quad x_2 \ge 0.
$$

Sin pérdida de generalidad, $a_1 \ge a_2$: la región 1 es la más productiva.

Dos rasgos de la función de producción deciden la forma de la solución:
- Es **cóncava**: $f_i'' = -a_i/(1+x_i)^2 < 0$. Cada peso adicional rinde
  menos que el anterior, así que conviene repartir.
- Su producto marginal en cero es **finito**: $f_i'(0) = a_i$. Si la región 2
  es poco productiva, ni su primer peso rinde lo que rinde un peso más en la
  región 1, y puede convenir no darle nada. Con $f_i = a_i\sqrt{x_i}$, en
  cambio, $f_i'(0) = \infty$ y toda región recibe algo.

El conjunto factible es compacto y $f$ es continua, así que el máximo existe
(teorema de Weierstrass, [A.I3](repaso/analisis.md#ai3)). Las secciones 2 a 4
construyen las herramientas para encontrarlo; la sección 4.4 lo resuelve.

---

## 2. Optimización sin restricciones

Sea $f: U \to \mathbb{R}$ dos veces diferenciable, con $U \subset \mathbb{R}^n$
abierto.

### 2.1 Condición de primer orden

**Proposición.** Si $x^\ast$ es un máximo local de $f$ en $U$, entonces
$\nabla f(x^\ast) = 0$.

*Demostración.* Para cualquier dirección $h$, la función de una variable
$\varphi(t) = f(x^\ast + th)$ tiene un máximo local en $t = 0$, así que
$\varphi'(0) = \nabla f(x^\ast)^\top h = 0$. Como vale para todo $h$,
$\nabla f(x^\ast) = 0$. $\square$

### 2.2 Condiciones de segundo orden

**Proposición.** Sea $\nabla f(x^\ast) = 0$.
1. *(Suficiente)* Si $\nabla^2 f(x^\ast)$ es definida negativa, $x^\ast$ es
   un máximo local estricto.
2. *(Necesaria)* Si $x^\ast$ es un máximo local, $\nabla^2 f(x^\ast)$ es
   semidefinida negativa.

La idea está en el desarrollo de Taylor de segundo orden
([C.I7](repaso/calculo.md#ci7)): como el gradiente es cero,
$f(x^\ast + h) - f(x^\ast) \approx \tfrac12 h^\top\nabla^2 f(x^\ast)\thinspace h$,
y el signo lo decide la forma cuadrática ([L.I4](repaso/algebra_lineal.md#li4)).

### 2.3 Concavidad: del óptimo local al global

**Lema (desigualdad del gradiente).** Si $f$ es cóncava y diferenciable en
un conjunto convexo abierto $U$, entonces para todo $x, y \in U$

$$
f(y) \le f(x) + \nabla f(x)^\top(y - x):
$$

la función queda por debajo de su plano tangente.

*Demostración* **[Avanzado]**. Por concavidad, para $\theta \in (0, 1]$,
$f\big(x + \theta(y - x)\big) \ge f(x) + \theta\big(f(y) - f(x)\big)$.
Restando $f(x)$, dividiendo entre $\theta$ y haciendo $\theta \to 0$, el
lado izquierdo tiende a $\nabla f(x)^\top(y - x)$. $\square$

**Proposición.** Si $f$ es cóncava en $U$ convexo y $\nabla f(x^\ast) = 0$,
entonces $x^\ast$ es un máximo global. Si $f$ es estrictamente cóncava, es
el único.

*Demostración.* Con $\nabla f(x^\ast) = 0$, el lema da
$f(y) \le f(x^\ast)$ para todo $y$. Si hubiera dos maximizadores distintos,
el punto medio daría un valor estrictamente mayor por concavidad estricta.
$\square$

**Ejemplo.** Una sola región con precio $p > 0$ por peso invertido:
$\max_x a\ln(1 + x) - px$. La función es estrictamente cóncava y
$a/(1 + x) = p$ da $x^\ast = a/p - 1$, el máximo global, siempre que
$a > p$. Si $a \le p$, el óptimo con $x \ge 0$ es la esquina $x^\ast = 0$
([C.B2](repaso/calculo.md#cb2)). La sección 4 generaliza este razonamiento.

---

## 3. Restricciones de igualdad: el método de Lagrange

### 3.1 El teorema

Considera $\max f(x)$ sujeto a $g_j(x) = c_j$, $j = 1, \dots, m$, con
$m < n$. Sea $Dg(x)$ la matriz $m \times n$ de gradientes de las
restricciones.

**Teorema (Lagrange).** Si $x^\ast$ es un máximo local y $Dg(x^\ast)$ tiene
rango $m$, existen multiplicadores $\lambda_1, \dots, \lambda_m$ tales que

$$
\nabla f(x^\ast) = \sum_{j=1}^m \lambda_j\nabla g_j(x^\ast).
$$

Equivalentemente, con el **lagrangiano**
$\mathcal L(x, \lambda) = f(x) + \sum_j \lambda_j\big(c_j - g_j(x)\big)$, el
óptimo es un punto crítico de $\mathcal L$: $\nabla_x\mathcal L = 0$ y
$\nabla_\lambda\mathcal L = 0$ (que son las restricciones).

**Geometría ($n = 2$, $m = 1$).** En el óptimo, la curva de nivel de $f$ es
tangente a la restricción: si no lo fuera, moverse a lo largo de la
restricción aumentaría $f$. Tangencia significa gradientes paralelos,
$\nabla f = \lambda\nabla g$.

*Demostración para $n = 2$, $m = 1$* **[Avanzado]**. Como $\nabla g(x^\ast) \ne 0$,
supón $g_2 \ne 0$. Por el teorema de la función implícita
([C.I4](repaso/calculo.md#ci4)), cerca de $x^\ast$ la restricción define
$x_2 = h(x_1)$ con $h' = -g_1/g_2$. La función de una variable
$F(x_1) = f\big(x_1, h(x_1)\big)$ tiene un máximo local en $x_1^\ast$, así que
$F' = f_1 + f_2h' = f_1 - f_2\thinspace g_1/g_2 = 0$. Con
$\lambda = f_2/g_2$ quedan $f_2 = \lambda g_2$ y $f_1 = \lambda g_1$. $\square$

La condición de rango es necesaria. Sin ella el teorema puede fallar: ver la
sección 4.5.

### 3.2 El multiplicador como precio sombra

Sea $V(c)$ el valor máximo cuando la restricción es $g(x) = c$. Entonces

$$
V'(c) = \lambda:
$$

el multiplicador dice cuánto aumenta el óptimo si la restricción se relaja
en una unidad. En el problema de las regiones, $\lambda$ es el **valor
social de un peso adicional del fondo**. La demostración general es el
teorema de la envolvente, que se ve en la sesión 3; aquí se verifica en el
ejemplo de la sección 3.4.

### 3.3 Condición de segundo orden

Para $n = 2$ y $m = 1$, un punto crítico del lagrangiano es un máximo local
estricto si

$$
\det\bar H = \det\begin{pmatrix} 0 & g_1 & g_2 \cr g_1 & \mathcal L_{11} & \mathcal L_{12} \cr g_2 & \mathcal L_{12} & \mathcal L_{22}\end{pmatrix} > 0,
$$

donde $\mathcal L_{ij}$ son las segundas derivadas del lagrangiano respecto
de $x$. El criterio general, con $n$ variables y $m$ restricciones, está en
[L.I5](repaso/algebra_lineal.md#li5).

### 3.4 Ejemplo: las dos regiones con el presupuesto agotado

Si se exige $x_1 + x_2 = B$ y se ignoran las restricciones $x_i \ge 0$, las
condiciones de Lagrange son

$$
\frac{a_1}{1 + x_1} = \frac{a_2}{1 + x_2} = \lambda.
$$

El último peso debe rendir lo mismo en las dos regiones. Despejando
$1 + x_i = a_i/\lambda$ y sumando, $B + 2 = (a_1 + a_2)/\lambda$:

$$
\lambda = \frac{a_1 + a_2}{B + 2},
\qquad
x_i = \frac{a_i\thinspace(B + 2)}{a_1 + a_2} - 1.
$$

**Precio sombra.** El valor óptimo es
$V(B) = \sum_i a_i\ln\big(a_i(B + 2)/(a_1 + a_2)\big)$, y derivando,
$V'(B) = (a_1 + a_2)/(B + 2) = \lambda$, como afirma la sección 3.2.

**Segundo orden.** Con $g_1 = g_2 = 1$, $\mathcal L_{12} = 0$ y
$\mathcal L_{ii} = -a_i/(1 + x_i)^2 < 0$, el determinante de la hessiana
orlada vale $-(\mathcal L_{11} + \mathcal L_{22}) > 0$: es un máximo.

**El problema.** La fórmula da $x_2 < 0$ cuando
$a_2(B + 2) < a_1 + a_2$, es decir, cuando

$$
B < \bar B = \frac{a_1}{a_2} - 1.
$$

Con un fondo pequeño y regiones muy distintas, Lagrange recomienda
**desinvertir** en la región 2 para invertir más en la 1, lo que no es
factible. Hacen falta las restricciones de desigualdad.

---

## 4. Restricciones de desigualdad: Kuhn-Tucker

### 4.1 Las condiciones

Considera

$$
\max f(x) \qquad\text{sujeto a}\qquad g_j(x) \le c_j \ (j = 1, \dots, m),
\qquad x \ge 0,
$$

con lagrangiano $\mathcal L = f(x) + \sum_j\lambda_j\big(c_j - g_j(x)\big)$.
Las **condiciones de Kuhn-Tucker** son:

$$
\frac{\partial\mathcal L}{\partial x_i} \le 0,
\qquad x_i \ge 0,
\qquad x_i\thinspace\frac{\partial\mathcal L}{\partial x_i} = 0
\qquad (i = 1, \dots, n),
$$

$$
c_j - g_j(x) \ge 0,
\qquad \lambda_j \ge 0,
\qquad \lambda_j\big(c_j - g_j(x)\big) = 0
\qquad (j = 1, \dots, m).
$$

**Teorema (Kuhn-Tucker).** Si $x^\ast$ es un máximo local y se cumple una
calificación de las restricciones (sección 4.5), existen
$\lambda_1, \dots, \lambda_m$ tales que $(x^\ast, \lambda)$ cumple las
condiciones de Kuhn-Tucker.

### 4.2 Holgura complementaria: la lectura económica

Las igualdades $x_i\thinspace\partial\mathcal L/\partial x_i = 0$ y
$\lambda_j(c_j - g_j) = 0$ se llaman de **holgura complementaria**. En cada
par, al menos una de las dos desigualdades se cumple con igualdad:

| Situación | Consecuencia | Lectura en el problema de las regiones |
|---|---|---|
| La restricción no se agota: $g_j < c_j$ | $\lambda_j = 0$ | Si sobrara fondo, un peso más no valdría nada |
| El precio sombra es positivo: $\lambda_j > 0$ | $g_j = c_j$ | Si un peso más vale algo, se gasta todo el fondo |
| Se invierte en $i$: $x_i > 0$ | $\partial\mathcal L/\partial x_i = 0$ | El producto marginal de $i$ iguala el precio sombra del fondo |
| No se invierte en $i$: $x_i = 0$ | $\partial\mathcal L/\partial x_i \le 0$ | El primer peso en $i$ rinde menos que el precio sombra |

En la última fila está la respuesta a la pregunta del bloque: una región no
recibe nada si su producto marginal en cero no alcanza el valor de un peso
del fondo.

### 4.3 Suficiencia

**Teorema.** Si $f$ es cóncava y cada $g_j$ es convexa, todo punto que cumple
las condiciones de Kuhn-Tucker es un máximo global. Si $f$ es estrictamente
cóncava, el máximo es único.

*Demostración* **[Avanzado]**. Para $\lambda \ge 0$ fijo, la función
$x \mapsto \mathcal L(x, \lambda)$ es cóncava (suma de cóncavas). Sea $x$
factible. Por la desigualdad del gradiente (sección 2.3),

$$
\mathcal L(x, \lambda) \le \mathcal L(x^\ast, \lambda) + \nabla_x\mathcal L(x^\ast, \lambda)^\top(x - x^\ast)
= \mathcal L(x^\ast, \lambda) + \sum_i \frac{\partial\mathcal L}{\partial x_i}\thinspace x_i,
$$

donde se usó $x_i^\ast\thinspace\partial\mathcal L/\partial x_i = 0$. Como
$\partial\mathcal L/\partial x_i \le 0$ y $x_i \ge 0$, la suma es $\le 0$, así
que $\mathcal L(x, \lambda) \le \mathcal L(x^\ast, \lambda) = f(x^\ast)$, por
holgura complementaria. Además, $\mathcal L(x, \lambda) \ge f(x)$ porque
$\lambda_j \ge 0$ y $c_j - g_j(x) \ge 0$. Entonces $f(x) \le f(x^\ast)$.
$\square$

Las condiciones son **necesarias** en general (bajo calificación) y
**suficientes** con concavidad. Sin concavidad, un punto de Kuhn-Tucker puede
ser incluso un mínimo; el cuaderno lo muestra con rendimientos crecientes
(sección 5).

Con $f$ sólo cuasicóncava, la suficiencia requiere condiciones adicionales
(Arrow y Enthoven, 1961).

### 4.4 Solución del problema de las dos regiones

El lagrangiano es
$\mathcal L = a_1\ln(1 + x_1) + a_2\ln(1 + x_2) + \lambda(B - x_1 - x_2)$, y
las condiciones de Kuhn-Tucker:

$$
\frac{a_i}{1 + x_i} - \lambda \le 0,
\qquad x_i \ge 0,
\qquad x_i\left(\frac{a_i}{1 + x_i} - \lambda\right) = 0,
$$

$$
B - x_1 - x_2 \ge 0,
\qquad \lambda \ge 0,
\qquad \lambda\thinspace(B - x_1 - x_2) = 0.
$$

1. **El fondo se agota.** Si $\lambda = 0$, la primera condición pediría
   $a_i/(1 + x_i) \le 0$, imposible. Entonces $\lambda > 0$ y
   $x_1 + x_2 = B$.
2. **Las dos regiones reciben inversión** ($x_1, x_2 > 0$). Es la solución de
   Lagrange de la sección 3.4, válida si $B \ge \bar B$.
3. **Sólo la región 1 recibe** ($x_2 = 0$, $x_1 = B$). La condición de
   $x_1 > 0$ da $\lambda = a_1/(1 + B)$, y la de $x_2 = 0$ pide
   $a_2 - \lambda \le 0$, es decir, $B \le \bar B$.
4. **Sólo la región 2 recibe** ($x_1 = 0$): pediría $a_1 \le a_2/(1 + B)$,
   imposible con $a_1 \ge a_2$ y $B > 0$.

Como $f$ es estrictamente cóncava y la restricción es lineal, la solución es
el único máximo global (sección 4.3).

**Proposición.** Con $a_1 \ge a_2$ y $\bar B = a_1/a_2 - 1$:

$$
(x_1^\ast, x_2^\ast, \lambda) =
\begin{cases}
\left(B,\ 0,\ \dfrac{a_1}{1 + B}\right) & \text{si } B \le \bar B, \cr
\left(\dfrac{a_1(B + 2)}{a_1 + a_2} - 1,\ \dfrac{a_2(B + 2)}{a_1 + a_2} - 1,\ \dfrac{a_1 + a_2}{B + 2}\right) & \text{si } B > \bar B.
\end{cases}
$$

**Lectura económica.**
- Con un fondo pequeño, todo va a la región más productiva; a partir de
  $\bar B$, también la menos productiva recibe. El umbral crece con la
  brecha de productividad $a_1/a_2$.
- El precio sombra $\lambda(B)$ es continuo y decreciente: en $\bar B$ vale
  $a_2$ por las dos fórmulas. Cada peso adicional del fondo vale menos que el
  anterior, y $V(B)$ es cóncava.
- Desde la región 2, la regla es simple: recibe inversión si y sólo si su
  producto marginal en cero, $a_2$, supera el valor de un peso del fondo,
  $\lambda$.

**Ejemplo numérico.** Con $a_1 = 2$ y $a_2 = 1$, $\bar B = 1$. Con $B = 0.5$:
$x^\ast = (0.5, 0)$ y $\lambda = 2/1.5 \approx 1.33$. Con $B = 4$:
$x^\ast = (3, 1)$ y $\lambda = 3/6 = 0.5$.

### 4.5 Calificación de las restricciones **[Avanzado]**

El teorema de Kuhn-Tucker pide una **calificación de las restricciones**. La
más usada (independencia lineal) exige que los gradientes de las
restricciones activas en $x^\ast$, incluidas las $x_i \ge 0$ activas, sean
linealmente independientes ([L.A3](repaso/algebra_lineal.md#la3)).

**Contraejemplo** (Chiang y Wainwright, sec. 13.2). Maximizar $x_1$ sujeto a
$x_2 - (1 - x_1)^3 \le 0$ y $x_1, x_2 \ge 0$. El conjunto factible está bajo
la curva $x_2 = (1 - x_1)^3$ y el óptimo es $(1, 0)$. Ahí

$$
\frac{\partial\mathcal L}{\partial x_1} = 1 - 3\lambda(1 - x_1)^2 = 1 > 0
\quad\text{con}\quad x_1 = 1 > 0,
$$

así que no existe $\lambda$ que cumpla las condiciones. La frontera forma una
cúspide en el óptimo, y los gradientes de las dos restricciones activas,
$(0, 1)$ y $(0, -1)$, son linealmente dependientes.

**Restricciones lineales.** Si todas las restricciones son lineales, como en
el problema de las regiones, una calificación (la de Abadie) se cumple
siempre, y las condiciones de Kuhn-Tucker son necesarias sin más
hipótesis.

---

## 5. Cuándo la concavidad no se cumple

Supón rendimientos crecientes, $f_i(x_i) = a_ix_i^\gamma$ con $\gamma > 1$:
por ejemplo, economías de aglomeración. A lo largo del presupuesto
agotado, $\varphi(x_1) = a_1x_1^\gamma + a_2(B - x_1)^\gamma$ es convexa, así
que su máximo está en un extremo: **todo el fondo va a una sola región**,
la de mayor $a_i$.

El punto interior donde $a_1\gamma x_1^{\gamma-1} = a_2\gamma x_2^{\gamma-1}$
cumple las condiciones de Kuhn-Tucker, pero es el **mínimo** de $\varphi$. Las
condiciones son necesarias, no suficientes; sin concavidad hay que comparar
todos los candidatos.

La lección sirve para la política regional: con rendimientos decrecientes,
la eficiencia recomienda repartir; con rendimientos crecientes, concentrar.
La misma tensión reaparece en el caso dinámico de la sesión 14.

---

## 6. Hacia la optimización dinámica

Tres ideas de esta sesión reaparecen en el resto del curso:

| Idea estática | Versión dinámica |
|---|---|
| El multiplicador $\lambda$ es el precio sombra del fondo | El coestado $\lambda(t)$ es el precio sombra del capital en el tiempo $t$ (sesión 11) |
| Concavidad de $f$ y convexidad de las $g_j$ hacen suficientes las condiciones | Suficiencia de Mangasarian y de Arrow (sesión 13) |
| Una función lineal se maximiza en una esquina | Hamiltoniano lineal en el control: soluciones bang-bang (sesiones 13 y 14) |

En el modelo de Rahman, Intriligator y Takayama (sesión 14), el producto es
lineal en el capital: $Y_i = v_iK_i$. Por eso, a diferencia de este problema
estático, el óptimo no reparte: invierte todo en una región y, en un
momento dado, cambia a la otra.

---

## 7. Resumen formal

| Concepto | Enunciado | Dónde |
|---|---|---|
| Primer orden | Máximo interior $\Rightarrow \nabla f = 0$ | 2.1 |
| Segundo orden | $\nabla^2 f$ definida negativa $\Rightarrow$ máximo local estricto | 2.2 |
| Concavidad | $f$ cóncava y $\nabla f(x^\ast) = 0 \Rightarrow$ máximo global | 2.3 |
| Lagrange | Con rango completo, $\nabla f = \sum_j\lambda_j\nabla g_j$ | 3.1 |
| Precio sombra | $V'(c) = \lambda$ | 3.2, 3.4 |
| Kuhn-Tucker | Condiciones de signo y de holgura complementaria | 4.1, 4.2 |
| Suficiencia | $f$ cóncava, $g_j$ convexas $\Rightarrow$ Kuhn-Tucker basta | 4.3 |
| Dos regiones | Todo a la más productiva si $B \le a_1/a_2 - 1$; si no, se iguala el producto marginal | 4.4 |
| Calificación | Sin ella, el óptimo puede no cumplir Kuhn-Tucker; con restricciones lineales siempre se cumple | 4.5 |
| Sin concavidad | Un punto de Kuhn-Tucker puede ser un mínimo | 5 |

---

## 8. Ejercicios formales

- **F1.** Resuelve el problema de las dos regiones con $a_1 = 3$, $a_2 = 1$ y
  $B = 1$ y $B = 5$. ¿Cuánto vale el umbral $\bar B$? Verifica las
  condiciones de Kuhn-Tucker en cada caso.
- **F2.** Repite el problema con $f_i = a_i\sqrt{x_i}$. Muestra que las dos
  regiones siempre reciben inversión y explica por qué, en términos de
  $f_i'(0)$.
- **F3.** Supón que el planificador valora más el producto de la región 2,
  más pobre: maximiza $f_1(x_1) + \omega f_2(x_2)$ con $\omega > 1$. ¿Cómo
  cambia el umbral $\bar B$? ¿Qué valor de $\omega$ haría que las dos regiones
  reciban lo mismo para un $B$ dado?
- **F4.** Con $a_1 = 2$, $a_2 = 1$, calcula $V(B)$ para $B = 0.5$ y $B = 0.51$
  y compara $\big(V(0.51) - V(0.5)\big)/0.01$ con $\lambda(0.5)$.

**[Avanzado]**

- **F5.** Generaliza a $n$ regiones con $f_i = a_i\ln(1 + x_i)$. Muestra que
  $x_i^\ast = \max\lbrace a_i/\lambda - 1,\ 0\rbrace$, donde $\lambda$ es el
  único valor que agota el fondo. ¿Qué regiones reciben inversión? (Es la
  regla de "llenado de agua".)
- **F6.** Demuestra que $V(B)$ es cóncava en el problema de las dos regiones,
  usando la fórmula de $\lambda(B)$. ¿Es diferenciable en $\bar B$?
- **F7.** Demuestra que en el contraejemplo de la sección 4.5 el óptimo es
  $(1, 0)$ y que ahí no existe $\lambda \ge 0$ que cumpla Kuhn-Tucker. ¿Qué
  pasa si se reemplaza $(1 - x_1)^3$ por $1 - x_1$?

---

## Referencias

- Arrow, K. J., & Enthoven, A. C. (1961). Quasi-concave programming.
  *Econometrica*, 29(4), 779–800. https://doi.org/10.2307/1911819
- Chiang, A. C., & Wainwright, K. (2006). *Métodos fundamentales de economía
  matemática* (4.ª ed.). McGraw-Hill.
- Kuhn, H. W., & Tucker, A. W. (1951). Nonlinear programming. En J. Neyman
  (Ed.), *Proceedings of the Second Berkeley Symposium on Mathematical
  Statistics and Probability* (pp. 481–492). University of California
  Press. https://doi.org/10.1525/9780520411586-036
- Simon, C. P., & Blume, L. (1994). *Mathematics for Economists*. W. W.
  Norton.
