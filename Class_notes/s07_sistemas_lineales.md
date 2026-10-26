# Sesión 7: Sistemas de ecuaciones diferenciales y linealización

> **Cómo usar estas notas.** La clase se da en el pizarrón y sigue estas
> notas en su orden. El **plan de clase** de abajo dice qué secciones se
> escriben en el pizarrón, cuándo se proyecta el cuaderno
> (`Code/s07_sistemas_lineales.jl`) y qué queda para leer. En el pizarrón
> van las ecuaciones y los resultados en recuadro; el texto que las rodea es
> lo que se explica de palabra. Como todo está aquí, en clase no hace falta
> copiar. El cuerpo de las notas es la **ruta básica** y se evalúa; las
> demostraciones y los temas opcionales están al final, en **Para
> profundizar**, y no se ven en clase.
>
> Repaso recomendado: [L.B1–B3](repaso/algebra_lineal.md#lb1) (matrices,
> sistemas y determinantes), [L.I1–I3](repaso/algebra_lineal.md#li1)
> (eigenvalores, diagonalización y eigenvalores complejos),
> [L.I6](repaso/algebra_lineal.md#li6) (jacobiano),
> [D.I3](repaso/ecuaciones_diferenciales.md#di3) (lineales de segundo
> orden) y [D.I5](repaso/ecuaciones_diferenciales.md#di5) (sistemas lineales
> de dos dimensiones); para Para profundizar,
> [D.A1](repaso/ecuaciones_diferenciales.md#da1) (Hartman-Grobman) y
> [D.A5](repaso/ecuaciones_diferenciales.md#da5) (sistemas discretos).
>
> Lecturas: Chiang y Wainwright (2006), cap. 16 y secs. 19.5–19.6; Strogatz
> (2015), caps. 5–6.

**Plan de clase** (120 minutos)

| Minutos | Dónde | Qué | Secciones |
|---|---|---|---|
| 0–5 | Pizarra | La pregunta: dos regiones que se afectan entre sí | 0 |
| 5–15 | Pizarra | Repaso: eigenvalores, traza y determinante | 1 |
| 15–30 | Pizarra | La solución por modos; los casos complejo y repetido, de palabra | 2.1 |
| 30–42 | Pizarra | Clasificación por la traza y el determinante; la Proposición 2 | 2.2 |
| 42–50 | Proyector | El explorador de $A$: retrato de fase y plano traza-determinante | Cuaderno, sección 1 |
| 50–62 | Pizarra | Dos regiones con derrames (nodo); el primer punto de silla, $\ddot y = y$ | 2.3, 2.4 |
| 62–67 | | Pausa | |
| 67–74 | Proyector | Tres sistemas regionales, incluido el ciclo inmobiliario (foco) | Cuaderno, sección 2; notas, 2.5 |
| 74–82 | Pizarra | Ecuaciones de segundo orden como sistemas | 3 |
| 82–92 | Pizarra y proyector | Sistemas en tiempo discreto: $\lvert\lambda\rvert < 1$; continuo contra discreto | 4; cuaderno, sección 3 |
| 92–108 | Pizarra y proyector | Linealización con el jacobiano; el punto de silla de Ramsey | 5.1, 5.2; cuaderno, sección 4 |
| 108–118 | Parejas | Ejercicio F1 a mano | 8 |
| 118–120 | Pizarra | Cierre: diagramas de fase no lineales (sesión 8) | 6 |
| Después | Lectura | El ciclo inmobiliario en detalle (2.5), el centro (2.6), el término constante (2.7), el triángulo de estabilidad (P.3), Hartman-Grobman (P.2), el resumen (7) y Para profundizar | |

**Pregunta de la unidad.** ¿Convergen los estados de México? ¿A qué
velocidad?

---

## 0. La pregunta

Hasta ahora cada región tenía su propia ecuación. Pero las regiones se
afectan entre sí: el capital y la población se mueven, la demanda de una
región compra producción de otra, y el crecimiento de una se derrama sobre
sus vecinas. Con dos regiones que interactúan, el estado es un **vector** y
la dinámica es un **sistema** de ecuaciones diferenciales.

En una dimensión había dos destinos posibles cerca de un equilibrio:
acercarse o alejarse. En dos dimensiones hay más: acercarse en línea recta,
acercarse girando, girar sin acercarse, o acercarse por una dirección y
alejarse por otra. Este último caso, el **punto de silla**, es el que
aparece en todos los modelos de crecimiento óptimo (sesiones 10 y 12).

---

## 1. Repaso: eigenvalores, traza y determinante

Para una matriz $A$ de $2 \times 2$, un **eigenvector** $v \ne 0$ con
**eigenvalor** $\lambda$ cumple $Av = \lambda v$: en la dirección de $v$,
aplicar $A$ sólo estira por el factor $\lambda$
([L.I1](repaso/algebra_lineal.md#li1)). Hay un $v \ne 0$ así si y sólo si
$A - \lambda I$ no es invertible. Con la traza $\tau = a_{11} + a_{22}$ y el
determinante $\Delta = \det A$:

$$
\det(A - \lambda I) = (a_{11} - \lambda)(a_{22} - \lambda) - a_{12}a_{21}
= \lambda^2 - (a_{11} + a_{22})\lambda + (a_{11}a_{22} - a_{12}a_{21}),
$$

así que los eigenvalores son las raíces de

$$
\boxed{\ \lambda^2 - \tau\lambda + \Delta = 0,
\qquad
\lambda_{1,2} = \frac{\tau \pm \sqrt{\tau^2 - 4\Delta}}{2}\ }
$$

y cumplen $\lambda_1 + \lambda_2 = \tau$ y $\lambda_1\lambda_2 = \Delta$.
Estas dos relaciones bastan para casi todo lo que sigue.

---

## 2. Sistemas lineales $\dot x = Ax$

### 2.1 La solución por modos

**Proposición 1.** Si $A$ tiene dos eigenvalores reales distintos
$\lambda_1, \lambda_2$ con eigenvectores $v_1, v_2$, la solución de
$\dot x = Ax$ con $x(0) = x_0$ es

$$
\boxed{\ x(t) = c_1e^{\lambda_1t}v_1 + c_2e^{\lambda_2t}v_2\ }
$$

donde $(c_1, c_2)$ son las coordenadas de $x_0$ en la base de
eigenvectores: $x_0 = c_1v_1 + c_2v_2$.

*Demostración.* Cada término cumple la ecuación:
$\frac{d}{dt}\big(e^{\lambda_it}v_i\big) = \lambda_ie^{\lambda_it}v_i = Ae^{\lambda_it}v_i$.
La suma también, por linealidad, y en $t = 0$ vale $x_0$. La unicidad es
la de la sesión 6. $\square$

**Lectura.** Cada eigenvector es un **modo** que evoluciona por su cuenta
([L.I2](repaso/algebra_lineal.md#li2)): el modo $i$ crece o decae como
$e^{\lambda_it}$, exactamente como en la sesión 5. Un sistema de dos
ecuaciones acopladas se convierte en dos ecuaciones independientes al
mirarlo en la base correcta.

Si los eigenvalores son complejos, $\lambda = \alpha \pm i\omega$, las
soluciones son combinaciones de $e^{\alpha t}\cos\omega t$ y
$e^{\alpha t}\sin\omega t$: giran con frecuencia $\omega$ y su amplitud
cambia como $e^{\alpha t}$ ([L.I3](repaso/algebra_lineal.md#li3)). Ver
[Para profundizar, P.1](#pp1).

Si hay un **eigenvalor repetido** $\lambda = \tau/2$ (cuando
$\tau^2 = 4\Delta$) y $A$ no es un múltiplo de la identidad, sólo hay una
dirección de eigenvectores $v$, y las soluciones son

$$
x(t) = e^{\lambda t}\big(c_1v + c_2(tv + w)\big),
\qquad (A - \lambda I)w = v.
$$

El factor $t$ aparece como en la ecuación de segundo orden con raíz doble
([D.I3](repaso/ecuaciones_diferenciales.md#di3)). El comportamiento lo
sigue decidiendo el signo de $\lambda$: no hay giro, y es el caso frontera
entre un nodo y un foco.

### 2.2 Clasificación por la traza y el determinante

El origen es un equilibrio de $\dot x = Ax$. Su tipo depende sólo de $\tau$ y
$\Delta$ ([D.I5](repaso/ecuaciones_diferenciales.md#di5)):

| Condición | Eigenvalores | Tipo | Comportamiento |
|---|---|---|---|
| $\Delta < 0$ | Reales, de signo opuesto | **Punto de silla** | Inestable; sólo converge lo que empieza sobre la recta estable |
| $\Delta > 0$, $\tau < 0$, $\tau^2 \ge 4\Delta$ | Reales negativos | **Nodo estable** | Converge sin girar |
| $\Delta > 0$, $\tau < 0$, $\tau^2 < 4\Delta$ | Complejos, parte real negativa | **Foco estable** | Converge girando: ciclos amortiguados |
| $\Delta > 0$, $\tau = 0$ | Imaginarios puros | **Centro** | Órbitas cerradas: ciclos que no se amortiguan |
| $\Delta > 0$, $\tau > 0$ | Parte real positiva | Nodo o foco inestable | Se aleja |
| $\Delta = 0$ | Al menos uno es cero | No hiperbólico | Una recta de equilibrios |

**Proposición 2.** El origen es asintóticamente estable si y sólo si

$$
\boxed{\ \tau < 0 \quad\text{y}\quad \Delta > 0\ }
$$

*Demostración.* Si los eigenvalores son reales, $\Delta > 0$ dice que tienen
el mismo signo y $\tau < 0$ que ese signo es negativo. Si son complejos,
$\Delta = \alpha^2 + \omega^2 > 0$ siempre, y la parte real es
$\alpha = \tau/2$. $\square$

**El diagrama traza-determinante.** En el plano $(\tau, \Delta)$, la
parábola $\Delta = \tau^2/4$ separa nodos (debajo) de focos (encima). El
semieje $\tau = 0$, $\Delta > 0$ son los centros, y todo el semiplano
$\Delta < 0$ son puntos de silla. La región estable es el cuadrante
$\tau < 0$, $\Delta > 0$. El cuaderno lo dibuja.

### 2.3 Ejemplo: dos regiones con derrames (nodo estable)

*Modelo ilustrativo, construido para esta sesión.*

Sea $z_i$ la brecha de ingreso de la región $i$ respecto de su estado
estacionario. Cada región converge a la tasa $\beta$ (sesión 5) y, además,
la brecha de una arrastra a la otra con intensidad $\mu > 0$: si la región
2 está mejor, la región 1 se beneficia.

$$
\dot z_1 = -\beta z_1 + \mu(z_2 - z_1),
\qquad
\dot z_2 = -\beta z_2 + \mu(z_1 - z_2),
\qquad
A = \begin{pmatrix} -\beta - \mu & \mu \cr \mu & -\beta - \mu \end{pmatrix}.
$$

Los eigenvectores se comprueban multiplicando:

$$
A\begin{pmatrix} 1 \cr 1 \end{pmatrix}
= \begin{pmatrix} -\beta - \mu + \mu \cr \mu - \beta - \mu \end{pmatrix}
= -\beta\begin{pmatrix} 1 \cr 1 \end{pmatrix},
\qquad
A\begin{pmatrix} 1 \cr -1 \end{pmatrix}
= \begin{pmatrix} -\beta - 2\mu \cr \beta + 2\mu \end{pmatrix}
= (-\beta - 2\mu)\begin{pmatrix} 1 \cr -1 \end{pmatrix}.
$$

Los eigenvalores son $-\beta$, con eigenvector $(1, 1)$, y $-\beta - 2\mu$,
con eigenvector $(1, -1)$. Los dos modos tienen lectura económica:

- **El modo común** $(1, 1)$: un choque que afecta igual a las dos regiones
  decae a la tasa $\beta$. Los derrames no lo aceleran.
- **El modo diferencial** $(1, -1)$: la diferencia entre las dos regiones
  decae a la tasa $\beta + 2\mu$, más rápido. **Los derrames cierran las
  brechas entre regiones, no la brecha con el estado estacionario.**

Con $\beta = 0.02$ y $\mu = 0.03$: un choque común tarda $\ln 2/0.02 \approx 35$
años en reducirse a la mitad; una diferencia entre regiones, sólo
$\ln 2/0.08 \approx 9$ años.

### 2.4 Ejemplo: el primer punto de silla del curso

Minimizar $\int_0^T(\dot y^2 + y^2)\thinspace dt$ lleva (sesión 10) a la
ecuación $\ddot y = y$ ([D.I3](repaso/ecuaciones_diferenciales.md#di3)).
Con $x = (y, \dot y)$,

$$
\dot x = \begin{pmatrix} 0 & 1 \cr 1 & 0 \end{pmatrix}x,
\qquad \tau = 0,\quad \Delta = -1:
$$

un punto de silla. Los eigenvalores cumplen $\lambda^2 - 1 = 0$, así que
son $-1$ y $1$, con eigenvectores $(1, -1)$ y $(1, 1)$:
$A(1, -1)^\top = (-1, 1)^\top$ y $A(1, 1)^\top = (1, 1)^\top$. La solución es
$y(t) = c_1e^{-t} + c_2e^{t}$.

Dado $y(0) = y_0$, todavía hay que elegir $\dot y(0)$. Casi toda elección
tiene $c_2 \ne 0$ y explota. Para que $c_2 = 0$, la condición inicial
$(y_0, \dot y(0))$ tiene que estar sobre el eigenvector estable $(1, -1)$:
**sólo $\dot y(0) = -y_0$** converge al origen. En los problemas de optimización con horizonte infinito, el estado
inicial está dado y la variable que falta (el consumo, el coestado) se elige
justamente así: para caer sobre la **rama estable** del punto de silla
(sesiones 10 y 12).

### 2.5 Ejemplo: el ciclo inmobiliario regional (foco estable)

*Modelo ilustrativo, construido para esta sesión con la lógica de los
modelos de acervo y flujo del mercado de vivienda.*

En el mercado de vivienda de una región, sean $p$ el precio y $H$ el
acervo de vivienda, los dos medidos como desviaciones de su equilibrio. El
precio baja cuando sobra vivienda y se corrige hacia su nivel normal; la
construcción responde al precio con rezago, y la vivienda se deprecia:

$$
\dot p = -\eta p - H,
\qquad
\dot H = \psi p - \delta H,
\qquad
A = \begin{pmatrix} -\eta & -1 \cr \psi & -\delta \end{pmatrix}.
$$

$\tau = -(\eta + \delta) < 0$ y $\Delta = \eta\delta + \psi > 0$: siempre
estable. Si la construcción responde mucho al precio ($\psi$ grande),
$\tau^2 < 4\Delta$ y el equilibrio es un **foco**: precio y acervo oscilan
mientras convergen. Con $\eta = 0.2$, $\psi = 0.5$ y $\delta = 0.05$, los
eigenvalores son $-0.125 \pm 0.70i$: un ciclo de $2\pi/0.70 \approx 9$
años, cuya amplitud se reduce a la mitad cada $\ln 2/0.125 \approx 5.5$
años.

**Lectura.** El ciclo no viene de choques externos: lo genera la propia
dinámica del mercado. Un precio alto atrae construcción; cuando la
vivienda nueva llega, el precio ya bajó, y se construye de más.

### 2.6 El centro: sólo reconocerlo

Si $\tau = 0$ y $\Delta > 0$, las órbitas son elipses cerradas: ciclos que
ni crecen ni se amortiguan. En el ejemplo anterior, ocurriría con
$\eta = \delta = 0$. Es un caso **frágil**: cualquier término de
amortiguamiento, por pequeño que sea, lo convierte en foco. En la economía
casi no se usa, y en el curso sólo hace falta reconocerlo.

### 2.7 Con término constante

Para $\dot x = Ax + b$ con $\Delta \ne 0$, el equilibrio es
$x^\ast = -A^{-1}b$ ([L.B2](repaso/algebra_lineal.md#lb2)), y la desviación
$h = x - x^\ast$ cumple $\dot h = Ah$. Todo lo anterior se aplica alrededor
de $x^\ast$: es la misma receta de la sesión 5, ahora con vectores.

---

## 3. Ecuaciones de segundo orden como sistemas

La ecuación $\ddot y + a_1\dot y + a_2y = 0$ se escribe como un sistema con
$x = (y, \dot y)$:

$$
\dot x = \begin{pmatrix} 0 & 1 \cr -a_2 & -a_1 \end{pmatrix}x,
\qquad \tau = -a_1,\quad \Delta = a_2.
$$

(La primera ecuación, $\dot x_1 = x_2$, dice que $x_2 = \dot y$; la segunda
es la ecuación original despejada, $\ddot y = -a_2y - a_1\dot y$.) El
polinomio característico de la matriz,

$$
\det\begin{pmatrix} -\lambda & 1 \cr -a_2 & -a_1 - \lambda \end{pmatrix}
= \lambda(a_1 + \lambda) + a_2 = \lambda^2 + a_1\lambda + a_2,
$$

es
la **ecuación característica** de la ecuación de segundo orden
([D.I3](repaso/ecuaciones_diferenciales.md#di3)): las raíces características
son los eigenvalores. Según el discriminante $a_1^2 - 4a_2$:

| Raíces características | Solución | Comportamiento |
|---|---|---|
| Reales distintas ($a_1^2 > 4a_2$) | $c_1e^{r_1t} + c_2e^{r_2t}$ | Nodo o punto de silla: no oscila |
| Repetida ($a_1^2 = 4a_2$), $r = -a_1/2$ | $(c_1 + c_2t)e^{rt}$ | Caso frontera: no oscila |
| Complejas ($a_1^2 < 4a_2$), $\alpha \pm i\omega$ | $e^{\alpha t}(c_1\cos\omega t + c_2\sin\omega t)$ | Foco o centro: oscila |

Por la Proposición 2, la ecuación es estable si y sólo si $a_1 > 0$ y
$a_2 > 0$.

Esto importa porque la ecuación de Euler del cálculo de variaciones suele
ser de segundo orden (sesión 10). Al escribirla como sistema, se analiza con
las mismas herramientas que cualquier otro par de ecuaciones.

---

## 4. Sistemas lineales en tiempo discreto

Para $x_{t+1} = Ax_t$, la solución por modos es
$x_t = c_1\lambda_1^tv_1 + c_2\lambda_2^tv_2$
([L.I2](repaso/algebra_lineal.md#li2)). El modo $i$ decae si
$\lvert\lambda_i\rvert < 1$.

**Proposición 3.** El origen de $x_{t+1} = Ax_t$ es asintóticamente
estable si y sólo si los dos eigenvalores tienen módulo menor que 1. Para
una matriz $2 \times 2$, esto equivale a

$$
\lvert\tau\rvert < 1 + \Delta
\qquad\text{y}\qquad
\Delta < 1.
$$

*Demostración de la equivalencia*: en [Para profundizar, P.3](#pp3).

| | Tiempo continuo | Tiempo discreto |
|---|---|---|
| El modo $i$ decae si | $\mathrm{Re}\thinspace\lambda_i < 0$ | $\lvert\lambda_i\rvert < 1$ |
| Región estable de los eigenvalores | Semiplano izquierdo | Disco unitario |
| Punto de silla | Un eigenvalor positivo y otro negativo | Uno dentro y otro fuera del disco |

Como en la sesión 6, el método de Euler con paso $h$ convierte $\dot x = Ax$
en $x_{t+1} = (I + hA)x_t$, con eigenvalores $1 + h\lambda_i$. Si $h$ es
grande, $1 + h\lambda$ puede salir del disco unitario aunque
$\mathrm{Re}\thinspace\lambda < 0$.

---

## 5. Linealización

### 5.1 El jacobiano en el equilibrio

Sea $\dot x = F(x)$ con $F: \mathbb{R}^2 \to \mathbb{R}^2$ suave y
$F(x^\ast) = 0$. Cerca de $x^\ast$, por el desarrollo de Taylor
([C.I7](repaso/calculo.md#ci7)),

$$
\boxed{\ \dot x = F(x) \approx F(x^\ast) + J(x^\ast)(x - x^\ast) = J(x^\ast)(x - x^\ast)\ }
$$

donde $J$ es el **jacobiano**: la matriz de derivadas parciales
$J_{ij} = \partial F_i/\partial x_j$ ([L.I6](repaso/algebra_lineal.md#li6)).
La desviación $h = x - x^\ast$ cumple, aproximadamente, el sistema lineal
$\dot h = Jh$. Es la versión en dos dimensiones del criterio $f'(x^\ast)$ de
la sesión 6.

**Regla práctica.** Si ningún eigenvalor de $J(x^\ast)$ tiene parte real
cero (el equilibrio es **hiperbólico**), el equilibrio del sistema no lineal
es del mismo tipo que el del sistema linealizado: estable si los dos
eigenvalores tienen parte real negativa, punto de silla si tienen signos
opuestos. Es el teorema de Hartman-Grobman: ver [Para profundizar,
P.2](#pp2). Si algún eigenvalor tiene parte real cero (un centro, por
ejemplo), la linealización **no decide**.

### 5.2 Ejemplo: el modelo de Ramsey

En la sesión 12 se deriva el sistema del modelo de Ramsey para el capital
$k$ y el consumo $c$ de una economía:

$$
\dot k = f(k) - \delta k - c,
\qquad
\dot c = \frac{c}{\theta}\big(f'(k) - \delta - \rho\big),
$$

con $f(k) = k^\alpha$. En el estado estacionario, $f'(k^\ast) = \delta + \rho$
y $c^\ast = f(k^\ast) - \delta k^\ast$. Las cuatro derivadas parciales son

$$
\frac{\partial\dot k}{\partial k} = f'(k) - \delta,
\qquad
\frac{\partial\dot k}{\partial c} = -1,
\qquad
\frac{\partial\dot c}{\partial k} = \frac{c\thinspace f''(k)}{\theta},
\qquad
\frac{\partial\dot c}{\partial c} = \frac{f'(k) - \delta - \rho}{\theta},
$$

y el jacobiano en el estado estacionario es

$$
J = \begin{pmatrix} f'(k^\ast) - \delta & -1 \cr \dfrac{c^\ast f''(k^\ast)}{\theta} & 0 \end{pmatrix}
= \begin{pmatrix} \rho & -1 \cr \dfrac{c^\ast f''(k^\ast)}{\theta} & 0 \end{pmatrix}.
$$

(La entrada $\partial\dot c/\partial c$ vale cero en el estado estacionario,
porque ahí $f'(k^\ast) = \delta + \rho$.) Su determinante es

$$
\boxed{\ \Delta = \rho\cdot 0 - (-1)\frac{c^\ast f''(k^\ast)}{\theta} = \frac{c^\ast f''(k^\ast)}{\theta} < 0\ }
$$

porque $f'' < 0$: **el estado estacionario de Ramsey es un punto de silla**,
sin importar los valores de los parámetros.

Con $\alpha = 0.3$, $\delta = 0.05$, $\rho = 0.03$ y $\theta = 2$:
$k^\ast \approx 6.61$, $c^\ast \approx 1.43$ y los eigenvalores son
$-0.064$ y $0.094$. Sobre la rama estable, la economía converge a una
velocidad de 6.4% anual: la mitad de la brecha se cierra en unos 11 años.
Es la velocidad de convergencia de la sesión 5, ahora con el ahorro elegido
de manera óptima en lugar de fijo.

---

## 6. Hacia la optimización dinámica

| Idea de esta sesión | Dónde reaparece |
|---|---|
| Punto de silla y rama estable | La elección del consumo inicial en Ramsey y la condición de transversalidad (sesión 12) |
| Ecuación de segundo orden como sistema | La ecuación de Euler del cálculo de variaciones (sesión 10) |
| Linealización con el jacobiano | Diagramas de fase no lineales e isoclinas (sesión 8) |
| Velocidad = eigenvalor estable | La velocidad de convergencia de Ramsey calibrado (sesión 12) |
| Estabilidad discreta con $\lvert\lambda\rvert < 1$ | La ecuación de Euler en tiempo discreto y el punto de silla discreto (sesión 18) |

---

## 7. Resumen formal

| Concepto | Enunciado | Dónde |
|---|---|---|
| Eigenvalores $2 \times 2$ | Raíces de $\lambda^2 - \tau\lambda + \Delta$; suma $\tau$, producto $\Delta$ | 1 |
| Solución por modos | $x(t) = c_1e^{\lambda_1t}v_1 + c_2e^{\lambda_2t}v_2$ | 2.1 |
| Clasificación | Silla si $\Delta < 0$; foco si $\tau^2 < 4\Delta$; centro si $\tau = 0 < \Delta$ | 2.2 |
| Estabilidad continua | Estable $\iff \tau < 0$ y $\Delta > 0$ | 2.2 |
| Derrames | Cierran las brechas entre regiones, no la brecha con el estado estacionario | 2.3 |
| Punto de silla | Sólo converge lo que empieza sobre el eigenvector estable | 2.4 |
| Ciclo | Eigenvalores complejos: periodo $2\pi/\omega$ | 2.5 |
| Segundo orden | $\ddot y + a_1\dot y + a_2y = 0$ es estable $\iff a_1, a_2 > 0$ | 3 |
| Estabilidad discreta | $\lvert\lambda_i\rvert < 1 \iff \lvert\tau\rvert < 1 + \Delta$ y $\Delta < 1$ | 4 |
| Linealización | En un equilibrio hiperbólico, el tipo lo decide $J(x^\ast)$ | 5.1 |
| Ramsey | Su estado estacionario es siempre un punto de silla | 5.2 |

---

## 8. Ejercicios formales

- **F1.** Clasifica el origen para las tres matrices siguientes y, para la
  segunda, encuentra la recta estable:

$$
\begin{pmatrix} -1 & 2 \cr 0 & -3\end{pmatrix}, \qquad
\begin{pmatrix} 1 & 2 \cr 2 & 1\end{pmatrix}, \qquad
\begin{pmatrix} -1 & -4 \cr 1 & -1\end{pmatrix}.
$$

- **F2.** En el modelo de derrames, ¿qué valor de $\mu$ hace que una
  diferencia entre las regiones se cierre a la mitad en 5 años, con
  $\beta = 0.02$? ¿Cambia la vida media de un choque común?
- **F3.** Escribe $\ddot y + 0.4\dot y + 4y = 0$ como sistema, clasifica el
  equilibrio y calcula el periodo de las oscilaciones.
- **F4.** En el ciclo inmobiliario, ¿para qué valores de $\psi$ el
  equilibrio es un nodo y no un foco, con $\eta = 0.2$ y $\delta = 0.05$?
  Interpreta: ¿qué tipo de mercado regional no tiene ciclos?

**Para profundizar** (opcionales)

- **F5.** Clasifica el origen de $x_{t+1} = Ax_t$ con
  $A$ de filas $(0.5, 0.4)$ y $(0.3, 0.6)$, primero con
  los eigenvalores y después con el triángulo de [P.3](#pp3).
- **F6.** En el modelo de Ramsey, muestra que la pendiente de la rama
  estable cerca de $(k^\ast, c^\ast)$ es $dc/dk = \rho - \lambda_s$, donde
  $\lambda_s < 0$ es el eigenvalor estable. Interpreta su signo.
- **F7.** Muestra con el ejemplo de [P.2](#pp2) que un centro de la
  linealización puede ser, en el sistema no lineal, un foco estable o
  inestable.

## Para profundizar

Material opcional: demostraciones y temas que no se ven en clase. Cada
apartado indica de qué sección de las notas viene.

<a id="pp1"></a>

### P.1 Eigenvalores complejos (sección 2.1)

Si $\lambda = \alpha + i\omega$ es eigenvalor con eigenvector complejo
$v = u + iw$, entonces $e^{\lambda t}v$ es una solución compleja. Como $A$
es real, sus partes real e imaginaria también son soluciones:

$$
e^{\alpha t}(u\cos\omega t - w\sin\omega t),
\qquad
e^{\alpha t}(u\sin\omega t + w\cos\omega t).
$$

Toda solución real es combinación de las dos. El factor $e^{\alpha t}$
decide si la amplitud crece o decae, y las funciones trigonométricas hacen
que la trayectoria gire con periodo $2\pi/\omega$
([L.I3](repaso/algebra_lineal.md#li3)).

<a id="pp2"></a>

### P.2 El teorema de Hartman-Grobman y los casos no hiperbólicos (sección 5.1)

**Teorema (Hartman-Grobman).** Si $x^\ast$ es un equilibrio hiperbólico de
$\dot x = F(x)$, existe una vecindad de $x^\ast$ y una transformación
continua con inversa continua que lleva las trayectorias de $\dot x = F(x)$
en las de $\dot h = J(x^\ast)h$, respetando la dirección del tiempo
([D.A1](repaso/ecuaciones_diferenciales.md#da1)).

El teorema dice que cerca de un equilibrio hiperbólico el sistema no lineal
"se ve" como su linealización: mismo número de direcciones estables e
inestables, mismo tipo de equilibrio. No dice cuán grande es la vecindad.

**Un caso no hiperbólico.** El sistema

$$
\dot x = -y + \mu x(x^2 + y^2),
\qquad
\dot y = x + \mu y(x^2 + y^2)
$$

tiene en el origen el jacobiano

$$
\begin{pmatrix} 0 & -1 \cr 1 & 0\end{pmatrix},
$$

un centro. En coordenadas polares, $\dot r = \mu r^3$: si $\mu < 0$, las
trayectorias se acercan en espiral (foco estable); si $\mu > 0$, se alejan.
La linealización es la misma en los dos casos y no puede distinguirlos.

<a id="pp3"></a>

### P.3 El triángulo de estabilidad en tiempo discreto (sección 4)

Sea $p(\lambda) = \lambda^2 - \tau\lambda + \Delta$. **Raíces complejas**:
tienen módulo $\sqrt{\Delta}$, así que son estables si y sólo si
$\Delta < 1$; además $\tau^2 < 4\Delta \le (1 + \Delta)^2$, de modo que
$\lvert\tau\rvert < 1 + \Delta$ se cumple sola. **Raíces reales**: las dos
están en $(-1, 1)$ si y sólo si la parábola $p$, que abre hacia arriba, es
positiva en $\pm 1$ y su vértice $\tau/2$ está en $(-1, 1)$:
$p(1) = 1 - \tau + \Delta > 0$, $p(-1) = 1 + \tau + \Delta > 0$ y
$\lvert\tau\rvert < 2$. Las dos primeras son $\lvert\tau\rvert < 1 + \Delta$;
junto con $\Delta = \lambda_1\lambda_2 < 1$ implican la tercera. En el plano
$(\tau, \Delta)$, la región estable es el triángulo con vértices
$(-2, 1)$, $(2, 1)$ y $(0, -1)$.

---

## Referencias

- Chiang, A. C., & Wainwright, K. (2006). *Métodos fundamentales de economía
  matemática* (4.ª ed.). McGraw-Hill.
- Strogatz, S. H. (2015). *Nonlinear Dynamics and Chaos* (2.ª ed.). Westview
  Press.
