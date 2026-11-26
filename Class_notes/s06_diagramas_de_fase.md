# Sesión 6: Equilibrio, diagramas de fase y ecuaciones en diferencias

> **Cómo usar estas notas.** La clase se da en el pizarrón y cubre el núcleo
> de estas notas, no todas. El **plan de clase** de abajo dice qué secciones
> se escriben en el pizarrón, cuándo se proyecta el cuaderno
> (`Code/s06_diagramas_de_fase.jl`) y qué queda para leer. En el pizarrón
> van las ecuaciones y los resultados en recuadro; el texto que las rodea es
> lo que se explica de palabra. Como todo está aquí, en clase no hace falta
> copiar. El cuerpo de las notas es la **ruta básica** y se evalúa; las
> demostraciones y los temas opcionales están al final, en **Para
> profundizar**, y no se ven en clase.
>
> Las secciones marcadas con ★ son el **núcleo** que se ve en clase; las
> demás se leen por cuenta propia y se evalúan igual.
>
> Repaso recomendado: [D.B1–B2](repaso/ecuaciones_diferenciales.md#db1)
> (ecuaciones diferenciales y en diferencias, crecimiento exponencial),
> [A.B2](repaso/analisis.md#ab2) (sucesiones),
> [D.I1](repaso/ecuaciones_diferenciales.md#di1) (lineales de primer orden),
> [D.I4](repaso/ecuaciones_diferenciales.md#di4) (puntos fijos y diagramas
> de fase), [A.I5](repaso/analisis.md#ai5) (contracciones) y
> [C.I7](repaso/calculo.md#ci7) (desarrollo de Taylor).
>
> Lecturas: Strogatz (2015), cap. 2; Chiang y Wainwright (2006), cap. 17.

**Plan de clase** (120 minutos: 105 de núcleo y 15 de margen). El núcleo: el
criterio de la derivada para la estabilidad, en tiempo continuo y en tiempo
discreto.

| Minutos | Dónde | Qué | Secciones |
|---|---|---|---|
| 0–20 | Proyector y pizarra | La pregunta: ¿a dónde va una región? (cuaderno, sección 0); equilibrios, la recta de fase, el criterio de la derivada y la linealización; el caso $f'(x^\ast) = 0$, de palabra | 0, 1.1–1.3 |
| 20–40 | Pizarra y proyector | Solow: los equilibrios y $f'(k^\ast)$ en el pizarrón; la recta de fase y las trayectorias en el cuaderno | 1.4; cuaderno, sección 1 |
| 40–55 | Pizarra y proyector | Aglomeración: los tres equilibrios y el umbral; el umbral al mover $a$ | 1.5; cuaderno, sección 2 |
| 55–60 | | Pausa | |
| 60–85 | Pizarra | Ecuaciones en diferencias: la lineal (estable si $\lvert a\rvert < 1$, oscila si $a < 0$) y la no lineal ($\lvert g'(x^\ast)\rvert < 1$ y la telaraña); Solow en tiempo discreto | 2.1, 2.2, 2.4 |
| 85–100 | Parejas | Ejercicio F3 a mano | 6 |
| 100–105 | Pizarra | Cierre: continuo y discreto, lado a lado, con la tabla; sistemas en el plano (sesión 7) | 3, 4 |
| 105–120 | Margen | Si alcanza, en este orden: las seis zonas de $a$ (cuaderno, sección 3); telarañas de tres mapas y el método de Euler como ecuación en diferencias (cuaderno, secciones 4 y 5); el gran impulso más barato (cuaderno, sección 2) | |
| Después | Lectura | Lo que no entró del margen; contracciones (2.3), la telaraña de un mercado regional (2.5), del tiempo continuo al discreto (2.6), el resumen (5) y Para profundizar | |

Lo del **margen** se ve sólo si sobra tiempo, en el orden indicado; lo
que no se vea pasa a la lectura y se evalúa igual.

**Pregunta de la unidad.** ¿Convergen los estados de México? ¿A qué
velocidad?

---

## 0. La pregunta

En la sesión 5, la brecha de una región cumplía una ecuación **lineal**,
$\dot z = -\beta z$, y se podía resolver. Casi ningún modelo económico es
lineal: el capital del modelo de Solow, la población de una región que
atrae migrantes por aglomeración, un precio que responde con rezago. Esta
sesión responde dos preguntas sin resolver las ecuaciones:

1. **¿A dónde va el sistema?** A cuál equilibrio, según dónde empiece.
2. **¿Cómo llega?** Si se acerca directamente, oscilando o si se aleja.

La herramienta es el **diagrama de fase**: el signo de la ecuación dice
hacia dónde se mueve el estado, y la pendiente en el equilibrio dice si
regresa a él. En una dimensión basta una recta; en dos (sesiones 7 y 8), un
plano. El modelo de Ramsey de la sesión 12 se resuelve así.

---

## 1. Tiempo continuo: $\dot x = f(x)$ ★

Sea $f$ con derivada continua. La ecuación es **autónoma**: $f$ no depende
de $t$ ([D.B1](repaso/ecuaciones_diferenciales.md#db1)).

### 1.1 Equilibrios ★

Un **equilibrio** (o punto fijo) es un $x^\ast$ con $f(x^\ast) = 0$: si el
sistema empieza ahí, se queda ahí.

### 1.2 El diagrama de fase en la recta ★

Se grafica $f(x)$ contra $x$. Donde $f > 0$, $x$ crece: flecha a la
derecha. Donde $f < 0$, decrece: flecha a la izquierda. Los equilibrios son
los cruces con el eje.

**Proposición 1.** Toda solución de $\dot x = f(x)$ es monótona y converge
al primer equilibrio que encuentra en la dirección de las flechas. Si en esa
dirección no hay ningún equilibrio, crece (o decrece) sin límite, y puede
incluso explotar en tiempo finito: $\dot x = x^2$ con $x_0 > 0$ tiene la
solución $x(t) = x_0/(1 - x_0t)$, que se va a infinito en $t = 1/x_0$.

Las soluciones no oscilan ni cruzan un equilibrio: en una dimensión, para
ir de un lado a otro habría que pasar por un punto con $f = 0$, y ahí la
solución se queda. Ver [Para profundizar, P.1](#pp1).

**Consecuencia.** Con el dibujo de $f$ se sabe todo el comportamiento
cualitativo: a dónde va cada condición inicial, sin resolver nada.

### 1.3 Estabilidad ★

**Definición.** Un equilibrio $x^\ast$ es **localmente asintóticamente
estable** si las soluciones que empiezan suficientemente cerca de $x^\ast$
convergen a $x^\ast$. Es **inestable** si hay soluciones que empiezan tan
cerca como se quiera y se alejan.

**Proposición 2 (criterio de la derivada).** Sea $f(x^\ast) = 0$.
- Si $f'(x^\ast) < 0$, $x^\ast$ es localmente asintóticamente estable.
- Si $f'(x^\ast) > 0$, $x^\ast$ es inestable.
- Si $f'(x^\ast) = 0$, el criterio no decide.

La idea es que cerca del equilibrio $f$ se parece a su recta tangente
([C.I7](repaso/calculo.md#ci7)):

$$
\boxed{\ \dot x = f(x) \approx f'(x^\ast)(x - x^\ast)\ }
$$

Es la ecuación lineal de la sesión 5 con $a = -f'(x^\ast)$: la desviación
decae si $f'(x^\ast) < 0$ y crece si $f'(x^\ast) > 0$. Además,
$\lvert f'(x^\ast)\rvert$ mide la **velocidad** cerca del equilibrio: la
vida media de una desviación pequeña es $\ln 2/\lvert f'(x^\ast)\rvert$.
*Demostración*: en [Para profundizar, P.2](#pp2).

**Cuando $f'(x^\ast) = 0$.** La recta tangente es horizontal y no dice nada;
decide el signo de $f$ a cada lado:

| Ecuación | Signo de $f$ a la izquierda y a la derecha de 0 | El equilibrio $x^\ast = 0$ es |
|---|---|---|
| $\dot x = -x^3$ | $+$, $-$ | Estable (pero converge lentamente, no exponencialmente) |
| $\dot x = x^3$ | $-$, $+$ | Inestable |
| $\dot x = x^2$ | $+$, $+$ | **Semiestable**: atrae por la izquierda y repele por la derecha |

### 1.4 Ejemplo: Solow ★

El capital por trabajador de una región cumple

$$
\dot k = f(k) = sk^\alpha - (n + \delta)k,
\qquad 0 < \alpha < 1,
$$

con tasa de ahorro $s$, crecimiento de la población $n$ y depreciación
$\delta$. Los equilibrios salen de $f(k) = 0$:

$$
sk^\alpha = (n + \delta)k
\iff k = 0 \ \text{ o } \ k^{\alpha - 1} = \frac{n + \delta}{s}
\iff k = 0 \ \text{ o } \ k^\ast = \left(\frac{s}{n + \delta}\right)^{1/(1-\alpha)}.
$$

- Cerca de $k = 0$, $sk^\alpha$ domina a $(n + \delta)k$ y $f > 0$: el
  equilibrio $k = 0$ es inestable. (Ahí $f'$ no existe, porque
  $f'(k) \to \infty$; el diagrama de fase decide sin la derivada.)
- En $k^\ast$, usando $sk^{\ast\thinspace\alpha - 1} = n + \delta$,

$$
\boxed{\ f'(k^\ast) = \alpha sk^{\ast\thinspace\alpha - 1} - (n + \delta) = \alpha(n + \delta) - (n + \delta) = -(1 - \alpha)(n + \delta) < 0\ }
$$

  estable.

Toda región con $k > 0$ converge a $k^\ast$, y la velocidad cerca de
$k^\ast$ es $(1 - \alpha)(n + \delta)$, la misma que se obtuvo para el
ingreso en la sesión 5 (P.3). Con $s = 0.2$, $\alpha = 0.3$ y
$n + \delta = 0.06$:

$$
k^\ast = \left(\frac{0.2}{0.06}\right)^{1/0.7} \approx 5.58,
\qquad
\lvert f'(k^\ast)\rvert = 0.7 \times 0.06 = 0.042,
\qquad
\text{vida media} = \frac{\ln 2}{0.042} \approx 16.5 \text{ años}.
$$

**Lectura regional.** Si dos regiones tienen los mismos $s$, $\alpha$, $n$ y
$\delta$, convergen al mismo $k^\ast$: convergencia absoluta. Si difieren en
$s$ o en $n$, cada una va a su propio $k^\ast$: convergencia condicional,
y las brechas no se cierran (sesión 5, sección 3.3).

### 1.5 Ejemplo: aglomeración y umbrales ★

Una región atrae población según cuánto mejor se vive ahí que en el resto
del país. Con aglomeración, vivir en la región mejora con su tamaño al
principio (más empleos, más servicios) y empeora después (congestión). Sea
$L$ la población de la región y

$$
\dot L = f(L) = L\thinspace u(L),
\qquad
u(L) = a + bL - cL^2,
\qquad a < 0 < b,\ c > 0,
$$

donde $u(L)$ es la ventaja de vivir en la región respecto del resto del
país, y la migración neta es proporcional a la población. Con $a < 0$, una
región pequeña no tiene la masa crítica para atraer a nadie. Si
$b^2 > 4\lvert a\rvert c$, $u$ tiene dos raíces positivas, $L_1 < L_2$, y hay
tres equilibrios:

| Equilibrio | $f'$ | Tipo | Lectura |
|---|---|---|---|
| $L = 0$ | $f'(0) = a < 0$ | Estable | La región se vacía |
| $L_1$ | $L_1u'(L_1) > 0$ | Inestable | **Umbral** de masa crítica |
| $L_2$ | $L_2u'(L_2) < 0$ | Estable | Región consolidada |

(En $L_1$ y $L_2$, $u = 0$, así que $f'(L_i) = u(L_i) + L_iu'(L_i) = L_iu'(L_i)$;
$u$ crece en $L_1$ y decrece en $L_2$.)

Las raíces de $u$ salen de la fórmula cuadrática:

$$
u(L) = 0 \iff cL^2 - bL - a = 0 \iff
L_{1,2} = \frac{b \mp \sqrt{b^2 + 4ac}}{2c}
= \frac{b \mp \sqrt{b^2 - 4\lvert a\rvert c}}{2c}.
$$

Con $a = -0.3$, $b = 2$ y $c = 1.5$: $\sqrt{4 - 1.8} \approx 1.48$, así que
$L_1 \approx (2 - 1.48)/3 \approx 0.17$ y $L_2 \approx (2 + 1.48)/3 \approx 1.16$.

**Lectura regional.**
- **La historia importa.** Dos regiones idénticas pueden terminar en
  equilibrios distintos sólo porque empezaron a un lado o al otro del
  umbral. La economía no "converge" a un único destino.
- **Política de gran impulso.** Un subsidio temporal que lleve a la región
  por encima de $L_1$ basta: después, la región crece sola hasta $L_2$,
  aunque el subsidio se retire. Un subsidio que no cruce el umbral se
  pierde.
- **Un equilibrio inestable no se observa.** El umbral $L_1$ es un punto de
  equilibrio, pero cualquier perturbación aleja a la región de él.

Es la lógica de los modelos de nueva geografía económica, en la versión más
simple posible. El modelo es ilustrativo, construido para esta sesión.

---

## 2. Tiempo discreto: ecuaciones en diferencias

### 2.1 La ecuación lineal $y_{t+1} = ay_t + b$ ★

Con $a \ne 1$, el punto fijo cumple $y^\ast = ay^\ast + b$, así que
$y^\ast = b/(1 - a)$. Restando las dos ecuaciones, la desviación
$z_t = y_t - y^\ast$ cumple

$$
\begin{aligned}
y_{t+1} - y^\ast &= (ay_t + b) - (ay^\ast + b) = a\thinspace(y_t - y^\ast), \cr
z_{t+1} &= az_t
\quad\Longrightarrow\quad
z_t = a^tz_0,
\end{aligned}
$$

y entonces

$$
\boxed{\ y_t = y^\ast + a^t(y_0 - y^\ast)\ }
$$

Como en la sesión 5, **solución = equilibrio + desviación**; la desviación
se multiplica por $a$ en cada periodo ([A.B2](repaso/analisis.md#ab2),
[D.I1](repaso/ecuaciones_diferenciales.md#di1)):

| $a$ | Comportamiento |
|---|---|
| $0 < a < 1$ | Converge monótonamente |
| $-1 < a < 0$ | Converge **oscilando**: la desviación cambia de signo cada periodo |
| $a > 1$ | Se aleja monótonamente |
| $a < -1$ | Se aleja oscilando |
| $a = -1$ | Oscila para siempre entre dos valores (ciclo de periodo 2) |
| $a = 1$ | No hay punto fijo (si $b \ne 0$): $y_t = y_0 + bt$ |

**El punto fijo es estable si y sólo si $\lvert a\rvert < 1$**, y la
trayectoria oscila si y sólo si $a < 0$.

**La diferencia con el tiempo continuo.** Una ecuación diferencial de primer
orden **nunca** oscila (Proposición 1). Una ecuación en diferencias de
primer orden sí puede: en tiempo discreto, el estado salta de un valor a
otro sin pasar por los intermedios, y puede brincar al otro lado del
equilibrio.

### 2.2 La ecuación no lineal $x_{t+1} = g(x_t)$ ★

Un **punto fijo** cumple $g(x^\ast) = x^\ast$: gráficamente, es un cruce de
$y = g(x)$ con la diagonal $y = x$. Cerca de él,

$$
\boxed{\ x_{t+1} - x^\ast = g(x_t) - g(x^\ast) \approx g'(x^\ast)(x_t - x^\ast)\ }
$$

que es la ecuación lineal de la sección 2.1 con $a = g'(x^\ast)$.

**Proposición 3.** Sea $g(x^\ast) = x^\ast$.
- Si $\lvert g'(x^\ast)\rvert < 1$, $x^\ast$ es localmente asintóticamente
  estable; la convergencia es monótona si $g'(x^\ast) > 0$ y oscilante si
  $g'(x^\ast) < 0$.
- Si $\lvert g'(x^\ast)\rvert > 1$, $x^\ast$ es inestable.
- Si $\lvert g'(x^\ast)\rvert = 1$, el criterio no decide.

*Demostración*: en [Para profundizar, P.2](#pp2).

**El diagrama de telaraña.** Se grafican $y = g(x)$ y la diagonal. Desde
$x_0$, se sube (o baja) a la curva para obtener $x_1 = g(x_0)$, se va
horizontalmente a la diagonal para pasar $x_1$ al eje horizontal, y se
repite ([D.I4](repaso/ecuaciones_diferenciales.md#di4)). Si $g$ cruza la
diagonal con pendiente entre 0 y 1, la trayectoria es una escalera hacia el
punto fijo; con pendiente entre $-1$ y 0, una espiral cuadrada.

### 2.3 Convergencia global: contracciones

El criterio de la derivada es **local**. Para asegurar que la iteración
converge desde cualquier punto de partida, hace falta una cota uniforme
([A.I5](repaso/analisis.md#ai5)):

**Proposición 4.** Si $g$ manda un intervalo cerrado $I$ en sí mismo y
$\lvert g'(x)\rvert \le \rho < 1$ en todo $I$, entonces $g$ tiene un único
punto fijo en $I$, y para todo $x_0 \in I$,

$$
\lvert x_t - x^\ast\rvert \le \rho^t\lvert x_0 - x^\ast\rvert.
$$

Es la versión en una dimensión del teorema del punto fijo de Banach, que
garantiza que la iteración de la función valor converge (sesión 16).
*Demostración*: en [Para profundizar, P.3](#pp3).

### 2.4 Ejemplo: Solow en tiempo discreto ★

En la sesión 1, el capital de una región con tasa de inversión constante
cumplía

$$
K_{t+1} = g(K_t) = (1 - \delta)K_t + sK_t^\alpha.
$$

El punto fijo es $K^\ast = (s/\delta)^{1/(1-\alpha)}$ y, usando
$sK^{\ast\thinspace\alpha - 1} = \delta$,

$$
g'(K^\ast) = 1 - \delta + \alpha sK^{\ast\thinspace\alpha - 1} = 1 - (1 - \alpha)\delta \in (0, 1).
$$

La convergencia es monótona. Con $\alpha = 0.3$ y $\delta = 0.05$,
$g'(K^\ast) = 0.965$: cerca de $K^\ast$, cada año queda el 96.5% de la
brecha. Por eso en la sesión 1 el capital apenas llegó a 5.4 en 40 años,
con $K^\ast \approx 7.25$.

### 2.5 Ejemplo: la telaraña de un mercado regional

Un cultivo regional se siembra con el precio del año anterior. La oferta de
este año es $q_t^s = C + Dp_{t-1}$, la demanda es $q_t^d = A - Bp_t$, con
$A, B, D > 0$, y el mercado se vacía cada año. Igualando,

$$
p_t = \frac{A - C}{B} - \frac{D}{B}\thinspace p_{t-1}.
$$

Es una ecuación lineal con $a = -D/B < 0$: **el precio siempre oscila**. Un
año de precio alto lleva a sembrar mucho, lo que baja el precio del año
siguiente, lo que lleva a sembrar poco. El precio de equilibrio,
$p^\ast = (A - C)/(B + D)$, es estable si $D < B$: si la oferta responde al
precio menos que la demanda. Si la oferta es más sensible que la demanda,
las oscilaciones crecen. Es el modelo de la telaraña de Chiang y Wainwright
(sec. 17.4).

### 2.6 Del tiempo continuo al discreto

El método de Euler aplicado a $\dot y = -a(y - y^\ast)$, con paso
$\Delta t$, es la ecuación en diferencias

$$
y_{k+1} - y^\ast = (1 - a\thinspace\Delta t)(y_k - y^\ast).
$$

Por la sección 2.1: converge monótonamente si $a\thinspace\Delta t < 1$,
oscila si $1 < a\thinspace\Delta t < 2$ y diverge si $a\thinspace\Delta t > 2$,
**aunque la ecuación diferencial sea estable**. Es lo que se vio en el
cuaderno de la sesión 5. La oscilación es un defecto de la aproximación, no
del modelo: para simular bien hace falta un paso pequeño respecto de la
velocidad del sistema.

---

## 3. Continuo y discreto, lado a lado ★

| | Tiempo continuo, $\dot x = f(x)$ | Tiempo discreto, $x_{t+1} = g(x_t)$ |
|---|---|---|
| Equilibrio | $f(x^\ast) = 0$ | $g(x^\ast) = x^\ast$ |
| Estable si | $f'(x^\ast) < 0$ | $\lvert g'(x^\ast)\rvert < 1$ |
| Oscila | Nunca (en una dimensión) | Si $g'(x^\ast) < 0$ |
| Velocidad cerca de $x^\ast$ | La desviación se multiplica por $e^{f'(x^\ast)}$ cada unidad de tiempo | La desviación se multiplica por $g'(x^\ast)$ cada periodo |
| Diagrama | Recta de fase | Telaraña |
| Caso lineal | $\dot y + ay = b$: estable si $a > 0$ | $y_{t+1} = ay_t + b$: estable si $\lvert a\rvert < 1$ |

Las dos columnas coinciden si $g(x) = x + f(x)\Delta t$ con $\Delta t$
pequeño: $g'(x^\ast) = 1 + f'(x^\ast)\Delta t$, que es menor que 1 si y sólo
si $f'(x^\ast) < 0$.

---

## 4. Hacia la optimización dinámica

| Idea de esta sesión | Dónde reaparece |
|---|---|
| Diagrama de fase en la recta | Diagrama de fase en el plano y el punto de silla de Ramsey (sesiones 7, 8 y 12) |
| Estabilidad por la derivada en el equilibrio | Estabilidad por los eigenvalores del jacobiano (sesiones 7 y 8) |
| Contracción e iteración de punto fijo | Iteración de la función valor y operador de Bellman (sesiones 15 y 16) |
| Euler como ecuación en diferencias | Elegir el método numérico y el paso en los laboratorios (sesión 9) |

---

## 5. Resumen formal

| Concepto | Enunciado | Dónde |
|---|---|---|
| Equilibrio continuo | $f(x^\ast) = 0$ | 1.1 |
| Recta de fase | Las soluciones son monótonas y van hacia donde apuntan las flechas | 1.2 |
| Estabilidad continua | Estable si $f'(x^\ast) < 0$; inestable si $f'(x^\ast) > 0$ | 1.3 |
| Velocidad | Vida media cerca de $x^\ast$: $\ln 2/\lvert f'(x^\ast)\rvert$ | 1.3 |
| Solow | $f'(k^\ast) = -(1 - \alpha)(n + \delta)$ | 1.4 |
| Umbrales | Un equilibrio inestable entre dos estables separa destinos distintos | 1.5 |
| Lineal discreta | $y_t = y^\ast + a^t(y_0 - y^\ast)$; estable si $\lvert a\rvert < 1$; oscila si $a < 0$ | 2.1 |
| No lineal discreta | Estable si $\lvert g'(x^\ast)\rvert < 1$ | 2.2 |
| Contracción | $\lvert g'\rvert \le \rho < 1$ en un intervalo invariante: punto fijo único y convergencia global | 2.3 |
| Telaraña | Estable si la oferta responde menos que la demanda ($D < B$) | 2.5 |
| Euler | Con paso grande, una ecuación estable puede simularse oscilante o divergente | 2.6 |

---

## 6. Ejercicios formales

- **F1.** Encuentra los equilibrios de $\dot x = x(1 - x)(x - 0.3)$, dibuja la
  recta de fase y clasifícalos. ¿A dónde va la solución que empieza en
  $x_0 = 0.2$? ¿Y en $x_0 = 0.5$?
- **F2.** En el modelo de Solow con $s = 0.2$, $\alpha = 0.3$ y
  $n + \delta = 0.06$, calcula $k^\ast$ y la vida media de una desviación
  pequeña. ¿Cómo cambian si la región ahorra el doble?
- **F3.** Resuelve $y_{t+1} = -0.5y_t + 3$ con $y_0 = 0$. Calcula $y_1$ a
  $y_4$, el punto fijo y di si converge y cómo.
- **F4.** En el modelo de aglomeración con $a = -0.3$, $b = 2$ y $c = 1.5$,
  verifica los valores de $L_1$ y $L_2$ y clasifica los tres equilibrios.
  ¿Qué pasa con $L_1$ y $L_2$ si una política mejora la ventaja de la región
  ($a$ sube a $-0.1$)? Interpreta.

**Para profundizar** (opcionales)

- **F5.** Para $x_{t+1} = rx_t(1 - x_t)$ con $0 < r < 4$, encuentra el punto
  fijo positivo y muestra que es estable si $1 < r < 3$. ¿Para qué valores
  de $r$ la convergencia es oscilante?
- **F6.** Muestra que en la telaraña de la sección 2.5 la desviación del
  precio respecto de $p^\ast$ se multiplica por $-D/B$ cada año. Si
  $D = B$, ¿qué pasa?
- **F7.** Muestra que $g(x) = 1 + 0.5\cos x$ es una contracción en
  $\mathbb{R}$ y estima cuántas iteraciones hacen falta para que el error
  sea menor que $10^{-6}$ empezando en $x_0 = 0$.

## Para profundizar

Material opcional: demostraciones y temas que no se ven en clase. Cada
apartado indica de qué sección de las notas viene.

<a id="pp1"></a>

### P.1 Las soluciones en la recta son monótonas (sección 1.2)

Sea $x(t)$ una solución con $f(x_0) > 0$. Mientras $f(x(t)) > 0$, $x$
crece. Si llegara a un equilibrio $x^\ast$ en un tiempo finito $t_1$,
habría dos soluciones que pasan por $x^\ast$ en $t_1$: la constante
$x(t) \equiv x^\ast$ y la nuestra. Con $f$ de derivada continua, las
soluciones son únicas, así que eso no puede pasar. Entonces $f(x(t)) > 0$
para todo $t$ y $x$ crece siempre. Una función creciente converge (si está
acotada) o se va a $+\infty$ ([A.B2](repaso/analisis.md#ab2)); si converge
a un límite $\bar x$, entonces $\dot x = f(x(t)) \to f(\bar x)$. Si fuera
$f(\bar x) > 0$, a partir de algún momento $x$ crecería al menos a una
velocidad constante positiva y no podría estar acotada. Entonces
$f(\bar x) = 0$: el límite es el siguiente equilibrio a la derecha. El caso
$f(x_0) < 0$ es simétrico.

<a id="pp2"></a>

### P.2 El criterio de la derivada (secciones 1.3 y 2.2)

**Tiempo continuo.** Si $f'(x^\ast) < 0$, por continuidad de $f'$ existen
$\varepsilon > 0$ y $c > 0$ con $f'(x) \le -c$ en
$[x^\ast - \varepsilon, x^\ast + \varepsilon]$. Por el teorema del valor
medio, $f(x) = f'(\xi)(x - x^\ast)$ con $\xi$ entre $x$ y $x^\ast$, así que

$$
\frac{d}{dt}(x - x^\ast)^2 = 2(x - x^\ast)f(x) = 2f'(\xi)(x - x^\ast)^2 \le -2c\thinspace(x - x^\ast)^2.
$$

Entonces $(x(t) - x^\ast)^2 \le e^{-2ct}(x_0 - x^\ast)^2$: la solución no sale
del intervalo y converge exponencialmente. Con $f'(x^\ast) > 0$, el mismo
argumento con la desigualdad al revés muestra que la distancia crece
mientras la solución siga cerca.

**Tiempo discreto.** Si $\lvert g'(x^\ast)\rvert < 1$, existen $\varepsilon > 0$
y $\rho < 1$ con $\lvert g'(x)\rvert \le \rho$ en
$I = [x^\ast - \varepsilon, x^\ast + \varepsilon]$. Por el valor medio,
$\lvert g(x) - x^\ast\rvert = \lvert g'(\xi)\rvert\thinspace\lvert x - x^\ast\rvert \le \rho\lvert x - x^\ast\rvert$:
$g$ manda $I$ en $I$ y la distancia se multiplica por $\rho$ o menos en cada
paso. Si $g'(x^\ast) < 0$, el signo de $x_t - x^\ast$ se alterna cerca del
equilibrio: oscila.

<a id="pp3"></a>

### P.3 Contracciones en una dimensión (sección 2.3)

Por el valor medio, $\lvert g(x) - g(y)\rvert \le \rho\lvert x - y\rvert$
para $x, y \in I$. **Unicidad**: si $x^\ast$ y $y^\ast$ fueran puntos fijos,
$\lvert x^\ast - y^\ast\rvert = \lvert g(x^\ast) - g(y^\ast)\rvert \le \rho\lvert x^\ast - y^\ast\rvert$,
lo que obliga a $x^\ast = y^\ast$. **Existencia**: $h(x) = g(x) - x$ cumple
$h(\min I) \ge 0$ y $h(\max I) \le 0$, porque $g$ manda $I$ en $I$; por el
teorema del valor intermedio, $h$ se anula en $I$. **Convergencia**:
$\lvert x_{t+1} - x^\ast\rvert = \lvert g(x_t) - g(x^\ast)\rvert \le \rho\lvert x_t - x^\ast\rvert$,
y se aplica $t$ veces. En la sesión 16, el mismo argumento se hace con
funciones en lugar de números, y la derivada se reemplaza por el factor de
descuento $\beta$.

---

## Referencias

- Chiang, A. C., & Wainwright, K. (2006). *Métodos fundamentales de economía
  matemática* (4.ª ed.). McGraw-Hill.
- Strogatz, S. H. (2015). *Nonlinear Dynamics and Chaos* (2.ª ed.). Westview
  Press.
