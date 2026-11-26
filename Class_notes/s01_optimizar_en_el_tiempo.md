# Sesión 1: Por qué optimizar en el tiempo

> **Cómo usar estas notas.** La clase se da en el pizarrón y cubre el núcleo
> de estas notas, no todas. El **plan de clase** de abajo dice qué secciones
> se escriben en el pizarrón, cuándo se proyecta el cuaderno
> (`Code/s01_optimizar_en_el_tiempo.jl`) y qué queda para leer. En el
> pizarrón van las ecuaciones y los resultados en recuadro; el texto que las
> rodea es lo que se explica de palabra. Como todo está aquí, en clase no
> hace falta copiar. El cuerpo de las notas es la **ruta básica** y se
> evalúa; las demostraciones y los temas opcionales están al final, en
> **Para profundizar**, y no se ven en clase.
>
> Las secciones marcadas con ★ son el **núcleo** que se ve en clase; las
> demás se leen por cuenta propia y se evalúan igual.
>
> En esta sesión se resuelve en clase el [diagnóstico de
> matemáticas](repaso/diagnostico_inicial.md): te dice qué claves del
> repaso necesitas. Repaso recomendado:
> [C.B2](repaso/calculo.md#cb2) (máximos en una variable),
> [C.B3](repaso/calculo.md#cb3) (exponencial y logaritmo),
> [A.B2–B3](repaso/analisis.md#ab2) (sucesiones, series y descuento) y
> [D.B1–B2](repaso/ecuaciones_diferenciales.md#db1) (ecuaciones
> diferenciales y en diferencias).
>
> Lecturas: Becerril Fonseca et al. (2002), para el repaso de cálculo en
> varias variables. Opcional, como adelanto del curso: Chiang (1992), cap. 1.

**Plan de clase** (120 minutos: 105 de núcleo y 15 de margen). El núcleo:
reconocer un problema dinámico y escribirlo con sus cuatro piezas (estado,
control, ecuación de movimiento y objetivo), empezando por el problema de
dos periodos y terminando con el problema de tesis de cada estudiante.

| Minutos | Dónde | Qué | Secciones |
|---|---|---|---|
| 0–10 | Pizarra | Presentación: el curso, la evaluación y el proyecto ligado a la tesis | — |
| 10–40 | Individual | Diagnóstico de matemáticas, sin calculadora, con la pregunta abierta sobre la tesis | `repaso/diagnostico_inicial.md` |
| 40–45 | | Pausa | |
| 45–50 | Proyector | Las brechas entre regiones, 2003–2023 | 0; cuaderno, sección 0 |
| 50–70 | Pizarra | Estático contra dinámico; el problema de dos periodos y la ecuación de Euler | 1.1–1.3 |
| 70–87 | Pizarra | Estado, control y ecuación de movimiento en tiempo discreto; la formulación en tiempo continuo, sólo enunciada; cómo distinguir el estado del control | 2.1, 2.2 (sólo la formulación), 2.3 |
| 87–102 | Pizarra | Tu problema de tesis: estado, control, ecuación de movimiento y objetivo. Qué se entrega en la sesión 12 | 6 |
| 102–105 | Pizarra | Cierre: el hilo conductor, invertir en una región o en otra, sólo como pregunta; se resuelve en la sesión 14 | 4.1 |
| 105–120 | Margen | Si alcanza, en este orden: una región con tasa de inversión fija, su estado estacionario y por qué una regla constante no es óptima (3.1, 3.3; cuaderno, sección 2); el modelo de dos regiones y una política con un cambio (4.2, 4.4; cuaderno, sección 3) | |
| Después | Lectura | Lo que no entró del margen; el tiempo continuo en detalle (2.2), trayectorias y reglas (2.4), la regla de oro (3.2), políticas sin cambio (4.3), las herramientas del curso (5), el resumen (7) y Para profundizar | |

Lo del **margen** se ve sólo si sobra tiempo, en el orden indicado; lo
que no se vea pasa a la lectura y se evalúa igual.

El cuaderno se proyecta en clase; cada estudiante lo abre después del
Laboratorio 0 (sesión 4), cuando ya tiene Julia instalado.

**Pregunta de la unidad.** ¿Cómo repartir un fondo de inversión entre dos
regiones?

---

## 0. Motivación: las brechas entre regiones

Entre 2003 y 2023, el PIB per cápita sin petróleo de la Ciudad de México
pasó de 321 a 412 mil pesos de 2018 por persona, y el de Chiapas, de 70 a
63 mil (datos del INEGI y la OCDE en `Data/entidades.csv`). La razón entre
los dos pasó de 4.6 a 6.5: la brecha no se cerró, se abrió. La Unidad II
mide la convergencia con todas las entidades (sesión 5).

Este curso estudia otra pregunta: **si un gobierno puede invertir en las
regiones, ¿cómo debe hacerlo?** Invertir hoy en una región aumenta su
capital mañana, y con él lo que se podrá producir e invertir después. Una
decisión que cambia las posibilidades futuras es la marca de un problema
**dinámico**.

---

## 1. Optimización estática y dinámica ★

### 1.1 El problema estático ★

Un problema de optimización **estático** elige un punto $x$ de un conjunto
factible $X$:

$$
\max_{x \in X} f(x).
$$

La sesión 2 resuelve uno: repartir un fondo $B$ entre dos regiones, con
$X = \lbrace (x_1, x_2) \ge 0 : x_1 + x_2 \le B\rbrace$. Se decide una sola
vez y el conjunto factible no depende de decisiones anteriores.

### 1.2 Un problema de dos periodos ★

Un gobierno regional recibe $y_0$ hoy y $y_1$ mañana. Lo que no gasta hoy lo
invierte a una tasa bruta $R > 0$: cada peso rinde $R$ pesos mañana. Gasta
$c_0$ hoy y $c_1$ mañana, y resuelve

$$
\max_{c_0}\ \ln c_0 + \beta\ln c_1
\qquad\text{sujeto a}\qquad c_1 = y_1 + R\thinspace(y_0 - c_0),
$$

con **factor de descuento** $0 < \beta < 1$: una unidad de bienestar mañana
vale $\beta$ unidades de bienestar hoy. No es lo mismo que un peso: lo que
vale hoy un peso de mañana depende de cuánto se gasta en cada periodo, y en
el óptimo es $1/R$. Si $c_0 > y_0$, el gobierno se endeuda.

**Proposición 1.** El gasto óptimo es

$$
\boxed{\ c_0^\ast = \frac{1}{1 + \beta}\left(y_0 + \frac{y_1}{R}\right),
\qquad
c_1^\ast = \beta R\thinspace c_0^\ast\ }
$$

y cumple la **ecuación de Euler**

$$
\boxed{\ \frac{1}{c_0^\ast} = \beta R\thinspace\frac{1}{c_1^\ast}\ }
$$

*Demostración.* Se sustituye la restricción en el objetivo, que queda en
función de $c_0$ sola, y se deriva ([C.B2](repaso/calculo.md#cb2)):

$$
\begin{aligned}
U(c_0) &= \ln c_0 + \beta\ln\big(y_1 + R(y_0 - c_0)\big), \cr
U'(c_0) &= \frac{1}{c_0} + \beta\thinspace\frac{-R}{y_1 + R(y_0 - c_0)}
= \frac{1}{c_0} - \frac{\beta R}{c_1} = 0.
\end{aligned}
$$

Es la ecuación de Euler, y da $c_1 = \beta R\thinspace c_0$. La restricción se
reescribe como el **presupuesto intertemporal** (el valor presente del gasto
es igual al del ingreso), y se sustituye $c_1$:

$$
\begin{aligned}
c_1 = y_1 + R(y_0 - c_0)
&\iff c_0 + \frac{c_1}{R} = y_0 + \frac{y_1}{R} \cr
c_0 + \frac{\beta R\thinspace c_0}{R} = c_0(1 + \beta)
&= y_0 + \frac{y_1}{R}
\ \Rightarrow\ c_0^\ast = \frac{1}{1 + \beta}\left(y_0 + \frac{y_1}{R}\right).
\end{aligned}
$$

Por último, $U''(c_0) = -1/c_0^2 - \beta R^2/c_1^2 < 0$: $U$ es cóncava y el
punto crítico es el máximo global. $\square$

**Lectura económica.** La ecuación de Euler dice que, en el margen, da lo
mismo gastar un peso hoy (beneficio $1/c_0$) que invertirlo y gastar $R$
pesos mañana (beneficio $R/c_1$, descontado con $\beta$). Tres casos:

- Si $\beta R = 1$, el gasto es igual en los dos periodos: el gobierno
  **suaviza** el gasto, ahorrando si $y_0 > y_1$ y endeudándose si no.
- Si $\beta R > 1$, invertir rinde más de lo que pesa la impaciencia y el
  gasto crece: $c_1 > c_0$.
- Si $\beta R < 1$, el gasto decrece.

La regla sencilla **gastar lo que entra** ($c_0 = y_0$) sólo es óptima si
$y_1 = \beta R\thinspace y_0$, es decir, por casualidad (ejercicio F3).

**Ejemplo numérico.** Con $y_0 = 100$, $y_1 = 50$, $\beta = 0.95$ y
$R = 1.05$:

$$
y_0 + \frac{y_1}{R} = 100 + \frac{50}{1.05} = 147.62,
\qquad
c_0^\ast = \frac{147.62}{1.95} = 75.7,
\qquad
c_1^\ast = 0.9975 \times 75.7 = 75.5.
$$

El gobierno ahorra $100 - 75.7 = 24.3$ hoy para no tener que recortar el
gasto mañana.

La ecuación de Euler es la condición que más se repite en el curso: en el
cálculo de variaciones (sesión 10), en la regla de Keynes-Ramsey (sesión
12) y en tiempo discreto (sesión 18).

### 1.3 Qué hace dinámico a un problema ★

En el problema de dos periodos, la decisión de hoy cambia lo que se puede
gastar mañana. Con muchos periodos, esa liga se resume en una variable que
pasa de un periodo al siguiente: el ahorro acumulado, el capital, la
población. Esa variable es el **estado**, y su presencia es lo que hace
dinámico a un problema.

---

## 2. Los ingredientes de un problema dinámico

### 2.1 Tiempo discreto ★

**Definición (problema de control en tiempo discreto).** Dados un estado
inicial $x_0$ y un horizonte $T$, se elige una sucesión de controles
$u_0, u_1, \dots, u_{T-1}$ para resolver

$$
\boxed{\ \max\ \sum_{t=0}^{T-1} \beta^t\thinspace r(x_t, u_t) + \beta^T S(x_T)
\qquad\text{sujeto a}\qquad
x_{t+1} = g(x_t, u_t),\quad u_t \in \Gamma(x_t)\ }
$$

| Elemento | Nombre | Qué es |
|---|---|---|
| $x_t$ | **Estado** | Lo que se hereda del pasado y resume lo que importa de él |
| $u_t$ | **Control** | Lo que se decide en el periodo $t$ |
| $g$ | **Ecuación de movimiento** | Cómo el control de hoy determina el estado de mañana |
| $r(x_t, u_t)$ | **Recompensa** | Lo que se obtiene en el periodo $t$ |
| $\beta^t$ | **Descuento** | El peso del periodo $t$ visto desde hoy ([A.B3](repaso/analisis.md#ab3)) |
| $S(x_T)$ | **Valor terminal** | Lo que vale el estado al final; puede ser cero |
| $\Gamma(x_t)$ | **Conjunto factible** | Los controles permitidos, que pueden depender del estado |
| $T$ | **Horizonte** | Finito, o $T = \infty$ (y entonces no hay valor terminal) |

La ecuación de movimiento es una **ecuación en diferencias**
([D.B1](repaso/ecuaciones_diferenciales.md#db1)): conocida la regla para
elegir el control, determina toda la trayectoria del estado.

### 2.2 Tiempo continuo

En tiempo continuo, el control es una función $u(t)$ y el estado cumple una
**ecuación diferencial**:

$$
\max\ \int_0^T e^{-\rho t} F\big(x(t), u(t)\big)\thinspace dt + e^{-\rho T} S\big(x(T)\big)
\qquad\text{sujeto a}\qquad
\dot x = f(x, u),\quad x(0) = x_0,\quad u(t) \in U.
$$

La **tasa de descuento** $\rho > 0$ hace el papel de $\beta$: con periodos
de un año, $\beta = e^{-\rho}$ ([C.B3](repaso/calculo.md#cb3)). Por qué la
suma descontada se convierte en una integral: en [Para profundizar,
P.1](#pp1).

El curso usa las dos formulaciones. La continua lleva al **principio del
máximo** (Unidad III); la discreta, a la **ecuación de Bellman** (Unidad
IV). Muchos problemas se pueden escribir de las dos formas, y la sesión 19
compara las soluciones.

### 2.3 Cómo distinguir el estado del control ★

Tres preguntas ayudan:

1. **¿Se puede cambiar de golpe?** El control sí: se elige cada periodo. El
   estado no: sólo cambia a través de la ecuación de movimiento.
2. **¿Se hereda?** El estado al inicio del periodo $t$ es el resultado de
   las decisiones anteriores.
3. **¿Resume el pasado?** Para decidir hoy, basta conocer el estado actual;
   no hace falta conocer cómo se llegó a él.

| Situación regional | Estado | Control | Ecuación de movimiento |
|---|---|---|---|
| Infraestructura | Capital público $K_t$ | Inversión $I_t$ | $K_{t+1} = (1 - \delta)K_t + I_t$ |
| Educación | Capital humano $h_t$ | Gasto en escuelas $e_t$ | $h_{t+1} = (1 - \delta_h)h_t + \phi(e_t)$ |
| Pesquería | Biomasa $x_t$ | Captura $q_t$ | $x_{t+1} = x_t + G(x_t) - q_t$ |
| Deuda estatal | Deuda $d_t$ | Déficit primario $f_t$ | $d_{t+1} = R\thinspace d_t + f_t$ |
| Migración | Región donde se vive $r_t$ | Región elegida $r_{t+1}$ | $r_{t+1}$ es el control mismo |

En la última fila, el control de hoy *es* el estado de mañana: un caso
frecuente en problemas de elección discreta (sesión 19).

### 2.4 Trayectorias y reglas

Una solución puede darse de dos maneras:

- Como **trayectoria**: la lista de controles $u_0, u_1, \dots$ o la
  función $u(t)$, calculada desde el inicio.
- Como **regla** o **política**: una función $u_t = \sigma(x_t)$ que dice
  qué hacer en cada estado.

Sin incertidumbre, las dos dan la misma trayectoria del estado. El control
óptimo suele dar trayectorias; la programación dinámica, reglas. Con
incertidumbre (sesión 19) sólo sirven las reglas, porque el estado de
mañana no se conoce hoy.

---

## 3. Ejemplo: una región con tasa de inversión constante

Una región produce $y_t = K_t^{\alpha}$, con $0 < \alpha < 1$, invierte una
fracción constante $s \in [0, 1)$ y gasta el resto. Su capital se deprecia a
la tasa $\delta$:

$$
c_t = (1 - s)K_t^{\alpha},
\qquad
K_{t+1} = (1 - \delta)K_t + sK_t^{\alpha}.
$$

### 3.1 El estado estacionario de la regla

Con $s$ fija, la ecuación de movimiento es una ecuación en diferencias no
lineal. Un **estado estacionario** es un punto fijo, $K_{t+1} = K_t = K^\ast$:

$$
\begin{aligned}
K^\ast &= (1 - \delta)K^\ast + s(K^\ast)^{\alpha} \cr
\delta K^\ast &= s(K^\ast)^{\alpha} \cr
(K^\ast)^{1 - \alpha} &= \frac{s}{\delta}
\quad\Longrightarrow\quad
\boxed{\ K^\ast = \left(\frac{s}{\delta}\right)^{1/(1-\alpha)}\ }
\end{aligned}
$$

Con $s = 0.2$, $\delta = 0.05$ y $\alpha = 0.3$: $s/\delta = 4$ y
$K^\ast = 4^{1/0.7} \approx 7.25$. Si se empieza en $K_0 = 1$, el capital crece hacia $K^\ast$ sin
llegar en 40 años (en el cuaderno llega a 5.4). Por qué converge y a qué
velocidad es el tema de la Unidad II (sesión 6).

### 3.2 La regla de oro

En el estado estacionario, el gasto es
$c^\ast(s) = (1 - s)(K^\ast)^{\alpha} = (1 - s)(s/\delta)^{\alpha/(1-\alpha)}$.
Derivando su logaritmo ([C.B2](repaso/calculo.md#cb2)),

$$
\frac{d}{ds}\ln c^\ast = -\frac{1}{1 - s} + \frac{\alpha}{1 - \alpha}\cdot\frac{1}{s} = 0
\quad\Longrightarrow\quad
s = \alpha .
$$

La tasa $s = \alpha$, la **regla de oro**, da el mayor gasto *de largo
plazo*. Pero llegar ahí cuesta: hay que gastar menos mientras el capital se
acumula. Quien descuenta el futuro ($\beta < 1$) prefiere invertir menos. En
el cuaderno, con $T = 40$, la mejor tasa constante es 0.15, 0.20 y 0.23 para
$\beta = 0.90$, $0.95$ y $0.99$: crece con $\beta$ y se queda debajo de
$\alpha = 0.3$.

### 3.3 Una regla constante no es óptima

**Proposición 2.** Con horizonte finito y sin valor terminal ($S = 0$),
ninguna tasa constante $s > 0$ es óptima entre todas las sucesiones
$s_0, s_1, \dots, s_{T-1}$.

*Demostración.* Lo invertido en el último periodo, $s\thinspace y_{T-1}$, sólo
aumenta $K_T$, que no vale nada. Si en ese periodo se cambia $s$ por 0, el
gasto $c_{T-1}$ aumenta y nada más cambia, así que el objetivo aumenta. $\square$

El argumento dice más: conviene invertir menos al acercarse el final. La
mejor política **cambia con el tiempo**, y encontrarla es el problema del
control óptimo y de la programación dinámica.

---

## 4. El hilo conductor: invertir en una región o en otra

### 4.1 Dos versiones del mismo problema

| Sesión | Versión | Herramienta |
|---|---|---|
| 2 | Repartir un fondo fijo $B$ hoy | Lagrange y Kuhn-Tucker |
| 14 | Repartir la inversión de cada momento durante $T$ años | Principio del máximo |

La programación dinámica (Unidad IV) también podría resolverlo año por año,
pero con dos regiones el estado tiene dos dimensiones y el cálculo crece muy
rápido: la sesión 15 explica por qué conviene el principio del máximo.

### 4.2 El modelo de Rahman, Intriligator y Takayama

Cada región produce $Y_i = v_iK_i$ (con $v_i > 0$, la productividad del
capital) y ahorra la fracción $s_i$ de su producto. La inversión total
$I = s_1Y_1 + s_2Y_2$ se reparte: la fracción $\theta(t) \in [0, 1]$ va a la
región 1 y el resto a la región 2. Sin depreciación,

$$
\dot K_1 = \theta I,
\qquad
\dot K_2 = (1 - \theta) I,
\qquad
I = \gamma_1K_1 + \gamma_2K_2,
\qquad
\gamma_i = s_iv_i .
$$

El planificador maximiza el producto al final del horizonte,
$Y(T) = v_1K_1(T) + v_2K_2(T)$. En el lenguaje de la sección 2:

- **Estado**: $(K_1, K_2)$.
- **Control**: $\theta(t) \in [0, 1]$.
- **Ecuación de movimiento**: las dos ecuaciones diferenciales de arriba.
- **Objetivo**: el valor terminal $S = v_1K_1(T) + v_2K_2(T)$, sin
  recompensa intermedia ($F = 0$) ni descuento.

$\gamma_i$ es la **tasa de reinversión**: cada peso de capital en la región
$i$ genera $\gamma_i$ pesos de inversión al año, que se pueden mandar a
cualquiera de las dos regiones.

### 4.3 Políticas sin cambio

Si toda la inversión va a la región 1 ($\theta = 1$), $K_2$ no cambia y
$\dot K_1 = \gamma_1K_1 + \gamma_2K_2$. Se comprueba derivando que

$$
K_1(t) = \left(K_1(0) + \frac{\gamma_2K_2}{\gamma_1}\right)e^{\gamma_1 t} - \frac{\gamma_2K_2}{\gamma_1}
$$

cumple la ecuación y la condición inicial. Lo que crece exactamente a la tasa
$\gamma_1$ es $K_1 + \gamma_2K_2/\gamma_1$
([D.B2](repaso/ecuaciones_diferenciales.md#db2)); la tasa de crecimiento de
$K_1$ se acerca a $\gamma_1$ a medida que $K_1$ crece. Con
$\theta = 0$ ocurre lo mismo con los papeles de las regiones intercambiados.
Para un reparto constante $0 < \theta < 1$, la inversión total crece a la
tasa $\theta\gamma_1 + (1 - \theta)\gamma_2$: en [Para profundizar,
P.2](#pp2).

### 4.4 Una política con un cambio

Supón que la región 1 **ahorra más** y la región 2 **produce más**:
$\gamma_1 > \gamma_2$ y $v_2 > v_1$. El cuaderno usa $s_1 = 0.30$,
$v_1 = 0.25$, $s_2 = 0.15$, $v_2 = 0.35$, es decir, $\gamma_1 = 0.075$ y
$\gamma_2 = 0.0525$, con $K_1(0) = K_2(0) = 1$ y $T = 30$.

| Política | Producto final $Y(T)$ |
|---|---|
| Todo a la región 2 siempre | 3.86 |
| Mitad y mitad siempre | 4.06 |
| Todo a la región 1 siempre | 4.21 |
| Todo a la región 1 hasta $t_c \approx 20.3$, después todo a la región 2 | 4.71 |

La mejor política cambia de región. Al principio conviene la región que
reinvierte más, porque su capital genera más inversión para los años que
siguen. Cerca del final ya no queda tiempo para reinvertir, y conviene la
región donde el capital produce más. **Primero se crece donde se ahorra
más; al final se produce donde rinde más.**

El problema estático de la sesión 2 no puede ver esta tensión: en él no hay
"después". En la sesión 14, el principio del máximo demuestra que en este
modelo la política óptima, entre *todas* las funciones $\theta(t)$, es
exactamente de este tipo, y da una fórmula para el momento del cambio. El
cuaderno sólo compara políticas con un cambio.

La política que maximiza el producto total deja a la región 2 sin inversión
durante veinte años. Si al planificador le importa también la equidad, el
objetivo tiene que decirlo (ejercicio 8 del cuaderno): **el objetivo es una
decisión política, no técnica**.

---

## 5. Las herramientas del curso

| Unidad | Pregunta | Herramienta | Resultado |
|---|---|---|---|
| II | Si sigo una regla dada, ¿a dónde va el estado? | Sistemas dinámicos | Estados estacionarios, estabilidad, diagramas de fase |
| III | ¿Cuál es la mejor trayectoria del control en tiempo continuo? | Control óptimo | El hamiltoniano y el coestado $\lambda(t)$, precio sombra del estado |
| IV | ¿Cuál es la mejor regla en tiempo discreto? | Programación dinámica | La función valor $V(x)$ y la política $\sigma(x)$ |

El multiplicador de Lagrange de la sesión 2 es el antecedente del coestado:
los dos miden cuánto vale una unidad más del recurso escaso.

---

## 6. Tu problema de tesis ★

El proyecto final resuelve un problema de tu tesis (o uno del listado del
programa). Para plantearlo, responde:

1. **¿Qué se decide?** El control y su conjunto factible.
2. **¿Qué se hereda?** El estado y su valor inicial.
3. **¿Cómo cambia el estado?** La ecuación de movimiento, aunque sea con
   palabras al principio.
4. **¿Qué se quiere lograr?** El objetivo: qué se suma en el tiempo y cómo
   se descuenta.
5. **¿Hasta cuándo?** El horizonte, y qué vale el estado al final.
6. **¿Tiempo discreto o continuo?** Depende de los datos y de la
   herramienta que se quiera usar.

La propuesta de proyecto (sesión 12) es una página con estas respuestas.

---

## 7. Resumen formal

| Concepto | Enunciado | Dónde |
|---|---|---|
| Problema dinámico | Las decisiones están ligadas por un estado que se hereda | 1.3 |
| Dos periodos | $c_0^\ast = (y_0 + y_1/R)/(1 + \beta)$ | 1.2 |
| Ecuación de Euler | $u'(c_0) = \beta R\thinspace u'(c_1)$ | 1.2 |
| Control en tiempo discreto | $\max\sum\beta^t r(x_t, u_t)$ con $x_{t+1} = g(x_t, u_t)$ | 2.1 |
| Control en tiempo continuo | $\max\int e^{-\rho t}F(x, u)\thinspace dt$ con $\dot x = f(x, u)$ | 2.2 |
| Estado y control | El estado se hereda y no cambia de golpe; el control se elige | 2.3 |
| Estado estacionario | $K^\ast = (s/\delta)^{1/(1-\alpha)}$ | 3.1 |
| Regla de oro | $s = \alpha$ maximiza el gasto de largo plazo | 3.2 |
| Horizonte finito | Ninguna tasa constante positiva es óptima | 3.3 |
| Dos regiones | Primero se crece donde se ahorra más; al final se produce donde rinde más | 4.4 |

---

## 8. Ejercicios formales

- **F1.** Para cada situación, identifica el estado, el control, la ecuación
  de movimiento y un objetivo razonable: (a) un municipio que decide cuánto
  invertir cada año en mantenimiento de carreteras; (b) un estado que decide
  cuánta agua extraer de un acuífero; (c) una familia que decide cada año si
  migra a otra región.
- **F2.** En el problema de dos periodos, con $y_0 = 100$, $y_1 = 50$,
  $\beta = 0.95$ y $R = 1.05$, calcula $c_0^\ast$, $c_1^\ast$ y el ahorro.
  Verifica la ecuación de Euler.
- **F3.** Muestra que gastar lo que entra ($c_0 = y_0$) es óptimo si y sólo
  si $y_1 = \beta R\thinspace y_0$. Interpreta.
- **F4.** Con $\alpha = 0.3$ y $\delta = 0.05$, calcula $K^\ast$ y $c^\ast$
  para $s = 0.2$ y para $s = 0.3$. ¿Cuál da más gasto de largo plazo?
  ¿Contradice eso que la mejor tasa constante del cuaderno sea 0.20 con
  $\beta = 0.95$?
- **F5.** En el modelo de dos regiones con $\theta = 1$, $\gamma_1 = 0.075$,
  $\gamma_2 = 0.0525$ y $K_1(0) = K_2(0) = 1$, calcula $K_1(10)$ y verifica
  que la fórmula de la sección 4.3 cumple $\dot K_1 = \gamma_1K_1 + \gamma_2K_2$.

**Para profundizar** (opcionales)

- **F6.** Resuelve el problema de dos periodos con utilidad
  $u(c) = c^{1-\theta}/(1-\theta)$, $\theta > 0$. Muestra que
  $c_1/c_0 = (\beta R)^{1/\theta}$ e interpreta $1/\theta$.
- **F7.** Con un reparto constante $\theta$, usa [P.2](#pp2) para escribir
  $Y(T)$ en función de $\theta$. ¿Es $Y(T)$ lineal en $\theta$? ¿Por qué,
  entonces, el mejor reparto constante no es necesariamente un extremo?
- **F8.** Usa [P.1](#pp1) para mostrar que, con periodos de longitud
  $\Delta$ y $\beta = e^{-\rho\Delta}$, el valor presente de un flujo
  constante $F$ por periodo, $\sum_{k \ge 0}\beta^k F\Delta$, tiende a $F/\rho$
  cuando $\Delta \to 0$.

---

## Para profundizar

Material opcional: demostraciones y temas que no se ven en clase. Cada
apartado indica de qué sección de las notas viene.

<a id="pp1"></a>

### P.1 Del tiempo discreto al continuo (sección 2.2)

Divide el tiempo en periodos de longitud $\Delta$, con $t_k = k\Delta$. En
cada periodo, el estado cambia según $x_{k+1} = x_k + \Delta\thinspace f(x_k, u_k)$,
la recompensa es $F(x_k, u_k)\Delta$ y el factor de descuento por periodo
es $\beta_\Delta = e^{-\rho\Delta}$, de modo que $\beta_\Delta^k = e^{-\rho t_k}$.
El objetivo discreto es

$$
\sum_{k=0}^{T/\Delta - 1} e^{-\rho t_k}\thinspace F(x_k, u_k)\thinspace\Delta ,
$$

una suma de Riemann de $\int_0^T e^{-\rho t}F\big(x(t), u(t)\big)\thinspace dt$, y
la ecuación de movimiento es el método de Euler para $\dot x = f(x, u)$
([D.B3](repaso/ecuaciones_diferenciales.md#db3)). Cuando $\Delta \to 0$, la
suma tiende a la integral y las trayectorias de Euler tienden a las
soluciones de la ecuación diferencial. Con periodos de un año
($\Delta = 1$) queda $\beta = e^{-\rho}$; por ejemplo, $\rho = 0.05$ da
$\beta \approx 0.951$.

<a id="pp2"></a>

### P.2 La inversión total con un reparto constante (sección 4.3)

Con $\theta$ constante, el sistema es lineal:
$\dot K = MK$, con $K = (K_1, K_2)^\top$ y

$$
M = \begin{pmatrix} \theta\gamma_1 & \theta\gamma_2 \cr (1 - \theta)\gamma_1 & (1 - \theta)\gamma_2 \end{pmatrix}
= \begin{pmatrix} \theta \cr 1 - \theta \end{pmatrix}
\begin{pmatrix} \gamma_1 & \gamma_2 \end{pmatrix}
$$

([L.B1](repaso/algebra_lineal.md#lb1)). La inversión total
$I = \gamma_1K_1 + \gamma_2K_2$ cumple

$$
\dot I = \gamma_1\dot K_1 + \gamma_2\dot K_2 = \big(\theta\gamma_1 + (1 - \theta)\gamma_2\big) I,
$$

así que crece a la tasa constante $r = \theta\gamma_1 + (1 - \theta)\gamma_2$:
$I(t) = I(0)e^{rt}$. Integrando $\dot K_1 = \theta I$ y
$\dot K_2 = (1 - \theta)I$,

$$
K_1(t) = K_1(0) + \theta I(0)\thinspace\frac{e^{rt} - 1}{r},
\qquad
K_2(t) = K_2(0) + (1 - \theta) I(0)\thinspace\frac{e^{rt} - 1}{r}.
$$

El reparto constante enfrenta la misma tensión que la política con cambio,
pero sin poder resolverla: un $\theta$ alto hace crecer más la inversión
(si $\gamma_1 > \gamma_2$) y uno bajo la pone donde produce más (si
$v_2 > v_1$). En el lenguaje de la sesión 7, $M$ tiene eigenvalores $0$ y
$r$.

---

## Referencias

- Becerril Fonseca, Jardón Arcos y Reyes Victoria (2002). *Cálculo
  diferencial en varias variables*. UAM Iztapalapa.
- Chiang, A. C. (1992). *Elements of Dynamic Optimization*. McGraw-Hill.
- Intriligator, M. D. (1964). Regional allocation of investment: Comment.
  *Quarterly Journal of Economics*, 78(4), 659–662.
  https://doi.org/10.2307/1879665
- Rahman, M. A. (1963). Regional allocation of investment: An aggregative
  study in the theory of development programming. *Quarterly Journal of
  Economics*, 77(1), 26–39. https://doi.org/10.2307/1879370
- Sargent, T. J., y Stachurski, J. *Dynamic Programming, Vol. I: Finite
  States*. https://dp.quantecon.org
