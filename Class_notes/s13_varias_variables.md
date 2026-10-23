# Sesión 13: Varias variables de estado y de control

> **Cómo usar estas notas.** La clase se da en el pizarrón y sigue estas
> notas en su orden. El **plan de clase** de abajo dice qué secciones se
> escriben en el pizarrón, cuándo se proyecta el cuaderno
> (`Code/s13_varias_variables.jl`) y qué queda para leer. En el pizarrón
> van las ecuaciones y los resultados en recuadro; el texto que las rodea es
> lo que se explica de palabra. Como todo está aquí, en clase no hace falta
> copiar. El cuerpo de las notas es la **ruta básica** y se evalúa; las
> demostraciones y los temas opcionales están al final, en **Para
> profundizar**, y no se ven en clase.
>
> Repaso recomendado: [C.B2](repaso/calculo.md#cb2) (máximos en una
> variable), [C.I2](repaso/calculo.md#ci2) (concavidad) y
> [L.I4](repaso/algebra_lineal.md#li4) (formas cuadráticas y definitud);
> para Para profundizar, [C.A4](repaso/calculo.md#ca4) (concavidad y
> maximización parcial).
>
> Lecturas: Chiang (1992), secs. 8.3 y 8.4; Sethi (2021), secs. 2.3 y 2.4.

**Plan de clase** (120 minutos). En esta sesión el pizarrón va de lo
concreto a lo general: primero la función de cambio y la práctica
(secciones 2 y 3), después varios estados (sección 1).

| Minutos | Dónde | Qué | Secciones |
|---|---|---|---|
| 0–5 | Pizarra | La pregunta: las tres piezas que faltan para la sesión 14 | 0 |
| 5–15 | Pizarra | Hamiltoniano lineal en el control, función de cambio y regla bang-bang | 2.1 |
| 15–40 | Pizarra | Invertir o consumir: los cinco pasos hasta $t^\ast = T - 1/v$; el plazo de recuperación | 3.1–3.3 (con el procedimiento de 2.2) |
| 40–55 | Proyector | El bang-bang con deslizadores; las tasas fijas contra el óptimo | Cuaderno, secciones 1 y 2 |
| 55–60 | | Pausa | |
| 60–65 | Pizarra | Con descuento: el resultado y por qué la impaciencia adelanta el cambio | 3.3 |
| 65–82 | Pizarra | Varios estados: el ejemplo de infraestructura y capital privado | 1.1, 1.2 |
| 82–88 | Proyector | Coestados encadenados y gasto en infraestructura | Cuaderno, sección 3 |
| 88–103 | Pizarra | Mangasarian y Arrow; por qué en la práctica sólo aplica Arrow | 4.1–4.3 |
| 103–108 | Proyector | Prueba numérica: ningún control al azar supera al bang-bang | Cuaderno, sección 4 |
| 108–118 | Parejas | Ejercicio F2 a mano | 7 |
| 118–120 | Pizarra | Cierre: el caso de dos regiones (sesión 14) | 5 |
| Después | Lectura | La tabla de 3.3, la suficiencia en horizonte infinito (final de 4.3), el resumen (6), la sección [Avanzado] del cuaderno y Para profundizar (Mangasarian y arcos singulares) | |

**Pregunta de la unidad.** ¿Conviene invertir primero donde se ahorra más o
donde se produce más?

---

## 0. La pregunta

La sesión 14 resuelve el caso de la unidad: un gobierno reparte la
inversión entre dos regiones con $\theta(t) \in [0, 1]$. Para llegar ahí
faltan tres piezas, y esta sesión las da:

1. **Varios estados**: el capital de cada región es un estado, con su propio
   coestado.
2. **Control acotado con Hamiltoniano lineal**: el reparto entra de forma
   lineal y está entre 0 y 1, así que el óptimo es **bang-bang**: todo a
   una región o todo a la otra. Lo decide la **función de cambio**.
3. **Condiciones suficientes**: el principio del máximo es necesario. Hace
   falta saber cuándo un candidato es de verdad el óptimo.

La práctica es el ensayo de un solo estado del caso: una región reparte su
producto entre consumir e invertir. ¿Hasta cuándo conviene invertir?

---

## 1. Varios estados y varios controles

### 1.1 El problema

Con $n$ estados $y = (y_1, \dots, y_n)$ y $m$ controles
$u = (u_1, \dots, u_m)$:

$$
\max_u \int_0^T F(t, y, u)\thinspace dt
\qquad \text{sujeto a} \qquad
y_j' = f_j(t, y, u), \quad y_j(0) = y_{j0}, \quad j = 1, \dots, n, \quad u \in U.
$$

Cada estado tiene su ecuación de movimiento y su coestado $\lambda_j$. El
Hamiltoniano es

$$
H = F + \sum_{j=1}^n \lambda_j f_j,
$$

y el principio del máximo se escribe componente por componente:

1. $u^\ast(t)$ maximiza $H$ sobre $U$;
2. $y_j' = \partial H/\partial \lambda_j = f_j$ para cada $j$;
3. $\lambda_j' = -\partial H/\partial y_j$ para cada $j$;
4. una condición de transversalidad para cada estado, según su condición
   final (sesión 11, sección 3).

Son $2n$ ecuaciones diferenciales con $n$ condiciones iniciales y $n$
finales (Chiang, sec. 8.4). En horizonte infinito se usa $H_c$ y
$\mu_j' = \rho\mu_j - \partial H_c/\partial y_j$, como en la sesión 12.

**La novedad está en la condición 3.** $\partial H/\partial y_j$ incluye
$\sum_k \lambda_k\thinspace\partial f_k/\partial y_j$: si el estado $j$
ayuda a crecer al estado $k$, el precio sombra de $j$ incluye el valor de
esa ayuda, medido con el precio de $k$. Los precios sombra se encadenan.

### 1.2 Ejemplo: infraestructura y capital privado

Un gobierno regional construye infraestructura $G$ con un gasto $u$ que
cuesta $u^2/2$. La infraestructura atrae capital privado $K$, y el capital
produce:

$$
\max_u \int_0^T \Big(K - \frac{u^2}{2}\Big)\thinspace dt,
\qquad G' = u, \qquad K' = aG,
$$

con $G(0)$, $K(0)$ dados y $G(T)$, $K(T)$ libres. El Hamiltoniano es
$H = K - u^2/2 + \lambda_G u + \lambda_K aG$:

- $\partial H/\partial u = 0$: $u = \lambda_G$.
- $\lambda_K' = -\partial H/\partial K = -1$ y $\lambda_K(T) = 0$, así que
  $\lambda_K(t) = T - t$.
- $\lambda_G' = -\partial H/\partial G = -a\lambda_K = -a(T - t)$ y
  $\lambda_G(T) = 0$, así que $\lambda_G(t) = a(T - t)^2/2$.

El gasto óptimo es $u(t) = a(T - t)^2/2$: **se concentra al principio** y
llega a cero al final.

**Lectura.** $\lambda_K(t) = T - t$ es lo que produce una unidad de capital
privado en lo que queda del horizonte. $\lambda_G$ es el valor de una
unidad de infraestructura, y sale **sólo** del capital privado que atrae:
$\lambda_G' = -a\lambda_K$. La infraestructura vale por lo que hace crecer a
otro estado; cerca del final ya no le da tiempo y su precio cae a cero.

---

## 2. Control acotado y Hamiltoniano lineal

### 2.1 La función de cambio

Si el control entra de forma **lineal** en $F$ y en $f$, el Hamiltoniano se
escribe

$$
H = A(t, y, \lambda) + \sigma(t, y, \lambda)\thinspace u,
\qquad u \in [u_{\min}, u_{\max}],
$$

donde $\sigma = \partial H/\partial u$ es la **función de cambio**. Como $H$
es una recta en $u$, su máximo está en un extremo:

$$
u^\ast(t) = \begin{cases}
u_{\max} & \text{si } \sigma(t) > 0, \cr
u_{\min} & \text{si } \sigma(t) < 0, \cr
\text{no determinado por esta condición} & \text{si } \sigma(t) = 0.
\end{cases}
$$

El control **salta** de un extremo al otro cada vez que $\sigma$ cambia de
signo: es una solución **bang-bang**, y los instantes donde $\sigma = 0$ son
los **tiempos de cambio**. La condición $\partial H/\partial u = 0$ no sirve
aquí (no hay máximo interior); "$u$ maximiza $H$" sí. Es el caso que la
ecuación de Euler no podía resolver (sesión 10, sección 4.4).

### 2.2 Cómo se resuelve

1. Escribir $H$ y $\sigma$, y la regla de bang-bang.
2. Escribir la ecuación del coestado, que suele depender del control.
3. **Empezar por el final**: la transversalidad dice cuánto vale $\lambda$ en
   $T$, y con eso el signo de $\sigma$ cerca de $T$ y el control de la última
   fase.
4. Integrar **hacia atrás** con ese control hasta que $\sigma$ cambie de
   signo: ahí está el tiempo de cambio.
5. Seguir hacia atrás con el otro control. Con el coestado completo, se
   integra el estado hacia adelante.

Si $\sigma$ se anula en un intervalo completo, y no sólo en instantes
aislados, hay un **arco singular**; ver [Para profundizar, P.2](#pp2).

---

## 3. Práctica: invertir o consumir

### 3.1 El modelo

Una región tiene capital $K$ y produce $Y = vK$, donde $v$ es la
productividad del capital (el inverso de $K/Y$). Invierte una fracción
$u \in [0, 1]$ del producto y consume el resto. El consumo vale lo mismo en
cualquier momento (utilidad lineal, sin descuento por ahora):

$$
\max_{u \in [0, 1]} \int_0^T (1 - u)\thinspace vK\thinspace dt
\qquad \text{sujeto a} \qquad K' = uvK, \quad K(0) = K_0, \quad K(T) \text{ libre}.
$$

### 3.2 La solución

**Paso 1.** $H = (1 - u)vK + \lambda uvK = vK + vK(\lambda - 1)\thinspace u$.
La función de cambio es

$$
\sigma = vK(\lambda - 1).
$$

Como $vK > 0$, el signo lo decide $\lambda - 1$: **se invierte todo si
$\lambda > 1$ y se consume todo si $\lambda < 1$**. Una unidad de capital
vale $\lambda$; consumirla vale 1.

**Paso 2.** $\lambda' = -\partial H/\partial K = -v\big((1 - u) + \lambda u\big)$.

**Paso 3.** $K(T)$ es libre: $\lambda(T) = 0 < 1$. Al final se consume todo,
$u = 0$, y ahí $\lambda' = -v$:

$$
\lambda(t) = v(T - t).
$$

**Paso 4.** $\lambda$ llega a 1 cuando $v(T - t) = 1$:

$$
\boxed{\ t^\ast = T - \frac{1}{v}\ }
$$

**Paso 5.** Antes de $t^\ast$, con $u = 1$, $\lambda' = -v\lambda$, así que
$\lambda(t) = e^{v(t^\ast - t)} > 1$: se invierte todo, como se supuso. El
capital crece, $K(t) = K_0e^{vt}$, hasta $t^\ast$, y después se queda
constante y se consume todo lo que produce. Si $T < 1/v$, nunca conviene
invertir: $t^\ast = 0$.

### 3.3 Lectura: el plazo de recuperación

$\lambda(t) = v(T - t)$ en la fase final es lo que una unidad de capital
produce en el tiempo que queda. **Conviene invertir mientras una unidad de
capital alcance a devolver más de una unidad de consumo antes del final.**
$1/v$ es el **plazo de recuperación**: los años que tarda una unidad de
capital en producir su propio valor. Se invierte hasta que falten $1/v$
años.

Con $T = 20$ años:

| $v$ | Plazo $1/v$ | $t^\ast$ ($\rho = 0$) | $t^\ast$ ($\rho = 0.03$) | Consumo total, óptimo | Mejor tasa fija |
|---|---|---|---|---|---|
| 0.25 | 4 años | 16 | 15.7 | $54.6K_0$ | $13.9K_0$ (con $u \approx 0.73$) |
| 0.10 | 10 años | 10 | 8.1 | $2.72K_0$ | $2.00K_0$ (con $u = 0$) |
| 0.04 | 25 años | 0 | 0 | $0.80K_0$ | $0.80K_0$ (con $u = 0$) |

$v = 0.25$ corresponde al $K/Y \approx 4$ de México (sesión 12). La
columna "mejor tasa fija" es el mejor resultado con un mismo $u$ en todo el
horizonte: con utilidad lineal, la diferencia con el bang-bang es enorme,
porque al consumidor no le importa cuándo consume y conviene concentrar la
inversión al principio, cuando más rinde.

**Con descuento.** Con $\int_0^T e^{-\rho t}(1 - u)vK\thinspace dt$ y el
Hamiltoniano a valor presente, la fase final da
$\mu(t) = (v/\rho)\big(1 - e^{-\rho(T - t)}\big)$, y el cambio ocurre cuando
$\mu = 1$:

$$
\frac{v}{\rho}\big(1 - e^{-\rho(T - t^\ast)}\big) = 1
\iff e^{-\rho(T - t^\ast)} = 1 - \frac{\rho}{v}
\iff
\boxed{\ T - t^\ast = -\frac{1}{\rho}\ln\Big(1 - \frac{\rho}{v}\Big)\ }
$$

si $v > \rho$; si $v \le \rho$, no conviene invertir nunca. Con $\rho \to 0$
se recupera $1/v$. La impaciencia adelanta el cambio (ejercicio F4).

**Lectura regional.** Una región con capital muy productivo (plazo de
recuperación corto) debe dedicar casi todo el horizonte a acumular. Una con
capital poco productivo, a consumir. Con dos regiones (sesión 14), la
función de cambio compara los precios sombra del capital de cada una, y el
orden de las fases dice dónde invertir primero.

---

## 4. Condiciones suficientes

### 4.1 Mangasarian

**Teorema (Mangasarian).** En el problema con $T$ fijo, supón que $u^\ast$,
$y^\ast$ y $\lambda$ cumplen el principio del máximo y la transversalidad, y
que

1. $F$ es cóncava en $(y, u)$ para cada $t$;
2. cada $f_j$ es cóncava en $(y, u)$, y $\lambda_j(t) \ge 0$ para las $f_j$
   que no son lineales.

Entonces $u^\ast$ es óptimo. Si $F$ es estrictamente cóncava, es el único.

Es la versión dinámica de "condiciones de primer orden más concavidad dan
un máximo global" de la sesión 2. La demostración está en [P.1](#pp1).

### 4.2 Arrow

**Teorema (Arrow).** Sea $H^0(t, y, \lambda) = \max_{u \in U} H(t, y, u, \lambda)$
el **Hamiltoniano maximizado**. Si las condiciones del principio del máximo
se cumplen y $H^0$ es cóncavo en $y$ para cada $t$ (con $\lambda$ fijo),
entonces $u^\ast$ es óptimo.

Si se cumplen las condiciones de Mangasarian, $H = F + \sum\lambda_j f_j$
es cóncavo en $(y, u)$, y entonces $H^0$ es cóncavo en $y$
([C.A4](repaso/calculo.md#ca4)): Arrow es más general (Chiang, sec. 8.3;
Sethi, teorema 2.1).

### 4.3 Aplicaciones

| Problema | Mangasarian | Arrow |
|---|---|---|
| Fondo regional (sesiones 10 y 11): $F = e^{-\rho t}u(c)$, $f = rW - c$ | Sí: $u$ cóncava y $f$ lineal | Sí |
| Recurso (sesión 11): $F = e^{-\rho t}B(q)$, $f = -q$ | Sí | Sí |
| Infraestructura (sección 1.2): $F = K - u^2/2$, $f$ lineales | Sí | Sí |
| Invertir o consumir (sección 3): $F = (1 - u)vK$, $f = uvK$ | **No**: $uK$ no es cóncava en $(K, u)$ | **Sí**: $H^0 = vK\max\lbrace 1, \lambda\rbrace$ es lineal en $K$ |

En la práctica, $uvK$ es un producto de dos variables: su matriz hessiana en
$(K, u)$ tiene determinante $-v^2 < 0$, y no es cóncava
([L.I4](repaso/algebra_lineal.md#li4)). Mangasarian no aplica, pero Arrow
sí, porque una vez elegido el mejor $u$, el Hamiltoniano es lineal en $K$.
El bang-bang de la sección 3 es el óptimo.

**Horizonte infinito.** Los dos teoremas valen si se agrega
$\lim_{t \to \infty}\lambda(t)\big(y(t) - y^\ast(t)\big) \ge 0$ para toda
trayectoria factible $y$ (Sethi, sec. 3.6). En Ramsey, con $k \ge 0$ y
$\lambda k^\ast \to 0$, se cumple: la rama estable es el óptimo (sesión 12).

---

## 5. Hacia la optimización dinámica

| Idea de esta sesión | Dónde reaparece |
|---|---|
| Un coestado por estado; precios encadenados | Precio sombra del capital de cada región (sesión 14) |
| Función de cambio y bang-bang | El reparto $\theta(t)$ entre dos regiones (sesión 14) |
| Plazo de recuperación $1/v$ | Tiempo de cambio del caso de dos regiones (sesión 14) |
| Resolver hacia atrás desde $T$ | Inducción hacia atrás en la ecuación de Bellman (sesión 15) |
| Hamiltoniano maximizado | La función valor y la maximización parcial (sesión 16) |

---

## 6. Resumen formal

| Concepto | Enunciado | Dónde |
|---|---|---|
| Varios estados | $H = F + \sum_j\lambda_jf_j$; $\lambda_j' = -\partial H/\partial y_j$ | 1.1 |
| Precios encadenados | $\partial H/\partial y_j$ incluye $\sum_k\lambda_k\thinspace\partial f_k/\partial y_j$ | 1.1, 1.2 |
| Función de cambio | $\sigma = \partial H/\partial u$ cuando $H$ es lineal en $u$ | 2.1 |
| Bang-bang | $u = u_{\max}$ si $\sigma > 0$; $u = u_{\min}$ si $\sigma < 0$ | 2.1 |
| Resolver hacia atrás | La transversalidad fija la última fase | 2.2 |
| Invertir o consumir | Se invierte todo hasta $t^\ast = T - 1/v$ | 3.2 |
| Con descuento | $T - t^\ast = -\ln(1 - \rho/v)/\rho$ | 3.3 |
| Mangasarian | $F$ y $f$ cóncavas en $(y, u)$ (y $\lambda \ge 0$) | 4.1 |
| Arrow | $H^0$ cóncavo en $y$ | 4.2 |

---

## 7. Ejercicios formales

- **F1.** En el ejemplo de infraestructura, supón que la infraestructura se
  deprecia: $G' = u - \delta G$. Encuentra $\lambda_G(t)$ y el gasto óptimo.
  ¿Se concentra más o menos al principio que sin depreciación?
- **F2.** En la práctica, supón que el capital se deprecia:
  $K' = uvK - \delta K$, con $v > \delta$ y $\rho = 0$. Muestra que
  $T - t^\ast = -\ln(1 - \delta/v)/\delta$. Compáralo con la fórmula con
  descuento.
- **F3.** Verifica las condiciones de Mangasarian para el fondo regional
  (sesión 11) y para el recurso no renovable. Para la práctica, calcula
  $H^0(K, \lambda)$ y verifica la condición de Arrow.
- **F4.** Deriva la fórmula de $T - t^\ast$ con descuento. Muestra que es
  mayor que $1/v$ y que crece con $\rho$. Interpreta: ¿por qué la
  impaciencia adelanta el momento de dejar de invertir?

**Para profundizar** (opcionales)

- **F5.** Resuelve $\max \int_0^2 -\tfrac{1}{2}x^2\thinspace dt$ con
  $x' = u$, $x(0) = 1$ y $u \in [-1, 1]$ (Sethi, ejemplo 2.5). Muestra que
  hay un arco singular en $[1, 2]$ ([P.2](#pp2)).
- **F6.** Completa la demostración de Mangasarian ([P.1](#pp1)) para el
  caso con $y(T) \ge y_{\min}$.
- **F7.** Muestra que en el problema bang-bang de Chiang (sec. 7.2, ejemplo
  2; sesión 11, sección 5 del cuaderno), Mangasarian se cumple y, por
  tanto, la solución es óptima.

## Para profundizar

Material opcional: demostraciones y temas que no se ven en clase. Cada
apartado indica de qué sección de las notas viene.

<a id="pp1"></a>

### P.1 Demostración de la suficiencia de Mangasarian (sección 4.1)

Con un estado y un control para simplificar la notación, y $y(T)$ libre.
Sea $(y, u)$ cualquier par factible y $(y^\ast, u^\ast)$ el candidato, con
coestado $\lambda$. Se escribe $F^\ast = F(t, y^\ast, u^\ast)$, y lo mismo
para $f$ y las derivadas.

**Paso 1: concavidad.** Como $F$ y $\lambda f$ son cóncavas en $(y, u)$
($\lambda \ge 0$ si $f$ no es lineal), $H = F + \lambda f$ también lo es, y
queda debajo de su plano tangente
([C.I2](repaso/calculo.md#ci2)):

$$
H(y, u) - H(y^\ast, u^\ast) \le H_y^\ast\thinspace(y - y^\ast) + H_u^\ast\thinspace(u - u^\ast).
$$

**Paso 2: las condiciones.** $H_y^\ast = -\lambda'$ (condición 3). Como
$u^\ast$ maximiza $H$ sobre $U$ y $H$ es cóncavo en $u$,
$H_u^\ast(u - u^\ast) \le 0$ para todo $u \in U$ (en un máximo interior es
cero; en un extremo, el signo de $H_u^\ast$ apunta hacia afuera de $U$).
Entonces

$$
F - F^\ast \le -\lambda'(y - y^\ast) - \lambda\big(f - f^\ast\big)
= -\lambda'(y - y^\ast) - \lambda\big(y' - y^{\ast\prime}\big)
= -\frac{d}{dt}\Big(\lambda\thinspace(y - y^\ast)\Big).
$$

**Paso 3: integrar.** De 0 a $T$:

$$
\int_0^T (F - F^\ast)\thinspace dt \le -\lambda(T)\big(y(T) - y^\ast(T)\big) + \lambda(0)\big(y(0) - y^\ast(0)\big) = 0,
$$

porque $\lambda(T) = 0$ (transversalidad) y $y(0) = y^\ast(0) = y_0$.
Ninguna trayectoria factible da más que la candidata. $\square$

Si $y(T)$ es fijo, el término final se anula porque $y(T) = y^\ast(T)$; si
$y(T) \ge y_{\min}$, por la holgura complementaria (ejercicio F6). En
horizonte infinito, el término final es la condición
$\lim \lambda(y - y^\ast) \ge 0$ de la sección 4.3.

<a id="pp2"></a>

### P.2 Arcos singulares (sección 2.2)

Si la función de cambio vale cero en un intervalo, la condición "u maximiza
H" no dice nada: cualquier $u$ da el mismo $H$. Pero $\sigma = 0$ en un
intervalo implica que también $\sigma' = 0$, $\sigma'' = 0$, etc., y esas
ecuaciones suelen determinar el control.

**Ejemplo (Sethi, ejemplo 2.5).** $\max \int_0^2 -\tfrac{1}{2}x^2\thinspace dt$
con $x' = u$, $x(0) = 1$, $u \in [-1, 1]$. Aquí
$H = -\tfrac{1}{2}x^2 + \lambda u$, $\sigma = \lambda$ y
$\lambda' = x$, $\lambda(2) = 0$. La intuición dice que conviene bajar $x$
lo más rápido posible: $u = -1$ hasta que $x = 0$, en $t = 1$. Con
$\lambda(1) = 0$, en $[0, 1]$, $\lambda' = 1 - t$ da
$\lambda(t) = -\tfrac{1}{2}(1 - t)^2 \le 0$, consistente con $u = -1$.
En $[1, 2]$, mantener $\sigma = \lambda = 0$ exige $\lambda' = x = 0$, y
mantener $x = 0$ exige $u = 0$: un control **interior**, aunque el
Hamiltoniano es lineal. Es un **arco singular**.

En economía, los arcos singulares aparecen cuando conviene llegar a un
nivel del estado y quedarse ahí: por ejemplo, con un recurso renovable que
se explota con un Hamiltoniano lineal en la cosecha (el caso breve de la
sesión 18) o en problemas de inversión con un capital objetivo. Para
descartar un arco singular basta mostrar que $\sigma$ no puede anularse en
un intervalo, como en la práctica de la sección 3, donde $\lambda$ es
estrictamente decreciente.

---

## Referencias

- Chiang, A. C. (1992). *Elements of Dynamic Optimization*. McGraw-Hill.
- Sethi, S. P. (2021). *Optimal Control Theory: Applications to Management
  Science and Economics* (4.ª ed.). Springer.
  https://doi.org/10.1007/978-3-030-91745-6
