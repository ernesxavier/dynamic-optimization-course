# Sesión 16: Ecuación de Bellman en horizonte infinito

> **Cómo usar estas notas.** La clase se da en el pizarrón y sigue estas
> notas en su orden. El **plan de clase** de abajo dice qué secciones se
> escriben en el pizarrón, cuándo se proyecta el cuaderno
> (`Code/s16_bellman_infinito.jl`) y qué queda para leer. En el pizarrón van
> las ecuaciones y los resultados en recuadro; el texto que las rodea es lo
> que se explica de palabra. Como todo está aquí, en clase no hace falta
> copiar. El cuerpo de las notas es la **ruta básica** y se evalúa; las
> demostraciones y los temas opcionales están al final, en **Para
> profundizar**, y no se ven en clase.
>
> Repaso recomendado: [A.B2–B3](repaso/analisis.md#ab2) (sucesiones, series
> y descuento), [A.I4](repaso/analisis.md#ai4) (norma del supremo),
> [A.I5](repaso/analisis.md#ai5) (contracciones en una dimensión) y
> [N.I4–I6](repaso/metodos_numericos.md#ni4) (mallas, maximizar y medir el
> error); para Para profundizar, [A.A1–A3](repaso/analisis.md#aa1)
> (espacios completos, Banach y Blackwell), [L.A2](repaso/algebra_lineal.md#la2)
> (series de Neumann) y [N.A2](repaso/metodos_numericos.md#na2) (código de
> la iteración de política).
>
> Lecturas: Sargent y Stachurski, Vol. I, secs. 1.2 y 1.3; QuantEcon,
> *Cake Eating II*.

**Plan de clase** (120 minutos)

| Minutos | Dónde | Qué | Secciones |
|---|---|---|---|
| 0–5 | Pizarra | La pregunta: de una regla por periodo a una sola regla | 0 |
| 5–20 | Pizarra | El problema sin final y la ecuación de Bellman estacionaria | 1 |
| 20–40 | Pizarra | El operador de Bellman: punto fijo, contracción y regla de paro | 2 |
| 40–55 | Pizarra | La torta exacta: conjetura y verificación | 3 |
| 55–60 | | Pausa | |
| 60–72 | Pizarra | Crecimiento óptimo de una región sin final | 4 |
| 72–82 | Proyector | La iteración de la función valor contra la solución exacta | Cuaderno, sección 1 |
| 82–100 | Pizarra | La iteración de política: evaluar y mejorar | 5 |
| 100–110 | Proyector | Iteración de la función valor contra iteración de política | Cuaderno, sección 2 |
| 110–118 | Parejas | Ejercicio F1 a mano | 8 |
| 118–120 | Pizarra | Cierre: Laboratorio 2 y sesión 18 | 6 |
| Después | Lectura | El resumen (7), la sección [Avanzado] del cuaderno y Para profundizar (la verificación con transversalidad y la mejora de la política) | |

**Pregunta de la unidad.** ¿Cómo debe crecer una región que decide cada año
cuánto invertir?

---

## 0. La pregunta

En la sesión 15, la política dependía del estado y de **cuántos periodos
faltan**: una regla distinta para cada periodo. Con un plan de 10 periodos,
la región consumía el 71.5% del producto al principio y todo al final. Pero
una región no tiene un último año. Cuando faltan muchos periodos, la regla
apenas cambia de un periodo al siguiente (sesión 15, F7): con horizonte
infinito debería quedar **una sola regla**, "con este capital, invierte
tanto", válida en cualquier fecha.

Esta sesión encuentra esa regla y, sobre todo, enseña a **calcularla** con
dos métodos que se usan en el Laboratorio 2.

---

## 1. El problema sin final

Con estado inicial $x_0$, se eligen controles $u_0, u_1, \dots$ para

$$
\max\ \sum_{t=0}^{\infty}\beta^t\thinspace r(x_t, u_t)
\qquad\text{sujeto a}\qquad
x_{t+1} = g(x_t, u_t), \quad u_t \in \Gamma(x_t),
$$

con $0 < \beta < 1$, para que la suma converja cuando $r$ es acotada
([A.B3](repaso/analisis.md#ab3)). Es el problema de la sesión 15 con
$T \to \infty$ y sin valor terminal.

**La idea clave: el problema no envejece.** Desde el periodo $t$ con estado
$x$, lo que queda por delante es otra vez una suma infinita con la misma
recompensa, la misma ecuación de movimiento y el mismo descuento. El
problema visto desde $t$ es idéntico al visto desde 0; sólo cambia el
estado. Por eso la función valor **no depende de $t$**: hay una sola $V(x)$,
y la ecuación de Bellman de la sesión 15 queda

$$
\boxed{\ V(x) = \max_{u \in \Gamma(x)}\Big\lbrace r(x, u) + \beta\thinspace V\big(g(x, u)\big)\Big\rbrace\ }
$$

con la **misma** $V$ a los dos lados. La política

$$
\sigma(x) \in \arg\max_{u \in \Gamma(x)}\Big\lbrace r(x, u) + \beta\thinspace V\big(g(x, u)\big)\Big\rbrace
$$

es **estacionaria**: depende sólo del estado.

**Lo que cambia.** En horizonte finito, la inducción hacia atrás empezaba en
$V_T = S$ y terminaba en $V_0$. Ahora no hay por dónde empezar: $V$ es la
incógnita de una **ecuación funcional**, una ecuación cuya solución es una
función. Las secciones 2, 3 y 5 dicen cómo resolverla.

---

## 2. El operador de Bellman

### 2.1 Un punto fijo

Para cualquier función $v$ (una conjetura de la función valor), sea $Tv$ la
función que da el lado derecho de la ecuación de Bellman:

$$
(Tv)(x) = \max_{u \in \Gamma(x)}\Big\lbrace r(x, u) + \beta\thinspace v\big(g(x, u)\big)\Big\rbrace.
$$

$T$ es el **operador de Bellman**: recibe una función y devuelve otra. La
ecuación de Bellman dice que $V$ es un **punto fijo** de $T$:

$$
TV = V.
$$

Es la misma idea que $x^\ast = g(x^\ast)$ en una dimensión
([A.I5](repaso/analisis.md#ai5)), pero ahora los "puntos" son funciones.

**La iteración de la función valor.** Como en una dimensión, se busca el
punto fijo iterando: se empieza con cualquier $v_0$ y se calcula
$v_{n+1} = Tv_n$. Con $v_0 = 0$, $v_n$ es la función valor de la sesión 15
con $n$ periodos por delante y $S = 0$: **iterar $T$ es hacer la inducción
hacia atrás sin detenerse**. La pregunta es si $v_n$ converge, y a qué.

### 2.2 $T$ es una contracción

La distancia entre dos funciones es la mayor diferencia entre sus gráficas,
la **norma del supremo** ([A.I4](repaso/analisis.md#ai4)):
$\lVert v - w\rVert = \sup_x\lvert v(x) - w(x)\rvert$.

**Proposición.** Si $r$ es acotada, para cualesquiera $v$ y $w$ acotadas,

$$
\boxed{\ \lVert Tv - Tw\rVert \le \beta\thinspace\lVert v - w\rVert\ }
$$

*Por qué.* Dos hechos:

1. La diferencia entre dos máximos no es mayor que la mayor diferencia
   entre lo que se maximiza:
   $\lvert\max_u f(u) - \max_u h(u)\rvert \le \max_u\lvert f(u) - h(u)\rvert$.
   Si $f$ alcanza su máximo en $u_f$, entonces
   $\max f - \max h \le f(u_f) - h(u_f) \le \max\lvert f - h\rvert$, y lo
   mismo al revés.
2. En el estado $x$, lo que se maximiza para $Tv$ y para $Tw$ sólo difiere
   en el término del futuro: $r(x, u)$ se cancela y queda
   $\beta\big(v(g(x, u)) - w(g(x, u))\big)$.

Juntando los dos, en cada estado $x$,

$$
\lvert(Tv)(x) - (Tw)(x)\rvert
\le \beta\max_{u}\big\lvert v\big(g(x, u)\big) - w\big(g(x, u)\big)\big\rvert
\le \beta\thinspace\lVert v - w\rVert,
$$

y se toma el supremo sobre $x$. $\square$

**La lectura.** Aplicar $T$ acerca cualquier par de conjeturas al menos en
el factor $\beta$. La razón es económica: $v$ y $w$ sólo opinan sobre el
**futuro**, y el futuro está descontado.

### 2.3 Lo que se sigue

Con la proposición y el teorema del punto fijo de Banach
([A.A2](repaso/analisis.md#aa2)):

- **Existe una única** función acotada que resuelve la ecuación de Bellman.
- La iteración converge a ella **desde cualquier** $v_0$ acotada.
- El error cae al menos en el factor $\beta$ cada iteración:
  $\lVert v_n - V\rVert \le \beta^n\lVert v_0 - V\rVert$.

**¿Cuántas iteraciones?** Para reducir el error inicial un millón de veces
hace falta $\beta^n \le 10^{-6}$, es decir, $n \ge \ln 10^{-6}/\ln\beta$:

| $\beta$ | 0.90 | 0.95 | 0.99 |
|---|---|---|---|
| Iteraciones | 132 | 270 | 1375 |

Cuanto más paciente es la región, más lento converge el método.

**¿Cuándo detenerse?** No se conoce $V$, así que no se puede medir el error
directamente. Lo que sí se mide es la diferencia entre dos iteraciones, y
([A.A2](repaso/analisis.md#aa2))

$$
\lVert v_n - V\rVert \le \frac{\beta}{1 - \beta}\thinspace\lVert v_n - v_{n-1}\rVert.
$$

Con $\beta = 0.95$, el error puede ser hasta 19 veces la diferencia entre
iteraciones: una diferencia pequeña no basta. Para garantizar un error menor
que $\varepsilon$, hay que detenerse cuando
$\lVert v_n - v_{n-1}\rVert \le \varepsilon(1 - \beta)/\beta$.

---

## 3. La torta exacta: conjetura y verificación

Un fondo $x$ se gasta sin final: $x_{t+1} = x_t - c_t$, $r = \ln c$. La
recompensa no es acotada, así que la sección 2.3 no se aplica tal cual
([Para profundizar, P.1](#pp1)); pero la ecuación de Bellman tiene solución
cerrada, y sirve para **verificar el código**.

**La conjetura.** En la sesión 15, con $n$ periodos por delante, $V$ era
$(1 + \beta + \cdots + \beta^{n-1})\ln x$ más una constante. Se conjetura
la misma forma, $V(x) = a + b\ln x$, con $a$ y $b$ por determinar.

**El lado derecho.** Con la conjetura,

$$
(TV)(x) = \max_{0 \le c \le x}\ \big\lbrace\ln c + \beta a + \beta b\ln(x - c)\big\rbrace.
$$

La condición de primer orden es

$$
\frac{1}{c} = \frac{\beta b}{x - c}
\iff c = \frac{x}{1 + \beta b},
\qquad x - c = \frac{\beta b\thinspace x}{1 + \beta b}.
$$

**Igualar coeficientes.** Al sustituir, $\ln x$ aparece con coeficiente 1 en
$\ln c$ y con coeficiente $\beta b$ en $\beta b\ln(x - c)$. Para que
$TV = V$, el coeficiente de $\ln x$ debe ser el mismo a los dos lados:

$$
b = 1 + \beta b
\iff b = \frac{1}{1 - \beta}.
$$

Entonces $1 + \beta b = 1/(1 - \beta)$ y la política es

$$
\boxed{\ c = (1 - \beta)\thinspace x,
\qquad
V(x) = a + \frac{\ln x}{1 - \beta}\ }
$$

La constante sale de igualar los términos sin $x$ (con $c = (1 - \beta)x$ y
$x - c = \beta x$):

$$
a = \ln(1 - \beta) + \beta a + \beta b\ln\beta
\iff a = \frac{\ln(1 - \beta)}{1 - \beta} + \frac{\beta\ln\beta}{(1 - \beta)^2}.
$$

**La lectura.**

- Se gasta **siempre la misma fracción** del fondo, $1 - \beta$. Es el
  límite de la fracción $(1 - \beta)/(1 - \beta^n)$ de la sesión 15 cuando
  $n \to \infty$.
- El fondo y el gasto caen en el factor $\beta$ cada periodo: $x_t = \beta^t x_0$
  y $c_{t+1} = \beta c_t$, la misma ecuación de Euler de la sesión 15.
- **Ejemplo numérico.** Con $\beta = 0.9$ y $x_0 = 100$: se gasta 10, 9,
  8.1, …, la suma da 100 y $V(100) = -32.508 + 10\ln 100 = 13.543$. El
  Laboratorio 2 compara este número con la iteración de la función valor.

**El método.** Conjeturar una forma, sustituirla en el lado derecho, igualar
coeficientes. Funciona cuando la forma se conserva al aplicar $T$, como
aquí con $\ln$. Casi nunca pasa; cuando pasa, la solución exacta es la mejor
prueba de un código.

---

## 4. Crecimiento óptimo de una región sin final

La región de la sesión 15, sin último periodo:

$$
\max\ \sum_{t=0}^{\infty}\beta^t\ln c_t
\qquad\text{sujeto a}\qquad
k_{t+1} = Ak_t^\alpha - c_t.
$$

Es el modelo de Brock y Mirman (1972) sin incertidumbre.

**Conjetura y verificación.** Con $V(k) = a + b\ln k$ (otros $a$ y $b$ que
en la torta) y $y = Ak^\alpha$, la sección 4.2 de la sesión 15 ya hizo la
cuenta: la mejor respuesta a $b$ es $c = y/(1 + \beta b)$, y el coeficiente
de $\ln k$ del lado derecho es $\alpha(1 + \beta b)$. El punto fijo pide

$$
b = \alpha(1 + \beta b)
\iff b = \frac{\alpha}{1 - \alpha\beta},
\qquad 1 + \beta b = \frac{1}{1 - \alpha\beta},
$$

así que

$$
\boxed{\ c = (1 - \alpha\beta)\thinspace Ak^\alpha,
\qquad
k' = \alpha\beta\thinspace Ak^\alpha\ }
$$

**La lectura.**

- La región **ahorra siempre la fracción $\alpha\beta$ del producto**. Es el
  límite de la regla de la sesión 15 (F7) cuando faltan muchos periodos.
  Con $\alpha = 0.3$ y $\beta = 0.95$, ahorra el 28.5%.
- El capital de largo plazo resuelve $k^\ast = \alpha\beta A(k^\ast)^\alpha$:
  $k^\ast = (\alpha\beta A)^{1/(1 - \alpha)}$; con $A = 1$, $k^\ast = 0.166$.
- En logaritmos, la regla es lineal:
  $\ln k_{t+1} - \ln k^\ast = \alpha\big(\ln k_t - \ln k^\ast\big)$. Cada periodo
  se cierra el 70% de la brecha que queda. Una región pobre crece más rápido
  porque el rendimiento de su capital es mayor: la convergencia de la
  sesión 12, ahora con una regla explícita.
- Con depreciación parcial o utilidad CRRA con $\theta \ne 1$, la forma
  $a + b\ln k$ ya no se conserva y no hay solución cerrada (F7): se resuelve
  numéricamente, como en el Laboratorio 2.

**Por qué el cuaderno usa este problema y no la torta.** En una malla en la
que el estado siguiente también es un punto de la malla, la torta sin final
no tiene arreglo: el fondo sólo baja, tarde o temprano llega al punto más
bajo y de ahí no puede gastar nada, con valor $-\infty$. El crecimiento no
tiene ese problema, porque el capital se queda cerca de $k^\ast$, dentro de
la malla. En el Laboratorio 2, la torta se resuelve **interpolando** $v$
entre los puntos de la malla y eligiendo el gasto en un continuo
([N.I4–I5](repaso/metodos_numericos.md#ni4)).

---

## 5. La iteración de política

### 5.1 El problema de la iteración de la función valor

Cada iteración de la función valor mejora poco: el error cae en el factor
$\beta$, y con $\beta = 0.95$ hacen falta cientos de iteraciones. La
**iteración de política** (Howard, 1960) da pasos más caros pero mucho más
largos. Parte de una observación: **dada una política, su valor se puede
calcular directamente**.

### 5.2 Evaluar una política

Si se sigue para siempre la política $\sigma$, su valor $v_\sigma$ cumple la
ecuación de Bellman **sin máximo**:

$$
v_\sigma(x) = r\big(x, \sigma(x)\big) + \beta\thinspace v_\sigma\Big(g\big(x, \sigma(x)\big)\Big).
$$

No hay que elegir nada: es una ecuación **lineal** en $v_\sigma$. En una
malla de $N$ estados, $v_\sigma$ es un vector, la política dice a qué punto
de la malla se pasa desde cada punto, y la ecuación es el sistema lineal

$$
\boxed{\ v_\sigma = r_\sigma + \beta P_\sigma v_\sigma
\iff v_\sigma = \big(I - \beta P_\sigma\big)^{-1} r_\sigma\ }
$$

donde $r_\sigma$ es el vector de recompensas y $P_\sigma$ la matriz que
tiene un 1 en la fila $i$ y la columna del estado siguiente de $i$. La
inversa existe porque $\beta < 1$ ([L.A2](repaso/algebra_lineal.md#la2)).

**Ejemplo: gastar una fracción fija $\gamma$ de la torta.** Con
$c = \gamma x$, la ecuación es
$v_\sigma(x) = \ln(\gamma x) + \beta v_\sigma\big((1 - \gamma)x\big)$. Con la
conjetura $v_\sigma = a_\gamma + b\ln x$, el coeficiente de $\ln x$ cumple
$b = 1 + \beta b$, así que $b = 1/(1 - \beta)$ **para cualquier** $\gamma$;
sólo la constante depende de $\gamma$.

### 5.3 Mejorar la política

Con $v_\sigma$ en la mano, se elige en cada estado lo mejor **si de mañana
en adelante se sigue $\sigma$**:

$$
\sigma'(x) \in \arg\max_{u \in \Gamma(x)}\Big\lbrace r(x, u) + \beta\thinspace v_\sigma\big(g(x, u)\big)\Big\rbrace.
$$

La nueva política nunca es peor: $v_{\sigma'} \ge v_\sigma$ en todos los
estados ([Para profundizar, P.2](#pp2)).

**En la torta.** Con $v_\sigma = a_\gamma + \ln x/(1 - \beta)$, la mejora es
el problema de la sección 3 con $b = 1/(1 - \beta)$: da $c = (1 - \beta)x$.
**Desde cualquier fracción fija, un solo paso llega a la política óptima.**
Es un caso extremo, pero muestra por qué el método es rápido.

### 5.4 El algoritmo y su costo

1. Empezar con una política $\sigma_0$.
2. **Evaluar**: resolver el sistema lineal para $v_{\sigma_k}$.
3. **Mejorar**: $\sigma_{k+1}$ = la mejor respuesta a $v_{\sigma_k}$.
4. Si $\sigma_{k+1} = \sigma_k$, terminar; si no, volver a 2.

Con una malla finita hay un número finito de políticas y cada paso mejora,
así que el algoritmo **termina en un número finito de pasos**. El código
está en [N.A2](repaso/metodos_numericos.md#na2).

| | Función valor | Política |
|---|---|---|
| Un paso | Un máximo en cada estado | Un máximo en cada estado y un sistema lineal de $N \times N$ |
| Número de pasos | Cientos; crece con $\beta$ | Pocos; casi no depende de $\beta$ |
| Termina | Cuando la regla de paro lo dice (2.3) | Cuando la política no cambia |

Hay un punto intermedio: evaluar la política sólo aproximadamente, con unas
cuantas iteraciones de $v \mapsto r_\sigma + \beta P_\sigma v$ en lugar del
sistema lineal. Sargent y Stachurski (sec. 5.1.4) la llaman iteración de
política optimista.

---

## 6. Hacia la optimización dinámica

| Idea de esta sesión | Dónde reaparece |
|---|---|
| Iteración de la función valor y su regla de paro | Laboratorio 2: la torta y el crecimiento con los parámetros de la sesión 12 |
| La solución exacta para verificar el código | Laboratorio 2: el error contra el número de iteraciones |
| $c_{t+1} = \beta c_t$; la política por conjetura y verificación | La ecuación de Euler en tiempo discreto, a partir de la ecuación de Bellman (sesión 18) |
| Ahorro constante $\alpha\beta$ y convergencia | Comparación con el principio del máximo: el mismo problema por dos caminos (sesión 18 y Laboratorio 3) |
| La ecuación de Bellman con un valor esperado | ¿Migrar o quedarse? (Laboratorio 3) |

---

## 7. Resumen formal

| Concepto | Enunciado | Dónde |
|---|---|---|
| Bellman estacionaria | $V(x) = \max_u\lbrace r(x, u) + \beta V(g(x, u))\rbrace$; una sola $V$ y una política $\sigma(x)$ | 1 |
| Operador de Bellman | $V$ es punto fijo de $T$; iterar $T$ es la inducción hacia atrás sin fin | 2.1 |
| Contracción | $\lVert Tv - Tw\rVert \le \beta\lVert v - w\rVert$ si $r$ es acotada | 2.2 |
| Convergencia | Única solución; error $\le \beta^n\lVert v_0 - V\rVert$; parar si $\lVert v_n - v_{n-1}\rVert \le \varepsilon(1 - \beta)/\beta$ | 2.3 |
| Torta con $\ln c$ | $c = (1 - \beta)x$, $V = a + \ln x/(1 - \beta)$ | 3 |
| Iteración de política | Evaluar: $v_\sigma = (I - \beta P_\sigma)^{-1}r_\sigma$; mejorar; termina en pasos finitos | 5 |
| Crecimiento con $\ln c$ | $k' = \alpha\beta Ak^\alpha$; $k^\ast = (\alpha\beta A)^{1/(1 - \alpha)}$ | 4 |

---

## 8. Ejercicios formales

- **F1.** El fondo rinde: $x_{t+1} = R(x_t - c_t)$, con $r = \ln c$ y
  horizonte infinito. Con la conjetura $V(x) = a + b\ln x$, encuentra $b$ y
  la política. ¿Depende el gasto de $R$? ¿A qué tasa crece el gasto?
  Compara con la sesión 15, F2.
- **F2.** En la torta con $\beta = 0.9$, una región gasta cada periodo el 20%
  del fondo en lugar del 10%. Calcula $v_\sigma(100)$ con la sección 5.2 y
  compáralo con $V(100) = 13.543$. ¿Por qué factor habría que multiplicar
  el gasto de todos los periodos para compensar la pérdida?
- **F3.** En el crecimiento de la sección 4, con $\alpha = 0.3$,
  $\beta = 0.95$ y $A = 1$, una región empieza con $k_0 = k^\ast/10$.
  ¿Cuántos periodos tarda en cerrar el 90% de la brecha en logaritmos? ¿Y
  con $\alpha = 0.5$?
- **F4.** La iteración de la función valor de un problema con $\beta = 0.95$
  da $\lVert v_1 - v_0\rVert = 2$. Usa las cotas de
  [A.A2](repaso/analisis.md#aa2) para decir cuántas iteraciones bastan para
  garantizar un error menor que $10^{-4}$.

**Para profundizar** (opcionales)

- **F5.** Muestra que el operador de Bellman cumple las condiciones de
  Blackwell (monotonía y descuento) y deduce de ahí la proposición de la
  sección 2.2 ([A.A3](repaso/analisis.md#aa3)).
- **F6.** Muestra que la solución de la torta de la sección 3 cumple la
  condición $\lim_{t\to\infty}\beta^t V(x_t) = 0$ a lo largo de la
  trayectoria óptima, y explica por qué hace falta ([P.1](#pp1)).
- **F7.** Con depreciación parcial, $k_{t+1} = Ak_t^\alpha + (1 - \delta)k_t - c_t$
  con $\delta < 1$, sustituye la conjetura $a + b\ln k$ en la ecuación de
  Bellman y muestra que no se conserva.

## Para profundizar

Material opcional: demostraciones y temas que no se ven en clase. Cada
apartado indica de qué sección de las notas viene.

<a id="pp1"></a>

### P.1 ¿La conjetura es la función valor? (sección 3)

Con $r = \ln c$, la recompensa no es acotada: tiende a $-\infty$ cuando el
gasto tiende a cero. La proposición de la sección 2.2 no se aplica, y la
ecuación de Bellman puede tener **más de una** solución. Que $a + b\ln x$
cumpla la ecuación no prueba, por sí solo, que sea el valor del problema.

Lo que hace falta es una condición en el infinito. Si $W$ resuelve la
ecuación de Bellman y $\sigma$ es la política que alcanza el máximo,
aplicar la ecuación $n$ veces a lo largo de la trayectoria $x_{t+1} = x_t - \sigma(x_t)$ da

$$
W(x_0) = \sum_{t=0}^{n-1}\beta^t\ln\sigma(x_t) + \beta^n W(x_n).
$$

Si $\beta^n W(x_n) \to 0$, $W(x_0)$ es el valor que da $\sigma$. Con la
torta, $x_n = \beta^n x_0$ y

$$
\beta^n W(x_n) = \beta^n\Big(a + \frac{\ln x_0 + n\ln\beta}{1 - \beta}\Big) \to 0,
$$

porque $n\beta^n \to 0$ ([A.B2](repaso/analisis.md#ab2)). Para concluir
que $\sigma$ es **óptima** se necesita además el mismo límite a lo largo de
cualquier trayectoria factible con valor finito (Stokey, Lucas y Prescott,
sec. 4.1). Es el equivalente discreto de la condición de transversalidad
de la sesión 12. La alternativa general son normas ponderadas que admiten
funciones no acotadas ([A.A3](repaso/analisis.md#aa3)).

<a id="pp2"></a>

### P.2 La mejora de la política (sección 5.3)

Sea $T_\sigma v = r_\sigma + \beta P_\sigma v$ el operador que evalúa
$\sigma$ sin máximo. Es monótono ($v \le w$ implica $T_\sigma v \le T_\sigma w$,
porque $P_\sigma$ tiene entradas no negativas) y $v_\sigma$ es su punto fijo.

Como $\sigma'$ alcanza el máximo con $v_\sigma$,

$$
T_{\sigma'}v_\sigma = Tv_\sigma \ge T_\sigma v_\sigma = v_\sigma.
$$

Aplicando $T_{\sigma'}$ a los dos lados una y otra vez, por monotonía,
$v_\sigma \le T_{\sigma'}v_\sigma \le T_{\sigma'}^2 v_\sigma \le \cdots$, y
$T_{\sigma'}^n v_\sigma \to v_{\sigma'}$ porque $T_{\sigma'}$ es una
contracción. Entonces $v_{\sigma'} \ge v_\sigma$. Si la desigualdad es una
igualdad, $v_\sigma = Tv_\sigma$: $v_\sigma$ resuelve la ecuación de Bellman
y $\sigma$ es óptima. $\square$

---

## Referencias

- Brock, W. A., & Mirman, L. J. (1972). Optimal economic growth and
  uncertainty: The discounted case. *Journal of Economic Theory*, 4(3),
  479–513. https://doi.org/10.1016/0022-0531(72)90135-4
- Howard, R. A. (1960). *Dynamic Programming and Markov Processes*. MIT
  Press.
- QuantEcon. *Cake Eating II: Numerical Methods*. https://quantecon.org
- Sargent, T. J., & Stachurski, J. *Dynamic Programming, Vol. I: Finite
  States*. Versión en línea de agosto de 2026, https://dp.quantecon.org.
- Stokey, N. L., Lucas, R. E., & Prescott, E. C. (1989). *Recursive Methods
  in Economic Dynamics*. Harvard University Press.
