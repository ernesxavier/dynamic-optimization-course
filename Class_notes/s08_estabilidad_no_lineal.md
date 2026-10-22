# Sesión 8: Estabilidad de sistemas no lineales. Notas formales

> **Cómo leer estas notas.** Siguen el orden del programa: primero se explora
> en el cuaderno (`Code/s08_estabilidad_no_lineal.jl`), después se formaliza
> aquí. El cuerpo de las notas es la **ruta básica**: se ve en clase y se
> evalúa. Las demostraciones y los temas opcionales están al final, en
> **Para profundizar**; donde estaban queda una línea que los enlaza.
>
> Repaso recomendado: [C.I7](repaso/calculo.md#ci7) (desarrollo de Taylor),
> [L.I1–I2](repaso/algebra_lineal.md#li1) (eigenvalores y diagonalización),
> [L.I6](repaso/algebra_lineal.md#li6) (jacobiano) y
> [D.I6](repaso/ecuaciones_diferenciales.md#di6) (diagramas de fase en el
> plano); para Para profundizar,
> [D.A2](repaso/ecuaciones_diferenciales.md#da2) (variedades estable e
> inestable) y [D.A4](repaso/ecuaciones_diferenciales.md#da4) (funciones de
> Liapunov).
>
> Lecturas: Strogatz (2015), cap. 6.

**Pregunta de la unidad.** ¿Convergen los estados de México? ¿A qué
velocidad?

---

## 0. La pregunta

La sesión 7 resolvió los sistemas lineales y mostró que, cerca de un
equilibrio, un sistema no lineal se parece a su linealización. Pero la
linealización es **local**: no dice qué pasa lejos del equilibrio, ni cuál
de varios equilibrios alcanza el sistema, ni cómo se ven las trayectorias
completas. Para eso sirve el **diagrama de fase en el plano**.

Esta sesión lo construye en dos ejemplos. El primero, dos regiones que
compiten por la misma actividad, muestra que con interacción entre regiones
el destino puede depender de las condiciones iniciales. El segundo, el
modelo de Ramsey, es el puente con el control óptimo: su diagrama de fase
dice cuánto debe consumir y ahorrar una economía en cada momento.

---

## 1. El diagrama de fase en el plano

Sea el sistema autónomo

$$
\dot x = f(x, y),
\qquad
\dot y = g(x, y).
$$

El diagrama de fase se construye en cuatro pasos
([D.I6](repaso/ecuaciones_diferenciales.md#di6)).

### 1.1 Isoclinas

La **isoclina** $\dot x = 0$ es la curva $f(x, y) = 0$: sobre ella, $x$ no
cambia y las trayectorias la cruzan verticalmente. La isoclina $\dot y = 0$
es $g(x, y) = 0$: sobre ella, $y$ no cambia y las trayectorias la cruzan
horizontalmente. Los **equilibrios** son las intersecciones de las dos.

### 1.2 Direcciones del flujo

Las isoclinas dividen el plano en regiones. En cada una, $f$ y $g$ tienen
signo constante, y basta evaluarlas en un punto:

- $f > 0$: $x$ crece (flecha a la derecha); $f < 0$: a la izquierda.
- $g > 0$: $y$ crece (flecha hacia arriba); $g < 0$: hacia abajo.

Un atajo: el signo de $f$ cambia al cruzar la isoclina $f = 0$, y el lado
donde $f > 0$ lo dice la derivada parcial. Si $\partial f/\partial y < 0$,
por ejemplo, $f$ es positiva **debajo** de la isoclina $\dot x = 0$.

### 1.3 Equilibrios

En cada equilibrio se calcula el jacobiano y se clasifica con la traza y el
determinante (sesión 7). Si el equilibrio es hiperbólico, el tipo del
sistema no lineal es el de su linealización.

### 1.4 Trayectorias y ramas

Las trayectorias no se cruzan: por cada punto pasa una sola (sesión 6, P.1).
Siguiendo las flechas se dibujan las trayectorias típicas. Si hay un punto
de silla, se dibujan además sus dos **ramas estables**, las únicas
trayectorias que llegan a él, y sus dos ramas inestables, las que salen de
él.

**Qué puede pasar en el plano.** En una dimensión, una trayectoria acotada
siempre converge a un equilibrio (sesión 6). En el plano hay una posibilidad
más: puede acercarse a una **órbita cerrada**, un ciclo (o a una cadena de
equilibrios unidos por trayectorias). Los ejemplos de esta sesión no tienen
ciclos.

---

## 2. Ejemplo: dos regiones que compiten por la misma actividad

### 2.1 El modelo

Sean $x$ e $y$ el tamaño de una actividad (por ejemplo, una industria que
puede instalarse en cualquiera de las dos regiones) en la región 1 y en la
región 2, medidos como fracción de lo que cada región podría sostener por
sí sola. Cada región crece hacia su capacidad, pero la actividad en la otra
región le quita mercado, trabajadores o proveedores:

$$
\dot x = x(1 - x - ay),
\qquad
\dot y = y(1 - y - bx),
\qquad a, b > 0.
$$

$a$ mide cuánto le quita la región 2 a la región 1, y $b$ lo contrario. Es el
modelo de competencia de Lotka y Volterra, con regiones en lugar de
especies (Strogatz, sec. 6.4).

### 2.2 Isoclinas y equilibrios

- $\dot x = 0$ en el eje $x = 0$ y en la recta $x + ay = 1$.
- $\dot y = 0$ en el eje $y = 0$ y en la recta $bx + y = 1$.

Los equilibrios son $(0, 0)$, $(1, 0)$, $(0, 1)$ y, si las dos rectas se
cruzan en el cuadrante positivo,

$$
(x^\ast, y^\ast) = \left(\frac{1 - a}{1 - ab},\ \frac{1 - b}{1 - ab}\right).
$$

### 2.3 Estabilidad

El jacobiano es

$$
J(x, y) = \begin{pmatrix} 1 - 2x - ay & -ax \cr -by & 1 - 2y - bx \end{pmatrix}.
$$

- En $(0, 0)$, $J = I$: nodo inestable. Ninguna región se queda vacía.
- En $(1, 0)$, $J = \begin{pmatrix} -1 & -a \cr 0 & 1 - b \end{pmatrix}$, con
  eigenvalores $-1$ y $1 - b$: estable si $b > 1$, punto de silla si
  $b < 1$.
- En $(0, 1)$, por simetría: estable si $a > 1$.
- En el equilibrio interior, usando $x^\ast + ay^\ast = 1$ y
  $bx^\ast + y^\ast = 1$,
  $J = \begin{pmatrix} -x^\ast & -ax^\ast \cr -by^\ast & -y^\ast \end{pmatrix}$,
  con $\tau = -(x^\ast + y^\ast) < 0$ y $\Delta = x^\ast y^\ast(1 - ab)$.

### 2.4 Tres casos

| Caso | Equilibrio interior | Destino |
|---|---|---|
| $a < 1$ y $b < 1$: competencia débil | Nodo estable | **Coexistencia**: las dos regiones conservan la actividad |
| $a > 1$ y $b > 1$: competencia fuerte | Punto de silla | **Una sola región se queda con todo**, según dónde empiece |
| $a < 1 < b$ | No existe | La región 1 se queda con todo, empiece donde empiece |

**El caso de competencia fuerte.** Con $a = b = 2$, el equilibrio interior
$(1/3, 1/3)$ es un punto de silla, y $(1, 0)$ y $(0, 1)$ son estables. Las
dos ramas estables del punto de silla forman una curva, la **separatriz**,
que divide el plano en dos **cuencas de atracción**: todo lo que empieza de
un lado termina en $(1, 0)$, y todo lo que empieza del otro, en $(0, 1)$.

**Lectura regional.**
- Es la versión en dos dimensiones del umbral de la sesión 6, y la lógica de
  la aglomeración: cuando la competencia entre regiones es fuerte, una
  pequeña ventaja inicial decide cuál concentra la actividad. Dos regiones
  idénticas pueden terminar muy distintas.
- La frontera entre los dos destinos no es un punto sino una curva: lo que
  importa no es sólo cuánto tiene cada región, sino la combinación.
- Una política que quiera la coexistencia tiene que cambiar los parámetros
  ($a$ y $b$ menores que 1: menos competencia, más especialización), no sólo
  las condiciones iniciales.

---

## 3. El diagrama de fase de Ramsey

### 3.1 El sistema

En la sesión 12 se deriva, con el principio del máximo, el sistema que
describe el capital $k$ y el consumo $c$ óptimos de una economía con
producción $f(k) = k^\alpha$, depreciación $\delta$, tasa de descuento
$\rho$ y utilidad CRRA con parámetro $\theta$:

$$
\dot k = f(k) - \delta k - c,
\qquad
\dot c = \frac{c}{\theta}\big(f'(k) - \delta - \rho\big).
$$

La primera ecuación es la restricción de recursos: lo que no se consume se
invierte. La segunda es la **regla de Keynes-Ramsey**: el consumo crece si
el rendimiento neto del capital, $f'(k) - \delta$, supera la tasa de
descuento. Aquí sólo se analiza su diagrama de fase.

### 3.2 Isoclinas

- **$\dot k = 0$**: la curva $c = f(k) - \delta k$, el consumo que mantiene el
  capital constante. Tiene forma de joroba: vale cero en $k = 0$ y en
  $k_{\max}$, donde $f(k) = \delta k$, y su máximo está en la **regla de oro**,
  $f'(k_{RO}) = \delta$ (sesión 1). Por encima de ella se consume más de lo
  que se repone y $k$ baja; por debajo, $k$ sube.
- **$\dot c = 0$**: la recta vertical $k = k^\ast$, con $f'(k^\ast) = \delta + \rho$
  (la **regla de oro modificada**), y el eje $c = 0$. A la izquierda de
  $k^\ast$ el capital rinde mucho y $c$ sube; a la derecha, $c$ baja.

Como $\rho > 0$, $f'(k^\ast) > f'(k_{RO})$ y $k^\ast < k_{RO}$: **la
impaciencia hace que no convenga acumular hasta la regla de oro.** Con
$\alpha = 0.3$, $\delta = 0.05$ y $\rho = 0.03$: $k^\ast \approx 6.61$,
$k_{RO} \approx 12.9$ y $k_{\max} \approx 72$.

### 3.3 El estado estacionario es un punto de silla

El equilibrio interior es $(k^\ast, c^\ast)$ con
$c^\ast = f(k^\ast) - \delta k^\ast$. En la sesión 7 se mostró que su
jacobiano tiene determinante $c^\ast f''(k^\ast)/\theta < 0$: es un punto de
silla. Las flechas lo confirman. Las dos isoclinas dividen el plano en
cuatro regiones alrededor de $(k^\ast, c^\ast)$. Arriba a la izquierda
(sobre la joroba y a la izquierda de $k^\ast$), $k$ baja y $c$ sube: la
trayectoria se aleja. Abajo a la derecha, $k$ sube y $c$ baja: también se
aleja. Sólo desde las regiones de abajo a la izquierda y de arriba a la
derecha se puede llegar al equilibrio.

### 3.4 Tres destinos

Dado el capital inicial $k_0 < k^\ast$, el consumo inicial $c_0$ decide la
trayectoria:

| Consumo inicial | Trayectoria | ¿Es óptima? |
|---|---|---|
| $c_0$ sobre la rama estable | Llega a $(k^\ast, c^\ast)$ | Sí |
| $c_0$ mayor | El consumo sigue subiendo, cruza la isoclina $\dot k = 0$ y el capital se agota en tiempo finito | No: deja de ser factible |
| $c_0$ menor | El capital pasa de $k^\ast$, el consumo cae hacia cero y $k$ se acerca a $k_{\max}$ | No: acumula capital que nunca se consume; la condición de transversalidad la descarta (sesión 12) |

Sólo hay un consumo inicial correcto para cada $k_0$. La rama estable es la
gráfica de una función $c = \sigma(k)$, la **función de política**: cuánto
consumir con cada nivel de capital. Es la misma función que la programación
dinámica calcula directamente en la Unidad IV.

### 3.5 Cuánto ahorra una región pobre

Con $\alpha = 0.3$, $\delta = 0.05$, $\rho = 0.03$ y $\theta = 2$, la tasa de
ahorro óptima, $1 - c/f(k)$, sobre la rama estable es:

| Capital inicial | Consumo inicial | Tasa de ahorro |
|---|---|---|
| $k^\ast/4 \approx 1.65$ | 0.81 | 31% |
| $k^\ast/2 \approx 3.30$ | 1.07 | 25% |
| $k^\ast \approx 6.61$ | 1.43 | 19% |
| $1.5k^\ast \approx 9.91$ | 1.71 | 14% |

Una región pobre **ahorra una fracción mayor** de su producto: el capital
rinde más donde escasea. En el estado estacionario, la tasa de ahorro es
$\alpha\delta/(\delta + \rho) = 18.75\%$, menor que la de la regla de oro,
$\alpha = 30\%$. A diferencia del modelo de Solow, donde la tasa de ahorro
era fija, aquí se elige y cambia a lo largo de la transición. Los valores de
la tabla se obtienen numéricamente con el método de disparo del cuaderno.

### 3.6 Estática comparativa en el diagrama

Si $\rho$ baja (la economía se vuelve más paciente), la isoclina
$\dot c = 0$ se mueve a la derecha y $k^\ast$ sube. Si el cambio es
permanente e inesperado, el capital no puede saltar (es un estado), pero el
consumo sí (es una decisión): en el momento del cambio, $c$ salta hacia
abajo hasta la **nueva** rama estable, y desde ahí la economía acumula
capital hacia el nuevo estado estacionario. Es la lectura típica de un
diagrama de fase de optimización: **las variables de estado se mueven
despacio; las de control saltan a la rama estable**.

---

## 4. La rama estable como objeto: la variedad estable

Cerca del punto de silla, la rama estable es tangente al eigenvector estable
del jacobiano (sesión 7). Lejos, se curva. El **teorema de la variedad
estable** dice que el conjunto de puntos que llegan al punto de silla es una
curva suave, tangente al eigenvector estable
([D.A2](repaso/ecuaciones_diferenciales.md#da2)).

**Cómo se calcula.** Se parte de un punto muy cercano al equilibrio sobre
el eigenvector estable, $(k^\ast, c^\ast) \pm \varepsilon v_s$, y se integra
el sistema **hacia atrás en el tiempo**. Hacia atrás, la dirección estable
se vuelve inestable, y la trayectoria recorre la rama alejándose del
equilibrio. Así se dibuja en el cuaderno. La otra forma, el **disparo**,
busca por bisección el $c_0$ que no agota el capital ni lo acumula de más;
es el método del Laboratorio 1 y de la sesión 12. Detalles en [Para
profundizar, P.1](#pp1).

---

## 5. Hacia la optimización dinámica

| Idea de esta sesión | Dónde reaparece |
|---|---|
| Diagrama de fase de Ramsey | Se deriva con el principio del máximo y se calibra para México (sesión 12) |
| La rama estable es la función de política | La función de política de la programación dinámica (sesiones 15 y 16) |
| El control salta, el estado no | El coestado y el control se ajustan al instante; el capital, no (sesiones 11 y 12) |
| Separatriz y cuencas de atracción | Problemas no cóncavos con más de un candidato a óptimo |
| Disparo por bisección | Laboratorio 1 y problemas de valor en la frontera (sesiones 9 y 12) |

---

## 6. Resumen formal

| Concepto | Enunciado | Dónde |
|---|---|---|
| Isoclinas | $f = 0$ (cruce vertical) y $g = 0$ (cruce horizontal); sus intersecciones son los equilibrios | 1.1 |
| Direcciones | El signo de $f$ y $g$ es constante entre isoclinas | 1.2 |
| Trayectorias en el plano | No se cruzan; las acotadas van a un equilibrio o a un ciclo | 1.4 |
| Competencia entre regiones | Coexistencia si $a, b < 1$; una región se queda con todo si $a, b > 1$ | 2.4 |
| Separatriz | Las ramas estables de un punto de silla dividen el plano en cuencas | 2.4 |
| Ramsey | Isoclinas $c = f(k) - \delta k$ y $k = k^\ast$; punto de silla | 3.2, 3.3 |
| Regla de oro modificada | $f'(k^\ast) = \delta + \rho$, con $k^\ast < k_{RO}$ | 3.2 |
| Función de política | La rama estable $c = \sigma(k)$ | 3.4 |
| Ahorro en la transición | Una región pobre ahorra una fracción mayor | 3.5 |
| Variedad estable | Curva tangente al eigenvector estable; se calcula integrando hacia atrás | 4 |

---

## 7. Ejercicios formales

- **F1.** Dibuja el diagrama de fase de $\dot x = y - x^2$, $\dot y = x - y$:
  isoclinas, equilibrios, su tipo y las direcciones del flujo.
- **F2.** En el modelo de competencia, clasifica los cuatro equilibrios con
  $a = 0.5$, $b = 0.5$ y con $a = 2$, $b = 2$. En el segundo caso, ¿a dónde
  va una trayectoria que empieza en $(0.5, 0.4)$? ¿Y en $(0.4, 0.5)$?
- **F3.** En el modelo de Ramsey, ¿cómo se mueven las isoclinas, $k^\ast$ y
  $c^\ast$ si sube la depreciación $\delta$? Describe la trayectoria del
  consumo y del capital después de un aumento permanente e inesperado de
  $\delta$.
- **F4.** Calcula $k^\ast$, $k_{RO}$ y la tasa de ahorro de estado
  estacionario con $\alpha = 0.35$, $\delta = 0.06$ y $\rho = 0.02$.
  Muestra que, en general, la tasa de ahorro de estado estacionario es
  $\alpha\delta/(\delta + \rho)$.

**Para profundizar** (opcionales)

- **F5.** Muestra que $V(x, y) = x^2 + y^2$ es una función de Liapunov para
  $\dot x = -x + y$, $\dot y = -x - y^3$ ([P.2](#pp2)).
- **F6.** En el modelo de competencia con $a < 1 < b$, muestra que no hay
  equilibrio interior en el cuadrante positivo y que $(1, 0)$ atrae a toda
  trayectoria con $x_0 > 0$. (Pista: mira la región entre las dos
  isoclinas.)
- **F7.** En Ramsey, ¿por qué una trayectoria por encima de la rama estable
  agota el capital en tiempo **finito** y no sólo asintóticamente?

## Para profundizar

Material opcional: demostraciones y temas que no se ven en clase. Cada
apartado indica de qué sección de las notas viene.

<a id="pp1"></a>

### P.1 El teorema de la variedad estable y su cálculo (sección 4)

**Teorema (variedad estable).** Si $x^\ast$ es un punto de silla hiperbólico
de un sistema suave en el plano, el conjunto
$W^s = \lbrace x_0 : x(t) \to x^\ast\rbrace$ es, cerca de $x^\ast$, una curva
suave que pasa por $x^\ast$ y es tangente al eigenvector estable de
$J(x^\ast)$. La variedad inestable $W^u$ se define igual con $t \to -\infty$
y es tangente al eigenvector inestable
([D.A2](repaso/ecuaciones_diferenciales.md#da2)).

**Integrar hacia atrás.** Si $x(t)$ resuelve $\dot x = F(x)$, entonces
$z(s) = x(-s)$ resuelve $\dot z = -F(z)$. Cambiar el signo de $F$ cambia el
signo de los eigenvalores del jacobiano: la dirección estable se vuelve
inestable. Una trayectoria de $\dot z = -F(z)$ que empieza en
$x^\ast + \varepsilon v_s$ se aleja de $x^\ast$ siguiendo $W^s$, y es la
rama estable recorrida al revés. El error inicial de partir de la recta
tangente en lugar de la curva es del orden de $\varepsilon^2$, y la
dinámica hacia atrás lo reduce, porque las direcciones transversales a
$W^s$ se contraen al integrar hacia atrás.

**Disparo.** Para un $k_0$ dado, la función $c_0 \mapsto$ (destino de la
trayectoria) cambia de "se agota el capital" a "se acumula de más"
exactamente en la rama estable. La bisección sobre $c_0$ encuentra ese
punto con la precisión que se quiera, aunque en la práctica la
inestabilidad del punto de silla limita cuánto tiempo puede seguirse la
trayectoria (Laboratorio 1).

<a id="pp2"></a>

### P.2 Funciones de Liapunov

La linealización decide la estabilidad sólo cerca del equilibrio y sólo en
casos hiperbólicos. Una **función de Liapunov** es una $V$ con
$V(x^\ast) = 0$, $V > 0$ fuera de $x^\ast$ y

$$
\dot V = \nabla V(x)^\top F(x) \le 0
$$

a lo largo de las trayectorias ([D.A4](repaso/ecuaciones_diferenciales.md#da4)).
Entonces $x^\ast$ es estable, y asintóticamente estable si
$\dot V < 0$ fuera de $x^\ast$: $V$ funciona como una "energía" que nunca
aumenta. Si la desigualdad vale en todo el plano y $V$ crece sin límite
lejos de $x^\ast$, la estabilidad es **global**. En programación dinámica,
la distancia a la función valor hace un papel parecido: el operador de
Bellman la reduce en cada iteración (sesión 16).

---

## Referencias

- Strogatz, S. H. (2015). *Nonlinear Dynamics and Chaos* (2.ª ed.). Westview
  Press.
