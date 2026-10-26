# Sesión 18: Control óptimo frente a programación dinámica

> **Cómo usar estas notas.** La clase se da en el pizarrón y sigue estas
> notas en su orden. El **plan de clase** de abajo dice qué secciones se
> escriben en el pizarrón y qué queda para leer; esta sesión no tiene
> cuaderno, porque la comparación numérica es el Laboratorio 3. En el
> pizarrón van las ecuaciones y los resultados en recuadro; el texto que las
> rodea es lo que se explica de palabra. Como todo está aquí, en clase no
> hace falta copiar. El cuerpo de las notas es la **ruta básica** y se
> evalúa; las demostraciones y los temas opcionales están al final, en
> **Para profundizar**, y no se ven en clase.
>
> Repaso recomendado: [C.B3](repaso/calculo.md#cb3) (exponencial y
> logaritmo); para Para profundizar, [C.A2](repaso/calculo.md#ca2) (teorema
> de la envolvente en programación dinámica) y
> [D.A5](repaso/ecuaciones_diferenciales.md#da5) (sistemas lineales en
> tiempo discreto).
>
> Lecturas: Conrad y Rondeau (2020), los capítulos de recursos renovables.
>
> **Sesión flexible.** Si el calendario se atrasa, las secciones 1 a 3 son
> el núcleo; el caso del recurso renovable (5) puede quedar como lectura.

**Plan de clase** (120 minutos)

| Minutos | Dónde | Qué | Secciones |
|---|---|---|---|
| 0–5 | Pizarra | La pregunta: dos caminos, ¿el mismo resultado? | 0 |
| 5–30 | Pizarra | La ecuación de Euler a partir de la ecuación de Bellman | 1 |
| 30–50 | Pizarra | El precio sombra: $V'(k)$ y el coestado | 2 |
| 50–55 | | Pausa | |
| 55–75 | Pizarra | El límite continuo: de Euler a Keynes-Ramsey | 3 |
| 75–85 | Pizarra | Qué da cada método | 4 |
| 85–110 | Pizarra | Un recurso renovable en una región, por los dos caminos | 5 |
| 110–118 | Parejas | Ejercicio F1 a mano | 8 |
| 118–120 | Pizarra | Cierre: Laboratorio 3 | 6 |
| Después | Lectura | El resumen (7) y Para profundizar (el punto de silla discreto y cuándo es derivable $V$) | |

**Pregunta de la unidad.** ¿Cómo debe crecer una región que decide cada año
cuánto invertir?

---

## 0. La pregunta

La Unidad III resolvió el crecimiento de una región con el principio del
máximo: trayectorias, un coestado y la regla de Keynes-Ramsey (sesión 12).
La Unidad IV lo resolvió con la ecuación de Bellman: una función valor y una
regla (sesión 16). Son dos caminos para el mismo problema. ¿Dan lo mismo?
¿Qué papel juega en cada uno el precio sombra del capital? ¿Cuándo conviene
uno y cuándo el otro?

---

## 1. La ecuación de Euler a partir de la ecuación de Bellman

### 1.1 El problema

Una región con capital $k_t$ produce $f(k_t)$, el capital se deprecia a la
tasa $\delta$, y lo que no se consume se invierte:

$$
k_{t+1} = f(k_t) + (1 - \delta)k_t - c_t,
\qquad
V(k) = \max_{c}\ \Big\lbrace u(c) + \beta\thinspace V\big(f(k) + (1 - \delta)k - c\big)\Big\rbrace.
$$

Con $\delta = 1$ y $u = \ln c$ es el problema de la sesión 16, sección 4.
Ahora $u$ y $f$ son generales y no hay solución cerrada. Lo que sí se
puede obtener es una condición que cumple la trayectoria óptima.

### 1.2 Dos condiciones

**Primer orden.** Con $k' = f(k) + (1 - \delta)k - c$, derivar respecto de
$c$ e igualar a cero:

$$
u'(c) = \beta\thinspace V'(k').
$$

Consumir una unidad más hoy vale $u'(c)$; cuesta una unidad menos de
capital mañana, que vale $\beta V'(k')$.

**Envolvente.** ¿Cuánto vale una unidad más de capital hoy? Por el teorema
de la envolvente (sesión 3, sección 4), se deriva el lado derecho respecto
de $k$ **sin** tomar en cuenta que $c$ cambia, porque el efecto a través de
$c$ es cero en el óptimo:

