# Sesión 11: Principio del máximo

> **Cómo leer estas notas.** Siguen el orden del programa: primero se explora
> en el cuaderno (`Code/s11_principio_del_maximo.jl`), después se formaliza
> aquí. El cuerpo de las notas es la **ruta básica**: se ve en clase y se
> evalúa. Las demostraciones y los temas opcionales están al final, en
> **Para profundizar**; donde estaban queda una línea que los enlaza.
>
> Repaso recomendado: [C.B2](repaso/calculo.md#cb2) (máximos en una
> variable), [C.B4](repaso/calculo.md#cb4) (integrales),
> [C.I2–I3](repaso/calculo.md#ci2) (concavidad, regla de la cadena y
> diferencial total), [C.I6](repaso/calculo.md#ci6) (regla de Leibniz),
> [D.I2](repaso/ecuaciones_diferenciales.md#di2) (lineales de primer orden
> con coeficientes variables) y
> [D.I7](repaso/ecuaciones_diferenciales.md#di7) (valor inicial y valor en
> la frontera); para Para profundizar, [C.A3](repaso/calculo.md#ca3)
> (primera variación), [D.A3](repaso/ecuaciones_diferenciales.md#da3)
> (existencia y unicidad) y [N.A1](repaso/metodos_numericos.md#na1)
> (disparo).
>
> Lecturas: Chiang (1992), cap. 7 y sec. 8.1; Chiang y Wainwright (2006),
> cap. 20.

**Pregunta de la unidad.** ¿Conviene invertir primero donde se ahorra más o
donde se produce más?

---

## 0. La pregunta

En la sesión 10 el Hamiltoniano apareció como otra forma de escribir la
ecuación de Euler, con el control igual a la velocidad del estado,
$u = y'$. Esta sesión da el caso general: el estado cambia según una
ecuación $y' = f(t, y, u)$, el control puede tener límites y la condición
final puede ser de varios tipos.

El ejemplo de la sesión es una región con un **recurso no renovable**: un
yacimiento, como el carbón de Coahuila o el petróleo de Campeche y
Tabasco. ¿A qué ritmo conviene extraerlo? ¿Cuánto vale una tonelada más
bajo tierra? La respuesta a la segunda pregunta es el **coestado**, y la
regla que sale es la de **Hotelling**: el valor del recurso en el subsuelo
sube a la tasa de descuento.

---

## 1. El problema de control óptimo

$$
\max_{u}\ \int_0^T F\big(t, y(t), u(t)\big)\thinspace dt
\qquad \text{sujeto a} \qquad
y' = f(t, y, u), \quad y(0) = y_0, \quad u(t) \in U,
$$

más una **condición terminal** sobre $y(T)$ o sobre $T$ (sección 3).

- $y$ es el **estado**: lo que se hereda de un instante al siguiente
  (capital, fondo, recurso). No puede saltar.
- $u$ es el **control**: lo que se decide en cada instante (gasto,
  extracción, reparto de la inversión). Puede saltar, y debe estar en el
  conjunto $U$, por ejemplo $[0, \infty)$ o $[0, 1]$.
- $y' = f(t, y, u)$ es la **ecuación de movimiento**.

El cálculo de variaciones es el caso $f = u$ y $U = \mathbb{R}$.

**Dos ejemplos.**

| | Fondo regional (sesión 10) | Recurso no renovable |
|---|---|---|
| Estado | Saldo del fondo $W$ | Reservas $S$ |
| Control | Gasto $c \ge 0$ | Extracción $q \ge 0$ |
| Movimiento | $W' = rW - c$ | $S' = -q$ |
| Objetivo | $\int_0^T e^{-\rho t}u(c)\thinspace dt$ | $\int_0^T e^{-\rho t}B(q)\thinspace dt$ |
| Final | $W(T) = W_T$ | $S(T) \ge 0$ |

---

## 2. El principio del máximo

### 2.1 El enunciado

Se define el **Hamiltoniano**

$$
H(t, y, u, \lambda) = F(t, y, u) + \lambda\thinspace f(t, y, u),
$$

donde $\lambda(t)$ es el **coestado**.

**Teorema (principio del máximo de Pontryagin).** Si $u^\ast$ es óptimo y
$y^\ast$ es su trayectoria, existe una función continua $\lambda(t)$ tal
que, para todo $t \in [0, T]$,

1. $u^\ast(t)$ **maximiza** $H\big(t, y^\ast(t), u, \lambda(t)\big)$ sobre
   $u \in U$;
2. $y^{\ast\prime} = \dfrac{\partial H}{\partial \lambda} = f(t, y^\ast, u^\ast)$;
3. $\lambda' = -\dfrac{\partial H}{\partial y}$;
4. se cumple la **condición de transversalidad** que corresponde a la
   condición terminal (sección 3).

Es una condición **necesaria**, como la ecuación de Euler. Las condiciones
suficientes (Mangasarian y Arrow) se ven en la sesión 13. Una derivación
está en [Para profundizar, P.1](#pp1).

### 2.2 Qué cambia respecto a la sesión 10

**La condición 1 dice "maximiza", no "derivada igual a cero".** Si el
máximo de $H$ en $u$ es interior, la condición 1 implica
$\partial H/\partial u = 0$ (y $\partial^2 H/\partial u^2 \le 0$), como en
la sesión 10. Pero si $U$ tiene límites, el máximo puede estar en uno de
ellos: es Kuhn-Tucker (sesión 2) en cada instante. En el recurso de la
sección 5, la extracción llega a $q = 0$ y se queda ahí; en la sesión 13,
el Hamiltoniano es lineal en $u$ y el óptimo salta de un extremo al otro
(bang-bang).

**Las condiciones 2 y 3 forman un sistema de dos ecuaciones de primer
orden**, en $y$ y en $\lambda$, una vez que la condición 1 da $u$ como
función de $(t, y, \lambda)$. Necesita dos condiciones: $y(0) = y_0$ al
principio y la condición terminal al final. Es otra vez un problema de
**valor en la frontera** ([D.I7](repaso/ecuaciones_diferenciales.md#di7)).

### 2.3 El fondo regional, con el gasto como control

Con $H = e^{-\rho t}u(c) + \lambda(rW - c)$:

- $\partial H/\partial c = 0$: $e^{-\rho t}u'(c) = \lambda$. Como $u$ es
  cóncava, es un máximo, y $c > 0$ porque $u'(c) \to \infty$ cuando
  $c \to 0$ (con la utilidad CRRA).
- $\lambda' = -\partial H/\partial W = -r\lambda$.

Son las mismas condiciones de la sesión 10, sección 4.3, y dan otra vez
$c'/c = (r - \rho)/\theta$. Escribir el problema con el control natural (el
gasto, no la velocidad del fondo) no cambia la solución, pero sí la
facilidad para leerla.

---

## 3. Condiciones terminales

Las condiciones 1 a 3 son las mismas en todos los problemas. Lo que cambia
con la condición final es la condición 4:

| Condición final | Transversalidad | Lectura |
|---|---|---|
| $y(T) = Z$ fijo | Ninguna: $y(T) = Z$ ya da la condición que falta | El estado final no se elige |
| $y(T)$ libre | $\lambda(T) = 0$ | Lo que sobra al final no vale nada: se usa hasta que su valor marginal es cero |
| $y(T) \ge y_{\min}$ | $\lambda(T) \ge 0$, $\big(y(T) - y_{\min}\big)\lambda(T) = 0$ | Holgura complementaria: si sobra, $\lambda(T) = 0$; si $\lambda(T) > 0$, no sobra nada |
| $T$ libre, $y(T) = Z$ | $H(T) = 0$ | Se termina cuando seguir un instante más ya no agrega valor |

**La tercera fila es Kuhn-Tucker en el instante final.** La restricción
$y(T) \ge y_{\min}$ tiene un multiplicador, $\lambda(T)$, que es positivo
sólo si la restricción se cumple con igualdad (sesión 2). Es la condición
del recurso: $S(T) \ge 0$.

**La cuarta fila** se combina con las anteriores si $T$ es libre y $y(T)$
también: se pide $H(T) = 0$ y la condición sobre $\lambda(T)$
correspondiente. Las derivaciones de las cuatro están en [P.1](#pp1).

**Ejemplo.** $\max \int_0^2 \big(y - \tfrac{1}{2}u^2\big)\thinspace dt$ con
$y' = u$ e $y(0) = 0$. El Hamiltoniano es $H = y - \tfrac{1}{2}u^2 + \lambda u$:

- $\partial H/\partial u = 0$: $u = \lambda$.
- $\lambda' = -\partial H/\partial y = -1$, así que $\lambda(t) = \lambda(2) + 2 - t$.

Con $y(2)$ libre, $\lambda(2) = 0$: $u = 2 - t$ e
$y(t) = 2t - t^2/2$, con $y(2) = 2$. Si se pide $y(2) \ge 3$, la solución
libre no la cumple, así que $\lambda(2) = k > 0$ y $y(2) = 3$:
$y(2) = \int_0^2 (k + 2 - t)\thinspace dt = 2k + 2 = 3$ da $k = 1/2$. Si se
pide $y(2) \ge 1$, la solución libre ya la cumple y $\lambda(2) = 0$. El
cuaderno lo muestra con un deslizador para $y_{\min}$.

---

## 4. El coestado como precio sombra

### 4.1 Lo que mide

Sea $V(t, y)$ el valor óptimo del problema que empieza en el instante $t$
con el estado $y$. Entonces, sobre la trayectoria óptima,

$$
\lambda(t) = \frac{\partial V}{\partial y}\big(t, y^\ast(t)\big).
$$

$\lambda(t)$ es cuánto sube el valor total si en el instante $t$ hubiera
una unidad más del estado: el **precio sombra** del estado. En particular,
$\lambda(0) = \partial V/\partial y_0$, que es el $V'(B) = \lambda$ de la
sesión 3 y el $\lambda(0) = dV/dW_0$ del fondo de la sesión 10. El
argumento está en [P.2](#pp2).

Como $F$ suele estar descontada ($e^{-\rho t}$), $\lambda(t)$ es un precio
en valor de $t = 0$. El precio en valor del instante $t$ es
$\mu(t) = e^{\rho t}\lambda(t)$; la sesión 12 trabaja con él directamente.

### 4.2 Las tres condiciones, leídas con precios

**El Hamiltoniano es el beneficio total del instante.** $H = F + \lambda f$
suma lo que se obtiene ahora, $F$, y lo que vale el cambio del estado,
$\lambda f = \lambda y'$, a su precio sombra. Maximizar $H$ en $u$ es
equilibrar el presente contra el futuro: en el recurso, extraer una
tonelada más da beneficio ahora, pero deja una tonelada menos en el
subsuelo, que vale $\lambda$.

**La ecuación del coestado es una condición de arbitraje.** Escrita como

$$
-\lambda' = \frac{\partial F}{\partial y} + \lambda\thinspace\frac{\partial f}{\partial y},
$$

dice que el precio de una unidad de estado baja, con el tiempo, a la
velocidad con la que esa unidad rinde: lo que aporta al beneficio de este
instante ($F_y$) más lo que aporta a su propio crecimiento ($\lambda f_y$).
Una unidad de estado es un activo: su valor es lo que le queda por rendir.
En el fondo, $F_W = 0$ y $f_W = r$, así que $\lambda' = -r\lambda$. En el
recurso, $F_S = 0$ y $f_S = 0$: el precio sombra en valor de $t = 0$ es
**constante**.

**La transversalidad pone el precio final.** Con $y(T)$ libre, al final una
unidad más de estado no sirve para nada, y $\lambda(T) = 0$.

---

## 5. Práctica: el precio sombra de un recurso

### 5.1 El modelo

Una región tiene reservas $S_0$ de un recurso no renovable. Extrae $q(t)$
por año; las reservas bajan, $S' = -q$, y no pueden ser negativas,
$S(T) \ge 0$. El beneficio de extraer $q$ es

$$
B(q) = aq - \frac{b}{2}q^2, \qquad B'(q) = a - bq,
$$

el área bajo la demanda inversa $p = a - bq$, sin costos de extracción. $a$
es el **precio de ahogo**: el precio al que nadie compra, por ejemplo
porque conviene más un sustituto. El problema es

$$
\max_{q \ge 0}\ \int_0^T e^{-\rho t}B(q)\thinspace dt
\qquad \text{sujeto a} \qquad S' = -q, \quad S(0) = S_0, \quad S(T) \ge 0.
$$

### 5.2 La regla de Hotelling

El Hamiltoniano es $H = e^{-\rho t}B(q) - \lambda q$.

- **Condición 3**: $\lambda' = -\partial H/\partial S = 0$. El coestado es
  una constante, $\lambda$.
- **Condición 1**: $H$ es cóncava en $q$; su máximo en $q \ge 0$ es
  $e^{-\rho t}B'(q) = \lambda$ si eso da $q > 0$, y $q = 0$ si no:

$$
q(t) = \max\Big\lbrace 0,\ \frac{a - \lambda e^{\rho t}}{b}\Big\rbrace.
$$

- **Condición 4**: $\lambda \ge 0$, $S(T) \ge 0$ y $\lambda S(T) = 0$.

Mientras se extrae, el precio de mercado es

$$
p(t) = B'(q(t)) = \lambda\thinspace e^{\rho t}:
$$

**el precio del recurso sube a la tasa de descuento**. Es la regla de
Hotelling (1931). Se lee como arbitraje: dejar una tonelada en el subsuelo
es una inversión. Si su precio subiera más rápido que $\rho$, convendría
extraer menos hoy y más mañana; si subiera más lento, extraer más hoy. Sólo
con $p'/p = \rho$ a la región le da igual.

### 5.3 Tres casos: la escasez decide el precio

La transversalidad separa dos situaciones.

- **Recurso abundante.** Si extraer $q = a/b$ todos los años (hasta el
  precio cero) no agota las reservas, es decir, si $S_0 \ge aT/b$, entonces
  $\lambda = 0$ y sobra recurso al final. **Una tonelada más en el
  subsuelo no vale nada.**
- **Recurso escaso.** Si $S_0 < aT/b$, entonces $\lambda > 0$ y
  $S(T) = 0$: se agota exactamente. Si además la extracción es positiva
  hasta $T$, la condición $\int_0^T q\thinspace dt = S_0$ da

$$
\lambda = \frac{\rho\thinspace(aT - bS_0)}{e^{\rho T} - 1}.
$$

- **Recurso muy escaso.** Si con ese $\lambda$ el precio $\lambda e^{\rho t}$
  llega al de ahogo $a$ antes de $T$, la extracción se detiene antes: en
  $\tau < T$, con $\lambda e^{\rho\tau} = a$, y desde ahí $q = 0$. Es una
  **solución de esquina**: la condición $\partial H/\partial q = 0$ ya no
  vale, pero "$q$ maximiza $H$" sí.

Con $a = 10$, $b = 1$, $\rho = 0.05$ y $T = 20$:

| Reservas $S_0$ | $\lambda$ | Extracción $q(0) \to q(T)$ | Se agota en |
|---|---|---|---|
| 30 | 5.47 | $4.53 \to 0$ | $\tau = 12.1$ años |
| 100 | 2.91 | $7.09 \to 2.09$ | $T = 20$ |
| 150 | 1.45 | $8.55 \to 6.05$ | $T = 20$ |
| 200 o más | 0 | $10 \to 10$ | No se agota |

**Lectura regional.**
- El valor de una tonelada en el subsuelo no depende de su precio de
  mercado hoy, sino de qué tan escaso es el recurso. Una región con
  reservas abundantes no gana nada con conservarlas; una con reservas
  escasas sí, y su extracción baja con el tiempo.
- La extracción decreciente no es un error de política ni una señal de
  agotamiento físico: es lo óptimo cuando el recurso escasea.
- El precio sombra sirve para diseñar política. Si nadie es dueño del
  yacimiento y cada quien extrae mientras el precio sea positivo, el
  recurso se agota demasiado pronto. Una regalía igual a $\lambda e^{\rho t}$
  por tonelada lleva el precio a $\lambda e^{\rho t}$ y la extracción al
  ritmo óptimo.
- En el cuaderno, $\lambda$ coincide con $\partial V/\partial S_0$,
  calculado numéricamente.

### 5.4 Si la región elige cuándo cerrar la mina

Con $T$ libre, la cuarta fila de la tabla de la sección 3 pide $H(T) = 0$.
Con $p(T) = \lambda e^{\rho T} = a - bq(T)$,

$$
H(T) = e^{-\rho T}\Big(aq - \frac{b}{2}q^2 - (a - bq)q\Big)
= e^{-\rho T}\frac{b}{2}q(T)^2 = 0,
$$

así que $q(T) = 0$: **se cierra la mina justo cuando la extracción óptima
llega a cero**, es decir, cuando el precio alcanza el de ahogo. Es el caso
"muy escaso" de la sección 5.3, con $T = \tau$.

---

## 6. Hacia la optimización dinámica

| Idea de esta sesión | Dónde reaparece |
|---|---|
| $\mu = e^{\rho t}\lambda$, el precio en valor corriente | Hamiltoniano a valor presente (sesión 12) |
| Transversalidad con $y(T)$ libre o acotado | Transversalidad en horizonte infinito; selecciona la rama estable (sesión 12) |
| "$u$ maximiza $H$" con soluciones de esquina | Control acotado y bang-bang (sesiones 13 y 14) |
| $\lambda = \partial V/\partial y$ | La derivada de la función valor en la ecuación de Bellman (sesiones 15, 16 y 18) |
| Precio sombra de un recurso | Precio sombra del capital de cada región, que decide dónde invertir (sesión 14) |

---

## 7. Resumen formal

| Concepto | Enunciado | Dónde |
|---|---|---|
| Problema de control óptimo | $\max \int F\thinspace dt$ con $y' = f(t, y, u)$, $u \in U$ | 1 |
| Hamiltoniano | $H = F + \lambda f$ | 2.1 |
| Principio del máximo | $u^\ast$ maximiza $H$; $y' = H_\lambda$; $\lambda' = -H_y$; transversalidad | 2.1 |
| Máximo interior | $H_u = 0$ y $H_{uu} \le 0$; si no, solución de esquina | 2.2 |
| Transversalidad | $\lambda(T) = 0$ (libre); holgura complementaria ($y(T) \ge y_{\min}$); $H(T) = 0$ ($T$ libre) | 3 |
| Precio sombra | $\lambda(t) = \partial V/\partial y$ | 4.1 |
| Arbitraje | $-\lambda' = F_y + \lambda f_y$ | 4.2 |
| Hotelling | El precio del recurso sube a la tasa $\rho$ mientras se extrae | 5.2 |
| Escasez | Recurso abundante: $\lambda = 0$; escaso: $\lambda > 0$ y $S(T) = 0$ | 5.3 |

---

## 8. Ejercicios formales

- **F1.** Resuelve $\max \int_0^1 \big(-u^2\big)\thinspace dt$ con
  $y' = y + u$, $y(0) = 1$ e $y(1) = 0$ (Chiang, sec. 7.4, ejemplo 1).
- **F2.** En el ejemplo de la sección 3, encuentra $\lambda(2)$ e $y(t)$
  para cualquier $y_{\min}$. ¿Para qué valores la restricción está activa?
  Dibuja $\lambda(2)$ como función de $y_{\min}$ e interprétala.
- **F3.** En el fondo regional con $W(T) \ge 0$ libre (sin reserva
  obligatoria), muestra con la transversalidad que $W(T) = 0$. ¿Por qué
  nunca conviene dejar dinero en el fondo?
- **F4.** En el recurso con $a = 10$, $b = 1$, $\rho = 0.05$, $T = 20$ y
  $S_0 = 100$, verifica que $\lambda = 2.91$ y calcula el precio del
  recurso en $t = 0$ y en $t = 20$. ¿Cuánto crece entre los dos?

**Para profundizar** (opcionales)

- **F5.** Resuelve $\max \int_0^2 (2y - 3u)\thinspace dt$ con
  $y' = y + u$, $y(0) = 4$, $y(2)$ libre y $u \in [0, 2]$ (Chiang, sec.
  7.2, ejemplo 2). Muestra que $u^\ast = 2$ hasta $t = 2 - \ln 2.5$ y
  $u^\ast = 0$ después.
- **F6.** En el ejemplo de la sección 3 con $y(2)$ libre y $y(0) = y_0$,
  calcula el valor óptimo $V(y_0)$ y verifica que $V'(y_0) = \lambda(0)$
  ([P.2](#pp2)).
- **F7.** En el recurso con $S_0 = 30$, plantea las dos ecuaciones que
  determinan $\lambda$ y $\tau$, y muestra que $\tau$ cumple
  $a\tau - a(1 - e^{-\rho\tau})/\rho = bS_0$.

## Para profundizar

Material opcional: demostraciones y temas que no se ven en clase. Cada
apartado indica de qué sección de las notas viene.

<a id="pp1"></a>

### P.1 Una derivación del principio del máximo (secciones 2 y 3)

Esta derivación supone que el control óptimo es interior y que todo es
diferenciable; da las condiciones 1 a 4 en su versión
$\partial H/\partial u = 0$. La demostración general, que admite
soluciones de esquina, usa perturbaciones del control en intervalos muy
cortos (Pontryagin y otros, 1962).

**Paso 1: el Lagrangiano.** Para cualquier función $\lambda(t)$, sobre una
trayectoria que cumple $y' = f$,

$$
J = \int_0^T \Big(F + \lambda\big(f - y'\big)\Big)\thinspace dt
= \int_0^T \big(H - \lambda y'\big)\thinspace dt.
$$

**Paso 2: integrar por partes.** $\int_0^T \lambda y'\thinspace dt
= \lambda(T)y(T) - \lambda(0)y_0 - \int_0^T \lambda' y\thinspace dt$, así
que

$$
J = \int_0^T \big(H + \lambda' y\big)\thinspace dt - \lambda(T)y(T) + \lambda(0)y_0.
$$

**Paso 3: perturbar.** Se cambia el control a $u^\ast + \varepsilon p$ y el
estado responde, $y^\ast + \varepsilon q$, con $q(0) = 0$; si $T$ es libre,
también $T^\ast + \varepsilon\thinspace\Delta T$. Derivando respecto a
$\varepsilon$ en $\varepsilon = 0$ ([C.I6](repaso/calculo.md#ci6)):

$$
\frac{dJ}{d\varepsilon} = \int_0^T \Big(\big(H_y + \lambda'\big)q + H_u\thinspace p\Big)\thinspace dt
- \lambda(T)\thinspace\Delta y_T + H(T)\thinspace\Delta T,
$$

donde $\Delta y_T$ es el cambio total del estado final.

**Paso 4: elegir $\lambda$ y leer.** Se elige $\lambda$ de modo que
$\lambda' = -H_y$ (condición 3): el término en $q$ desaparece, y no hace
falta saber cómo responde el estado. Para que $dJ/d\varepsilon = 0$ con
toda $p$, hace falta $H_u = 0$ (condición 1, versión interior) y que el
término de frontera sea cero:

- $y(T)$ fijo y $T$ fijo: $\Delta y_T = \Delta T = 0$; no hay condición.
- $y(T)$ libre: $\Delta y_T$ arbitrario, así que $\lambda(T) = 0$.
- $T$ libre con $y(T)$ fijo: $\Delta T$ arbitrario, así que $H(T) = 0$.
- $y(T) \ge y_{\min}$: si $y(T) > y_{\min}$, $\Delta y_T$ es arbitrario y
  $\lambda(T) = 0$; si $y(T) = y_{\min}$, sólo se permite $\Delta y_T \ge 0$,
  y en un máximo $-\lambda(T)\Delta y_T \le 0$ da $\lambda(T) \ge 0$.
  $\square$

<a id="pp2"></a>

### P.2 El coestado es la derivada del valor óptimo (sección 4.1)

Sea $V(y_0) = J[u^\ast]$ el valor óptimo con estado inicial $y_0$. Por el
Paso 2 de P.1, sobre la trayectoria óptima,

$$
V(y_0) = \int_0^T \big(H + \lambda' y\big)\thinspace dt - \lambda(T)y(T) + \lambda(0)y_0.
$$

Si $y_0$ cambia, cambian $u^\ast$, $y^\ast$ y $\lambda$. Pero, igual que en
el teorema de la envolvente de la sesión 3, los efectos a través de $u^\ast$
y de $y^\ast$ desaparecen por las condiciones de primer orden ($H_u = 0$,
$H_y + \lambda' = 0$ y la transversalidad), y queda sólo el efecto directo:

$$
V'(y_0) = \lambda(0).
$$

Como el problema que empieza en $t$ con estado $y^\ast(t)$ tiene la misma
solución que el original desde $t$ (principio de optimalidad, sesión 15),
el mismo argumento da $\lambda(t) = \partial V/\partial y$ en cada
instante. Ésta es la conexión entre el principio del máximo y la
programación dinámica: el coestado es la derivada de la función valor
(sesión 18).

---

## Referencias

- Chiang, A. C. (1992). *Elements of Dynamic Optimization*. McGraw-Hill.
- Chiang, A. C., & Wainwright, K. (2006). *Métodos fundamentales de
  economía matemática* (4.ª ed.). McGraw-Hill.
- Hotelling, H. (1931). The economics of exhaustible resources. *Journal of
  Political Economy*, 39(2), 137–175. https://doi.org/10.1086/254195
- Pontryagin, L. S., Boltyanskii, V. G., Gamkrelidze, R. V., & Mishchenko,
  E. F. (1962). *The Mathematical Theory of Optimal Processes*.
  Interscience.
