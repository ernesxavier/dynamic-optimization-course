# Sesión 12: Horizonte infinito y descuento

> **Cómo usar estas notas.** Ésta es una sesión mixta. La primera hora se
> da en el pizarrón y sigue estas notas: el Hamiltoniano a valor presente,
> la transversalidad y el modelo de Ramsey. La segunda hora sigue el
> **cuaderno** (`Code/s12_ramsey.jl`), que llega con los datos cargados y
> la calibración hecha: en clase se interpreta. El **plan de clase** de
> abajo dice qué se hace en cada momento. En el pizarrón van las ecuaciones
> y los resultados en recuadro; como todo está aquí, en clase no hace falta
> copiar. El cuerpo de las notas es la **ruta básica** y se evalúa; las
> demostraciones y los temas opcionales están al final, en **Para
> profundizar**, y no se ven en clase.
>
> Repaso recomendado: [C.B3–B4](repaso/calculo.md#cb3) (exponencial e
> integrales), [A.B3](repaso/analisis.md#ab3) (series y descuento),
> [E.B2](repaso/estadistica.md#eb2) (tasas de crecimiento con datos),
> [L.I1–I2](repaso/algebra_lineal.md#li1) (eigenvalores),
> [D.I2](repaso/ecuaciones_diferenciales.md#di2) (lineales de primer orden),
> [D.I6–I7](repaso/ecuaciones_diferenciales.md#di6) (diagramas de fase y
> valor en la frontera), [N.I1](repaso/metodos_numericos.md#ni1)
> (bisección y Newton), [N.I3](repaso/metodos_numericos.md#ni3)
> (DifferentialEquations.jl), [E.I3](repaso/estadistica.md#ei3)
> (calibración) y [N.I7](repaso/metodos_numericos.md#ni7) (datos en Julia);
> para Para profundizar, [D.A2](repaso/ecuaciones_diferenciales.md#da2)
> (variedades estable e inestable), [A.A5](repaso/analisis.md#aa5)
> (integrales impropias y condiciones al infinito) y
> [N.A1](repaso/metodos_numericos.md#na1) (disparo).
>
> Lecturas: Chiang (1992), sec. 8.2 y cap. 9.

**Plan de clase** (120 minutos)

| Minutos | Dónde | Qué | Secciones |
|---|---|---|---|
| 0–5 | Pizarra | La pregunta: ¿qué velocidad de convergencia predice un modelo de ahorro óptimo? | 0 |
| 5–12 | Pizarra | Horizonte infinito y descuento | 1 |
| 12–30 | Pizarra | El Hamiltoniano a valor presente: definición, condiciones y la lectura como arbitraje | 2 |
| 30–38 | Pizarra | Transversalidad en horizonte infinito | 3 |
| 38–58 | Pizarra | Ramsey: el problema, la regla de Keynes-Ramsey, el estado estacionario, el punto de silla y cómo la transversalidad elige la rama estable | 4.1–4.5 |
| 58–63 | | Pausa | |
| 63–70 | Pizarra | La velocidad de convergencia | 4.6 |
| 70–80 | Cuaderno | Los datos de México en la Penn World Table | Cuaderno, sección 2; notas, 5.1 (lectura previa) |
| 80–95 | Cuaderno | La calibración: $\rho$, $s^\ast$ y $\beta$; mover $\alpha$ y $\theta$ | Cuaderno, sección 3; notas, 5.2–5.4 |
| 95–108 | Cuaderno | El diagrama de fase calibrado y la transición; la transversalidad, numéricamente | Cuaderno, secciones 4 y 5 |
| 108–118 | Parejas, en el cuaderno | Ejercicios de código 1 a 3 | Cuaderno, ejercicios |
| 118–120 | Pizarra | Cierre: entrega de la propuesta de proyecto | 6 |
| Después | Lectura | El resumen (7), la lectura completa de la calibración (5.4) y Para profundizar | |

**Pregunta de la unidad.** ¿Conviene invertir primero donde se ahorra más o
donde se produce más?

---

## 0. La pregunta

La Unidad II preguntó si los estados de México convergen y a qué
velocidad (sesión 5), y en la sesión 8 se vio el diagrama de fase de
Ramsey sin derivarlo. Esta sesión lo deriva con el principio del máximo y
lo calibra con datos de México. Así se responde la pregunta de la Unidad
II con un modelo en el que el ahorro se elige: ¿qué velocidad de
convergencia predice un modelo de crecimiento óptimo calibrado para
México, y se parece a la de los datos?

Hacen falta dos herramientas nuevas. Una economía o una región no tiene
fecha final: el horizonte es **infinito**. Y con descuento conviene medir
los precios en valor corriente, con el **Hamiltoniano a valor presente**.

---

## 1. Horizonte infinito

### 1.1 El problema

$$
\max_{u}\ \int_0^\infty e^{-\rho t}F\big(y(t), u(t)\big)\thinspace dt
\qquad \text{sujeto a} \qquad y' = f(y, u), \quad y(0) = y_0, \quad u \in U.
$$

$F$ y $f$ no dependen de $t$: el tiempo entra sólo por el descuento. Es un
problema **autónomo**.

**¿Por qué infinito?** Con un horizonte finito $T$ habría que decir qué
pasa con el capital en $T$. Si sobra, no vale nada ($\lambda(T) = 0$) y el
modelo pide consumirlo todo antes del final; los resultados dependerían de
una fecha que nadie elige. Con horizonte infinito, el problema que empieza
en cualquier instante tiene la misma forma que el original.

### 1.2 El descuento hace que la integral converja

Si $F$ está acotada, $|F| \le M$, y $\rho > 0$, la integral converge:
$\int_0^\infty e^{-\rho t}M\thinspace dt = M/\rho$
([A.A5](repaso/analisis.md#aa5)). Sin descuento, una trayectoria con $F$
positiva acumula un valor infinito, y no se pueden comparar dos de ellas.
Es la versión continua de la serie geométrica del descuento
([A.B3](repaso/analisis.md#ab3)).

---

## 2. El Hamiltoniano a valor presente

### 2.1 Definición y condiciones

En la sesión 11, con $F$ descontada, $H = e^{-\rho t}F + \lambda f$ y
$\lambda(t)$ es un precio en valor de $t = 0$. Se define el precio en valor
del instante $t$,

$$
\mu(t) = e^{\rho t}\lambda(t),
$$

y el **Hamiltoniano a valor presente**

$$
H_c(y, u, \mu) = e^{\rho t}H = F(y, u) + \mu\thinspace f(y, u).
$$

**Sobre el nombre.** "Hamiltoniano a valor presente" es el término de
Chiang y Wainwright (2006, cap. 20) en español. En inglés, Chiang (1992,
sec. 8.2) y Sethi (2021, sec. 3.3) lo llaman *current-value Hamiltonian*:
mide los valores en unidades del instante $t$ (valor corriente), no
descontados a $t = 0$. Por eso aquí se dice que $\mu$ es un precio "en valor
corriente". Es el mismo objeto con dos nombres.

Las condiciones del principio del máximo se vuelven:

1. $u^\ast$ maximiza $H_c(y, u, \mu)$ sobre $u \in U$;
2. $y' = f(y, u)$;
3. $\boxed{\ \mu' = \rho\mu - \dfrac{\partial H_c}{\partial y}\ }$;
4. la condición de transversalidad (sección 3).

**De dónde sale la condición 3.** De $\lambda = e^{-\rho t}\mu$,
$\lambda' = e^{-\rho t}(\mu' - \rho\mu)$. La condición de la sesión 11,
$\lambda' = -\partial H/\partial y = -e^{-\rho t}\partial H_c/\partial y$,
da $\mu' - \rho\mu = -\partial H_c/\partial y$. Las condiciones 1 y 2 no
cambian, porque multiplicar $H$ por $e^{\rho t} > 0$ no cambia dónde está su
máximo.

### 2.2 Por qué conviene

En $H_c$ no aparece $t$. Si la condición 1 da $u$ como función de $(y, \mu)$,
las condiciones 2 y 3 forman un **sistema autónomo** en $(y, \mu)$: tiene
estados estacionarios y diagrama de fase (sesiones 6 a 8). Con $\lambda$ no
pasa eso, porque $\lambda$ cae a la tasa $\rho$ aun en el estado
estacionario.

### 2.3 Lectura: una condición de arbitraje

Escrita como

$$
\rho\thinspace\mu = \frac{\partial H_c}{\partial y} + \mu',
$$

la condición 3 compara dos formas de usar una unidad de estado valuada en
$\mu$. A la izquierda, lo que rendiría a la tasa de descuento. A la
derecha, lo que rinde en el problema: su aporte en este instante (el
**dividendo**, $\partial H_c/\partial y$) más el cambio de su precio (la
**ganancia de capital**, $\mu'$). En el óptimo, conservar la unidad rinde
exactamente $\rho$.

- **Recurso de la sesión 11**: $\partial H_c/\partial S = 0$, así que
  $\mu' = \rho\mu$: el precio en valor corriente sube a la tasa $\rho$. Es la
  regla de Hotelling, ahora en una línea.
- **Fondo de la sesión 10**: $\partial H_c/\partial W = r\mu$, así que
  $\mu'/\mu = \rho - r$.

---

## 3. Transversalidad en horizonte infinito

Sin fecha final, la condición $\lambda(T) = 0$ no tiene un instante donde
aplicarse. Su análogo, para un estado que debe ser no negativo, es

$$
\boxed{\ \lim_{t \to \infty} e^{-\rho t}\mu(t)\thinspace y(t) = \lim_{t \to \infty} \lambda(t)\thinspace y(t) = 0\ }
$$

**Lectura.** $\lambda(t)y(t)$ es el valor del estado en el instante $t$,
medido en valor de hoy. La condición dice que, a muy largo plazo, ese valor
tiende a cero: no es óptimo acumular para siempre algo que tiene valor y
nunca se usa. Es la holgura complementaria
$\lambda(T)\big(y(T) - 0\big) = 0$ de la sesión 11, llevada al límite.

**Cuidado.** La condición más directa, $\lim_{t \to \infty}\lambda(t) = 0$,
no es necesaria en general. Cuándo es necesaria la transversalidad en
horizonte infinito es una pregunta delicada; está en [Para profundizar,
P.1](#pp1). En el modelo de Ramsey, la forma de arriba sí es necesaria.

---

## 4. El modelo de Ramsey

### 4.1 El problema

La población trabajadora crece a la tasa $n$, $L(t) = L_0e^{nt}$. Con capital
por trabajador $k$, producto por trabajador $f(k) = Ak^\alpha$,
depreciación $\delta$ y consumo por trabajador $c$, el capital por
trabajador cambia según

$$
k' = f(k) - (\delta + n)k - c.
$$

El término $nk$ es la **dilución**: con más trabajadores, el mismo capital
se reparte entre más. El planificador maximiza la utilidad de todas las
generaciones, pesada por su tamaño:

$$
\max_c \int_0^\infty e^{-\rho t}L(t)\thinspace u(c)\thinspace dt
\ \propto\ \int_0^\infty e^{-(\rho - n)t}\thinspace u(c)\thinspace dt,
\qquad u(c) = \frac{c^{1-\theta} - 1}{1 - \theta},
$$

con $\rho > n$ para que la integral converja. La tasa de descuento efectiva
es $\rho - n$. $\theta$ es el parámetro de la utilidad CRRA de las sesiones 8
y 10, no el reparto $\theta(t)$ de la sesión 14.

### 4.2 La regla de Keynes-Ramsey

Con $H_c = u(c) + \mu\big(f(k) - (\delta + n)k - c\big)$ y la tasa de
descuento $\rho - n$:

- Condición 1: $u'(c) = \mu$. El consumo se elige hasta que su utilidad
  marginal iguala el precio del capital.
- Condición 3: $\mu' = (\rho - n)\mu - \mu\big(f'(k) - \delta - n\big)$, es
  decir, $\mu'/\mu = \rho + \delta - f'(k)$.

Derivando la primera, $u''(c)c' = \mu'$; con la utilidad CRRA,
$u''(c)c/u'(c) = -\theta$, así que $-\theta c'/c = \mu'/\mu$:

$$
\boxed{\ \frac{c'}{c} = \frac{f'(k) - \delta - \rho}{\theta}\ }
$$

Es la regla de la sesión 10 con el rendimiento del fondo, $r$, reemplazado
por el rendimiento neto del capital, $f'(k) - \delta$. El crecimiento de la
población no aparece porque se descuenta con $\rho - n$ y se diluye con
$n$: los dos efectos se cancelan.

### 4.3 El estado estacionario

Con $c' = 0$ y $k' = 0$:

$$
\boxed{\ f'(k^\ast) = \delta + \rho,
\qquad
c^\ast = f(k^\ast) - (\delta + n)k^\ast\ }
$$

La primera es la **regla de oro modificada**. La regla de oro, el capital
que maximiza el consumo de estado estacionario, cumple
$f'(k_{RO}) = \delta + n$. Como $\rho > n$, $k^\ast < k_{RO}$: por la
impaciencia no conviene acumular hasta la regla de oro (sesión 8). Con
$f(k) = Ak^\alpha$, $f'(k) = \alpha f(k)/k$, así que en el estado
estacionario $f(k^\ast)/k^\ast = (\delta + \rho)/\alpha$. El ahorro repone la
depreciación y la dilución, $(\delta + n)k^\ast$, y la tasa de ahorro de
estado estacionario es

$$
\boxed{\ s^\ast = \frac{(\delta + n)k^\ast}{f(k^\ast)} = \frac{\alpha(\delta + n)}{\delta + \rho}\ }
$$

menor que la de la regla de oro, $\alpha$.

### 4.4 Punto de silla

El jacobiano del sistema $(k, c)$ en el estado estacionario es

$$
J = \begin{pmatrix} \rho - n & -1 \cr c^\ast f''(k^\ast)/\theta & 0 \end{pmatrix},
\qquad
\det J = \frac{c^\ast f''(k^\ast)}{\theta} < 0:
$$

un punto de silla (sesión 7), con un eigenvalor negativo y uno positivo.
El diagrama de fase es el de la sesión 8, ahora con la isoclina
$k' = 0$ en $c = f(k) - (\delta + n)k$.

### 4.5 La transversalidad elige la rama estable

Dado $k_0$, el consumo inicial $c_0$ no está dado: es un control. Las
condiciones 1 a 3 se cumplen en cualquier trayectoria que empiece en
$(k_0, c_0)$. ¿Cuál es la óptima? En la sesión 8 había tres destinos:

- **Arriba de la rama estable**: el capital se agota en tiempo finito.
  Después, $c$ tendría que caer de golpe a cero, y la regla de Keynes-Ramsey
  no lo permite. No es factible.
- **Abajo de la rama estable**: el consumo tiende a cero y el capital a
  $k_{\max}$, donde $f(k_{\max}) = (\delta + n)k_{\max}$. Ahí
  $f'(k_{\max}) < \delta + n$, así que $\mu$ crece a la tasa
  $\rho + \delta - f'(k_{\max}) > \rho - n$, y
  $e^{-(\rho - n)t}\mu(t)k(t)$ **crece sin límite**. Viola la
  transversalidad.
- **Sobre la rama estable**: $\mu$ y $k$ tienden a $\mu^\ast$ y $k^\ast$, y
  $e^{-(\rho - n)t}\mu k \to 0$. Cumple todo.

**La transversalidad es la condición terminal que faltaba** para un
problema de valor en la frontera con horizonte infinito: con $k(0) = k_0$,
fija el $c_0$ de la rama estable. El cuaderno lo comprueba numéricamente.

### 4.6 La velocidad de convergencia

Cerca de $k^\ast$, sobre la rama estable,
$k(t) - k^\ast \approx (k_0 - k^\ast)e^{-\beta t}$, donde $-\beta$ es el
eigenvalor negativo de $J$:

$$
\beta = \frac{1}{2}\Big(\sqrt{(\rho - n)^2 - 4c^\ast f''(k^\ast)/\theta} - (\rho - n)\Big).
$$

La **vida media**, el tiempo en que se cierra la mitad de la brecha, es
$\ln 2/\beta$. Es el $\beta$ de la convergencia de la sesión 5, ahora
derivado de un modelo de ahorro óptimo. (En la Unidad IV, $\beta$ será otra
cosa: el factor de descuento en tiempo discreto.) Con Cobb-Douglas se puede escribir
sin $A$ ([P.2](#pp2)):

$$
\beta = \frac{1}{2}\Bigg(\sqrt{(\rho - n)^2 + \frac{4(1 - \alpha)(1 - s^\ast)(\delta + \rho)^2}{\alpha\theta}} - (\rho - n)\Bigg).
$$

$\beta$ baja con $\theta$: si al planificador le disgusta que el consumo
varíe, prefiere una transición lenta.

---

## 5. Práctica con datos: Ramsey calibrado para México

### 5.1 Los datos

*Lectura previa: esta sección y la tabla de datos se leen antes de clase;
en clase, el cuaderno muestra las series y la calibración.*

El cuaderno carga la Penn World Table 11.0 para México
(`Data/pwt_mexico.csv`) y calcula promedios de 1990 a 2019 (después de la
apertura comercial y antes de la pandemia):

| Dato | Variable de la PWT | Valor 1990–2019 |
|---|---|---|
| Participación del trabajo | `labsh` | 0.354 |
| Depreciación | `delta` | 0.035 |
| Crecimiento del empleo | `emp` | 2.3% anual |
| Capital entre producto, $K/Y$ | `rnna / rgdpna` | 3.66 |
| Inversión entre producto | `csh_i` | 0.192 |
| Crecimiento del producto por trabajador | `rgdpna / emp` | −0.04% anual |

El último renglón es un hecho notable: **el producto por trabajador de
México no creció entre 1990 y 2019**, y la productividad total de los
factores de la PWT (`rtfpna`) cayó de 1.28 a 1.03. Por eso el modelo se
calibra sin progreso técnico. La inversión, `csh_i`, está a precios PPA
corrientes; es una aproximación a la tasa de ahorro. La participación del
trabajo es exactamente constante (0.395) de 1950 a 1993: la PWT parece
extender un mismo valor hacia atrás. Su efecto en el promedio es pequeño
(0.346 si se promedia desde 1995).

### 5.2 La calibración

- $\alpha = 1 - $ participación del trabajo $= 0.646$.
- $\delta = 0.035$ y $n = 0.023$, directamente de los datos.
- $\rho$ se elige para que el estado estacionario reproduzca el $K/Y$ de
  los datos. En el estado estacionario,
  $f'(k^\ast) = \alpha Y/K = \delta + \rho$, así que

$$
\boxed{\ \rho = \frac{\alpha}{K/Y} - \delta\ }
$$

- $\theta$ no se puede obtener de estos datos: se supone $\theta = 2$ y se
  prueba entre 1 y 4.
- $A$ sólo fija las unidades; el cuaderno normaliza el producto de estado
  estacionario a 1.

### 5.3 Resultados

| | $\alpha$ de la PWT | $\alpha = 1/3$ |
|---|---|---|
| $\alpha$ | 0.646 | 0.333 |
| $\rho$ calibrado | 14.1% | 5.6% |
| Rendimiento neto del capital, $f'(k^\ast) - \delta$ | 14.1% | 5.6% |
| Ahorro de estado estacionario, $s^\ast$ | 21.3% | 21.3% |
| $\beta$ con $\theta = 2$ | 4.2% | 6.6% |
| Vida media con $\theta = 2$ | 16.5 años | 10.5 años |

### 5.4 Lectura

- **El ahorro coincide con los datos.** El modelo pide $s^\ast = 21.3\%$, y la
  inversión observada es 19.2%. Ojo: $s^\ast = (\delta + n)K/Y$ es una
  identidad de cualquier estado estacionario, también del modelo de Solow.
  Que coincida dice que México está cerca de un estado estacionario, no que
  ahorre de manera óptima.
- **El $\rho$ calibrado es alto.** Con el $\alpha$ de la PWT, el capital rinde
  14% neto, y el modelo sólo puede explicarlo con impaciencia. Fuera del
  modelo hay otras explicaciones: riesgo, restricciones de crédito o una
  participación del trabajo mal medida. **El parámetro calibrado depende
  del supuesto sobre $\alpha$**: con $\alpha = 1/3$, $\rho$ baja a 5.6%.
- **¿Qué $\alpha$ usar?** La participación del trabajo de México en la PWT es
  baja (alrededor de 0.35). Una razón posible es la dificultad de imputar
  el ingreso de los trabajadores por cuenta propia, que en México son
  muchos. El valor convencional, $\alpha \approx 1/3$, viene de países donde
  esa imputación importa menos. El cuaderno permite usar los dos.
- **La convergencia predicha es rápida.** Con cualquier $\alpha$, Ramsey
  predice que una economía cierra la mitad de su brecha en 10 a 17 años
  ($\beta$ entre 4% y 7%). Entre los estados de México, en la sesión 5 no
  hubo convergencia absoluta ($\beta \approx 0$ sin los estados
  petroleros). La diferencia dice que los estados no comparten el mismo
  estado estacionario (productividad, instituciones, infraestructura), o
  que les falta algo que el modelo no tiene, como la movilidad de capital
  y de trabajo entre regiones (Laboratorio 1).
- Es un modelo de una **economía cerrada** calibrado con datos nacionales.
  Usarlo para una región exige decidir qué pasa con el capital y el trabajo
  que cruzan sus fronteras: es la pregunta de la sesión 14.

---

## 6. Hacia la optimización dinámica

| Idea de esta sesión | Dónde reaparece |
|---|---|
| Hamiltoniano a valor presente | Invertir o consumir con descuento (sesión 13) |
| Sistema autónomo en $(y, \mu)$ | El diagrama de fase de Ramsey en $(k, c)$, que es el de $(k, \mu)$ con $\mu = u'(c)$ (sesiones 8 y 12) |
| La transversalidad elige la rama estable | Programación dinámica: la función valor elige la política sin condición terminal (sesión 16) |
| Rama estable $c = \sigma(k)$ | Función de política calculada por iteración de la función valor (sesión 17) |
| Calibración con un dato de los datos ($K/Y$) | Calibración del caso de dos regiones con el PIB por trabajador (sesión 14) y del proyecto final |

---

## 7. Resumen formal

| Concepto | Enunciado | Dónde |
|---|---|---|
| Problema autónomo descontado | $\max \int_0^\infty e^{-\rho t}F(y, u)\thinspace dt$, $y' = f(y, u)$ | 1.1 |
| Hamiltoniano a valor presente | $H_c = F + \mu f$, con $\mu = e^{\rho t}\lambda$ | 2.1 |
| Condiciones | $u$ maximiza $H_c$; $y' = f$; $\mu' = \rho\mu - \partial H_c/\partial y$ | 2.1 |
| Arbitraje | $\rho\mu = \partial H_c/\partial y + \mu'$ | 2.3 |
| Transversalidad | $\lim e^{-\rho t}\mu(t)y(t) = 0$ | 3 |
| Keynes-Ramsey | $c'/c = (f'(k) - \delta - \rho)/\theta$ | 4.2 |
| Regla de oro modificada | $f'(k^\ast) = \delta + \rho$; $s^\ast = \alpha(\delta + n)/(\delta + \rho)$ | 4.3 |
| Selección de la rama | La transversalidad descarta las demás trayectorias | 4.5 |
| Velocidad de convergencia | $\beta$ = menos el eigenvalor estable; vida media $\ln 2/\beta$ | 4.6 |
| Calibración | $\rho = \alpha/(K/Y) - \delta$ | 5.2 |

---

## 8. Ejercicios formales

- **F1.** Un gobierno con fondo $W_0$ que rinde $r$ resuelve
  $\max \int_0^\infty e^{-\rho t}\ln c\thinspace dt$ con $W' = rW - c$ y
  $\lim_{t \to \infty} e^{-rt}W(t) = 0$. Con el Hamiltoniano a valor
  presente, muestra que $c(t) = \rho W(t)$: se gasta cada año una fracción
  $\rho$ del fondo, sin importar $r$. (Es el fondo perpetuo de Sethi, 2021,
  ejemplo 3.7.)
- **F2.** Con $f(k) = k^{0.3}$, $\delta = 0.05$, $\rho = 0.03$ y $n = 0.01$,
  calcula $k^\ast$, $c^\ast$, $k_{RO}$ y $s^\ast$.
- **F3.** Muestra que $s^\ast = \alpha(\delta + n)/(\delta + \rho)$ con
  Cobb-Douglas, y que $s^\ast < \alpha$ si y sólo si $\rho > n$.
- **F4.** Con $\alpha = 0.646$ y $\delta = 0.035$, ¿qué $\rho$ se calibraría si
  $K/Y$ fuera 3.0? ¿Y si fuera 4.5? Interpreta: ¿qué dice un $K/Y$ alto
  sobre la paciencia que el modelo le atribuye a una economía?

**Para profundizar** (opcionales)

- **F5.** Completa el argumento de la sección 4.5 para las trayectorias
  debajo de la rama estable: muestra que $f'(k_{\max}) < \delta + n$ con
  $f(k) = Ak^\alpha$ y que $e^{-(\rho - n)t}\mu(t)k(t) \to \infty$.
- **F6.** Deriva la fórmula de $\beta$ con Cobb-Douglas ([P.2](#pp2)) y
  muestra que $\beta$ baja con $\theta$.
- **F7.** En F1, quita la condición $\lim e^{-rt}W(t) = 0$. Muestra que, para
  cualquier trayectoria de gasto, existe otra que gasta más en todos los
  años (endeudándose cada vez más). ¿Qué dice esto sobre la necesidad de
  una condición al infinito?

## Para profundizar

Material opcional: demostraciones y temas que no se ven en clase. Cada
apartado indica de qué sección de las notas viene.

<a id="pp1"></a>

### P.1 ¿Cuándo es necesaria la transversalidad en horizonte infinito? (sección 3)

En horizonte finito, $\lambda(T) = 0$ sale del término de frontera de la
derivación de la sesión 11 (P.1). Al llevar el argumento a $T \to \infty$ se
esperarían $\lim \lambda(t) = 0$ y, como $T$ no está fijo,
$\lim H(t) = 0$ (Chiang, sec. 9.1). Pero el paso al límite no es
automático:

- **Halkin (1974)** construyó un problema autónomo cuyo óptimo tiene
  $\lambda(t) = -1$ para todo $t$: $\lim \lambda(t) = 0$ no se cumple. Chiang
  (sec. 9.2) argumenta que el problema tiene implícito un estado final
  fijo, y que por eso esa condición no debía esperarse. En cualquier caso,
  $\lim \lambda(t) = 0$ no es necesaria en general.
- **Michel (1982)** demostró que en problemas autónomos descontados sí es
  necesaria $\lim_{t \to \infty} H(t) = 0$, con $H$ en valor de $t = 0$.
- Para problemas **cóncavos** con estado no negativo, como Ramsey,
  $\lim \lambda(t)y(t) = 0$ es necesaria bajo condiciones generales que
  Ramsey cumple (Kamihigashi, 2001) y, junto con las demás condiciones,
  **suficiente** (sesión 13, Mangasarian y Arrow).

La lección práctica: en los modelos del curso se usa
$\lim \lambda(t)y(t) = 0$, y se comprueba que la trayectoria candidata la
cumple; la suficiencia de la sesión 13 garantiza que es el óptimo.

<a id="pp2"></a>

### P.2 La velocidad de convergencia con Cobb-Douglas (sección 4.6)

Los eigenvalores de $J$ cumplen $\nu^2 - (\rho - n)\nu + c^\ast f''(k^\ast)/\theta = 0$,
así que

$$
\nu = \frac{(\rho - n) \pm \sqrt{(\rho - n)^2 - 4c^\ast f''(k^\ast)/\theta}}{2}.
$$

Como $c^\ast f''(k^\ast) < 0$, la raíz es mayor que $|\rho - n|$: un
eigenvalor es positivo y el otro, $-\beta$, negativo. Con $f = Ak^\alpha$,
en el estado estacionario $f(k^\ast)/k^\ast = (\delta + \rho)/\alpha$,
$f''(k^\ast) = -\alpha(1 - \alpha)f(k^\ast)/(k^\ast)^2$ y
$c^\ast = (1 - s^\ast)f(k^\ast)$. Entonces

$$
c^\ast f''(k^\ast) = -\alpha(1 - \alpha)(1 - s^\ast)\Big(\frac{f(k^\ast)}{k^\ast}\Big)^2
= -\frac{(1 - \alpha)(1 - s^\ast)(\delta + \rho)^2}{\alpha},
$$

que no depende de $A$. Sustituyendo sale la fórmula de la sección 4.6. Como
$\theta$ divide al término dentro de la raíz, $\beta$ baja con $\theta$.

---

## Referencias

- Chiang, A. C. (1992). *Elements of Dynamic Optimization*. McGraw-Hill.
- Chiang, A. C., & Wainwright, K. (2006). *Métodos fundamentales de
  economía matemática* (4.ª ed.). McGraw-Hill.
- Feenstra, R. C., Inklaar, R., & Timmer, M. P. (2015). The next
  generation of the Penn World Table. *American Economic Review*, 105(10),
  3150–3182. https://doi.org/10.1257/aer.20130954. Datos: Penn World Table
  11.0, https://doi.org/10.34894/FABVLR.
- Halkin, H. (1974). Necessary conditions for optimal control problems with
  infinite horizons. *Econometrica*, 42(2), 267–272.
  https://doi.org/10.2307/1911976
- Kamihigashi, T. (2001). Necessity of transversality conditions for
  infinite horizon problems. *Econometrica*, 69(4), 995–1012.
  https://doi.org/10.1111/1468-0262.00227
- Michel, P. (1982). On the transversality condition in infinite horizon
  optimal problems. *Econometrica*, 50(4), 975–985.
  https://doi.org/10.2307/1912772
- Sethi, S. P. (2021). *Optimal Control Theory: Applications to Management
  Science and Economics* (4.ª ed.). Springer.
  https://doi.org/10.1007/978-3-030-91745-6