$$
V'(k) = \beta\thinspace V'(k')\thinspace\big(1 + f'(k) - \delta\big).
$$

Es la **fórmula de Benveniste-Scheinkman** (1979).

### 1.3 Juntar las dos

Por la condición de primer orden, $\beta V'(k') = u'(c)$, así que la
envolvente queda

$$
V'(k) = u'(c)\thinspace\big(1 + f'(k) - \delta\big).
$$

Vale en cualquier periodo; un periodo después,
$V'(k') = u'(c')\big(1 + f'(k') - \delta\big)$. Sustituyendo en la condición
de primer orden, con $R_{t+1} = 1 + f'(k_{t+1}) - \delta$:

$$
\boxed{\ u'(c_t) = \beta\thinspace R_{t+1}\thinspace u'(c_{t+1})\ }
$$

**La lectura.** Dejar de consumir una unidad hoy cuesta $u'(c_t)$; invertida,
da $R_{t+1}$ unidades mañana, que valen $\beta R_{t+1}u'(c_{t+1})$ hoy. En el
óptimo, las dos cosas son iguales. Es la ecuación de Euler de la sesión 1,
ahora deducida de la ecuación de Bellman. La función valor **desapareció**:
la ecuación sólo tiene consumos y capitales.

### 1.4 Comprobaciones

- **La torta** (sesión 15): $k' = k - c$, así que $R = 1$ y
  $1/c_t = \beta/c_{t+1}$: $c_{t+1} = \beta c_t$. ✓
- **El crecimiento con $\ln c$ y $\delta = 1$** (sesión 16, sección 4):
  $R_{t+1} = \alpha Ak_{t+1}^{\alpha - 1}$ y $c_t = (1 - \alpha\beta)Ak_t^\alpha$.
  El lado derecho es

  $$\beta\thinspace\alpha Ak_{t+1}^{\alpha - 1}\thinspace\frac{1}{(1 - \alpha\beta)Ak_{t+1}^\alpha} = \frac{\alpha\beta}{(1 - \alpha\beta)\thinspace k_{t+1}} = \frac{1}{(1 - \alpha\beta)Ak_t^\alpha},$$

  usando $k_{t+1} = \alpha\beta Ak_t^\alpha$. Es $1/c_t$. ✓

**El estado estacionario.** Con $c_t = c_{t+1}$, la ecuación de Euler pide
$\beta R = 1$. Si $\beta = 1/(1 + \rho)$,

$$
f'(k^\ast) - \delta = \rho,
$$

la misma condición $f'(k^\ast) = \delta + \rho$ de la sesión 12.

