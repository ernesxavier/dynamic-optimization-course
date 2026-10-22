# Repaso: álgebra lineal

> Cada concepto tiene una clave (por ejemplo **[L.I2](#li2)**) y dice en qué
> sesiones se usa. El índice [README.md](README.md) indica qué repasar antes
> de cada sesión. Los fragmentos de Julia corren en el entorno del curso
> (`julia --project=Code`).
>
> - **Básico**: lo que se supone sabido al empezar el curso.
> - **Intermedio**: lo necesario para seguir las clases, las tareas y las
>   notas formales.
> - **Avanzado**: lo necesario para los puntos [Avanzado]: demostraciones y
>   extensiones.

---

## Nivel básico

<a id="lb1"></a>

### L.B1 Vectores y matrices
*Sesiones 2, 5, 7.*

Un **vector** $x \in \mathbb{R}^n$ es una lista de $n$ números; una
**matriz** $A$ de $m \times n$ tiene $m$ filas y $n$ columnas, y $a_{ij}$ es
la entrada de la fila $i$, columna $j$. Vectores en minúscula, matrices en
mayúscula. La **transpuesta** $A^\top$ intercambia filas y columnas: su
entrada $ij$ es $a_{ji}$. $A$ es **simétrica** si $A^\top = A$.

- **Producto punto**: $x^\top y = \sum_i x_i y_i$.
- **Producto matriz-vector**: si $y = Ax$, entonces $y_i = \sum_j a_{ij}x_j$.
  Cada entrada es el producto punto de una fila de $A$ con $x$.
- **Producto de matrices**: si $M = AB$, entonces
  $m_{ij} = \sum_k a_{ik}b_{kj}$. Requiere que $A$ tenga tantas columnas
  como filas tenga $B$. En general, $AB \ne BA$.
- **Identidad** $I$: unos en la diagonal, ceros fuera; $AI = IA = A$.

**Ejemplo dinámico.** Un sistema de dos regiones en el que el capital de cada
una depende del de ambas en el periodo anterior se escribe
$k_{t+1} = Ak_t$, con $k_t = (k_{1t}, k_{2t})$. Toda la dinámica está en la
matriz $A$ ([L.I2](#li2)).

```julia
A = [0.9 0.05; 0.1 0.85]
k = [1.0, 2.0]
A * k                      # [1.0, 1.8]
A * A * k ≈ A^2 * k        # true (con ≈: el redondeo puede diferir)
```

<a id="lb2"></a>

### L.B2 Sistemas de ecuaciones lineales
*Sesiones 3, 5, 7.*

Un sistema de $n$ ecuaciones lineales con $n$ incógnitas se escribe
$Ax = b$. Si $A$ es **invertible**, la solución única es $x = A^{-1}b$, donde
$A^{-1}A = AA^{-1} = I$. Para $2 \times 2$:

$$
A = \begin{pmatrix} a_{11} & a_{12} \cr a_{21} & a_{22} \end{pmatrix},
\qquad
A^{-1} = \frac{1}{a_{11}a_{22} - a_{12}a_{21}}\begin{pmatrix} a_{22} & -a_{12} \cr -a_{21} & a_{11} \end{pmatrix}:
$$

se intercambian los elementos de la diagonal, se cambia el signo de los de
fuera y se divide entre el determinante ([L.B3](#lb3)).

**Equilibrios.** El equilibrio de $\dot x = Ax + b$ es el punto donde
$\dot x = 0$: $x^\ast = -A^{-1}b$. El de $x_{t+1} = Ax_t + b$ cumple
$x^\ast = Ax^\ast + b$, es decir, $x^\ast = (I - A)^{-1}b$.

En Julia, `A \ b` resuelve el sistema sin calcular la inversa (es más
rápido y más preciso que `inv(A) * b`).

```julia
A = [-0.5 0.2; 0.1 -0.3]; b = [1.0, 0.5]
xstar = -(A \ b)           # equilibrio de ẋ = Ax + b: [3.0769…, 2.6923…]
A * xstar + b              # ≈ [0, 0]
```

<a id="lb3"></a>

### L.B3 Determinantes
*Sesiones 2, 3, 7.*

Para $2 \times 2$, $\det A = a_{11}a_{22} - a_{12}a_{21}$. Para
$3 \times 3$, por cofactores a lo largo de la primera fila: cada entrada se
multiplica por el determinante que queda al borrar su fila y su columna, con
signos alternados $+, -, +$.

$$
\det\begin{pmatrix} a_{11} & a_{12} & a_{13} \cr a_{21} & a_{22} & a_{23} \cr a_{31} & a_{32} & a_{33}\end{pmatrix}
= a_{11}\begin{vmatrix} a_{22} & a_{23} \cr a_{32} & a_{33}\end{vmatrix} -
a_{12}\begin{vmatrix} a_{21} & a_{23} \cr a_{31} & a_{33}\end{vmatrix} +
a_{13}\begin{vmatrix} a_{21} & a_{22} \cr a_{31} & a_{32}\end{vmatrix}.
$$

Se puede desarrollar por cualquier fila o columna; conviene elegir la que
tenga más ceros.

Propiedades:
- $\det A \ne 0$ si y sólo si $A$ es invertible, si y sólo si $Ax = b$
  tiene solución única.
- $\det(AB) = \det A\thinspace\det B$, $\det A^\top = \det A$ y
  $\det A^{-1} = 1/\det A$.
- Si $A$ es triangular (o diagonal), el determinante es el producto de la
  diagonal.
- Intercambiar dos filas cambia el signo; multiplicar una fila por $c$
  multiplica el determinante por $c$; sumar a una fila un múltiplo de otra
  no lo cambia.
- El determinante es el producto de los eigenvalores ([L.I1](#li1)).

<a id="lb4"></a>

### L.B4 Regla de Cramer
*Sesión 3.*

Si $\det A \ne 0$, la solución de $Ax = b$ es

$$
x_i = \frac{\det A_i}{\det A},
$$

donde $A_i$ es $A$ con la columna $i$ reemplazada por $b$.

**Ejemplo.** $2x + y = 5$, $x + 3y = 5$: $\det A = 6 - 1 = 5$ y

$$
x = \frac{1}{5}\begin{vmatrix} 5 & 1 \cr 5 & 3\end{vmatrix} = \frac{15 - 5}{5} = 2,
\qquad
y = \frac{1}{5}\begin{vmatrix} 2 & 5 \cr 1 & 5\end{vmatrix} = \frac{10 - 5}{5} = 1.
$$

**Uso en estática comparativa.** Al diferenciar las condiciones de primer
orden de $\max_{x_1, x_2} f(x_1, x_2; \alpha)$ respecto del parámetro
$\alpha$ ([C.I4](calculo.md#ci4)) se obtiene un sistema lineal en las
derivadas del óptimo:

$$
\begin{pmatrix} f_{11} & f_{12} \cr f_{12} & f_{22}\end{pmatrix}
\begin{pmatrix} dx_1/d\alpha \cr dx_2/d\alpha\end{pmatrix}
= -\begin{pmatrix} f_{1\alpha} \cr f_{2\alpha}\end{pmatrix}
\quad\Longrightarrow\quad
\frac{dx_1}{d\alpha} = \frac{-f_{1\alpha}f_{22} + f_{12}f_{2\alpha}}{f_{11}f_{22} - f_{12}^2}.
$$

La matriz es la hessiana. Si el óptimo es un máximo, la condición de segundo
orden ([L.I4](#li4)) dice que su determinante es positivo, así que el signo de
$dx_1/d\alpha$ es el del numerador. Ésta es la técnica de la sesión 3.

---

## Nivel intermedio

<a id="li1"></a>

### L.I1 Eigenvalores y eigenvectores
*Sesiones 5, 7, 8, 12.*

$v \ne 0$ es un **eigenvector** de $A$ con **eigenvalor** $\lambda$ si

$$
Av = \lambda v.
$$

En la dirección de $v$, aplicar $A$ sólo estira o encoge por el factor
$\lambda$. (En español también se dicen **valores y vectores propios**, o
raíces y vectores característicos, como en Chiang y Wainwright.) Los
eigenvalores son las raíces del **polinomio característico**
$\det(A - \lambda I) = 0$; para cada uno, los eigenvectores son las
soluciones no nulas de $(A - \lambda I)v = 0$.

**Caso $2 \times 2$.** Con $\tau = \mathrm{tr}\thinspace A = a_{11} + a_{22}$
y $\Delta = \det A$:

$$
\lambda^2 - \tau\lambda + \Delta = 0,
\qquad
\lambda_{1,2} = \frac{\tau \pm \sqrt{\tau^2 - 4\Delta}}{2},
\qquad
\lambda_1 + \lambda_2 = \tau,\quad \lambda_1\lambda_2 = \Delta.
$$

Estas dos relaciones bastan para clasificar los equilibrios de un sistema
$2 \times 2$ ([D.I5](ecuaciones_diferenciales.md#di5)): por ejemplo, si
$\Delta < 0$, los eigenvalores son reales y de signo opuesto.

**Ejemplo a mano.** La matriz

$$
A = \begin{pmatrix} 1 & 2 \cr 2 & 1\end{pmatrix}
$$

tiene $\tau = 2$ y $\Delta = -3$: $\lambda^2 - 2\lambda - 3 = 0$, así que
$\lambda_1 = 3$ y $\lambda_2 = -1$. Para $\lambda_1 = 3$,
$(A - 3I)v = 0$ da $-2v_1 + 2v_2 = 0$: $v = (1, 1)$, o cualquier múltiplo.
Para $\lambda_2 = -1$, $2v_1 + 2v_2 = 0$: $v = (1, -1)$.

```julia
using LinearAlgebra
A = [1.0 2.0; 2.0 1.0]
eigen(A)                   # valores -1 y 3; vectores (1, -1)/√2 y (1, 1)/√2
tr(A), det(A)              # (2.0, -3.0): suma y producto de los eigenvalores
```

<a id="li2"></a>

### L.I2 Diagonalización y sistemas lineales
*Sesiones 5, 7, 8, 12.*

Si $A$ ($n \times n$) tiene $n$ eigenvectores linealmente independientes
$v_1, \dots, v_n$, se **diagonaliza**:

$$
A = P\Lambda P^{-1},
\qquad P = (v_1 \ \cdots \ v_n),
\qquad \Lambda = \mathrm{diag}(\lambda_1, \dots, \lambda_n).
$$

Esto ocurre siempre que los $n$ eigenvalores son distintos. La utilidad:
$A^t = P\Lambda^tP^{-1}$, y las potencias (y exponenciales) de una matriz
diagonal se calculan entrada por entrada.

**Solución de sistemas lineales.** Se escribe la condición inicial en la
base de eigenvectores, $x_0 = \sum_i c_i v_i$ (es decir, $c = P^{-1}x_0$), y
cada componente evoluciona por separado:

$$
x_{t+1} = Ax_t \ \Rightarrow\ x_t = \sum_i c_i\thinspace\lambda_i^t\thinspace v_i,
\qquad
\dot x = Ax \ \Rightarrow\ x(t) = \sum_i c_i\thinspace e^{\lambda_i t}\thinspace v_i.
$$

Cada eigenvector es un **modo** que evoluciona por su cuenta. En tiempo
continuo, el modo $i$ decae si $\lambda_i < 0$ y crece si $\lambda_i > 0$; en
tiempo discreto, decae si $\lvert\lambda_i\rvert < 1$.

**Punto de silla.** Si $\lambda_1 < 0 < \lambda_2$, casi toda condición
inicial diverge por el modo 2. Sólo las que empiezan sobre la recta de $v_1$
($c_2 = 0$) convergen al equilibrio. En los modelos de crecimiento óptimo,
la condición de transversalidad obliga a elegir el consumo inicial sobre esa
recta (sesión 12, [D.I6](ecuaciones_diferenciales.md#di6)).

<a id="li3"></a>

### L.I3 Eigenvalores complejos y oscilaciones
*Sesiones 5, 7.*

Si $\tau^2 < 4\Delta$, los eigenvalores de una matriz real $2 \times 2$ son
complejos conjugados: $\lambda = \alpha \pm i\omega$, con $\alpha = \tau/2$.

- **Tiempo continuo.** $e^{\lambda t} = e^{\alpha t}\big(\cos\omega t + i\sin\omega t\big)$:
  las trayectorias **giran** con frecuencia $\omega$ (una vuelta cada
  $2\pi/\omega$ unidades de tiempo) y su amplitud crece o decae como
  $e^{\alpha t}$. Si $\alpha < 0$, espiral hacia el equilibrio
  (foco estable); si $\alpha = 0$, órbitas cerradas (centro).
- **Tiempo discreto.** Con $\lambda = re^{i\theta}$ y $r = \lvert\lambda\rvert = \sqrt{\Delta}$,
  las trayectorias giran un ángulo $\theta$ por periodo (un ciclo dura
  $2\pi/\theta$ periodos) y su amplitud cambia como $r^t$. Convergen si
  $r < 1$.

La parte real (continuo) o el módulo (discreto) decide la estabilidad; la
parte imaginaria sólo dice si hay oscilación. En ecuaciones de segundo orden
es lo mismo: raíces complejas dan ciclos amortiguados o explosivos
([D.I3](ecuaciones_diferenciales.md#di3)).

<a id="li4"></a>

### L.I4 Formas cuadráticas y definitud
*Sesiones 2, 13.*

Una **forma cuadrática** es $Q(h) = h^\top Ah$, con $A$ simétrica. Se dice
que $A$ es:

| Definitud | Condición | Eigenvalores | Menores principales |
|---|---|---|---|
| Definida positiva | $Q(h) > 0$ para $h \ne 0$ | Todos $> 0$ | Los $n$ menores principales dominantes $> 0$ |
| Definida negativa | $Q(h) < 0$ para $h \ne 0$ | Todos $< 0$ | Los menores dominantes alternan: $D_1 < 0$, $D_2 > 0$, $D_3 < 0$, … |
| Semidefinida positiva | $Q(h) \ge 0$ | Todos $\ge 0$ | **Todos** los menores principales son $\ge 0$ |
| Semidefinida negativa | $Q(h) \le 0$ | Todos $\le 0$ | **Todos** los menores principales de orden $k$ tienen signo $(-1)^k$ o son 0 |
| Indefinida | Toma ambos signos | De ambos signos | Ninguno de los anteriores |

El **menor principal dominante** $D_k$ es el determinante de la submatriz
formada por las primeras $k$ filas y columnas. Para la semidefinición no
bastan los dominantes: hay que revisar todos los menores principales (los
que se obtienen borrando las mismas filas y columnas).

**Uso.** La hessiana definida negativa da un máximo local
([C.I1](calculo.md#ci1)); semidefinida negativa en todo el dominio, una
función cóncava ([C.I2](calculo.md#ci2)). Para mínimos y funciones
convexas, lo mismo con "positiva".

**Caso $2 \times 2$.** La matriz simétrica

$$
A = \begin{pmatrix} a & b \cr b & c\end{pmatrix}
$$

es definida negativa si y sólo si $a < 0$ y $ac - b^2 > 0$; semidefinida
negativa si y sólo si $a \le 0$, $c \le 0$ y $ac - b^2 \ge 0$. Por ejemplo,
con $a = -2$, $b = 1$ y $c = -1$: $D_1 = -2 < 0$ y $D_2 = 2 - 1 = 1 > 0$, así
que es definida negativa.

<a id="li5"></a>

### L.I5 Hessiana orlada
*Sesión 2.*

Para $\max f(x)$ con $x \in \mathbb{R}^n$ sujeto a $m$ restricciones
$g(x) = c$, la condición de segundo orden pide que la hessiana del
lagrangiano sea definida negativa **sólo en las direcciones que respetan las
restricciones**. Se revisa con la **hessiana orlada**:

$$
\bar H = \begin{pmatrix} 0 & Dg \cr Dg^\top & \nabla^2_{xx}\mathcal L\end{pmatrix},
$$

de tamaño $(m + n) \times (m + n)$, donde $Dg$ es la matriz $m \times n$ de
derivadas de las restricciones.

**Criterio.** Sea $x^\ast$ un punto que cumple las condiciones de primer
orden. Es un máximo local estricto si los últimos $n - m$ menores
principales dominantes de $\bar H$ alternan de signo, y el signo de
$\det\bar H$ es el de $(-1)^n$. Es un mínimo local estricto si todos ellos
tienen el signo de $(-1)^m$.

**Caso más común: dos variables y una restricción.** Basta con un
determinante:

$$
\det\begin{pmatrix} 0 & g_1 & g_2 \cr g_1 & \mathcal L_{11} & \mathcal L_{12} \cr g_2 & \mathcal L_{12} & \mathcal L_{22}\end{pmatrix}
= 2g_1g_2\mathcal L_{12} - g_1^2\mathcal L_{22} - g_2^2\mathcal L_{11} > 0
\ \Rightarrow\ \text{máximo}.
$$

En el ejemplo de las dos regiones de [C.I5](calculo.md#ci5), con
$g = x_1 + x_2$ (así que $g_1 = g_2 = 1$) y $\mathcal L_{12} = 0$, el
determinante vale $-(\mathcal L_{11} + \mathcal L_{22}) > 0$ porque cada
$\mathcal L_{ii} = -a_i/(4x_i^{3/2}) < 0$.

<a id="li6"></a>

### L.I6 El jacobiano
*Sesiones 3, 7, 8.*

Para $F: \mathbb{R}^n \to \mathbb{R}^n$, el **jacobiano** es la matriz de
derivadas parciales $J_{ij} = \partial F_i/\partial x_j$. Es la mejor
aproximación lineal de $F$ cerca de un punto:
$F(x^\ast + h) \approx F(x^\ast) + J(x^\ast)\thinspace h$.

**Linealización.** Si $x^\ast$ es un equilibrio de $\dot x = F(x)$, cerca de
él $\dot h \approx J(x^\ast)\thinspace h$ con $h = x - x^\ast$. Los
eigenvalores de $J(x^\ast)$ deciden la estabilidad
([D.A1](ecuaciones_diferenciales.md#da1)).

**Ejemplo.** $\dot x = x(1 - x) - xy$, $\dot y = y(x - 0.5)$. En el
equilibrio interior $(0.5, 0.5)$:

$$
J = \begin{pmatrix} 1 - 2x - y & -x \cr y & x - 0.5\end{pmatrix}
= \begin{pmatrix} -0.5 & -0.5 \cr 0.5 & 0\end{pmatrix},
\qquad \tau = -0.5,\quad \Delta = 0.25.
$$

Como $\tau < 0$, $\Delta > 0$ y $\tau^2 - 4\Delta = -0.75 < 0$, es un foco
estable: las trayectorias se acercan girando.

```julia
using Symbolics, LinearAlgebra
@variables x y
F = [x * (1 - x) - x * y, y * (x - 0.5)]
J = Symbolics.jacobian(F, [x, y])
J0 = Float64.(Symbolics.value.(substitute.(J, Ref(Dict(x => 0.5, y => 0.5)))))
eigvals(J0)                # -0.25 ± 0.433i: foco estable
```

---

## Nivel avanzado

<a id="la1"></a>

### L.A1 La exponencial de una matriz
*Sesión 7.*

La solución de $\dot x = Ax$ con $x(0) = x_0$ es $x(t) = e^{At}x_0$, donde

$$
e^{At} = \sum_{k=0}^\infty \frac{(At)^k}{k!} = I + At + \frac{(At)^2}{2} + \cdots
$$

Si $A = P\Lambda P^{-1}$, entonces $e^{At} = P\thinspace e^{\Lambda t}P^{-1}$
con $e^{\Lambda t} = \mathrm{diag}(e^{\lambda_1t}, \dots, e^{\lambda_nt})$:
es la fórmula de modos de [L.I2](#li2). La definición por series funciona
también cuando $A$ no es diagonalizable. Por ejemplo,

$$
A = \begin{pmatrix}\lambda & 1 \cr 0 & \lambda\end{pmatrix}
= \lambda I + N,
\qquad
N = \begin{pmatrix} 0 & 1 \cr 0 & 0\end{pmatrix},
$$

tiene un eigenvalor repetido y un solo eigenvector. Como $N^2 = 0$, la serie
de $e^{Nt}$ se corta en $I + Nt$, y

$$
e^{At} = e^{\lambda t}\thinspace e^{Nt} = e^{\lambda t}\begin{pmatrix} 1 & t \cr 0 & 1\end{pmatrix}:
$$

aparece el factor $te^{\lambda t}$, igual que con raíces repetidas en una
ecuación de segundo orden ([D.I3](ecuaciones_diferenciales.md#di3)).

```julia
using LinearAlgebra
A = [-1.0 1.0; 0.0 -1.0]; t = 2.0
exp(A * t) ≈ exp(-t) * [1 t; 0 1]      # true
```

<a id="la2"></a>

### L.A2 Normas, radio espectral y series de Neumann
*Sesiones 5, 7, 16.*

Una **norma** mide el tamaño de un vector: $\lVert x\rVert_2 = \sqrt{x^\top x}$,
$\lVert x\rVert_\infty = \max_i\lvert x_i\rvert$. La **norma inducida** de
una matriz es $\lVert A\rVert = \max_{x \ne 0}\lVert Ax\rVert/\lVert x\rVert$:
el máximo factor por el que $A$ estira un vector. Con la norma
$\lVert\cdot\rVert_\infty$, es la máxima suma de valores absolutos por
fila: $\lVert A\rVert_\infty = \max_i \sum_j \lvert a_{ij}\rvert$.

El **radio espectral** es $\rho(A) = \max_i\lvert\lambda_i\rvert$. Resultados:
- $\rho(A) \le \lVert A\rVert$ para cualquier norma inducida.
- $A^t \to 0$ si y sólo si $\rho(A) < 1$. Es la condición de estabilidad de
  $x_{t+1} = Ax_t$. Su análogo continuo: $e^{At} \to 0$ si y sólo si todos
  los eigenvalores tienen parte real negativa.
- **Serie de Neumann.** Si $\rho(M) < 1$, entonces $I - M$ es invertible y
  $(I - M)^{-1} = \sum_{k=0}^\infty M^k$.

**En programación dinámica** (sesión 16). El valor de seguir una política
fija con recompensas $r$ y matriz de transición $P$ cumple $v = r + \beta Pv$.
Como $P$ es estocástica ([L.A4](#la4)), $\lVert P\rVert_\infty = 1$ y
$\rho(\beta P) = \beta < 1$, así que

$$
v = (I - \beta P)^{-1}r = \sum_{t=0}^\infty \beta^tP^tr:
$$

el valor presente esperado de las recompensas. Así se evalúa una política en
la iteración de política ([N.A2](metodos_numericos.md#na2)).

<a id="la3"></a>

### L.A3 Rango e independencia lineal
*Sesión 2.*

Los vectores $v_1, \dots, v_k$ son **linealmente independientes** si
$\sum_i c_iv_i = 0$ sólo con todos los $c_i = 0$: ninguno es combinación de
los demás. El **rango** de una matriz es el número máximo de filas
linealmente independientes, que siempre coincide con el de columnas. Una matriz cuadrada es invertible si y
sólo si tiene rango completo.

**Calificación de las restricciones.** Si en el óptimo están activas $k$
restricciones, la condición de regularidad más usada pide que la matriz
$k \times n$ de sus gradientes tenga rango $k$. Con esa condición, las
condiciones de Lagrange y de Kuhn-Tucker son necesarias
([C.A1](calculo.md#ca1)).

```julia
using LinearAlgebra
rank([0 1; 0 -1])          # 1: gradientes (0, 1) y (0, -1) dependientes
```

<a id="la4"></a>

### L.A4 Matrices estocásticas y cadenas de Markov
*Sesiones 15, 16 (lectura opcional sobre incertidumbre) y 19 (migración entre dos regiones).*

Una matriz $P$ de $n \times n$ es **estocástica** si sus entradas son no
negativas y cada fila suma 1. Describe una **cadena de Markov** con $n$
estados: $P_{ij}$ es la probabilidad de pasar del estado $i$ al $j$.

- Si $\psi_t$ (vector fila) es la distribución del estado en $t$, entonces
  $\psi_{t+1} = \psi_tP$.
- Si $v$ es una función de los estados (vector columna) y $w = Pv$, entonces
  $w_i = \sum_j P_{ij}v_j = \mathbb{E}[v(x_{t+1}) \mid x_t = i]$. Ésta es la
  esperanza condicional que aparece en la ecuación de Bellman con
  incertidumbre.
- $P\mathbf 1 = \mathbf 1$, así que 1 es eigenvalor, y $\rho(P) = 1$.
- Una **distribución estacionaria** cumple $\psi^\ast = \psi^\ast P$: es un
  eigenvector izquierdo con eigenvalor 1.

```julia
P = [0.9 0.1; 0.4 0.6]
ψ0 = [1.0 0.0]             # empieza en el estado 1
ψ0 * P^200                 # ≈ [0.8 0.2], la distribución estacionaria
```

---

## Autodiagnóstico

<details>
<summary><b>1 (B).</b> Calcula <i>Ax</i> con <i>A</i> = [[1, 2], [0, 3]] y <i>x</i> = (1, −1).</summary>

$(1 \cdot 1 + 2 \cdot (-1),\ 0 \cdot 1 + 3 \cdot (-1)) = (-1, -3)$.
</details>

<details>
<summary><b>2 (B).</b> Encuentra la inversa de [[2, 1], [4, 3]].</summary>

$\det = 6 - 4 = 2$. Se intercambia la diagonal (3 y 2), se cambia el signo
de los elementos de fuera ($-1$ y $-4$) y se divide entre 2: la inversa
tiene filas $(1.5, -0.5)$ y $(-2, 1)$. Comprobación: $AA^{-1} = I$.
</details>

<details>
<summary><b>3 (B).</b> ¿Tiene solución única el sistema <i>x</i> + 2<i>y</i> = 3, 2<i>x</i> + 4<i>y</i> = 5?</summary>

No: $\det = 4 - 4 = 0$. La segunda ecuación pide $x + 2y = 2.5$, que
contradice la primera, así que no hay solución.
</details>

<details>
<summary><b>4 (B).</b> Encuentra el equilibrio de <i>x</i><sub><i>t</i>+1</sub> = 0.5<i>x</i><sub><i>t</i></sub> + 2.</summary>

$x^\ast = 0.5x^\ast + 2$, así que $x^\ast = 4$. Es el caso escalar de
$x^\ast = (I - A)^{-1}b$.
</details>

<details>
<summary><b>5 (B).</b> Resuelve con Cramer: 3<i>x</i> − <i>y</i> = 1, <i>x</i> + <i>y</i> = 3.</summary>

$\det A = 3 \cdot 1 - (-1) \cdot 1 = 4$. Para $x$, se reemplaza la primera
columna por $b = (1, 3)$: $\det A_1 = 1 \cdot 1 - (-1) \cdot 3 = 4$, así que
$x = 1$. Para $y$, la segunda: $\det A_2 = 3 \cdot 3 - 1 \cdot 1 = 8$, así que
$y = 2$.
</details>

<details>
<summary><b>6 (I).</b> Encuentra los eigenvalores de [[0, 1], [2, −1]]. ¿Qué tipo de equilibrio tiene ẋ = <i>Ax</i>?</summary>

$\tau = -1$, $\Delta = -2$: $\lambda^2 + \lambda - 2 = 0$, así que
$\lambda = 1$ y $\lambda = -2$. Signos opuestos: punto de silla.
</details>

<details>
<summary><b>7 (I).</b> ¿Es definida negativa la matriz [[−1, 2], [2, −3]]?</summary>

$D_1 = -1 < 0$ pero $D_2 = 3 - 4 = -1 < 0$: no alterna, así que no es
definida negativa. Es indefinida (el determinante negativo implica
eigenvalores de signo opuesto).
</details>

<details>
<summary><b>8 (I).</b> Los eigenvalores de la matriz de un sistema discreto son 0.6 ± 0.6<i>i</i>. ¿Converge? ¿Oscila?</summary>

$\lvert\lambda\rvert = \sqrt{0.36 + 0.36} \approx 0.85 < 1$: converge, y
oscila porque los eigenvalores son complejos. Gira $\theta = \pi/4$ por
periodo, así que el ciclo dura unos 8 periodos.
</details>

<details>
<summary><b>9 (A).</b> Una política da recompensas <i>r</i> = (1, 0) con <i>P</i> = [[0.9, 0.1], [0.4, 0.6]] y β = 0.9. Plantea el sistema para su valor.</summary>

$v = r + \beta Pv$, es decir, $(I - 0.9P)v = r$, donde $I - 0.9P$ tiene
filas $(0.19, -0.09)$ y $(-0.36, 0.46)$. Con Cramer, $\det = 0.0874 - 0.0324 = 0.055$, $v_1 = 0.46/0.055 \approx 8.36$
y $v_2 = 0.36/0.055 \approx 6.55$.
</details>

<details>
<summary><b>10 (A).</b> Calcula <i>e</i><sup><i>At</i></sup> para <i>A</i> = diag(−1, 2) y describe las trayectorias de ẋ = <i>Ax</i>.</summary>

$e^{At} = \mathrm{diag}(e^{-t}, e^{2t})$. La coordenada $x_1$ decae y $x_2$
crece: punto de silla. Sólo las condiciones iniciales con $x_2(0) = 0$ (el
eje horizontal, que es la variedad estable) convergen al origen.
</details>

---

## Para profundizar

- Chiang y Wainwright (2006), caps. 4–5 (matrices y determinantes) y
  sec. 11.3 (formas cuadráticas).
- Simon y Blume (1994), caps. 6–9, 16 y 23: sistemas lineales,
  determinantes, formas cuadráticas restringidas y eigenvalores.
- Strang, G. *Introduction to Linear Algebra*: referencia general, muy
  intuitiva.
- Sargent y Stachurski, Vol. I, cap. 1: normas, radio espectral y series de
  Neumann en programación dinámica.
