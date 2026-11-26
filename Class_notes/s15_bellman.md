# Sesión 15: Ecuación de Bellman en horizonte finito

> **Cómo usar estas notas.** La clase se da en el pizarrón y cubre el núcleo
> de estas notas, no todas. El **plan de clase** de abajo dice qué secciones
> se escriben en el pizarrón, cuándo se proyecta el cuaderno
> (`Code/s15_bellman.jl`) y qué queda para leer. En el pizarrón van las
> ecuaciones y los resultados en recuadro; el texto que las rodea es lo que
> se explica de palabra. Como todo está aquí, en clase no hace falta copiar.
> El cuerpo de las notas es la **ruta básica** y se evalúa; las
> demostraciones y los temas opcionales están al final, en **Para
> profundizar**, y no se ven en clase.
>
> Las secciones marcadas con ★ son el **núcleo** que se ve en clase; las
> demás se leen por cuenta propia y se evalúan igual.
>
> Repaso recomendado: [C.B3](repaso/calculo.md#cb3) (logaritmo),
> [A.B3](repaso/analisis.md#ab3) (series y descuento),
> [A.I1–I3](repaso/analisis.md#ai1) (máximo, compactos y teorema de
> Weierstrass) y [N.I5](repaso/metodos_numericos.md#ni5) (maximizar en una
> variable); para Para profundizar, [L.A4](repaso/algebra_lineal.md#la4)
> (matrices estocásticas y cadenas de Markov).
>
> Lecturas: Sargent y Stachurski, Vol. I, sec. 1.1; QuantEcon, *Cake
> Eating I*.

**Plan de clase** (120 minutos: 105 de núcleo y 15 de margen). El núcleo: la
ecuación de Bellman y la inducción hacia atrás, en la torta y en el
crecimiento de una región.

| Minutos | Dónde | Qué | Secciones |
|---|---|---|---|
| 0–15 | Pizarra | La pregunta: decidir cada año; trayectorias y reglas; el problema en tiempo discreto (sesión 1) | 0, 1 |
| 15–35 | Pizarra | La función valor, la ecuación de Bellman y la política; el principio de optimalidad | 2 |
| 35–55 | Pizarra | Inducción hacia atrás: la torta en tres periodos | 3 |
| 55–60 | | Pausa | |
| 60–85 | Pizarra | Crecimiento óptimo de una región: la función valor y la política por periodos restantes | 4 |
| 85–100 | Parejas | Ejercicio F1 a mano | 8 |
| 100–105 | Pizarra | Cierre: lo que cuesta, la maldición de la dimensionalidad, de palabra; horizonte infinito (sesión 16) | 5, 6 |
| 105–120 | Margen | Si alcanza, en este orden: las políticas según los periodos que faltan y una trayectoria completa (cuaderno, sección 2); la inducción hacia atrás en una malla, contra la fórmula (cuaderno, sección 1) | |
| Después | Lectura | Lo que no entró del margen; mallas y dimensiones en detalle (5), el resumen (7), la sección [Avanzado] del cuaderno y Para profundizar (el principio de optimalidad y la búsqueda de empleo de la lectura) | |

Lo del **margen** se ve sólo si sobra tiempo, en el orden indicado; lo
que no se vea pasa a la lectura y se evalúa igual.

**Pregunta de la unidad.** ¿Cómo debe crecer una región que decide cada año
cuánto invertir?

---

## 0. La pregunta

En la Unidad III, la solución de un problema dinámico era una
**trayectoria**: el gasto $c(t)$ o el reparto $\theta(t)$ para cada instante,
calculados desde el principio. En la sesión 1 (sección 2.4) se distinguió
otra forma de dar la solución: una **regla**, que dice qué hacer en cada
estado. Si el gobierno de una región decide cada año cuánto invertir, lo
natural es una regla: "con este capital, invierte tanto".

La **programación dinámica** encuentra esa regla. Su idea central, el
principio de optimalidad de Bellman, ya apareció en la sesión 14: Rahman
(1963) resolvió el problema de las dos regiones así. Esta unidad la usa en
tiempo discreto, donde se vuelve un método de cálculo directo.

---

## 1. El problema en tiempo discreto ★

Es la formulación de la sesión 1 (sección 2.1). Dados un estado inicial
$x_0$ y un horizonte $T$, se eligen controles $u_0, \dots, u_{T-1}$ para

$$
\max\ \sum_{t=0}^{T-1}\beta^t\thinspace r(x_t, u_t) + \beta^T S(x_T)
\qquad\text{sujeto a}\qquad
x_{t+1} = g(x_t, u_t), \quad u_t \in \Gamma(x_t).
$$

$x_t$ es el **estado**, $u_t$ el **control**, $g$ la **ecuación de
movimiento**, $r$ la **recompensa** de cada periodo, $S$ el **valor
terminal** y $\Gamma(x)$ los controles permitidos con el estado $x$.

**Dos ejemplos de esta sesión.**

| | La torta (un fondo que se gasta) | Crecimiento de una región |
|---|---|---|
| Estado | Lo que queda del fondo, $x_t$ | Capital, $k_t$ |
| Control | Gasto, $c_t \in [0, x_t]$ | Consumo, $c_t \in [0, Ak_t^\alpha]$ |
| Movimiento | $x_{t+1} = x_t - c_t$ | $k_{t+1} = Ak_t^\alpha - c_t$ |
| Recompensa | $\ln c_t$ | $\ln c_t$ |
| Valor terminal | $S = 0$ | $S = 0$ |

La torta es el fondo regional de la sesión 10 sin rendimientos, en tiempo
discreto. En el crecimiento, el capital se deprecia por completo en un
periodo: lo que no se consume del producto es el capital del periodo
siguiente. Con esos supuestos, los dos problemas tienen solución cerrada.

---

## 2. La función valor y la ecuación de Bellman ★

### 2.1 La función valor ★

Sea $V_t(x)$ el **mejor valor que se puede obtener desde el periodo $t$ con
el estado $x$**, si de ahí en adelante se decide de forma óptima:

$$
V_t(x) = \max_{u_t, \dots, u_{T-1}}\ \sum_{s=t}^{T-1}\beta^{s-t}\thinspace r(x_s, u_s) + \beta^{T-t}S(x_T),
\qquad x_t = x.
$$

En el último periodo no queda nada por decidir: $V_T(x) = S(x)$.

### 2.2 La ecuación de Bellman ★

**Proposición (principio de optimalidad).** Para $t = 0, \dots, T - 1$,

$$
\boxed{\ V_t(x) = \max_{u \in \Gamma(x)}\Big\lbrace r(x, u) + \beta\thinspace V_{t+1}\big(g(x, u)\big)\Big\rbrace\ }
$$

**La lectura.** Elegir hoy es comparar lo que se obtiene hoy, $r(x, u)$, con
lo que se podrá obtener mañana desde el estado que deja la decisión,
$V_{t+1}(g(x, u))$, descontado con $\beta$. No hace falta pensar en todas
las decisiones futuras a la vez: $V_{t+1}$ ya las resume. Un problema de $T$
periodos se vuelve una sucesión de problemas de **un** periodo. La
justificación está en [Para profundizar, P.1](#pp1).

### 2.3 La política ★

El control que alcanza el máximo es la **política** del periodo $t$:

$$
\sigma_t(x) \in \arg\max_{u \in \Gamma(x)}\Big\lbrace r(x, u) + \beta\thinspace V_{t+1}\big(g(x, u)\big)\Big\rbrace.
$$

Es una regla: dice qué hacer con **cualquier** estado, no sólo con el que
se espera. Si algo inesperado cambia el estado, la regla sigue sirviendo. En
horizonte finito la regla depende de cuántos periodos faltan, porque el
futuro que resume $V_{t+1}$ es más corto cuanto más cerca está el final.

**Cuándo existe el máximo.** Si $\Gamma(x)$ es compacto y la expresión entre
llaves es continua en $u$, el máximo existe por el teorema de Weierstrass
([A.I3](repaso/analisis.md#ai3)).

---

## 3. Inducción hacia atrás ★

### 3.1 El procedimiento ★

La ecuación de Bellman se resuelve **desde el final**:

1. $V_T = S$.
2. Con $V_T$, la ecuación de Bellman da $V_{T-1}$ y la política
   $\sigma_{T-1}$.
3. Con $V_{T-1}$, da $V_{T-2}$ y $\sigma_{T-2}$; y así hasta $V_0$ y $\sigma_0$.
4. Con las políticas, se simula la trayectoria hacia adelante desde $x_0$:
   $u_t = \sigma_t(x_t)$ y $x_{t+1} = g(x_t, u_t)$.

Es el mismo orden que en la sesión 13 ("empezar por el final"), pero aquí
lo que se arrastra hacia atrás no es un coestado sino una función entera.

### 3.2 La torta en tres periodos ★

Un fondo $x_0$ se gasta en los periodos 0, 1 y 2, con $r = \ln c$ y $S = 0$.
Se cuentan los **periodos que faltan**, $n$: en el periodo 2 falta uno.

**Último periodo** ($n = 1$). Lo que no se gasta no vale nada, así que se
gasta todo: $c = x$ y

$$
V_2(x) = \ln x.
$$

**Penúltimo** ($n = 2$). La ecuación de Bellman es

$$
V_1(x) = \max_{0 \le c \le x}\ \big\lbrace\ln c + \beta\ln(x - c)\big\rbrace.
$$

La condición de primer orden es

$$
\frac{1}{c} = \frac{\beta}{x - c}
\iff x - c = \beta c
\iff c = \frac{x}{1 + \beta},
\qquad x - c = \frac{\beta x}{1 + \beta},
$$

y sustituyendo,

$$
V_1(x) = \ln\frac{x}{1 + \beta} + \beta\ln\frac{\beta x}{1 + \beta}
= (1 + \beta)\ln x + a_1,
$$

donde $a_1 = \beta\ln\beta - (1 + \beta)\ln(1 + \beta)$ es una constante que
no afecta las decisiones.

**Primer periodo** ($n = 3$). Ahora el futuro vale $\beta V_1$:

$$
\begin{aligned}
V_0(x) &= \max_{0 \le c \le x}\ \big\lbrace\ln c + \beta(1 + \beta)\ln(x - c) + \beta a_1\big\rbrace, \cr
\frac{1}{c} &= \frac{\beta(1 + \beta)}{x - c}
\iff c = \frac{x}{1 + \beta + \beta^2}.
\end{aligned}
$$

**El patrón.** Con $n$ periodos por delante, se gasta la fracción

$$
\boxed{\ \sigma_n(x) = \frac{x}{1 + \beta + \cdots + \beta^{n-1}} = \frac{1 - \beta}{1 - \beta^n}\thinspace x\ }
$$

del fondo ([A.B3](repaso/analisis.md#ab3)), y $V$ es $(1 + \beta + \cdots + \beta^{n-1})\ln x$
más una constante.

**Ejemplo numérico.** Con $x_0 = 100$ y $\beta = 0.9$:

| Periodo | Periodos que faltan | Fondo al inicio | Gasto |
|---|---|---|---|
| 0 | 3 | 100.00 | $100/(1 + 0.9 + 0.81) = 36.90$ |
| 1 | 2 | 63.10 | $63.10/1.9 = 33.21$ |
| 2 | 1 | 29.89 | $29.89$ |

El gasto cae 10% cada periodo: $c_{t+1} = \beta c_t$. Es la ecuación de
Euler de la sesión 1 con $R = 1$, $u'(c_t) = \beta\thinspace u'(c_{t+1})$, que
la sesión 18 deriva en general a partir de la ecuación de Bellman.

---

## 4. Crecimiento óptimo de una región ★

### 4.1 El problema ★

Una región con capital $k_t$ produce $Ak_t^\alpha$, consume $c_t$ e invierte
el resto, que es su capital del periodo siguiente:

$$
\max\ \sum_{t=0}^{T-1}\beta^t\ln c_t
\qquad\text{sujeto a}\qquad
k_{t+1} = Ak_t^\alpha - c_t, \quad 0 \le c_t \le Ak_t^\alpha.
$$

Es la versión discreta, con horizonte finito, del modelo de la sesión 12.

### 4.2 Inducción hacia atrás ★

Se propone que, con $n$ periodos por delante, $V_n(k) = a_n + b_n\ln k$, y
se comprueba que la ecuación de Bellman mantiene esa forma. Sea
$y = Ak^\alpha$ el producto.

**Último periodo** ($n = 1$): se consume todo, $c = y$, y
$V_1(k) = \ln(Ak^\alpha) = \ln A + \alpha\ln k$. Entonces $b_1 = \alpha$.

**Un periodo antes**, con el futuro $V_{n-1}(k') = a_{n-1} + b_{n-1}\ln k'$ y
$k' = y - c$:

$$
\begin{aligned}
V_n(k) &= \max_{0 \le c \le y}\ \big\lbrace\ln c + \beta a_{n-1} + \beta b_{n-1}\ln(y - c)\big\rbrace, \cr
\frac{1}{c} &= \frac{\beta b_{n-1}}{y - c}
\iff c = \frac{y}{1 + \beta b_{n-1}},
\qquad y - c = \frac{\beta b_{n-1}\thinspace y}{1 + \beta b_{n-1}}.
\end{aligned}
$$

Al sustituir, $\ln y = \ln A + \alpha\ln k$ aparece con coeficiente
$1 + \beta b_{n-1}$ en los dos términos, así que

$$
b_n = \alpha\big(1 + \beta b_{n-1}\big).
$$

Con $b_1 = \alpha$, la recursión da $b_2 = \alpha(1 + \alpha\beta)$,
$b_3 = \alpha(1 + \alpha\beta + (\alpha\beta)^2)$ y, en general,

$$
b_n = \alpha\thinspace\frac{1 - (\alpha\beta)^n}{1 - \alpha\beta},
\qquad
1 + \beta b_{n-1} = \frac{1 - (\alpha\beta)^n}{1 - \alpha\beta}.
$$

La política es

$$
\boxed{\ c = \frac{1 - \alpha\beta}{1 - (\alpha\beta)^n}\thinspace Ak^\alpha,
\qquad
k' = \alpha\beta\thinspace\frac{1 - (\alpha\beta)^{n-1}}{1 - (\alpha\beta)^n}\thinspace Ak^\alpha\ }
$$

### 4.3 Lectura ★

- **La región consume una fracción del producto, y la fracción depende del
  tiempo que falta.** Con mucho futuro por delante ($n$ grande), la
  fracción consumida se acerca a $1 - \alpha\beta$; cerca del final sube,
  hasta consumirlo todo en el último periodo.
- Con $\alpha = 0.3$ y $\beta = 0.95$, $\alpha\beta = 0.285$: con 10 periodos
  por delante se consume el 71.5% del producto, con 2 periodos el 77.8% y
  en el último el 100%. Invertir deja de convenir al final porque el
  capital ya no alcanza a producir nada que valga.
- Es la Proposición 2 de la sesión 1 (una tasa constante no es óptima con
  horizonte finito), ahora con la regla óptima completa.
- La regla depende del **estado** ($k$) y de **cuánto falta** ($n$), no de
  la historia: dos regiones con el mismo capital y el mismo horizonte
  invierten lo mismo, sin importar cómo llegaron ahí.

---

## 5. Lo que cuesta: mallas y dimensiones

Casi ningún problema tiene solución cerrada. En la práctica, $V_t$ se
calcula en una **malla** de estados $x_1 < \cdots < x_N$
([N.I4](repaso/metodos_numericos.md#ni4)), y en cada punto se busca el
máximo de la ecuación de Bellman ([N.I5](repaso/metodos_numericos.md#ni5)):

$$
V_t(x_i) = \max_{u \in \Gamma(x_i)}\Big\lbrace r(x_i, u) + \beta\thinspace V_{t+1}\big(g(x_i, u)\big)\Big\rbrace,
\qquad i = 1, \dots, N,
$$

con $V_{t+1}$ interpolada entre los puntos de la malla o, más simple, con el
estado siguiente elegido también en la malla. El cuaderno usa la versión
simple con la torta y con el crecimiento, y compara con las fórmulas.

**El costo.** Con $N$ puntos de estado y $M$ controles posibles, cada
periodo cuesta unas $N \times M$ evaluaciones, y hay $T$ periodos. Con un
estado está bien. Con dos regiones, el estado es $(K_1, K_2)$ y la malla tiene
$N^2$ puntos; con $d$ estados, $N^d$. Es la **maldición de la
dimensionalidad**: el método es general, pero su costo crece muy rápido con
el número de estados. Por eso el caso de dos regiones de la sesión 14 se
resolvió con el principio del máximo, que maneja varios estados sin mallas.

---

## 6. Hacia la optimización dinámica

| Idea de esta sesión | Dónde reaparece |
|---|---|
| Ecuación de Bellman en horizonte finito | Horizonte infinito: una sola función valor, punto fijo del operador de Bellman (sesión 16) |
| La política se acerca a una regla fija cuando falta mucho | La política estacionaria del horizonte infinito (sesión 16) |
| Inducción hacia atrás en una malla | Iteración de la función valor (Laboratorio 2) |
| $c_{t+1} = \beta c_t$ en la torta | La ecuación de Euler en tiempo discreto y su relación con el principio del máximo (sesión 18) |
| Maldición de la dimensionalidad | Por qué el caso de dos regiones se resolvió con control óptimo (sesión 14) |

---

## 7. Resumen formal

| Concepto | Enunciado | Dónde |
|---|---|---|
| Función valor | $V_t(x)$: el mejor valor desde $t$ con estado $x$; $V_T = S$ | 2.1 |
| Ecuación de Bellman | $V_t(x) = \max_u\lbrace r(x, u) + \beta V_{t+1}(g(x, u))\rbrace$ | 2.2 |
| Política | $\sigma_t(x)$: el control que alcanza el máximo; depende de cuánto falta | 2.3 |
| Inducción hacia atrás | De $V_T$ a $V_0$; después se simula hacia adelante | 3.1 |
| Torta con $\ln c$ | Se gasta la fracción $(1 - \beta)/(1 - \beta^n)$ del fondo | 3.2 |
| Crecimiento con $\ln c$ | Se consume la fracción $(1 - \alpha\beta)/(1 - (\alpha\beta)^n)$ del producto | 4.2 |
| Costo | $N^d$ puntos de malla con $d$ estados | 5 |

---

## 8. Ejercicios formales

- **F1.** Resuelve la torta en dos periodos con $r = \sqrt c$ y $S = 0$.
  ¿Qué fracción del fondo se gasta en el primer periodo con $\beta = 0.9$?
  Compárala con la de la utilidad logarítmica.
- **F2.** El fondo rinde: $x_{t+1} = R(x_t - c_t)$, con $r = \ln c$, dos
  periodos y $S = 0$. Encuentra la política del primer periodo y muestra
  que $c_1 = \beta R\thinspace c_0$. ¿Depende el gasto de hoy de $R$? Compara
  con el problema de dos periodos de la sesión 1.
- **F3.** En el crecimiento de la sección 4, calcula $b_3$ y la política con
  tres periodos por delante, con $\alpha = 0.3$ y $\beta = 0.95$.
  Verifica la fórmula general.
- **F4.** Con la política de la sección 4, ¿qué tasa de inversión,
  $k'/(Ak^\alpha)$, tiene una región con 10 periodos por delante? ¿Y con
  uno? ¿Cómo se compara con la mejor tasa constante del cuaderno de la
  sesión 1?

**Para profundizar** (opcionales)

- **F5.** Demuestra por inducción que la torta con $n$ periodos y
  $r = \ln c$ gasta la fracción $(1 - \beta)/(1 - \beta^n)$ ([P.1](#pp1)).
- **F6.** En la búsqueda de empleo de [P.2](#pp2), con dos periodos,
  $c = 10$, $\beta = 0.96$ y ofertas de 10, 30 y 50 con la misma
  probabilidad, calcula el salario de reserva del primer periodo.
- **F7.** Muestra que, cuando $n \to \infty$, la política de la sección 4
  converge a $c = (1 - \alpha\beta)Ak^\alpha$. ¿A qué capital converge la
  región si sigue esa regla para siempre?

## Para profundizar

Material opcional: demostraciones y temas que no se ven en clase. Cada
apartado indica de qué sección de las notas viene.

<a id="pp1"></a>

### P.1 El principio de optimalidad (sección 2.2)

Sea $W_t(x)$ el valor máximo del problema que empieza en $t$ con estado $x$,
definido como en la sección 2.1 (un máximo sobre toda la sucesión de
controles). Hay que mostrar que $W_t$ cumple la ecuación de Bellman.

*Desigualdad* $\le$. Sea $(u_t, u_{t+1}, \dots)$ óptima desde $(t, x)$ y
$x' = g(x, u_t)$. La cola $(u_{t+1}, \dots)$ es una sucesión factible desde
$(t + 1, x')$, así que su valor es a lo más $W_{t+1}(x')$. Entonces
$W_t(x) \le r(x, u_t) + \beta W_{t+1}(x') \le \max_u\lbrace r(x, u) + \beta W_{t+1}(g(x, u))\rbrace$.

*Desigualdad* $\ge$. Para cualquier $u \in \Gamma(x)$, se elige $u$ hoy y,
desde $(t + 1, g(x, u))$, una sucesión óptima. Es una sucesión factible desde
$(t, x)$ con valor $r(x, u) + \beta W_{t+1}(g(x, u))$, así que $W_t(x)$ es al
menos eso para todo $u$, y en particular al menos el máximo. $\square$

Bellman (1957) lo enunció así: "una política óptima tiene la propiedad de
que, cualesquiera que sean el estado y las decisiones iniciales, las
decisiones restantes deben constituir una política óptima respecto del
estado que resulta de las primeras". Es la cita con la que Alexiadis (2018,
sec. 2.1) explica el método de Rahman (1963) para el caso de la sesión 14.

<a id="pp2"></a>

### P.2 La lectura: buscar empleo en una región (sección 2)

Sargent y Stachurski (sec. 1.1) introducen la ecuación de Bellman con el
modelo de búsqueda de empleo de McCall (1970). Una persona desempleada en
una región recibe cada periodo una oferta de salario $W_t$, con
probabilidades conocidas $\varphi(w)$ e independientes en el tiempo. Puede
aceptar y trabajar con ese salario hasta el final, o rechazar, cobrar un
seguro de desempleo $c$ y esperar la oferta siguiente.

Con dos periodos ($t = 1, 2$): en el último, se acepta si $w \ge c$, así que
$v_2(w) = \max\lbrace c, w\rbrace$. En el primero,

$$
v_1(w) = \max\Big\lbrace\underbrace{w + \beta w}_{\text{aceptar}},\ \underbrace{c + \beta\sum_{w'}v_2(w')\thinspace\varphi(w')}_{\text{rechazar y esperar}}\Big\rbrace.
$$

Es una ecuación de Bellman con **incertidumbre**: el estado de mañana (la
oferta) no se conoce hoy, y el futuro entra como un **valor esperado**. La
política es un **salario de reserva**, $w_1^\ast = h_1/(1 + \beta)$, donde
$h_1$ es el valor de esperar: se acepta cualquier oferta mayor. Un seguro de
desempleo más alto sube $h_1$ y el salario de reserva.

La incertidumbre se trata en la sesión 19 con otro problema regional, la
decisión de migrar, donde los salarios siguen una cadena de Markov
([L.A4](repaso/algebra_lineal.md#la4)).

---

## Referencias

- Bellman, R. (1957). *Dynamic Programming*. Princeton University Press.
- McCall, J. J. (1970). Economics of information and job search. *Quarterly
  Journal of Economics*, 84(1), 113–126.
- QuantEcon. *Cake Eating I: Introduction to Optimal Saving*.
  https://quantecon.org
- Sargent, T. J., & Stachurski, J. *Dynamic Programming, Vol. I: Finite
  States*. Versión en línea de agosto de 2026, https://dp.quantecon.org.