**Lo que falta.** La ecuación de Euler relaciona $k_t$, $k_{t+1}$ y $k_{t+2}$
(porque $c_t$ depende de $k_t$ y $k_{t+1}$): es una ecuación en diferencias
de **segundo orden**. Con $k_0$ dado, falta una condición. La da la
transversalidad, $\lim_{t\to\infty}\beta^t u'(c_t)k_{t+1} = 0$, que elige la
única trayectoria que converge, como en el punto de silla de la sesión 12
([Para profundizar, P.1](#pp1)).

---

## 2. El precio sombra: $V'(k)$ y el coestado

### 2.1 El lagrangiano en tiempo discreto

El mismo problema se puede resolver sin ecuación de Bellman, con un
multiplicador $\mu_t$ por periodo para la restricción de recursos:

$$
\mathcal{L} = \sum_{t=0}^{\infty}\beta^t\Big\lbrace u(c_t) + \mu_t\big(f(k_t) + (1 - \delta)k_t - c_t - k_{t+1}\big)\Big\rbrace.
$$

Los multiplicadores están en **valor corriente**: cada $\mu_t$ se mide en
utilidad del periodo $t$, como el $\mu$ de la sesión 12.

**Primer orden respecto de $c_t$:**

$$
u'(c_t) = \mu_t.
$$

**Primer orden respecto de $k_{t+1}$**, que aparece en la restricción de $t$
(con signo $-$) y en la de $t + 1$ (a través de $f$ y de la depreciación):

$$
-\beta^t\mu_t + \beta^{t+1}\mu_{t+1}\big(1 + f'(k_{t+1}) - \delta\big) = 0
\iff
\mu_t = \beta\thinspace R_{t+1}\thinspace\mu_{t+1}.
$$

Con $\mu_t = u'(c_t)$, es otra vez la ecuación de Euler.

### 2.2 El coestado es la derivada de la función valor

Las dos derivaciones dicen

$$
\boxed{\ \mu_t = u'(c_t) = \beta\thinspace V'(k_{t+1})\ }
$$

El multiplicador de la restricción del periodo $t$ es el valor, descontado
a $t$, de una unidad más de capital al empezar $t + 1$. Es el resultado de
la sesión 3: **el multiplicador es la derivada del valor óptimo respecto
del recurso**. En el principio del máximo, el coestado $\mu(t)$ es el precio
sombra del capital en $t$; en programación dinámica, ese precio es la
pendiente de $V$.

**La lectura.** El coestado del principio del máximo es una **trayectoria**
de precios, uno por fecha, a lo largo del plan óptimo. La función valor da
el precio de una unidad de capital **en cualquier estado**, también fuera
del plan. $V'$ contiene todos los coestados posibles.

---

## 3. El límite continuo: de Euler a Keynes-Ramsey

¿La ecuación de Euler discreta y la regla de Keynes-Ramsey son la misma
condición? Sea $\Delta$ la duración de un periodo. Con tasas por unidad de
tiempo,

- la utilidad del periodo es $u(c)\Delta$;
- el descuento es $\beta = e^{-\rho\Delta}$ ([C.B3](repaso/calculo.md#cb3));
- el capital cambia $k_{t+\Delta} = k_t + \big(f(k_t) - \delta k_t - c_t\big)\Delta$,
  así que el rendimiento bruto es $R = 1 + \big(f'(k) - \delta\big)\Delta$.

La ecuación de Euler (el factor $\Delta$ de la utilidad se cancela a los dos
lados) es

$$
u'(c_t) = e^{-\rho\Delta}\Big(1 + \big(f'(k) - \delta\big)\Delta\Big)\thinspace u'(c_{t+\Delta}).
$$

**Aproximar a primer orden en $\Delta$.** Con $e^{-\rho\Delta} \approx 1 - \rho\Delta$
y $u'(c_{t+\Delta}) \approx u'(c_t) + u''(c_t)\thinspace c'\thinspace\Delta$, donde
$c'$ es la derivada respecto del tiempo:

$$
\begin{aligned}
u'(c) &\approx \big(1 - \rho\Delta\big)\Big(1 + \big(f'(k) - \delta\big)\Delta\Big)\Big(u'(c) + u''(c)\thinspace c'\thinspace\Delta\Big) \cr
&\approx u'(c) + \Big[u''(c)\thinspace c' + \big(f'(k) - \delta - \rho\big)u'(c)\Big]\Delta.
\end{aligned}
$$

**Restar $u'(c)$, dividir entre $\Delta$ y hacer $\Delta \to 0$:**

$$
0 = u''(c)\thinspace c' + \big(f'(k) - \delta - \rho\big)u'(c)
\iff
-\frac{u''(c)\thinspace c}{u'(c)}\thinspace\frac{c'}{c} = f'(k) - \delta - \rho.
$$

Con utilidad CRRA, $-u''(c)c/u'(c) = \theta$, y queda

$$
\boxed{\ \frac{c'}{c} = \frac{f'(k) - \delta - \rho}{\theta}\ }
$$

la regla de Keynes-Ramsey de la sesión 12. **Los dos caminos llevan a la
misma condición**: la ecuación de Euler es la versión discreta de la
ecuación del coestado del principio del máximo.

---

## 4. Qué da cada método

| | Principio del máximo | Programación dinámica |
|---|---|---|
| Incógnita | Trayectorias $c(t)$, $k(t)$, $\mu(t)$ | Una función $V(k)$ y una regla $\sigma(k)$ |
| Ecuaciones | Diferenciales, con condiciones al principio y al final | Una ecuación funcional: un punto fijo |
| La solución dice | Qué hacer en cada fecha, desde un $k_0$ | Qué hacer con cualquier estado |
| Precio sombra | $\mu(t)$, a lo largo del plan | $V'(k)$, en todos los estados |
| Varios estados | Bien: la sesión 14 tuvo dos | Caro: $N^d$ puntos de malla (sesión 15) |
| Incertidumbre | Difícil | Natural: el futuro entra como valor esperado |
| Controles acotados, bang-bang | Función de cambio (sesión 13) | Se incluyen en $\Gamma(x)$ |
| Cálculo | Problema de valor en la frontera: disparo o colocación | Iteración de la función valor o de la política |
| Garantías | Condiciones suficientes (sesión 13) | Contracción (sesión 16) |

**La regla práctica.** Con pocos estados, sin incertidumbre y con interés en
la trayectoria y en su lectura económica, el principio del máximo suele ser
más claro. Con incertidumbre, restricciones complicadas o interés en la
regla, la programación dinámica. El Laboratorio 3 resuelve un mismo
problema por los dos caminos y compara.

---

## 5. Un recurso renovable en una región

### 5.1 El problema

Una región administra un recurso que se regenera: un bosque, una pesquería,
un acuífero. El acervo $x$ crece de forma **logística**,

$$
G(x) = g\thinspace x\Big(1 - \frac{x}{K}\Big),
$$

donde $g$ es la tasa de crecimiento con acervo pequeño y $K$ la capacidad de
carga. Cada año se cosecha $h \in [0, h_{\max}]$ y se vende a un precio $p$
dado (la región es pequeña en el mercado). El problema es

$$
\max\ \int_0^\infty e^{-\rho t}\thinspace p\thinspace h\thinspace dt
\qquad\text{sujeto a}\qquad
x' = G(x) - h, \quad x(0) = x_0.
$$

El crecimiento $G$ es máximo en $x = K/2$: ahí se puede cosechar para siempre
lo más posible, $gK/4$, el **rendimiento máximo sostenible**. ¿Es eso lo
óptimo?

### 5.2 Por el principio del máximo

El Hamiltoniano a valor presente (sesión 12) es

$$
H_c = p\thinspace h + \mu\big(G(x) - h\big) = (p - \mu)\thinspace h + \mu\thinspace G(x).
$$

Es **lineal** en $h$, con función de cambio $\sigma = p - \mu$, como en la
sesión 13: si $\mu < p$, se cosecha $h_{\max}$; si $\mu > p$, nada. En un
**arco singular** ([sesión 13, P.2](s13_varias_variables.md#pp2)),
$\sigma = 0$ durante un intervalo: $\mu = p$ constante, así que $\mu' = 0$. La
ecuación del coestado de la sesión 12, $\mu' = \rho\mu - \partial H_c/\partial x$,
da

$$
0 = \rho\thinspace p - p\thinspace G'(x)
\iff
\boxed{\ G'(x^\ast) = \rho\ }
$$

Con la logística, $G'(x) = g(1 - 2x/K)$, así que

$$
x^\ast = \frac{K}{2}\Big(1 - \frac{\rho}{g}\Big),
\qquad
h^\ast = G(x^\ast).
$$

**El camino.** Si $x_0 < x^\ast$, no se cosecha hasta llegar a $x^\ast$; si
$x_0 > x^\ast$, se cosecha $h_{\max}$ hasta bajar a $x^\ast$. Después se
cosecha $h^\ast$, justo lo que crece. Es una **aproximación más rápida**: se
va al acervo objetivo lo más rápido posible y ahí se queda.

### 5.3 Por programación dinámica

En tiempo discreto, con $\beta = 1/(1 + \rho)$,

$$
V(x) = \max_{h}\ \Big\lbrace p\thinspace h + \beta\thinspace V\big(x + G(x) - h\big)\Big\rbrace.
$$

La condición de primer orden (interior) es $p = \beta V'(x')$, y la
envolvente, $V'(x) = \beta V'(x')\big(1 + G'(x)\big) = p\big(1 + G'(x)\big)$.
Un periodo después, $V'(x') = p\big(1 + G'(x')\big)$, y con la condición de
primer orden,

$$
p = \beta\thinspace p\thinspace\big(1 + G'(x')\big)
\iff
1 + G'(x') = 1 + \rho
\iff
G'(x') = \rho.
$$

