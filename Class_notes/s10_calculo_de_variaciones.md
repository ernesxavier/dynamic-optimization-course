# Sesión 10: Del cálculo de variaciones al Hamiltoniano

> **Cómo usar estas notas.** La clase se da en el pizarrón y cubre el núcleo
> de estas notas, no todas. El **plan de clase** de abajo dice qué secciones
> se escriben en el pizarrón, cuándo se proyecta el cuaderno
> (`Code/s10_calculo_de_variaciones.jl`) y qué queda para leer. En el
> pizarrón van las ecuaciones y los resultados en recuadro; el texto que las
> rodea es lo que se explica de palabra. Como todo está aquí, en clase no
> hace falta copiar. El cuerpo de las notas es la **ruta básica** y se
> evalúa; las demostraciones y los temas opcionales están al final, en
> **Para profundizar**, y no se ven en clase.
>
> Las secciones marcadas con ★ son el **núcleo** que se ve en clase; las
> demás se leen por cuenta propia y se evalúan igual.
>
> Repaso recomendado: [C.B1–B4](repaso/calculo.md#cb1) (derivadas,
> máximos, exponencial e integrales), [C.I6](repaso/calculo.md#ci6) (regla
> de Leibniz), [C.I7](repaso/calculo.md#ci7) (desarrollo de Taylor) y
> [D.I3](repaso/ecuaciones_diferenciales.md#di3) (lineales de segundo
> orden); para Para profundizar, [C.A3](repaso/calculo.md#ca3) (funcionales
> y primera variación).
>
> Lecturas: Chiang (1992), caps. 1 y 2. Consulta: Sethi (2021), ejemplos
> 3.2 y 3.3 (el fondo regional con utilidad logarítmica, resuelto con el
> Hamiltoniano).

**Plan de clase** (120 minutos: 105 de núcleo y 15 de margen). El núcleo: la
ecuación de Euler, la regla de Keynes-Ramsey que da en el fondo regional y
el Hamiltoniano como segundo camino.

| Minutos | Dónde | Qué | Secciones |
|---|---|---|---|
| 0–15 | Pizarra | La pregunta: elegir una trayectoria; funcionales, el problema básico y el fondo regional | 0, 1.1, 1.2 |
| 15–40 | Pizarra | La ecuación de Euler: el teorema, de dónde sale en la versión discreta y por qué es de segundo orden con dos extremos; los casos especiales, de palabra | 2.1–2.4 |
| 40–45 | | Pausa | |
| 45–68 | Pizarra | El fondo con la ecuación de Euler: la regla de Keynes-Ramsey, su lectura y cómo los extremos fijan $c_0$ | 3.1–3.3 |
| 68–90 | Pizarra | El Hamiltoniano $H = F + \lambda u$; sus condiciones dan la ecuación de Euler; el fondo por el segundo camino y $\lambda(0) = dV/dW_0$ | 4.1–4.3 |
| 90–102 | Parejas | Ejercicio F3 a mano | 7 |
| 102–105 | Pizarra | Cierre: por qué el resto del curso usa el Hamiltoniano, de palabra; el principio del máximo (sesión 11) | 4.4, 5 |
| 105–120 | Margen | Si alcanza, en este orden: misma regla, distinto $c_0$, y mover $r$, $\rho$, $\theta$ y $W_T$ (cuaderno, secciones 1 y 2); perturbar la trayectoria óptima (cuaderno, sección 3); el coestado calculado de dos formas (cuaderno, sección 4) | |
| Después | Lectura | Lo que no entró del margen; la utilidad lineal en detalle (4.4), cuándo es un máximo (2.5), la tabla de casos de 3.3, el resumen (6), la sección [Avanzado] del cuaderno y Para profundizar | |

Lo del **margen** se ve sólo si sobra tiempo, en el orden indicado; lo
que no se vea pasa a la lectura y se evalúa igual.

**Pregunta de la unidad.** ¿Conviene invertir primero donde se ahorra más o
donde se produce más?

---

## 0. La pregunta

En la Unidad I se eligieron **números**: cuánto del fondo $B$ va a cada
región (sesiones 2 y 3). En la Unidad II se estudió cómo evoluciona un
sistema cuando la regla ya está dada. Ahora se juntan las dos cosas: se
elige una **trayectoria completa**, una función del tiempo.

El ejemplo de la sesión: un gobierno estatal recibe un fondo extraordinario
$W_0$ (por ejemplo, ingresos petroleros o una transferencia federal que no
se repetirá). Lo que no gasta rinde una tasa $r$. Tiene $T$ años para
gastarlo y al final debe dejar una reserva $W_T$. ¿Le conviene gastarlo
pronto, despacio o al final? La respuesta no es un número sino una curva,
el gasto $c(t)$ para cada $t \in [0, T]$.

Esta sesión da dos formas de resolver este tipo de problema. La primera, el
**cálculo de variaciones**, es la clásica: lleva a la **ecuación de Euler**.
La segunda, el **Hamiltoniano**, llega a lo mismo y es la que se usa en el
resto del curso, porque admite restricciones sobre las decisiones.

---

## 1. El problema básico ★

### 1.1 Funcionales ★

Un **funcional** asigna un número a cada función. El problema básico del
cálculo de variaciones es

$$
\max_{y}\ J[y] = \int_0^T F\big(t, y(t), y'(t)\big)\thinspace dt
\qquad \text{sujeto a} \qquad y(0) = A, \quad y(T) = Z.
$$

Las trayectorias **admisibles** son las funciones con derivada continua en
$[0, T]$ que cumplen los dos **extremos fijos**. $F$ es el beneficio
instantáneo: depende del momento $t$, del nivel $y$ y de su velocidad de
cambio $y'$.

**Una trayectoria es una lista muy larga de números.** Si se divide $[0, T]$
en $N$ tramos de largo $h = T/N$ y se aproxima $y'(t_n)$ por
$(y_{n+1} - y_n)/h$, el funcional se vuelve una función de
$y_1, \dots, y_{N-1}$ (los extremos $y_0 = A$ e $y_N = Z$ están dados):

$$
J \approx \sum_{n=0}^{N-1} h\thinspace F\Big(t_n,\ y_n,\ \frac{y_{n+1} - y_n}{h}\Big).
$$

Es un problema de la Unidad I con $N - 1$ variables. El cuaderno lo
resuelve así, con $N = 200$, y lo compara con la solución exacta. La sección
2.2 usa esta idea para entender la ecuación de Euler.

### 1.2 El ejemplo: el fondo regional ★

Sea $W(t)$ el saldo del fondo y $c(t)$ el gasto. El fondo crece con sus
rendimientos y baja con el gasto:

$$
W'(t) = rW(t) - c(t)
\qquad\Longleftrightarrow\qquad
c(t) = rW(t) - W'(t).
$$

El gasto genera bienestar $u(c)$, con $u' > 0$ y $u'' < 0$, y el gobierno
descuenta el futuro a la tasa $\rho$ (sesión 1). El problema es

$$
\max_{W}\ \int_0^T e^{-\rho t}\thinspace u\big(rW - W'\big)\thinspace dt
\qquad \text{sujeto a} \qquad W(0) = W_0, \quad W(T) = W_T.
$$

Es un problema básico con $y = W$ y $F(t, W, W') = e^{-\rho t}u(rW - W')$:
**elegir la trayectoria del fondo es elegir la del gasto**. Se usa la
utilidad CRRA

$$
u(c) = \frac{c^{1-\theta} - 1}{1 - \theta}, \qquad u'(c) = c^{-\theta},
\qquad \theta > 0,
$$

con $u(c) = \ln c$ cuando $\theta = 1$. El parámetro $\theta$ mide cuánto
le disgusta al gobierno que el gasto varíe en el tiempo: es el mismo de la
sesión 8, y es la letra que usan los libros de crecimiento. **Ojo:** en la
sesión 14, $\theta(t)$ es otra cosa, el reparto de la inversión entre dos
regiones. El contexto distingue los dos usos: el de la utilidad es un
número fijo; el del reparto, un control que cambia en el tiempo.

Con utilidad logarítmica, este es el problema de consumo de Sethi (2021,
ejemplos 3.2 y 3.3), que lo resuelve con el Hamiltoniano.

---

## 2. La ecuación de Euler

### 2.1 El teorema ★

**Teorema (ecuación de Euler).** Si $y^\ast$ maximiza $J[y]$ entre las
trayectorias admisibles y es dos veces derivable, entonces, para todo
$t \in [0, T]$,

$$
\boxed{\ F_y\big(t, y^\ast, y^{\ast\prime}\big) - \frac{d}{dt}F_{y'}\big(t, y^\ast, y^{\ast\prime}\big) = 0\ }
$$

Aquí $F_y$ y $F_{y'}$ son las derivadas parciales de $F$ respecto a su
segundo y tercer argumento, tratados como variables independientes. La
derivada $\frac{d}{dt}$ es **total**: $F_{y'}$ se evalúa sobre la
trayectoria y se deriva respecto al tiempo.

Es una condición **necesaria**, como las de primer orden de la sesión 2: la
cumplen el máximo, el mínimo y otros puntos estacionarios. Las trayectorias
que la cumplen se llaman **extremales**. La demostración está en [Para
profundizar, P.1](#pp1).

### 2.2 De dónde sale: la condición de primer orden en cada instante ★

En la versión discreta de la sección 1.1, $y_n$ aparece en dos términos: en
el tramo $n$, como nivel y en la pendiente $(y_{n+1} - y_n)/h$, y en el
tramo $n - 1$, en la pendiente $(y_n - y_{n-1})/h$. La condición de primer
orden respecto a $y_n$ es

$$
h\thinspace F_y(t_n) - F_{y'}(t_n) + F_{y'}(t_{n-1}) = 0
\qquad\Longleftrightarrow\qquad
F_y(t_n) - \frac{F_{y'}(t_n) - F_{y'}(t_{n-1})}{h} = 0,
$$

y con $h \to 0$ el cociente se vuelve $\frac{d}{dt}F_{y'}$. **La ecuación de
Euler es la condición de primer orden de la Unidad I, escrita para cada
instante.** Se lee así: subir un poco $y$ en el instante $t_n$ da un
beneficio directo $F_y\thinspace h$, y además cambia dos pendientes, la del
tramo anterior (que sube) y la del siguiente (que baja). En el óptimo, la
suma de los tres efectos es cero.

### 2.3 Una ecuación de segundo orden con dos extremos ★

Al desarrollar la derivada total,

$$
F_y - F_{ty'} - F_{yy'}\thinspace y' - F_{y'y'}\thinspace y'' = 0.
$$

Si $F_{y'y'} \ne 0$, es una ecuación diferencial de **segundo orden** en $y$
([D.I3](repaso/ecuaciones_diferenciales.md#di3)). Su solución general tiene
dos constantes, y las fijan las dos condiciones de extremo, $y(0) = A$ e
$y(T) = Z$. A diferencia de la Unidad II, no es un problema de valor
inicial: una condición está al principio y la otra al final. Es un
**problema de valor en la frontera**, como el disparo de la sesión 8.

### 2.4 Casos especiales

Cuando a $F$ le falta algún argumento, la ecuación se simplifica (Chiang,
sec. 2.2):

| $F$ depende de | La ecuación de Euler se reduce a | Ejemplo |
|---|---|---|
| $t$, $y'$ (sin $y$) | $F_{y'} = \text{constante}$ | Ejercicio F1 |
| $y$, $y'$ (sin $t$) | $F - y'F_{y'} = \text{constante}$ | Ejercicio F5 |
| sólo $y'$ | $y'' = 0$: una recta (si $F_{y'y'} \ne 0$) | La distancia más corta, ejercicio F2 |
| $t$, $y$ (sin $y'$) | $F_y = 0$: un problema estático en cada $t$ | Ejercicio F7 |

### 2.5 ¿Cuándo es un máximo?

Si $F$ es **cóncava** en $(y, y')$ para cada $t$, toda extremal que cumpla
los dos extremos es un máximo global (Chiang, sec. 4.2). Es la versión
dinámica de la suficiencia con funciones cóncavas de la sesión 2. En el
fondo regional, $u$ es cóncava y su argumento $rW - W'$ es lineal en
$(W, W')$, así que $F$ es cóncava: la extremal es el óptimo. En la sesión 13
se ve la versión para el Hamiltoniano (Mangasarian).

---

## 3. El fondo regional resuelto con la ecuación de Euler ★

### 3.1 La regla de Keynes-Ramsey ★

Con $F = e^{-\rho t}u(rW - W')$ y $c = rW - W'$:

$$
F_W = e^{-\rho t}u'(c)\thinspace r,
\qquad
F_{W'} = -e^{-\rho t}u'(c).
$$

La ecuación de Euler, $F_W - \frac{d}{dt}F_{W'} = 0$, es

$$
e^{-\rho t}u'(c)\thinspace r + \frac{d}{dt}\Big(e^{-\rho t}u'(c)\Big) = 0
\qquad\Longrightarrow\qquad
r\thinspace u'(c) - \rho\thinspace u'(c) + u''(c)\thinspace c' = 0.
$$

Con la utilidad CRRA, $u''(c)\thinspace c/u'(c) = -\theta$, y queda

$$
\boxed{\ \frac{c'}{c} = \frac{r - \rho}{\theta}\ }
$$

Es la **regla de Keynes-Ramsey** de la sesión 8, con el rendimiento fijo
$r$ en lugar de $f'(k) - \delta$. La ecuación de Euler, que era de segundo
orden en $W$, quedó de primer orden en $c$.

### 3.2 Lectura económica: gastar hoy o gastar mañana ★

La regla compara dos cosas. Gastar un peso menos hoy cuesta $u'(c(t))$.
Ese peso, en el fondo, se vuelve $e^{r\Delta}$ pesos dentro de $\Delta$
años, que valen $e^{-\rho\Delta}u'(c(t + \Delta))$ hoy. En el óptimo, al
gobierno le da igual:

$$
u'\big(c(t)\big) = e^{(r - \rho)\Delta}\thinspace u'\big(c(t + \Delta)\big).
$$

- Si $r > \rho$, el fondo rinde más de lo que el gobierno descuenta: conviene
  esperar y el gasto **crece**.
- Si $r < \rho$, el gobierno es impaciente: el gasto **decrece**.
- Si $r = \rho$, el gasto es **constante**.

$\theta$ decide qué tan fuerte es la respuesta: con $\theta$ grande, al
gobierno le disgusta la variación y el gasto casi no cambia, aunque $r$ y
$\rho$ sean muy distintos.

### 3.3 Los extremos fijan el nivel ★

La regla dice cómo **cambia** el gasto, $c(t) = c_0\thinspace e^{gt}$ con
$g = (r - \rho)/\theta$, pero no cuánto vale $c_0$. Lo fijan los extremos.
Con el factor integrante $e^{-rt}$ ([D.I2](repaso/ecuaciones_diferenciales.md#di2)),
la ecuación $W' = rW - c$ se integra desde $W(0) = W_0$:

$$
\begin{aligned}
\frac{d}{dt}\big(e^{-rt}W\big) &= e^{-rt}(W' - rW) = -e^{-rt}c = -c_0e^{(g - r)t}, \cr
e^{-rt}W(t) &= W_0 - c_0\int_0^t e^{(g - r)s}\thinspace ds
= W_0 - c_0\thinspace\frac{1 - e^{-(r - g)t}}{r - g}.
\end{aligned}
$$

En $t = T$, la condición $W(T) = W_T$ da, si $r \ne g$,

$$
e^{-rT}W_T = W_0 - c_0\thinspace\frac{1 - e^{-(r - g)T}}{r - g}
\quad\Longrightarrow\quad
\boxed{\ c_0 = \frac{(r - g)\big(W_0 - e^{-rT}W_T\big)}{1 - e^{-(r - g)T}}\ }
$$

Es la **restricción presupuestal**: el valor presente del gasto es igual al
fondo inicial menos el valor presente de la reserva. Si $r = g$, el
cociente se vuelve $c_0 = (W_0 - e^{-rT}W_T)/T$.

Con $W_0 = 100$, $W_T = 0$ y $T = 20$:

| $r$ | $\rho$ | $\theta$ | $g$ | $c_0$ | $c(20)$ |
|---|---|---|---|---|---|
| 0.04 | 0.02 | 2 | 1% | 6.65 | 8.12 |
| 0.04 | 0.04 | 2 | 0 | 7.26 | 7.26 |
| 0.04 | 0.06 | 2 | −1% | 7.91 | 6.48 |
| 0.04 | 0.02 | 1 | 2% | 6.07 | 9.05 |
| 0.04 | 0.02 | 5 | 0.4% | 7.01 | 7.60 |

**Lectura regional.**
- La forma de la trayectoria depende sólo de $r - \rho$ y de $\theta$. El
  tamaño del fondo sólo cambia la escala: con el doble de fondo, se gasta el
  doble en cada año.
- Gastar todo al principio casi nunca es óptimo: haría falta una impaciencia
  enorme. Gastar parejo (la anualidad de la segunda fila) es óptimo sólo si
  $r = \rho$.
- Exigir una reserva final $W_T > 0$ baja el gasto en todos los años, no
  sólo en los últimos: con $W_T = 20$ en la primera fila, $c_0$ baja de 6.65
  a 6.05.

---

## 4. El mismo problema como control óptimo

### 4.1 El Hamiltoniano ★

Se llama **estado** a $y$ y **control** a su velocidad, $u = y'$. El
problema básico se escribe

$$
\max_{u}\ \int_0^T F(t, y, u)\thinspace dt
\qquad \text{sujeto a} \qquad y' = u, \quad y(0) = A, \quad y(T) = Z.
$$

Se agrega una función $\lambda(t)$, el **coestado**, que hace el papel del
multiplicador de Lagrange de la restricción $y' = u$ en cada instante, y se
forma el **Hamiltoniano**

$$
H(t, y, u, \lambda) = F(t, y, u) + \lambda u.
$$

Las condiciones son (se derivan en la sesión 11):

$$
\boxed{\ \frac{\partial H}{\partial u} = 0,
\qquad
\lambda' = -\frac{\partial H}{\partial y},
\qquad
y' = \frac{\partial H}{\partial \lambda} = u\ }
$$

### 4.2 Dan la ecuación de Euler ★

La primera condición es $F_u + \lambda = 0$, es decir,
$\lambda = -F_{y'}$. Derivando respecto al tiempo,
$\lambda' = -\frac{d}{dt}F_{y'}$. La segunda condición dice
$\lambda' = -F_y$. Igualando las dos:

$$
F_y - \frac{d}{dt}F_{y'} = 0.
$$

**Las condiciones del Hamiltoniano son la ecuación de Euler partida en dos
ecuaciones de primer orden**, una para el estado y otra para el coestado.

### 4.3 El fondo regional, por el segundo camino ★

Aquí la letra $u$ ya es la utilidad, así que el control se llama
$z = W'$. Con $H = e^{-\rho t}u(rW - z) + \lambda z$, las condiciones son:

- $\partial H/\partial z = 0$: $\lambda = e^{-\rho t}u'(c)$.
- $\lambda' = -\partial H/\partial W = -r\lambda$, así que
  $\lambda(t) = \lambda_0\thinspace e^{-rt}$.

Juntando las dos, $u'(c(t)) = \lambda_0\thinspace e^{(\rho - r)t}$, y con
$u'(c) = c^{-\theta}$ sale otra vez $c'/c = (r - \rho)/\theta$. El camino es
más corto: la ecuación del coestado se resuelve sola, sin pasar por una
ecuación de segundo orden.

**El coestado es un precio.** $\lambda(t) = e^{-\rho t}u'(c(t))$ es lo que
vale, en bienestar descontado a $t = 0$, un peso más en el fondo en el
instante $t$: se puede gastar ahí mismo y daría $u'(c(t))$. En particular,
$\lambda(0) = u'(c_0)$ es cuánto sube el bienestar total si el fondo inicial
es un peso mayor:

$$
\boxed{\ \lambda(0) = \frac{dV}{dW_0}\ }
$$

donde $V(W_0)$ es el valor óptimo. Es el $V'(B) = \lambda$ de la sesión 3,
ahora para cada instante. Con los números de la primera fila de la tabla,
$\lambda(0) = 6.65^{-2} \approx 0.0226$, y el cuaderno lo comprueba
calculando $V$ con $W_0 = 99$ y $W_0 = 101$. La sesión 11 desarrolla esta
lectura del coestado como **precio sombra** del estado.

En la sesión 11 el mismo problema se escribe con el gasto como control y la
restricción $W' = rW - c$, en la forma general $H = F + \lambda f$. Las
condiciones son las mismas.

### 4.4 Por qué el resto del curso usa el Hamiltoniano

El cálculo de variaciones supone que $y'$ puede tomar cualquier valor: la
ecuación de Euler es una derivada igualada a cero, como Lagrange en la
sesión 2. No sabe qué hacer cuando la decisión tiene **límites** y el
óptimo está en uno de ellos, como Kuhn-Tucker sí sabe. Un ejemplo con el
fondo: si la utilidad es **lineal**, $u(c) = c$, entonces

$$
F_W - \frac{d}{dt}F_{W'} = r e^{-\rho t} - \rho e^{-\rho t} = (r - \rho)\thinspace e^{-\rho t}.
$$

La ecuación de Euler no tiene a $W$: si $r \ne \rho$, **ninguna trayectoria
la cumple**. El óptimo existe si el gasto está acotado,
$0 \le c \le \bar c$: con $r > \rho$, no gastar nada al principio y gastar
$\bar c$ al final; con $r < \rho$, gastar $\bar c$ desde el principio y
después nada. El momento del cambio lo fija la reserva $W_T$. Son
soluciones **bang-bang**, en las esquinas del intervalo permitido. En la
sesión 11, la condición $\partial H/\partial u = 0$ se reemplaza por la de que $u$
**maximice** $H$ en el conjunto permitido, que sí encuentra las esquinas. En
la sesión 13 se resuelve este caso, y en la sesión 14 el reparto
$\theta(t) \in [0, 1]$ de la inversión entre dos regiones, que tiene la
misma estructura.

---

## 5. Hacia la optimización dinámica

| Idea de esta sesión | Dónde reaparece |
|---|---|
| Hamiltoniano $H = F + \lambda u$ | Forma general $H = F + \lambda f$ y condiciones terminales (sesión 11) |
| $\lambda(0) = dV/dW_0$ | El coestado como precio sombra (sesión 11); la derivada de la función valor (sesión 16) |
| Regla de Keynes-Ramsey | Ramsey con capital, $f'(k) - \delta$ en lugar de $r$ (sesión 12) |
| Utilidad lineal: Euler no tiene solución | Control acotado y bang-bang (sesiones 13 y 14) |
| Concavidad de $F$ da suficiencia | Condiciones de Mangasarian y de Arrow (sesión 13) |
| Discretizar la trayectoria | Programación dinámica en tiempo discreto (Unidad IV) |

---

## 6. Resumen formal

| Concepto | Enunciado | Dónde |
|---|---|---|
| Problema básico | $\max \int_0^T F(t, y, y')\thinspace dt$ con $y(0) = A$, $y(T) = Z$ | 1.1 |
| Ecuación de Euler | $F_y - \frac{d}{dt}F_{y'} = 0$; necesaria | 2.1 |
| Versión discreta | Es la condición de primer orden respecto a cada $y_n$ | 2.2 |
| Valor en la frontera | Segundo orden; los dos extremos fijan las dos constantes | 2.3 |
| Casos especiales | Sin $y$: $F_{y'}$ constante; sin $t$: $F - y'F_{y'}$ constante | 2.4 |
| Suficiencia | $F$ cóncava en $(y, y')$: la extremal es un máximo | 2.5 |
| Keynes-Ramsey | $c'/c = (r - \rho)/\theta$ | 3.1 |
| Restricción presupuestal | Fija $c_0$: valor presente del gasto $= W_0 - e^{-rT}W_T$ | 3.3 |
| Hamiltoniano | $H = F + \lambda u$; $H_u = 0$ y $\lambda' = -H_y$ dan Euler | 4.1, 4.2 |
| Coestado | $\lambda(0) = dV/dW_0$: precio sombra del fondo | 4.3 |
| Límites del método | Sin restricciones sobre $y'$; no encuentra soluciones de esquina | 4.4 |

---

## 7. Ejercicios formales

- **F1.** Encuentra la extremal de
  $\int_0^2 \big(12ty + (y')^2\big)\thinspace dt$ con $y(0) = 0$ y
  $y(2) = 8$. ¿Es un máximo o un mínimo? (Pista: ¿es $F$ cóncava o
  convexa en $(y, y')$?)
- **F2.** La longitud de una curva entre $(0, A)$ y $(T, Z)$ es
  $\int_0^T \sqrt{1 + (y')^2}\thinspace dt$. Muestra que la extremal es la
  recta que une los dos puntos.
- **F3.** Resuelve el fondo regional con utilidad logarítmica
  ($\theta = 1$) y $W_T = 0$. Muestra que
  $c_0 = \rho W_0/(1 - e^{-\rho T})$: el gasto inicial no depende de $r$.
  ¿Por qué? (Pista: un $r$ mayor hace más rico al gobierno, pero también
  hace más atractivo esperar.)
- **F4.** Resuelve el fondo regional con el Hamiltoniano, ahora con
  $W_T = 20$. Calcula $\lambda(0)$ con $r = 0.04$, $\rho = 0.02$,
  $\theta = 2$, $T = 20$ y $W_0 = 100$, y explica qué mide.

**Para profundizar** (opcionales)

- **F5.** Si $F$ no depende de $t$, muestra que
  $\frac{d}{dt}\big(F - y'F_{y'}\big) = y'\big(F_y - \frac{d}{dt}F_{y'}\big)$,
  y deduce que $F - y'F_{y'}$ es constante sobre una extremal.
- **F6.** Muestra que en el fondo regional se cumple la condición de
  Legendre, $F_{W'W'} \le 0$ ([P.2](#pp2)).
- **F7.** Si $F = F(t, y)$, ¿qué dice la ecuación de Euler? ¿Por qué, en
  general, ninguna trayectoria cumple los dos extremos?

## Para profundizar

Material opcional: demostraciones y temas que no se ven en clase. Cada
apartado indica de qué sección de las notas viene.

<a id="pp1"></a>

### P.1 La ecuación de Euler por la primera variación (sección 2.1)

Sea $y^\ast$ óptima y sea $\eta$ una función con derivada continua y
$\eta(0) = \eta(T) = 0$. Para cada $\varepsilon$, $y^\ast + \varepsilon\eta$
es admisible: cumple los dos extremos. La función

$$
\phi(\varepsilon) = J[y^\ast + \varepsilon\eta]
= \int_0^T F\big(t,\ y^\ast + \varepsilon\eta,\ y^{\ast\prime} + \varepsilon\eta'\big)\thinspace dt
$$

tiene un máximo en $\varepsilon = 0$, así que $\phi'(0) = 0$. Derivando bajo
la integral ([C.I6](repaso/calculo.md#ci6)),

$$
\phi'(0) = \int_0^T \big(F_y\thinspace\eta + F_{y'}\thinspace\eta'\big)\thinspace dt = 0.
$$

Se integra por partes el segundo término:

$$
\int_0^T F_{y'}\thinspace\eta'\thinspace dt
= \Big[F_{y'}\thinspace\eta\Big]_0^T - \int_0^T \frac{d}{dt}F_{y'}\thinspace\eta\thinspace dt,
$$

y el primer término vale cero porque $\eta(0) = \eta(T) = 0$. Queda

$$
\int_0^T \Big(F_y - \frac{d}{dt}F_{y'}\Big)\thinspace\eta(t)\thinspace dt = 0
\quad\text{para toda } \eta \text{ admisible.}
$$

Por el **lema fundamental del cálculo de variaciones**
([C.A3](repaso/calculo.md#ca3)), el paréntesis, que es continuo, vale cero
en todo $[0, T]$. $\square$

**Dos comentarios.** La integración por partes usa que $F_{y'}$ es
derivable sobre la trayectoria; por eso el teorema pide $y^\ast$ dos veces
derivable. Si $y(T)$ fuera libre, $\eta(T)$ ya no sería cero y el término de
frontera daría la condición $F_{y'} = 0$ en $t = T$: es la primera
**condición de transversalidad**, que se ve con el Hamiltoniano en la
sesión 11.

<a id="pp2"></a>

### P.2 La condición de Legendre (sección 2.5)

La ecuación de Euler es de primer orden: no distingue máximos de mínimos.
La condición de **segundo orden** necesaria es la de Legendre: si $y^\ast$
es un máximo,

$$
F_{y'y'}\big(t, y^\ast, y^{\ast\prime}\big) \le 0 \quad \text{para todo } t.
$$

*Idea.* Se toma $\phi''(0)$ con una perturbación $\eta$ que oscila muy
rápido: $\eta$ es pequeña pero $\eta'$ es grande, así que en
$\phi''(0) = \int \big(F_{yy}\eta^2 + 2F_{yy'}\eta\eta' + F_{y'y'}(\eta')^2\big)\thinspace dt$
domina el último término. Para que $\phi''(0) \le 0$ hace falta
$F_{y'y'} \le 0$. Es más débil que la concavidad de la sección 2.5:
Legendre es necesaria; la concavidad, suficiente.

---

## Referencias

- Chiang, A. C. (1992). *Elements of Dynamic Optimization*. McGraw-Hill.
- Sethi, S. P. (2021). *Optimal Control Theory: Applications to Management
  Science and Economics* (4.ª ed.). Springer.
  https://doi.org/10.1007/978-3-030-91745-6
