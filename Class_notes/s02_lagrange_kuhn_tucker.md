# Sesión 2: Lagrange, concavidad y Kuhn-Tucker

> **Cómo usar estas notas.** La clase se da en el pizarrón y cubre el núcleo
> de estas notas, no todas. El **plan de clase** de abajo dice qué secciones
> se escriben en el pizarrón, cuándo se proyecta el cuaderno
> (`Code/s02_lagrange_kuhn_tucker.jl`) y qué queda para leer. En el pizarrón
> van las ecuaciones y los resultados en recuadro; el texto que las rodea es
> lo que se explica de palabra. Como todo está aquí, en clase no hace falta
> copiar. El cuerpo de las notas es la **ruta básica** y se evalúa; las
> demostraciones y los temas opcionales están al final, en **Para
> profundizar**, y no se ven en clase.
>
> Las secciones marcadas con ★ son el **núcleo** que se ve en clase; las
> demás se leen por cuenta propia y se evalúan igual.
>
> Repaso recomendado: [C.B2](repaso/calculo.md#cb2) (máximos en una
> variable), [C.B5](repaso/calculo.md#cb5) (gradiente),
> [C.I1](repaso/calculo.md#ci1) (hessiana), [C.I2](repaso/calculo.md#ci2)
> (concavidad y cuasiconcavidad), [C.I5](repaso/calculo.md#ci5) (Lagrange),
> [L.I4](repaso/algebra_lineal.md#li4) (definitud),
> [L.I5](repaso/algebra_lineal.md#li5) (hessiana orlada) y
> [A.I3](repaso/analisis.md#ai3) (teorema de Weierstrass); para Para
> profundizar, [C.I4](repaso/calculo.md#ci4), [C.A1](repaso/calculo.md#ca1) y
> [L.A3](repaso/algebra_lineal.md#la3).
>
> Lecturas: Chiang y Wainwright (2006), caps. 11–13.

**Plan de clase** (120 minutos: 105 de núcleo y 15 de margen). El núcleo:
las condiciones de Kuhn-Tucker y la holgura complementaria, resueltas en el
problema de las dos regiones, con el multiplicador como precio sombra.
Lagrange se ve rápido para dejar a Kuhn-Tucker su tiempo completo.

| Minutos | Dónde | Qué | Secciones |
|---|---|---|---|
| 0–10 | Pizarra | La pregunta y el problema de las dos regiones; por qué importan la concavidad y $f_i'(0)$ | 1 |
| 10–22 | Pizarra | Repaso rápido: condición de primer orden y concavidad da un máximo global (enunciados); el ejemplo de una región; el segundo orden, de palabra | 2.1, 2.3 (2.2, de palabra) |
| 22–45 | Pizarra | Teorema de Lagrange y tangencia; el multiplicador como precio sombra, $V'(c) = \lambda$; las dos regiones con el presupuesto agotado y la falla $x_2 < 0$ | 3.1, 3.2, 3.4 |
| 45–50 | | Pausa | |
| 50–85 | Pizarra | Condiciones de Kuhn-Tucker; la tabla de holgura complementaria, de palabra; el teorema de suficiencia (enunciado); solución por casos y el ejemplo numérico | 4.1–4.4 (sin la cuasiconcavidad) |
| 85–100 | Parejas | Ejercicio F1 a mano | 8 |
| 100–105 | Pizarra | Cierre: el multiplicador será el coestado | 6 |
| 105–120 | Margen | Si alcanza, en este orden: la solución de esquina en el cuaderno (sección 4); rendimientos crecientes, $\varphi'' > 0$ y el punto de Kuhn-Tucker es un mínimo (5; cuaderno, sección 5); tangencia y precio sombra con deslizadores (cuaderno, secciones 2 y 3) | |
| Después | Lectura | Lo que no entró del margen; las condiciones de segundo orden (2.2), la hessiana orlada (3.3), la cuasiconcavidad y el teorema de Arrow y Enthoven (4.3), la calificación de las restricciones (4.5), el resumen (7) y Para profundizar | |

Lo del **margen** se ve sólo si sobra tiempo, en el orden indicado; lo
que no se vea pasa a la lectura y se evalúa igual.

**Pregunta de la unidad.** Un gobierno tiene un fondo $B$ para invertir en dos
regiones. ¿Cómo debe repartirlo? ¿Conviene siempre dar algo a cada región?

---

## 1. El problema de las dos regiones ★

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

### 2.1 Condición de primer orden ★

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

### 2.3 Concavidad: del óptimo local al global ★

**Lema (desigualdad del gradiente).** Si $f$ es cóncava y diferenciable en
un conjunto convexo abierto $U$, entonces para todo $x, y \in U$

$$
f(y) \le f(x) + \nabla f(x)^\top(y - x):
$$

la función queda por debajo de su plano tangente.

*Demostración*: en [Para profundizar, P.1](#pp1).

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

### 3.1 El teorema ★

Considera $\max f(x)$ sujeto a $g_j(x) = c_j$, $j = 1, \dots, m$, con
$m < n$. Sea $Dg(x)$ la matriz $m \times n$ de gradientes de las
restricciones.

**Teorema (Lagrange).** Si $x^\ast$ es un máximo local y $Dg(x^\ast)$ tiene
rango $m$, existen multiplicadores $\lambda_1, \dots, \lambda_m$ tales que

$$
\boxed{\ \nabla f(x^\ast) = \sum_{j=1}^m \lambda_j\nabla g_j(x^\ast)\ }
$$

Equivalentemente, con el **lagrangiano**
$\mathcal L(x, \lambda) = f(x) + \sum_j \lambda_j\big(c_j - g_j(x)\big)$, el
óptimo es un punto crítico de $\mathcal L$: $\nabla_x\mathcal L = 0$ y
$\nabla_\lambda\mathcal L = 0$ (que son las restricciones).

**Geometría ($n = 2$, $m = 1$).** En el óptimo, la curva de nivel de $f$ es
tangente a la restricción: si no lo fuera, moverse a lo largo de la
restricción aumentaría $f$. Tangencia significa gradientes paralelos,
$\nabla f = \lambda\nabla g$.

*Demostración* para $n = 2$, $m = 1$: en [Para profundizar, P.2](#pp2).

La hipótesis de rango no se puede omitir: sin ella, un óptimo puede no
cumplir la condición de Lagrange. Ver [Para profundizar, P.4](#pp4), con el
caso análogo de las desigualdades.

### 3.2 El multiplicador como precio sombra ★

Sea $V(c)$ el valor máximo cuando la restricción es $g(x) = c$. Entonces

$$
\boxed{\ V'(c) = \lambda\ }
$$

es decir, el multiplicador dice cuánto aumenta el óptimo si la restricción
se relaja en una unidad. En el problema de las regiones, $\lambda$ es el
**valor social de un peso adicional del fondo**. La demostración general es el
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

### 3.4 Ejemplo: las dos regiones con el presupuesto agotado ★

Si se exige $x_1 + x_2 = B$ y se ignoran las restricciones $x_i \ge 0$, el
lagrangiano es

$$
\mathcal L = a_1\ln(1 + x_1) + a_2\ln(1 + x_2) + \lambda\thinspace(B - x_1 - x_2),
$$

y las condiciones de Lagrange son

$$
\frac{\partial\mathcal L}{\partial x_i} = \frac{a_i}{1 + x_i} - \lambda = 0 \quad (i = 1, 2),
\qquad
\frac{\partial\mathcal L}{\partial\lambda} = B - x_1 - x_2 = 0.
$$

La primera dice que el último peso debe rendir lo mismo en las dos
regiones: $a_1/(1 + x_1) = a_2/(1 + x_2) = \lambda$. Se despeja cada $x_i$ y
se usa el presupuesto:

$$
\begin{aligned}
1 + x_i &= \frac{a_i}{\lambda} && (i = 1, 2) \cr
(1 + x_1) + (1 + x_2) &= \frac{a_1 + a_2}{\lambda} && \text{(sumando)} \cr
B + 2 &= \frac{a_1 + a_2}{\lambda} && (x_1 + x_2 = B) \cr
\lambda &= \frac{a_1 + a_2}{B + 2}, \cr
x_i &= \frac{a_i}{\lambda} - 1 = \frac{a_i\thinspace(B + 2)}{a_1 + a_2} - 1.
\end{aligned}
$$

**Precio sombra.** Con $1 + x_i = a_i(B + 2)/(a_1 + a_2)$, el valor óptimo
es

$$
\begin{aligned}
V(B) &= a_1\ln(1 + x_1) + a_2\ln(1 + x_2)
= \sum_i a_i\ln\frac{a_i\thinspace(B + 2)}{a_1 + a_2} \cr
&= \sum_i a_i\ln a_i + (a_1 + a_2)\ln(B + 2) - (a_1 + a_2)\ln(a_1 + a_2).
\end{aligned}
$$

Sólo el término del medio depende de $B$, así que

$$
V'(B) = \frac{a_1 + a_2}{B + 2} = \lambda,
$$

como afirma la sección 3.2.

**Segundo orden.** Con $g = x_1 + x_2$, $g_1 = g_2 = 1$; además
$\mathcal L_{12} = 0$ y $\mathcal L_{ii} = -a_i/(1 + x_i)^2 < 0$. Desarrollando
por el primer renglón:

$$
\det\bar H =
\det\begin{pmatrix} 0 & 1 & 1 \cr 1 & \mathcal L_{11} & 0 \cr 1 & 0 & \mathcal L_{22}\end{pmatrix}
= 0 - 1\cdot(\mathcal L_{22} - 0) + 1\cdot(0 - \mathcal L_{11})
= -(\mathcal L_{11} + \mathcal L_{22}) > 0:
$$

es un máximo.

**El problema.** La fórmula de $x_2$ puede ser negativa:

$$
\begin{aligned}
x_2 < 0
&\iff \frac{a_2\thinspace(B + 2)}{a_1 + a_2} < 1
\iff a_2B + 2a_2 < a_1 + a_2 \cr
&\iff a_2B < a_1 - a_2
\iff \boxed{\ B < \bar B = \frac{a_1}{a_2} - 1\ }
\end{aligned}
$$

Con un fondo pequeño y regiones muy distintas, Lagrange recomienda
**desinvertir** en la región 2 para invertir más en la 1, lo que no es
factible. Hacen falta las restricciones de desigualdad.

---

## 4. Restricciones de desigualdad: Kuhn-Tucker

### 4.1 Las condiciones ★

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

### 4.2 Holgura complementaria: la lectura económica ★

Las igualdades $x_i\thinspace\partial\mathcal L/\partial x_i = 0$ y
$\lambda_j(c_j - g_j) = 0$ se llaman de **holgura complementaria**. En cada
par, al menos una de las dos desigualdades se cumple con igualdad:

| Situación | Consecuencia | Lectura en el problema de las regiones |
|---|---|---|
| La restricción no se agota: $g_j < c_j$ | $\lambda_j = 0$ | Si sobrara fondo, un peso más no valdría nada |
| El precio sombra es positivo: $\lambda_j > 0$ | $g_j = c_j$ | Si un peso más vale algo, se gasta todo el fondo |
| Se invierte en $i$: $x_i > 0$ | $\partial\mathcal L/\partial x_i = 0$ | El producto marginal de $i$ iguala el precio sombra del fondo |
| No se invierte en $i$: $x_i = 0$ | $\partial\mathcal L/\partial x_i \le 0$ | El primer peso en $i$ rinde menos que el precio sombra |

En la última fila está la respuesta a la pregunta de la unidad: una región no
recibe nada si su producto marginal en cero no alcanza el valor de un peso
del fondo.

### 4.3 Suficiencia ★

**Teorema.** Si $f$ es cóncava y cada $g_j$ es convexa, todo punto que cumple
las condiciones de Kuhn-Tucker es un máximo global. Si $f$ es estrictamente
cóncava, el máximo es único.

*Demostración*: en [Para profundizar, P.3](#pp3).

Las condiciones son **necesarias** en general (bajo calificación) y
**suficientes** con concavidad. Sin concavidad, un punto de Kuhn-Tucker puede
ser incluso un mínimo; el cuaderno lo muestra con rendimientos crecientes
(sección 5).

*Lectura: de aquí al final de la sección 4.3.*

**Cuasiconcavidad.** En economía, muchas funciones objetivo no son cóncavas
pero sí **cuasicóncavas**: sus conjuntos de nivel superior
$\lbrace x : f(x) \ge c\rbrace$ son convexos para todo $c$
([C.I2](repaso/calculo.md#ci2)). Equivalentemente,
$f\big(\theta x + (1 - \theta)y\big) \ge \min\lbrace f(x), f(y)\rbrace$:
en el segmento entre dos puntos, $f$ nunca queda por debajo del menor de sus
dos valores. Toda cóncava es cuasicóncava, pero no al revés: la Cobb-Douglas
$x_1^ax_2^b$ con $a + b > 1$ (rendimientos crecientes a escala) es
cuasicóncava sin ser cóncava.

Importa por dos razones. Primero, la cuasiconcavidad es **ordinal**: se
conserva con cualquier transformación creciente, y por eso es la propiedad
natural de una función de utilidad, que sólo ordena. Segundo, basta para la
suficiencia con una condición adicional:

**Teorema (Arrow y Enthoven, 1961).** Si $f$ es cuasicóncava, cada $g_j$ es
cuasiconvexa (por ejemplo, lineal), $x^\ast$ cumple las condiciones de
Kuhn-Tucker, $\nabla f(x^\ast) \ne 0$ y $f$ es dos veces diferenciable cerca
de $x^\ast$, entonces $x^\ast$ es un máximo global.

La condición $\nabla f(x^\ast) \ne 0$ no sobra: con $f$ sólo cuasicóncava, un
punto con gradiente cero puede no ser máximo ($f(x) = x^3$ en $x = 0$).

**La relación con la hessiana orlada.** Con una restricción lineal, la
condición de Lagrange hace $\nabla g$ proporcional a $\nabla f$, y la
hessiana del lagrangiano es la de $f$. Entonces la hessiana orlada de la
sección 3.3 es, salvo un factor positivo, la de $f$ orlada con su propio
gradiente. La condición $\det\bar H > 0$ dice entonces que la curva de nivel
de $f$ es estrictamente convexa hacia el origen en el óptimo, como una curva
de indiferencia: es la versión local de la cuasiconcavidad.

En la sección 5, con $\gamma > 1$, $f = a_1x_1^\gamma + a_2x_2^\gamma$ ni
siquiera es cuasicóncava: sus conjuntos de nivel superior son el exterior de
un conjunto convexo. Por eso el punto de Kuhn-Tucker interior es un mínimo.

### 4.4 Solución del problema de las dos regiones ★

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

Se resuelve por casos.

1. **El fondo se agota.** Si $\lambda = 0$, la primera condición pediría
   $a_i/(1 + x_i) \le 0$, imposible porque $a_i > 0$. Entonces $\lambda > 0$,
   y la holgura complementaria da $x_1 + x_2 = B$.
2. **Las dos regiones reciben inversión** ($x_1, x_2 > 0$). Las dos
   condiciones se cumplen con igualdad: es la solución de Lagrange de la
   sección 3.4. Es válida si $x_2 > 0$, es decir, si $B > \bar B$ (y
   entonces también $x_1 > 0$, porque $a_1 \ge a_2$).
3. **Sólo la región 1 recibe** ($x_2 = 0$, $x_1 = B$). Las condiciones de
   cada región:

$$
\begin{aligned}
x_1 = B > 0: &\quad \frac{a_1}{1 + B} - \lambda = 0
\ \Rightarrow\ \lambda = \frac{a_1}{1 + B}, \cr
x_2 = 0: &\quad \frac{a_2}{1 + 0} - \lambda \le 0
\iff a_2 \le \frac{a_1}{1 + B}
\iff 1 + B \le \frac{a_1}{a_2}
\iff B \le \bar B.
\end{aligned}
$$

4. **Sólo la región 2 recibe** ($x_1 = 0$, $x_2 = B$). Igual que en el caso
   3, $\lambda = a_2/(1 + B)$, y $x_1 = 0$ pide
   $a_1 \le \lambda = a_2/(1 + B) < a_2$, imposible con $a_1 \ge a_2$.

Como $f$ es estrictamente cóncava y la restricción es lineal, la solución es
el único máximo global (sección 4.3).

**Proposición.** Con $a_1 \ge a_2$ y $\bar B = a_1/a_2 - 1$:

$$
\boxed{(x_1^\ast, x_2^\ast, \lambda) =
\begin{cases}
\left(B,\ 0,\ \dfrac{a_1}{1 + B}\right) & \text{si } B \le \bar B, \cr
\left(\dfrac{a_1(B + 2)}{a_1 + a_2} - 1,\ \dfrac{a_2(B + 2)}{a_1 + a_2} - 1,\ \dfrac{a_1 + a_2}{B + 2}\right) & \text{si } B > \bar B.
\end{cases}}
$$

**Lectura económica.**
- Con un fondo pequeño, todo va a la región más productiva; a partir de
  $\bar B$, también la menos productiva recibe. El umbral crece con la
  brecha de productividad $a_1/a_2$.
- El precio sombra $\lambda(B)$ es continuo y decreciente. En
  $\bar B = a_1/a_2 - 1$ las dos fórmulas coinciden:
  $a_1/(1 + \bar B) = a_1/(a_1/a_2) = a_2$ y
  $(a_1 + a_2)/(\bar B + 2) = (a_1 + a_2)/\big((a_1 + a_2)/a_2\big) = a_2$.
  Cada peso adicional del fondo vale menos que el anterior, y $V(B)$ es
  cóncava.
- Desde la región 2, la regla es simple: recibe inversión si y sólo si su
  producto marginal en cero, $a_2$, supera el valor de un peso del fondo,
  $\lambda$.

**Ejemplo numérico.** Con $a_1 = 2$ y $a_2 = 1$, $\bar B = 2/1 - 1 = 1$.

- Con $B = 0.5 \le \bar B$: esquina, $x^\ast = (0.5, 0)$ y
  $\lambda = 2/1.5 \approx 1.33$. La región 2 no recibe porque su primer peso
  rinde $a_2 = 1 < 1.33$.
- Con $B = 4 > \bar B$: $\lambda = (2 + 1)/(4 + 2) = 0.5$,
  $x_1 = 2 \cdot 6/3 - 1 = 3$ y $x_2 = 1 \cdot 6/3 - 1 = 1$:
  $x^\ast = (3, 1)$.

### 4.5 Calificación de las restricciones

El teorema de Kuhn-Tucker pide una **calificación de las restricciones**:
una condición sobre la forma del conjunto factible en el óptimo. Si todas
las restricciones son lineales, como en el problema de las regiones, se
cumple siempre. Qué es, y un ejemplo en el que falla: en [Para
profundizar, P.4](#pp4).

---

## 5. Cuándo la concavidad no se cumple

Supón rendimientos crecientes, $f_i(x_i) = a_ix_i^\gamma$ con $\gamma > 1$:
por ejemplo, economías de aglomeración. A lo largo del presupuesto agotado,
$x_2 = B - x_1$, el producto total es

$$
\begin{aligned}
\varphi(x_1) &= a_1x_1^\gamma + a_2(B - x_1)^\gamma, \cr
\varphi'(x_1) &= \gamma\big(a_1x_1^{\gamma - 1} - a_2(B - x_1)^{\gamma - 1}\big), \cr
\varphi''(x_1) &= \gamma(\gamma - 1)\big(a_1x_1^{\gamma - 2} + a_2(B - x_1)^{\gamma - 2}\big) > 0.
\end{aligned}
$$

$\varphi$ es convexa, así que su máximo está en un extremo:
$\varphi(B) = a_1B^\gamma$ o $\varphi(0) = a_2B^\gamma$. **Todo el fondo va a
una sola región**, la de mayor $a_i$.

El punto interior donde $\varphi' = 0$, es decir,
$a_1x_1^{\gamma - 1} = a_2x_2^{\gamma - 1}$, cumple las condiciones de
Kuhn-Tucker, pero como $\varphi'' > 0$ es el **mínimo** de $\varphi$. Las
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
| Calificación | Sin ella, el óptimo puede no cumplir Kuhn-Tucker; con restricciones lineales siempre se cumple | 4.5, P.4 |
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

**Para profundizar** (opcionales)

- **F5.** Generaliza a $n$ regiones con $f_i = a_i\ln(1 + x_i)$. Muestra que
  $x_i^\ast = \max\lbrace a_i/\lambda - 1,\ 0\rbrace$, donde $\lambda$ es el
  único valor que agota el fondo. ¿Qué regiones reciben inversión? (Es la
  regla de "llenado de agua".)
- **F6.** Demuestra que $V(B)$ es cóncava en el problema de las dos regiones,
  usando la fórmula de $\lambda(B)$. ¿Es diferenciable en $\bar B$?
- **F7.** Demuestra que en el contraejemplo de [P.4](#pp4) el óptimo es
  $(1, 0)$ y que ahí no existe $\lambda \ge 0$ que cumpla Kuhn-Tucker. ¿Qué
  pasa si se reemplaza $(1 - x_1)^3$ por $1 - x_1$?

## Para profundizar

Material opcional: demostraciones y temas que no se ven en clase. Cada
apartado indica de qué sección de las notas viene.

<a id="pp1"></a>

### P.1 La desigualdad del gradiente (sección 2.3)

*Demostración.* Por concavidad, para $\theta \in (0, 1]$,
$f\big(x + \theta(y - x)\big) \ge f(x) + \theta\big(f(y) - f(x)\big)$.
Restando $f(x)$, dividiendo entre $\theta$ y haciendo $\theta \to 0$, el
lado izquierdo tiende a $\nabla f(x)^\top(y - x)$. $\square$

<a id="pp2"></a>

### P.2 El teorema de Lagrange con dos variables (sección 3.1)

*Demostración.* Con $n = 2$ y $m = 1$, la condición de rango dice que
$\nabla g(x^\ast) \ne 0$; supón $g_2 \ne 0$. Por el teorema de la función implícita
([C.I4](repaso/calculo.md#ci4)), cerca de $x^\ast$ la restricción define
$x_2 = h(x_1)$ con $h' = -g_1/g_2$. La función de una variable
$F(x_1) = f\big(x_1, h(x_1)\big)$ tiene un máximo local en $x_1^\ast$, así que
$F' = f_1 + f_2h' = f_1 - f_2\thinspace g_1/g_2 = 0$. Con
$\lambda = f_2/g_2$ quedan $f_2 = \lambda g_2$ y $f_1 = \lambda g_1$. $\square$

<a id="pp3"></a>

### P.3 Suficiencia de las condiciones de Kuhn-Tucker (sección 4.3)

*Demostración.* Para $\lambda \ge 0$ fijo, la función
$x \mapsto \mathcal L(x, \lambda)$ es cóncava (suma de cóncavas). Sea $x$
factible. Por la desigualdad del gradiente (sección 2.3, [P.1](#pp1)),

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

<a id="pp4"></a>

### P.4 Calificación de las restricciones (secciones 3.1 y 4.5)

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