**El mismo acervo objetivo por los dos caminos.** Es la sección 1 con
$R = 1 + G'(x)$: el recurso es un capital que rinde lo que crece.

### 5.4 La lectura

- **El recurso es un activo.** Dejar una unidad sin cosechar rinde $G'(x)$
  al año; venderla y prestar el dinero rinde $\rho$. Se conserva el acervo
  hasta que los dos rendimientos son iguales. Es la regla del capital de la
  sesión 12, $f'(k^\ast) = \delta + \rho$, para un capital natural.
- **Con descuento, se conserva menos que el rendimiento máximo sostenible.**
  Con $g = 0.4$, $K = 100$ y $\rho = 0.05$: $x^\ast = 43.75$ y
  $h^\ast = 9.84$, contra $x = 50$ y $h = 10$ del rendimiento máximo. Con
  $\rho = 0.10$, $x^\ast = 37.5$.
- **Si $\rho \ge g$, lo óptimo es agotar el recurso** ($x^\ast = 0$): el
  recurso rinde menos que el dinero. Clark (1973) lo usó para explicar la
  sobreexplotación de las ballenas. Una región con un descuento alto (por
  pobreza o derechos de propiedad inseguros) explota más sus recursos, y la
  política pública puede cambiar ese resultado.
- Conrad y Rondeau (2020) usan $\delta$ para la tasa de descuento; aquí es
  $\rho$, y $\delta$ queda para la depreciación.

