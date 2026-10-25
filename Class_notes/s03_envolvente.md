# Sesión 3: Envolvente y estática comparativa

> **Cómo usar estas notas.** La clase se da en el pizarrón y sigue estas
> notas en su orden. El **plan de clase** de abajo dice qué secciones se
> escriben en el pizarrón, cuándo se proyecta el cuaderno
> (`Code/s03_envolvente.jl`) y qué queda para leer. En el pizarrón van las
> ecuaciones y los resultados en recuadro; el texto que las rodea es lo que
> se explica de palabra. Como todo está aquí, en clase no hace falta copiar.
> El cuerpo de las notas es la **ruta básica** y se evalúa; las
> demostraciones y los temas opcionales están al final, en **Para
> profundizar**, y no se ven en clase.
>
> Repaso recomendado: [C.B1](repaso/calculo.md#cb1) (derivadas),
> [C.B5](repaso/calculo.md#cb5) (derivadas parciales),
> [L.B2–B4](repaso/algebra_lineal.md#lb2) (sistemas lineales, determinantes
> y regla de Cramer), [C.I3](repaso/calculo.md#ci3) (diferencial total),
> [C.I4](repaso/calculo.md#ci4) (función implícita),
> [C.I5](repaso/calculo.md#ci5) (Lagrange) y
> [L.I6](repaso/algebra_lineal.md#li6) (jacobiano); para Para profundizar y
> los ejercicios opcionales, [C.A2](repaso/calculo.md#ca2) y
> [C.I6](repaso/calculo.md#ci6).
>
> Lecturas: Chiang y Wainwright (2006), caps. 8 y 13.

**Plan de clase** (120 minutos)

| Minutos | Dónde | Qué | Secciones |
|---|---|---|---|
| 0–5 | Proyector | La pregunta: cómo cambia el reparto cuando mejora la región 2 | Cuaderno, sección 0 |
| 5–12 | Pizarra | Variables y parámetros; la solución y la función de valor; la solución de la sesión 2 | 1 |
| 12–30 | Pizarra | Diferencial total; teorema de la función implícita; estática comparativa de un óptimo y el ejemplo de una región | 2.1–2.3 |
| 30–35 | Proyector | El cruce del producto marginal con el precio; función implícita contra diferencia finita | Cuaderno, sección 1 |
| 35–58 | Pizarra | Sistemas y el método de cuatro pasos; las dos regiones: el sistema, su determinante, y un aumento del fondo y de la productividad por la regla de Cramer | 2.4, 3.1–3.3 |
| 58–63 | Proyector | Cramer contra diferencia finita; el pico de $x^\ast(B)$ en $\bar B$ | Cuaderno, sección 2; notas, 3.4 |
| 63–68 | | Pausa | |
| 68–88 | Pizarra | Envolvente sin restricciones (efecto directo e indirecto) y su ejemplo; con restricciones; $V'(c) = \lambda$ | 4.1, 4.3 |
| 88–95 | Proyector | Por qué se llama envolvente; la envolvente del reparto | Cuaderno, sección 3; notas, 4.2 |
| 95–105 | Pizarra | La envolvente en el problema de las regiones; comparar políticas | 4.4, 4.5 |
| 105–118 | Parejas | Ejercicio F4 a mano | 7 |
| 118–120 | Pizarra | Cierre: el Laboratorio 0 | — |
| Después | Lectura | El cambio de régimen en detalle (3.4), por qué se llama envolvente (4.2), las verificaciones con la fórmula cerrada, el resumen (6) y Para profundizar, con la demostración del teorema de la envolvente (P.1) | |

El cuaderno se proyecta en clase; cada estudiante lo abre después del
Laboratorio 0 (sesión 4), cuando ya tiene Julia instalado.

**Pregunta de la unidad.** Un gobierno tiene un fondo $B$ para invertir en dos
regiones. ¿Cómo debe repartirlo?

**Pregunta de la sesión.** La sesión 2 encontró el mejor reparto para
valores dados de $a_1$, $a_2$ y $B$. Ahora los parámetros cambian: si la
región 2 se vuelve más productiva, ¿cuánto más recibe? ¿Qué vale más para el
planificador, un peso adicional en el fondo o un programa que eleve la
productividad de la región 2?

---

## 1. Del óptimo a las funciones del óptimo

Un problema de optimización depende de **variables**, que se eligen, y de
**parámetros**, que están dados. En el problema de las dos regiones,

$$
\max_{x_1, x_2}\ a_1\ln(1 + x_1) + a_2\ln(1 + x_2)
\qquad\text{sujeto a}\qquad x_1 + x_2 \le B,\quad x_1, x_2 \ge 0,
$$

las variables son $x_1, x_2$ y los parámetros, $\alpha = (a_1, a_2, B)$. Al
resolverlo para cada $\alpha$ se obtienen dos objetos:

- la **solución** $x^\ast(\alpha)$ y el multiplicador $\lambda(\alpha)$: qué
  se hace;
- la **función de valor** $V(\alpha) = f\big(x^\ast(\alpha), \alpha\big)$:
  cuánto se logra.

La sesión responde dos preguntas sobre ellos:

| Pregunta | Herramienta | Sección |
|---|---|---|
| ¿Cómo cambia la decisión, $\partial x^\ast/\partial\alpha$? | Estática comparativa: función implícita y regla de Cramer | 2 y 3 |
| ¿Cómo cambia el valor, $\partial V/\partial\alpha$? | Teorema de la envolvente | 4 |

Recuerda la solución de la sesión 2. Con $a_1 \ge a_2$ y
$\bar B = a_1/a_2 - 1$: si $B \le \bar B$, todo el fondo va a la región 1,
$x^\ast = (B, 0)$ y $\lambda = a_1/(1 + B)$; si $B > \bar B$, las dos
regiones reciben y

$$
\lambda = \frac{a_1 + a_2}{B + 2},
\qquad
x_i^\ast = \frac{a_i(B + 2)}{a_1 + a_2} - 1.
$$

Aquí hay fórmula cerrada y las derivadas se pueden calcular directamente.
Casi nunca es así: con otras funciones de producción, o con más regiones,
las condiciones de primer orden no se pueden despejar. Las herramientas de
esta sesión dan las derivadas **sin resolver el problema**, sólo a partir de
las condiciones de primer orden.

---

## 2. Diferencial total y función implícita

### 2.1 Diferencial total

Si $z = F(x, \alpha)$, su **diferencial total**
([C.I3](repaso/calculo.md#ci3)) es

$$
dz = F_x\thinspace dx + F_\alpha\thinspace d\alpha:
$$

el cambio de $z$ cuando $x$ y $\alpha$ cambian poco al mismo tiempo. Con
varias variables, se suma un término por cada una.

### 2.2 El teorema de la función implícita

Considera una ecuación $F(x, \alpha) = 0$ que define $x$ en función de
$\alpha$, aunque no se pueda despejar.

**Teorema (función implícita, una ecuación).** Si $F$ tiene derivadas
parciales continuas, $F(x_0, \alpha_0) = 0$ y $F_x(x_0, \alpha_0) \ne 0$,
entonces cerca de $(x_0, \alpha_0)$ existe una única función diferenciable
$x(\alpha)$ con $F\big(x(\alpha), \alpha\big) = 0$, y

$$
\boxed{\ \frac{dx}{d\alpha} = -\frac{F_\alpha}{F_x}\ }
$$

La fórmula sale del diferencial total: a lo largo de la solución, $F$ no
cambia, así que $0 = F_x\thinspace dx + F_\alpha\thinspace d\alpha$
([C.I4](repaso/calculo.md#ci4)). Lo que el teorema agrega es que $x(\alpha)$
**existe** y es diferenciable, y para eso hace falta $F_x \ne 0$.

### 2.3 Estática comparativa de un óptimo

En $\max_x f(x, \alpha)$ con óptimo interior, la condición de primer orden
$f_x(x, \alpha) = 0$ es una ecuación $F(x, \alpha) = 0$ con $F = f_x$.
Entonces

$$
\frac{dx^\ast}{d\alpha} = -\frac{f_{x\alpha}}{f_{xx}}.
$$

Si en el máximo $f_{xx} < 0$ (la condición suficiente de segundo orden de la
sesión 2), entonces

$$
\operatorname{signo}\frac{dx^\ast}{d\alpha} = \operatorname{signo} f_{x\alpha}.
$$

**El óptimo se mueve hacia donde el parámetro aumenta el rendimiento
marginal.** Para el signo basta saber cómo afecta $\alpha$ al beneficio
marginal; no hace falta conocer $x^\ast$.

**Ejemplo.** Una sola región con precio $p > 0$ por peso invertido:
$\max_x a\ln(1 + x) - px$, con $a > p$. La condición de primer orden es
$F = a/(1 + x) - p = 0$, con $F_x = -a/(1 + x)^2$. Entonces

$$
\frac{dx^\ast}{da} = -\frac{1/(1 + x)}{-a/(1 + x)^2} = \frac{1 + x^\ast}{a} > 0,
\qquad
\frac{dx^\ast}{dp} = -\frac{-1}{-a/(1 + x)^2} = -\frac{(1 + x^\ast)^2}{a} < 0.
$$

Con la fórmula cerrada $x^\ast = a/p - 1$ se obtiene lo mismo:
$dx^\ast/da = 1/p = (1 + x^\ast)/a$ y
$dx^\ast/dp = -a/p^2 = -(1 + x^\ast)^2/a$.

### 2.4 Sistemas de ecuaciones

Con $n$ variables y $n$ condiciones de primer orden,
$F(z, \alpha) = 0$ con $F, z \in \mathbb{R}^n$, el diferencial total de
cada ecuación da un **sistema lineal** en las derivadas:

$$
D_zF\thinspace\frac{\partial z}{\partial\alpha} = -\frac{\partial F}{\partial\alpha}.
$$

$D_zF$ es el jacobiano de las condiciones de primer orden
([L.I6](repaso/algebra_lineal.md#li6)). Si $\det D_zF \ne 0$, el teorema de
la función implícita garantiza que $z(\alpha)$ existe y es diferenciable, y
el sistema tiene solución única. Con dos o tres incógnitas, la **regla de
Cramer** ([L.B4](repaso/algebra_lineal.md#lb4)) da cada derivada como un
cociente de determinantes:

$$
\boxed{\ \frac{\partial z_i}{\partial\alpha} = \frac{\det J_i}{\det D_zF}\ }
$$

donde $J_i$ es $D_zF$ con la columna $i$ reemplazada por
$-\partial F/\partial\alpha$. Es útil porque el signo de $\det D_zF$ suele
conocerse por la condición de segundo orden, y entonces el signo de la
derivada es el del numerador.

**Método en cuatro pasos.**
1. Escribir las condiciones de primer orden como $F(z, \alpha) = 0$, con
   todas las incógnitas en $z$ (también los multiplicadores).
2. Tomar el diferencial total de cada ecuación respecto de $z$ y del
   parámetro que interesa.
3. Escribir el sistema lineal en forma matricial y verificar que el
   determinante no es cero.
4. Resolver con la regla de Cramer y leer los signos.

---

## 3. Estática comparativa del reparto entre regiones

### 3.1 El sistema

En el régimen interior ($B > \bar B$), las condiciones de primer orden son
tres ecuaciones en $z = (x_1, x_2, \lambda)$:

$$
\frac{a_1}{1 + x_1} - \lambda = 0,
\qquad
\frac{a_2}{1 + x_2} - \lambda = 0,
\qquad
B - x_1 - x_2 = 0.
$$

Sea $h_i = a_i/(1 + x_i)^2 > 0$, la curvatura del producto de la región $i$:
cuánto cae su producto marginal con cada peso adicional. El diferencial
total de cada ecuación, con $x_1, x_2, \lambda$ y los parámetros moviéndose a
la vez:

$$
\begin{aligned}
d\Big(\frac{a_1}{1 + x_1} - \lambda\Big) &= \frac{da_1}{1 + x_1} - h_1\thinspace dx_1 - d\lambda = 0, \cr
d\Big(\frac{a_2}{1 + x_2} - \lambda\Big) &= \frac{da_2}{1 + x_2} - h_2\thinspace dx_2 - d\lambda = 0, \cr
d\big(B - x_1 - x_2\big) &= dB - dx_1 - dx_2 = 0.
\end{aligned}
$$

Pasando los términos de los parámetros a la derecha, en forma matricial:

$$
\begin{pmatrix} -h_1 & 0 & -1 \cr 0 & -h_2 & -1 \cr -1 & -1 & 0 \end{pmatrix}
\begin{pmatrix} dx_1 \cr dx_2 \cr d\lambda \end{pmatrix}
= -\begin{pmatrix} da_1/(1 + x_1) \cr da_2/(1 + x_2) \cr dB \end{pmatrix}.
$$

Desarrollando el determinante por el primer renglón:

$$
\Delta = -h_1\big((-h_2)\cdot 0 - (-1)(-1)\big) - 0 + (-1)\big(0\cdot(-1) - (-h_2)(-1)\big)
= h_1 + h_2 > 0.
$$

Salvo el orden y el signo de la orla, la matriz es la hessiana orlada de la
sesión 2, y su determinante es positivo por la condición de segundo orden. El teorema de la función
implícita se aplica en todo el régimen interior.

### 3.2 Un aumento del fondo

Con $dB = 1$ y $da_1 = da_2 = 0$, el lado derecho es $(0, 0, -1)$. Por la
regla de Cramer, se reemplaza cada columna por ese vector:

$$
\begin{aligned}
\frac{\partial x_1^\ast}{\partial B} &= \frac{1}{\Delta}
\begin{vmatrix} 0 & 0 & -1 \cr 0 & -h_2 & -1 \cr -1 & -1 & 0 \end{vmatrix}
= \frac{(-1)\big(0\cdot(-1) - (-h_2)(-1)\big)}{\Delta}
= \frac{h_2}{h_1 + h_2}, \cr
\frac{\partial x_2^\ast}{\partial B} &= \frac{1}{\Delta}
\begin{vmatrix} -h_1 & 0 & -1 \cr 0 & 0 & -1 \cr -1 & -1 & 0 \end{vmatrix}
= \frac{-h_1\big(0 - (-1)(-1)\big)}{\Delta}
= \frac{h_1}{h_1 + h_2}, \cr
\frac{\partial\lambda}{\partial B} &= \frac{1}{\Delta}
\begin{vmatrix} -h_1 & 0 & 0 \cr 0 & -h_2 & 0 \cr -1 & -1 & -1 \end{vmatrix}
= \frac{-h_1\big((-h_2)(-1) - 0\big)}{\Delta}
= -\frac{h_1h_2}{h_1 + h_2} < 0.
\end{aligned}
$$

(Cada determinante se desarrolló por el primer renglón.)

**Lectura.** El peso adicional se reparte entre las dos regiones, y recibe
una parte mayor la región cuyo producto marginal cae **más despacio** (la
de menor $h_i$). El precio sombra baja: cada peso adicional del fondo vale
menos que el anterior.

**Verificación.** En el óptimo, $1 + x_i = a_i/\lambda$, así que
$h_i = \lambda^2/a_i$ y $h_2/(h_1 + h_2) = a_1/(a_1 + a_2)$, que es la
derivada de $x_1^\ast = a_1(B + 2)/(a_1 + a_2) - 1$ respecto de $B$.

### 3.3 Un aumento de la productividad

Con $da_2 = 1$, el lado derecho es $(0, -q, 0)$, con $q = 1/(1 + x_2)$:

$$
\begin{aligned}
\frac{\partial x_1^\ast}{\partial a_2} &= \frac{1}{\Delta}
\begin{vmatrix} 0 & 0 & -1 \cr -q & -h_2 & -1 \cr 0 & -1 & 0 \end{vmatrix}
= \frac{(-1)\big((-q)(-1) - 0\big)}{\Delta}
= -\frac{q}{\Delta} < 0, \cr
\frac{\partial x_2^\ast}{\partial a_2} &= \frac{1}{\Delta}
\begin{vmatrix} -h_1 & 0 & -1 \cr 0 & -q & -1 \cr -1 & 0 & 0 \end{vmatrix}
= \frac{-h_1\cdot 0 - 0 + (-1)\big(0 - (-q)(-1)\big)}{\Delta}
= \frac{q}{\Delta} > 0, \cr
\frac{\partial\lambda}{\partial a_2} &= \frac{1}{\Delta}
\begin{vmatrix} -h_1 & 0 & 0 \cr 0 & -h_2 & -q \cr -1 & -1 & 0 \end{vmatrix}
= \frac{-h_1\big(0 - (-q)(-1)\big)}{\Delta}
= \frac{h_1\thinspace q}{\Delta} > 0.
\end{aligned}
$$

**Lectura.**
- La región que se vuelve más productiva recibe más, y la otra recibe
  exactamente lo mismo de menos: el fondo está fijo, así que todo cambio es
  una **reasignación**.
- El precio sombra sube: con una región más productiva, un peso del fondo
  vale más.
- Con $a_1$ el resultado es simétrico (ejercicio F2).

### 3.4 Cuando cambia el régimen

En el régimen de esquina ($B < \bar B$), las condiciones activas son otras:
$x_2 = 0$, $x_1 = B$ y $\lambda = a_1/(1 + B)$. Entonces

$$
\frac{\partial x_1^\ast}{\partial B} = 1,
\qquad
\frac{\partial x_2^\ast}{\partial a_2} = 0,
\qquad
\frac{\partial\lambda}{\partial B} = -\frac{a_1}{(1 + B)^2}.
$$

Una pequeña mejora en la región 2 no cambia nada mientras $a_2$ siga por
debajo de $\lambda$: la región sigue sin recibir.

En $B = \bar B$ cambia el conjunto de restricciones activas, y con él las
ecuaciones del sistema. Ahí $x^\ast(B)$ es continua pero tiene un **pico**:
$\partial x_1^\ast/\partial B$ salta de 1 a $a_1/(a_1 + a_2)$. El teorema de la
función implícita vale **dentro** de cada régimen, no en la frontera entre
ellos. En la práctica, primero se identifica el régimen y después se
diferencian sus condiciones.

---

## 4. El teorema de la envolvente

### 4.1 Sin restricciones

Sea $V(\alpha) = \max_x f(x, \alpha)$, con maximizador interior y
diferenciable $x^\ast(\alpha)$. Como $V(\alpha) = f\big(x^\ast(\alpha), \alpha\big)$,
un cambio en $\alpha$ tiene dos efectos sobre $V$:

$$
V'(\alpha) =
\underbrace{f_x\big(x^\ast, \alpha\big)\thinspace\frac{dx^\ast}{d\alpha}}_{\text{efecto indirecto}}
+ \underbrace{f_\alpha\big(x^\ast, \alpha\big)}_{\text{efecto directo}}.
$$

En el óptimo, $f_x = 0$: el efecto indirecto desaparece.

**Teorema (envolvente, sin restricciones).**

$$
V'(\alpha) = \frac{\partial f}{\partial\alpha}\bigg|_{x = x^\ast(\alpha)}.
$$

Para saber cuánto cambia el valor, se deriva el objetivo **como si la
decisión no cambiara**. Reajustar la decisión no vale nada al margen,
porque ya era óptima: un pequeño error en $x$ cerca del óptimo cuesta muy
poco, del orden del cuadrado del error.

**Ejemplo.** En $V(p) = \max_x a\ln(1 + x) - px$,

$$
V'(p) = \frac{\partial}{\partial p}\big(a\ln(1 + x) - px\big)\bigg|_{x^\ast} = -x^\ast(p).
$$

Si el precio sube un peso, el planificador pierde un peso por cada unidad
que invierte; el reajuste de la inversión no agrega nada al primer orden.
Con la fórmula cerrada, $V(p) = a\ln(a/p) - a + p$ y
$V'(p) = -a/p + 1 = -x^\ast$.

### 4.2 Por qué se llama envolvente

Para cada decisión fija $\bar x$, la función $\alpha \mapsto f(\bar x, \alpha)$
es una curva. Como $V(\alpha) \ge f(\bar x, \alpha)$ para todo $\alpha$, con
igualdad cuando $\bar x = x^\ast(\alpha)$, la función de valor es la
**envolvente superior** de esa familia de curvas: cada curva queda debajo
de $V$ y la toca en el parámetro para el que $\bar x$ es óptima. Ahí son
tangentes, y por eso tienen la misma pendiente: es el teorema.

En el ejemplo, cada curva $p \mapsto a\ln(1 + \bar x) - p\bar x$ es una
**recta** de pendiente $-\bar x$. La envolvente superior de rectas es
convexa, así que $V(p)$ es convexa. El cuaderno lo dibuja. La relación
entre la convexidad de $V$ y la estática comparativa está en [Para
profundizar, P.2](#pp2).

### 4.3 Con restricciones

**Teorema (envolvente, con restricciones).** Sea
$V(\alpha) = \max_x f(x, \alpha)$ sujeto a $g_j(x, \alpha) = c_j$,
$j = 1, \dots, m$, con lagrangiano
$\mathcal L = f(x, \alpha) + \sum_j\lambda_j\big(c_j - g_j(x, \alpha)\big)$.
Si la solución $\big(x^\ast(\alpha), \lambda(\alpha)\big)$ es diferenciable,

$$
\boxed{\ V'(\alpha) = \frac{\partial\mathcal L}{\partial\alpha}\bigg|_{x^\ast(\alpha),\ \lambda(\alpha)}\ }
$$

Se deriva el **lagrangiano** respecto del parámetro, sin derivar $x^\ast$ ni
$\lambda$. Vale también con restricciones de desigualdad, mientras no
cambie el conjunto de restricciones activas.

*Demostración*: en [Para profundizar, P.1](#pp1).

**Caso particular: el precio sombra.** Si el parámetro es el lado derecho de
la restricción, $\alpha = c_j$, entonces $\partial\mathcal L/\partial c_j = \lambda_j$
y

$$
\boxed{\ V'(c_j) = \lambda_j\ }
$$

Es el resultado que la sesión 2 dejó pendiente: el multiplicador es el
valor de relajar la restricción en una unidad.

### 4.4 La envolvente en el problema de las regiones

El lagrangiano es
$\mathcal L = a_1\ln(1 + x_1) + a_2\ln(1 + x_2) + \lambda(B - x_1 - x_2)$.
Sin resolver nada más:

$$
\frac{\partial V}{\partial B} = \lambda,
\qquad
\frac{\partial V}{\partial a_1} = \ln(1 + x_1^\ast),
\qquad
\frac{\partial V}{\partial a_2} = \ln(1 + x_2^\ast).
$$

**Verificación.** En el régimen interior,
$V = \sum_i a_i\ln\big(a_i(B + 2)/(a_1 + a_2)\big)$. Derivando respecto de
$a_1$:

$$
\frac{\partial V}{\partial a_1} = \ln(1 + x_1^\ast) + a_1\left(\frac{1}{a_1} - \frac{1}{a_1 + a_2}\right) - \frac{a_2}{a_1 + a_2}
= \ln(1 + x_1^\ast).
$$

Los dos últimos términos son el efecto indirecto, y se cancelan.

**Lectura económica.**
- Elevar en una unidad la productividad de la región $i$ vale lo que esa
  región produce por unidad de productividad, $\ln(1 + x_i^\ast)$. El
  reajuste del reparto no agrega nada al primer orden.
- **Si la región 2 no recibe inversión, $\partial V/\partial a_2 = 0$.** Una
  pequeña mejora de productividad en una región que no recibe fondos no
  vale nada al margen: hay que mejorarla lo suficiente para que cruce el
  umbral, o darle fondos.
- $\lambda(B)$ es continuo en $\bar B$ (sesión 2), así que $V(B)$ es
  diferenciable en todas partes, aunque $x^\ast(B)$ tenga un pico en
  $\bar B$ (sección 3.4). La función de valor es más regular que la
  solución.

### 4.5 Comparar políticas

El teorema da un tipo de cambio entre instrumentos. Con $a_1 = 2$, $a_2 = 1$
y $B = 4$, el reparto es $x^\ast = (3, 1)$ y $\lambda = 0.5$. Entonces

$$
\frac{\partial V}{\partial B} = 0.5,
\qquad
\frac{\partial V}{\partial a_2} = \ln 2 \approx 0.69.
$$

Un programa que eleve $a_2$ en $0.1$ aumenta el producto en
$0.1 \times 0.69 \approx 0.069$, lo mismo que agregar
$0.069/0.5 \approx 0.14$ pesos al fondo. Si el programa cuesta menos de
$0.14$ pesos del fondo, conviene más que repartir esos pesos. Con $B = 0.5$,
la región 2 no recibe y el mismo programa no vale nada al margen.

---

## 5. Hacia la optimización dinámica

Las dos herramientas de esta sesión se usan en todo el curso:

| Idea estática | Versión dinámica |
|---|---|
| $V'(B) = \lambda$: el multiplicador es la derivada de la función de valor | El coestado $\lambda(t)$ es el valor marginal del capital en $t$, $\partial V/\partial k$ (sesiones 11 y 18) |
| Envolvente aplicada a $V(\alpha) = \max_x f(x, \alpha)$ | Envolvente aplicada a la ecuación de Bellman: fórmula de Benveniste-Scheinkman (sesión 16) |
| Función implícita en las condiciones de primer orden | Cómo cambia el estado estacionario de Ramsey cuando cambian $\rho$ o $\delta$ (sesión 12; ejercicio F3) |
| La solución cambia de régimen en $\bar B$ | El control bang-bang cambia de región en un tiempo de cambio (sesión 14) |

---

## 6. Resumen formal

| Concepto | Enunciado | Dónde |
|---|---|---|
| Función de valor | $V(\alpha) = f\big(x^\ast(\alpha), \alpha\big)$ | 1 |
| Función implícita | $F(x, \alpha) = 0$ y $F_x \ne 0 \Rightarrow dx/d\alpha = -F_\alpha/F_x$ | 2.2 |
| Signo de la estática comparativa | En un máximo, $\operatorname{signo} dx^\ast/d\alpha = \operatorname{signo} f_{x\alpha}$ | 2.3 |
| Sistemas | $D_zF\thinspace\partial z/\partial\alpha = -\partial F/\partial\alpha$; regla de Cramer | 2.4 |
| Dos regiones | $\partial x_2^\ast/\partial a_2 > 0$, $\partial x_1^\ast/\partial a_2 < 0$, $\partial\lambda/\partial B < 0$ | 3.2, 3.3 |
| Cambio de régimen | La función implícita vale dentro de cada régimen; $x^\ast$ tiene un pico en $\bar B$ | 3.4 |
| Envolvente | $V'(\alpha) = \partial\mathcal L/\partial\alpha$ en el óptimo | 4.1, 4.3 |
| Precio sombra | $V'(c) = \lambda$ | 4.3 |
| Valor de la productividad | $\partial V/\partial a_i = \ln(1 + x_i^\ast)$; cero si la región no recibe | 4.4 |

---

## 7. Ejercicios formales

- **F1.** En $\max_x a\ln(1 + x) - px$ con $a > p$, calcula con el teorema de
  la función implícita $dx^\ast/da$ y $dx^\ast/dp$ en $a = 3$, $p = 1$, y
  compáralos con la fórmula cerrada. Calcula $V'(a)$ con el teorema de la
  envolvente.
- **F2.** En el régimen interior de las dos regiones, calcula por la regla de
  Cramer $\partial x_1^\ast/\partial a_1$, $\partial x_2^\ast/\partial a_1$ y
  $\partial\lambda/\partial a_1$. Evalúa en $a_1 = 2$, $a_2 = 1$, $B = 4$ y
  verifica con la fórmula cerrada.
- **F3.** En el modelo de Ramsey (sesión 12), el capital de estado
  estacionario cumple $f'(k^\ast) = \rho + \delta$, con $f(k) = k^\alpha$ y
  $0 < \alpha < 1$. Sin despejar $k^\ast$, calcula $dk^\ast/d\rho$ y su
  signo. ¿Qué dice sobre una región más impaciente?
- **F4.** Con $a_1 = 2$ y $a_2 = 1$, ¿cuánto estaría dispuesto a pagar el
  planificador, en pesos del fondo, por un programa que eleve $a_2$ en
  $0.1$, si $B = 4$? ¿Y si $B = 0.5$? ¿Y si $B = 1.5$?

**Para profundizar** (opcionales)

- **F5.** Supón que el planificador valora con peso $\omega > 0$ el producto
  de la región 2: maximiza $a_1\ln(1 + x_1) + \omega a_2\ln(1 + x_2)$. Usa la
  envolvente para calcular $\partial V/\partial\omega$ y la función implícita
  para el signo de $\partial x_2^\ast/\partial\omega$.
- **F6.** Calcula las derivadas laterales de $x_1^\ast(B)$ y de $V(B)$ en
  $\bar B$. Muestra que $V$ es diferenciable ahí y $x_1^\ast$ no.
- **F7.** Un consumo constante $c$ durante $[0, T]$ da el valor presente
  $W(\rho, T) = \int_0^T e^{-\rho t}u(c)\thinspace dt$. Con la regla de Leibniz
  ([C.I6](repaso/calculo.md#ci6)), calcula $\partial W/\partial\rho$ y
  $\partial W/\partial T$, y compáralos con los de la fórmula cerrada.
- **F8.** Con [P.2](#pp2), demuestra que en $\max_x a\ln(1 + x) - px$ la
  inversión óptima decrece con $p$ sin calcular $x^\ast$.

## Para profundizar

Material opcional: demostraciones y temas que no se ven en clase. Cada
apartado indica de qué sección de las notas viene.

<a id="pp1"></a>

### P.1 Demostración del teorema de la envolvente (sección 4.3)

Con una restricción, $V(\alpha) = f\big(x^\ast(\alpha), \alpha\big)$ y
$g\big(x^\ast(\alpha), \alpha\big) = c$ para todo $\alpha$. Por la regla de la
cadena ([C.I3](repaso/calculo.md#ci3)),

$$
V'(\alpha) = \sum_i f_i\thinspace\frac{dx_i^\ast}{d\alpha} + f_\alpha.
$$

Las condiciones de Lagrange dicen que $f_i = \lambda g_i$ en el óptimo, así
que

$$
V'(\alpha) = \lambda\sum_i g_i\thinspace\frac{dx_i^\ast}{d\alpha} + f_\alpha.
$$

Al derivar la identidad $g\big(x^\ast(\alpha), \alpha\big) = c$ respecto de
$\alpha$, $\sum_i g_i\thinspace dx_i^\ast/d\alpha = -g_\alpha$. Entonces

$$
V'(\alpha) = f_\alpha - \lambda g_\alpha = \frac{\partial\mathcal L}{\partial\alpha}. \qquad\square
$$

Si el parámetro es $c$, el mismo razonamiento con $g(x^\ast(c)) = c$ da
$\sum_i g_i\thinspace dx_i^\ast/dc = 1$ y $V'(c) = \lambda$. Con varias
restricciones, se repite con cada una.

**Con desigualdades.** Las restricciones inactivas tienen $\lambda_j = 0$ y
no aportan nada; las activas se comportan como igualdades. Mientras el
conjunto de restricciones activas no cambie, la demostración vale sin
cambios. Milgrom y Segal (2002) generalizan el teorema a conjuntos de
elección arbitrarios, sin suponer que $x^\ast$ es diferenciable.

<a id="pp2"></a>

### P.2 La envolvente y la convexidad de la función de valor (sección 4.2)

Supón que el parámetro entra linealmente en el objetivo:
$f(x, \alpha) = r(x) + \alpha\thinspace s(x)$. Para cada $x$ fija,
$\alpha \mapsto f(x, \alpha)$ es una recta, y $V(\alpha)$ es el máximo de
una familia de rectas.

**Proposición.** $V$ es convexa.

*Demostración.* Sean $\alpha, \beta$ y $\theta \in [0, 1]$, y sea $\bar x$ el
óptimo en $\alpha_\theta = \theta\alpha + (1 - \theta)\beta$. Entonces

$$
V(\alpha_\theta) = \theta f(\bar x, \alpha) + (1 - \theta)f(\bar x, \beta)
\le \theta V(\alpha) + (1 - \theta)V(\beta). \qquad\square
$$

**Consecuencia.** Por la envolvente, $V'(\alpha) = s\big(x^\ast(\alpha)\big)$.
Si $V$ es dos veces diferenciable, la convexidad da

$$
V''(\alpha) = \frac{d}{d\alpha}s\big(x^\ast(\alpha)\big) \ge 0.
$$

En $\max_x a\ln(1 + x) - px$, con $s(x) = -x$, sale $dx^\ast/dp \le 0$: la
inversión decrece con su precio, **sin resolver el problema** y sin suponer
nada sobre $\ln$. Es un resultado de estática comparativa que viene sólo de
que $x^\ast$ es óptima. Con el mismo argumento, en la teoría de la empresa,
la función de beneficio es convexa en los precios y la oferta crece con el
precio (lema de Hotelling).

---

## Referencias

- Chiang, A. C., & Wainwright, K. (2006). *Métodos fundamentales de economía
  matemática* (4.ª ed.). McGraw-Hill.
- Milgrom, P., & Segal, I. (2002). Envelope theorems for arbitrary choice
  sets. *Econometrica*, 70(2), 583–601. https://doi.org/10.1111/1468-0262.00296
- Simon, C. P., & Blume, L. (1994). *Mathematics for Economists*. W. W.
  Norton.