---

## 6. Hacia la optimización dinámica

| Idea de esta sesión | Dónde reaparece |
|---|---|
| Los dos caminos llevan a la misma condición | Laboratorio 3, parte 1: el mismo problema con el principio del máximo y con iteración de la función valor |
| La programación dinámica maneja la incertidumbre | Laboratorio 3, parte 2: ¿migrar o quedarse? |
| El recurso renovable, el acervo objetivo y el arco singular | Ideas para el proyecto final (Unidad V) |

---

## 7. Resumen formal

| Concepto | Enunciado | Dónde |
|---|---|---|
| Benveniste-Scheinkman | $V'(k) = \beta V'(k')\big(1 + f'(k) - \delta\big)$ | 1.2 |
| Euler discreta | $u'(c_t) = \beta R_{t+1}u'(c_{t+1})$, con $R_{t+1} = 1 + f'(k_{t+1}) - \delta$ | 1.3 |
| Estado estacionario | $\beta R = 1$: $f'(k^\ast) - \delta = \rho$ | 1.4 |
| Precio sombra | $\mu_t = u'(c_t) = \beta V'(k_{t+1})$ | 2.2 |
| Límite continuo | Euler con $\Delta \to 0$ da Keynes-Ramsey | 3 |
| Recurso renovable | Acervo objetivo $G'(x^\ast) = \rho$; aproximación más rápida | 5 |

---

## 8. Ejercicios formales

- **F1.** Con utilidad CRRA, $u(c) = c^{1-\theta}/(1-\theta)$, muestra que la
  ecuación de Euler da $c_{t+1}/c_t = (\beta R)^{1/\theta}$. Con $\beta = 0.95$,
  $R = 1.08$ y $\theta = 2$, ¿a qué tasa crece el consumo? ¿Y con
  $\theta = 1$?
- **F2.** Con $f(k) = k^{0.3}$, $\delta = 0.06$ y $\beta = 0.95$, calcula el
  capital de estado estacionario, el consumo y la tasa de ahorro. Compara
  la tasa de ahorro con la fórmula $s^\ast = \alpha(\delta + n)/(\delta + \rho)$
  de la sesión 12, con $n = 0$ y $\beta = 1/(1 + \rho)$.
- **F3.** En el recurso de la sección 5, con $g = 0.4$ y $K = 100$, ¿qué
  tasa de descuento hace que el acervo objetivo sea la mitad del que da el
  rendimiento máximo sostenible, $x^\ast = 25$? ¿Qué cosecha permanente da?
- **F4.** Sin cosecha, la logística tiene solución
  $x(t) = K/\big(1 + \tfrac{K - x_0}{x_0}e^{-gt}\big)$. Con $x_0 = 20$ y los
  datos de la sección 5.4 ($\rho = 0.05$), ¿cuántos años tarda la región en
  llegar a $x^\ast$ sin cosechar nada?

**Para profundizar** (opcionales)

- **F5.** Linealiza la ecuación de Euler alrededor del estado estacionario
  y muestra que tiene un eigenvalor menor que 1 y otro mayor que 1
  ([P.1](#pp1)). Con $u = \ln c$, $f(k) = Ak^\alpha$ y $\delta = 1$, comprueba
  que el estable es $\alpha$ (sesión 16, sección 4).
- **F6.** Con un costo de cosecha que baja con el acervo, el beneficio es
  $\big(p - c(x)\big)h$ con $c'(x) < 0$. Muestra que el arco singular cumple
  $G'(x^\ast) - c'(x^\ast)G(x^\ast)/\big(p - c(x^\ast)\big) = \rho$, la
  "ecuación fundamental de los recursos renovables". ¿Se conserva más o
  menos acervo que en la sección 5?
- **F7.** En la ecuación de Bellman de la sección 5.3, elige el acervo
  siguiente $y = x + G(x) - h$ en lugar de $h$. Muestra que, mientras
  $0 \le h \le h_{\max}$ no se active, el $y$ óptimo no depende de $x$:
  la región deja el acervo en $x^\ast$ desde el primer periodo en que puede.
  Es la aproximación más rápida en tiempo discreto.

## Para profundizar

Material opcional: demostraciones y temas que no se ven en clase. Cada
apartado indica de qué sección de las notas viene.

<a id="pp1"></a>

### P.1 El punto de silla en tiempo discreto (sección 1.4)

Sea $\Phi(k) = f(k) + (1 - \delta)k$, de modo que $c_t = \Phi(k_t) - k_{t+1}$ y
$\Phi'(k) = R$. En el estado estacionario, $\beta R = 1$. Con desviaciones
pequeñas $\hat k_t = k_t - k^\ast$ y $\hat c_t = c_t - c^\ast$,

$$
\hat c_t = \frac{1}{\beta}\thinspace\hat k_t - \hat k_{t+1}.
$$

Linealizar la ecuación de Euler, $u'(c_t) = \beta R(k_{t+1})u'(c_{t+1})$, con
$R'(k) = f''(k)$:

$$
u''\thinspace\hat c_t = u''\thinspace\hat c_{t+1} + \beta f''\thinspace u'\thinspace\hat k_{t+1},
$$

con $u'$, $u''$ y $f''$ evaluadas en el estado estacionario. Sea
$\gamma = \beta f''u'/u'' > 0$ (porque $f'' < 0$ y $u'' < 0$). Sustituyendo
$\hat c_t$ y $\hat c_{t+1}$,

$$
\hat k_{t+2} - \Big(1 + \frac{1}{\beta} + \gamma\Big)\hat k_{t+1} + \frac{1}{\beta}\thinspace\hat k_t = 0.
$$

Las raíces de $P(\lambda) = \lambda^2 - (1 + 1/\beta + \gamma)\lambda + 1/\beta$
cumplen $\lambda_1\lambda_2 = 1/\beta > 0$, $P(0) = 1/\beta > 0$ y
$P(1) = -\gamma < 0$: una está entre 0 y 1 y la otra es mayor que 1. Es un
**punto de silla discreto** ([D.A5](repaso/ecuaciones_diferenciales.md#da5)).
Con $k_0$ dado, la solución general es
$\hat k_t = A_1\lambda_1^t + A_2\lambda_2^t$; la transversalidad descarta la
raíz explosiva ($A_2 = 0$) y queda $\hat k_t = \lambda_1^t\hat k_0$: la región
cierra cada periodo la fracción $1 - \lambda_1$ de la brecha. Es la
discretización del punto de silla de la sesión 12.

<a id="pp2"></a>

### P.2 ¿Cuándo es derivable $V$? (sección 1.2)

La sección 1 usó $V'$ sin preguntar si existe. Benveniste y Scheinkman
(1979) dan condiciones: si $u$ y $f$ son cóncavas y diferenciables, $V$ es
cóncava y, donde la política es interior, diferenciable, con la derivada
que da la envolvente ([C.A2](repaso/calculo.md#ca2)). Sin concavidad, $V$
puede tener esquinas: por ejemplo, cuando se elige entre opciones
discretas, como migrar o quedarse en el Laboratorio 3, $V$ es el máximo de
dos funciones y tiene una esquina donde se cruzan. Ahí la ecuación de Euler
no se aplica tal cual.

---

## Referencias

- Benveniste, L. M., & Scheinkman, J. A. (1979). On the differentiability
  of the value function in dynamic models of economics. *Econometrica*,
  47(3), 727–732. https://doi.org/10.2307/1910417
- Clark, C. W. (1973). Profit maximization and the extinction of animal
  species. *Journal of Political Economy*, 81(4), 950–961.
  https://doi.org/10.1086/260090
- Conrad, J. M., & Rondeau, D. (2020). *Natural Resource Economics:
  Analysis, Theory, and Applications*. Cambridge University Press.
  https://doi.org/10.1017/9781108588928
