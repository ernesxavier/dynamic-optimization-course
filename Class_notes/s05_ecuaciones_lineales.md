# Sesión 5: Ecuaciones diferenciales lineales de primer orden. Notas formales

> **Cómo leer estas notas.** Siguen el orden del programa: primero se explora
> en el cuaderno (`Code/s05_ecuaciones_lineales.jl`), después se formaliza
> aquí. El cuerpo de las notas es la **ruta básica**: se ve en clase y se
> evalúa. Las demostraciones y los temas opcionales están al final, en
> **Para profundizar**; donde estaban queda una línea que los enlaza.
>
> Repaso recomendado: [C.B3](repaso/calculo.md#cb3) (exponencial y
> logaritmo), [D.B1–B4](repaso/ecuaciones_diferenciales.md#db1) (ecuaciones
> diferenciales, crecimiento exponencial, método de Euler y variables
> separables), [D.I1](repaso/ecuaciones_diferenciales.md#di1) (lineales de
> primer orden), [E.B2–B3](repaso/estadistica.md#eb2) (tasas de crecimiento
> y mínimos cuadrados), [E.I2](repaso/estadistica.md#ei2) (error estándar) y
> [N.I7](repaso/metodos_numericos.md#ni7) (datos en Julia); para Para
> profundizar, [D.I2](repaso/ecuaciones_diferenciales.md#di2) y
> [E.A1](repaso/estadistica.md#ea1).
>
> Lecturas: Chiang y Wainwright (2006), cap. 15; Barro y Sala-i-Martin
> (1992).

**Pregunta de la unidad.** ¿Convergen los estados de México? ¿A qué
velocidad?

---

## 0. La pregunta

Entre 2003 y 2023, la razón entre el PIB per cápita sin petróleo de la
Ciudad de México y el de Chiapas pasó de 4.6 a 6.5 (sesión 1). ¿Es un caso
aislado, o las entidades pobres no alcanzan a las ricas? Y si se acercan, ¿a
qué velocidad?

Para responder hace falta un modelo de cómo se cierra una brecha. El más
simple dice que la brecha se cierra a una tasa constante $\beta$:

$$
\dot z = -\beta z,
\qquad z = \ln y - \ln y^\ast,
$$

donde $y$ es el ingreso per cápita de una región y $y^\ast$ el de su estado
estacionario. Es una **ecuación diferencial lineal de primer orden**. Esta
sesión la resuelve, define cuándo converge y mide $\beta$ con los datos de
las 32 entidades.

La unidad completa es cualitativa: interesa qué hacen las trayectorias
(convergen o no, a qué velocidad, si oscilan) más que las técnicas de
solución. Las ecuaciones de esta sesión reaparecen en la regla de
Keynes-Ramsey (sesión 12) y en la ecuación del coestado (sesión 11).

---

## 1. La ecuación $\dot y = ay$

**Proposición.** Para cada $y_0$, la única solución de $\dot y = ay$ con
$y(0) = y_0$ es

$$
y(t) = y_0e^{at}.
$$

*Demostración.* Que es solución se comprueba derivando. Para la unicidad,
sea $y$ cualquier solución y $w(t) = e^{-at}y(t)$. Entonces
$\dot w = e^{-at}(\dot y - ay) = 0$, así que $w$ es constante e igual a
$w(0) = y_0$. $\square$

Según el signo de $a$ ([D.B2](repaso/ecuaciones_diferenciales.md#db2)):

| | $a < 0$ | $a = 0$ | $a > 0$ |
|---|---|---|---|
| Trayectoria | Decae hacia 0 | Constante | Crece sin límite |
| Tiempo característico | Vida media $\ln 2/\lvert a\rvert$ | — | Duplicación $\ln 2/a$ |

La tasa $a$ es la **tasa de crecimiento** de $y$: $\dot y/y = a$
([C.B3](repaso/calculo.md#cb3)). Al 2% anual, algo se duplica en unos 35
años; si decae al 2%, la mitad desaparece en el mismo tiempo.

---

## 2. Lineales de primer orden con coeficientes constantes

### 2.1 Equilibrio

Considera

$$
\dot y + ay = b,
\qquad a \ne 0.
$$

Un **equilibrio** (o estado estacionario) es un valor $y^\ast$ en el que
$y$ deja de moverse: $\dot y = 0$. Aquí,

$$
y^\ast = \frac{b}{a}.
$$

### 2.2 Solución

**Proposición.** La solución con $y(0) = y_0$ es

$$
y(t) = y^\ast + (y_0 - y^\ast)\thinspace e^{-at}.
$$

*Demostración.* La **desviación** $z = y - y^\ast$ cumple
$\dot z = \dot y = b - ay = b - a(z + y^\ast) = -az$, una ecuación como la
de la sección 1. Entonces $z(t) = z_0e^{-at}$. $\square$

**Solución = equilibrio + desviación inicial que decae o crece.** Es la
receta de toda la unidad: primero se encuentra el equilibrio, después se
estudia qué pasa con las desviaciones. En la sesión 7 se aplica a sistemas
de dos ecuaciones.

Si $a = 0$, no hay equilibrio y $y(t) = y_0 + bt$ crece linealmente. Si los
coeficientes dependen del tiempo, la solución usa un factor integrante: ver
[Para profundizar, P.1](#pp1).

### 2.3 Estabilidad y velocidad

**Definición.** El equilibrio $y^\ast$ es **asintóticamente estable** si
$y(t) \to y^\ast$ para toda condición inicial.

**Proposición.** El equilibrio de $\dot y + ay = b$ es asintóticamente
estable si y sólo si $a > 0$.

Es inmediato de la sección 2.2: $e^{-at} \to 0$ si y sólo si $a > 0$. Si
$a < 0$, toda trayectoria que no empieza en $y^\ast$ se aleja de él.

Cuando el equilibrio es estable, $a$ mide la **velocidad de convergencia**:

| Medida | Fórmula |
|---|---|
| Fracción de la brecha que queda en $t$ | $e^{-at}$ |
| Fracción que se cierra en $t$ | $1 - e^{-at}$ |
| Vida media de la brecha | $\ln 2/a$ |
| Tiempo para cerrar el 90% | $\ln 10/a$ |

La velocidad no depende del tamaño de la brecha: en cada instante se cierra
la misma **fracción**. Una brecha el doble de grande se cierra el doble de
rápido en valor absoluto, pero tarda lo mismo en reducirse a la mitad.

### 2.4 Ejemplo: el capital de una región

Una región recibe un flujo constante de inversión $I$ por año, y su capital
se deprecia a la tasa $\kappa$:

$$
\dot K = I - \kappa K,
\qquad\text{es decir}\qquad
\dot K + \kappa K = I.
$$

Con $a = \kappa > 0$ y $b = I$, el capital converge a $K^\ast = I/\kappa$:

$$
K(t) = \frac{I}{\kappa} + \left(K_0 - \frac{I}{\kappa}\right)e^{-\kappa t}.
$$

La velocidad es la tasa de depreciación: con $\kappa = 0.05$, la mitad de la
brecha entre $K_0$ y $K^\ast$ se cierra en $\ln 2/0.05 \approx 14$ años.
Duplicar la inversión duplica $K^\ast$, pero **no** acelera la convergencia.

### 2.5 Simular

Cuando no hay fórmula, la trayectoria se aproxima con el **método de Euler**
([D.B3](repaso/ecuaciones_diferenciales.md#db3)): con pasos $\Delta t$,
$y_{k+1} = y_k + (b - ay_k)\Delta t$. El cuaderno compara la aproximación
con la solución exacta. Iterar una regla así es también una **ecuación en
diferencias**, el tema de la sesión 6.

---

## 3. Convergencia β

### 3.1 Del modelo a la regresión

Supón que el ingreso de estado estacionario crece a una tasa $x$ común a
todas las regiones, $\ln y^\ast(t) = \ln y_0^\ast + xt$, y que la brecha
$z_i = \ln y_i - \ln y^\ast$ de cada región $i$ cumple $\dot z_i = -\beta z_i$.
Entonces $z_i(T) = e^{-\beta T}z_i(0)$, y el **crecimiento promedio** de la
región entre $0$ y $T$ es

$$
g_i = \frac{1}{T}\ln\frac{y_i(T)}{y_i(0)}
= x + \frac{z_i(T) - z_i(0)}{T}
= \underbrace{x + \frac{1 - e^{-\beta T}}{T}\ln y_0^\ast}_{a}\
\underbrace{-\ \frac{1 - e^{-\beta T}}{T}}_{b}\ \ln y_i(0).
$$

Es una recta en $\ln y_i(0)$. Con datos de muchas regiones se estima por
mínimos cuadrados ([E.B3](repaso/estadistica.md#eb3)):

$$
g_i = a + b\ln y_i(0) + e_i.
$$

**Convergencia β**: $b < 0$, las regiones que empezaron más pobres crecen
más rápido.

### 3.2 De la pendiente a la velocidad

La pendiente **no** es $-\beta$. Despejando de $b = -(1 - e^{-\beta T})/T$:

$$
\beta = -\frac{\ln(1 + bT)}{T},
\qquad
\text{vida media} = \frac{\ln 2}{\beta}.
$$

Con $T$ corto, $\beta \approx -b$; con $T$ largo, la diferencia importa,
porque buena parte de la brecha ya se cerró y el crecimiento promedio la
subestima.

Barro y Sala-i-Martin (1992) estimaron $\beta \approx 0.02$ para los estados
de Estados Unidos entre 1880 y 1988: la mitad de una brecha tarda unos 35
años en cerrarse. Es la "regla del 2%" de la literatura de convergencia.

### 3.3 Convergencia absoluta y condicional

La regresión supone que todas las regiones van al **mismo** $y^\ast$.
Entonces se habla de **convergencia absoluta**. Si cada región tiene su
propio $y_i^\ast$ (por su capital humano, su infraestructura o su
geografía), cada una converge a su estado estacionario, pero las brechas
entre ellas no tienen por qué cerrarse: **convergencia condicional**. Para
medirla se agregan a la regresión variables que aproximen $y_i^\ast$.

Sin convergencia absoluta puede haber convergencia condicional. La
diferencia importa para la política: si las regiones pobres convergen a un
$y_i^\ast$ bajo, esperar no cierra la brecha; hay que cambiar $y_i^\ast$.

### 3.4 Convergencia σ

La **convergencia σ** es que la dispersión del ingreso entre regiones, la
desviación estándar de $\ln y_i$, disminuya con el tiempo. La convergencia β
es necesaria pero no suficiente: con choques nuevos cada año, puede haber
$b < 0$ sin que la dispersión baje. Ver [Para profundizar, P.2](#pp2).

---

## 4. Los estados de México, 2003–2023

Con el PIB per cápita de las 32 entidades (INEGI y OCDE,
`Data/entidades.csv`, en pesos de 2018) y $T = 20$:

| | Sin petróleo | Con petróleo |
|---|---:|---:|
| Pendiente $\hat b$ | $-0.0008$ | $-0.0121$ |
| Error estándar | $0.0029$ | $0.0031$ |
| $R^2$ | $0.002$ | $0.34$ |
| $\beta$ implícita | $0.0008$ | $0.0138$ |
| Vida media | unos 900 años | 50 años |
| Dispersión σ en 2003 y 2023 | $0.381 \to 0.395$ | $0.536 \to 0.444$ |

**Sin petróleo no hay convergencia.** La pendiente es prácticamente cero y su
intervalo de confianza del 95%, aproximadamente $(-0.0066,\ 0.0051)$
([E.I2](repaso/estadistica.md#ei2)), incluye pendientes positivas y
negativas. La dispersión no bajó: subió hasta 0.413 en 2019 y en 2023 era
mayor que en 2003. Las subdivisiones 2003–2013 y 2013–2023 dan lo mismo.

**Con petróleo, la convergencia es un espejismo.** En 2003 Campeche tenía el
mayor PIB per cápita del país, 1.33 millones de pesos por persona, casi
todo por la extracción de petróleo (87% de su PIB). En 2023 eran 536 mil.
Una entidad que empezó "rica" y cayó por el agotamiento de sus yacimientos
produce una pendiente negativa y una dispersión decreciente, pero no dice
nada sobre si las entidades pobres alcanzan a las ricas. Por eso la
convergencia regional se mide sin la minería petrolera.

**Lectura.**
- En dos décadas, las brechas entre las entidades de México no se cerraron
  solas. Con $\beta \approx 0$, el modelo $\dot z = -\beta z$ dice que la
  brecha de cada entidad se mantiene.
- Esto es convergencia **absoluta**. Puede haber convergencia condicional
  hacia estados estacionarios distintos, lo que significaría que las brechas
  son permanentes salvo que cambie $y_i^\ast$.
- Veinte años es poco, e incluyen dos recesiones (2009 y 2020). Los
  resultados describen el periodo, no una ley.
- Es el punto de partida del curso: si las brechas no se cierran solas, ¿cómo
  debe invertir un gobierno entre regiones? (sesiones 2 y 14).

---

## 5. Hacia la optimización dinámica

| Idea de esta sesión | Dónde reaparece |
|---|---|
| Solución = equilibrio + desviación | Linealización alrededor de un equilibrio (sesiones 7 y 8) |
| Estable si $a > 0$; la velocidad es $a$ | La velocidad de convergencia del modelo de Ramsey es el eigenvalor estable del punto de silla (sesión 12) |
| $\dot y + ay = b$ con condición inicial | La ecuación del coestado, $\dot\lambda = -\partial H/\partial y$, suele ser lineal en $\lambda$ y se resuelve hacia atrás desde una condición terminal (sesión 11, [P.1](#pp1)) |
| Crecimiento promedio $\frac1T\ln(y_T/y_0)$ | Calibración de Ramsey y del caso de dos regiones (sesiones 12 y 14) |

---

## 6. Resumen formal

| Concepto | Enunciado | Dónde |
|---|---|---|
| Exponencial | $\dot y = ay \Rightarrow y = y_0e^{at}$, única | 1 |
| Equilibrio | $\dot y + ay = b \Rightarrow y^\ast = b/a$ | 2.1 |
| Solución | $y(t) = y^\ast + (y_0 - y^\ast)e^{-at}$ | 2.2 |
| Estabilidad | Asintóticamente estable $\iff a > 0$ | 2.3 |
| Velocidad | Vida media $\ln 2/a$; independiente del tamaño de la brecha | 2.3 |
| Convergencia β | $g_i = a + b\ln y_i(0)$ con $b < 0$; $\beta = -\ln(1 + bT)/T$ | 3.1, 3.2 |
| Absoluta y condicional | Mismo $y^\ast$ para todas las regiones, o uno propio | 3.3 |
| Convergencia σ | La dispersión de $\ln y_i$ baja; β es necesaria pero no suficiente | 3.4, P.2 |
| México 2003–2023 | Sin petróleo, $\hat b \approx 0$ y σ no baja: no hay convergencia absoluta | 4 |

---

## 7. Ejercicios formales

- **F1.** Resuelve $\dot y + 0.5y = 2$ con $y(0) = 1$. ¿Cuál es el
  equilibrio? ¿Es estable? ¿Cuánto vale $y(2)$ y cuál es la vida media de la
  brecha?
- **F2.** Una región invierte $I = 10$ por año en infraestructura, que se
  deprecia al 5% anual, y hoy tiene $K_0 = 100$. Encuentra $K^\ast$ y el
  tiempo en que se cierra el 90% de la brecha. ¿Qué cambia si $I = 20$? ¿Y
  si $\kappa = 0.10$?
- **F3.** Con $\hat b = -0.012$ y $T = 20$, calcula $\beta$ y la vida media.
  ¿Qué vida media se obtendría leyendo $\hat b$ directamente como $-\beta$?
- **F4.** En 2023, el PIB per cápita sin petróleo de la Ciudad de México era
  6.5 veces el de Chiapas. Si las dos convergieran al mismo $y^\ast$ con
  $\beta = 0.02$, ¿en cuántos años la razón bajaría a 2? ¿Y con la $\beta$
  estimada sin petróleo?

**Para profundizar** (opcionales)

- **F5.** Resuelve $\dot y + ay = be^{gt}$ con el factor integrante de
  [P.1](#pp1), con $a > 0$ y $g \ne -a$. Muestra que, a largo plazo, $y$
  crece a la tasa $g$. ¿Qué representa en el modelo de convergencia?
- **F6.** Con [P.3](#pp3), calcula la velocidad de convergencia del modelo
  de Solow con $\alpha = 0.3$, $n = 0.01$ y $\kappa = 0.05$. ¿Es compatible
  con la regla del 2%? ¿Qué $\alpha$ haría falta?
- **F7.** Con el modelo de [P.2](#pp2), encuentra la varianza de los choques
  con la que la dispersión se mantiene constante aunque $\rho < 1$.

## Para profundizar

Material opcional: demostraciones y temas que no se ven en clase. Cada
apartado indica de qué sección de las notas viene.

<a id="pp1"></a>

### P.1 Coeficientes variables: el factor integrante (secciones 2.2 y 5)

Para $\dot y + a(t)y = b(t)$, sea $A(t) = \int_0^t a(s)\thinspace ds$. Como
$\frac{d}{dt}\big(e^{A(t)}y\big) = e^{A(t)}(\dot y + ay) = e^{A(t)}b(t)$,
integrando entre $0$ y $t$:

$$
y(t) = e^{-A(t)}\left[y_0 + \int_0^t e^{A(s)}b(s)\thinspace ds\right].
$$

Con $a$ y $b$ constantes se recupera la sección 2.2. Si la condición es
**terminal**, $y(T)$ dada, se integra entre $t$ y $T$:

$$
y(t) = e^{A(T) - A(t)}\thinspace y(T) - \int_t^T e^{A(s) - A(t)}\thinspace b(s)\thinspace ds.
$$

Es la forma en que se resuelve la ecuación del coestado en control óptimo
(sesión 11). Más ejemplos en [D.I2](repaso/ecuaciones_diferenciales.md#di2).

<a id="pp2"></a>

### P.2 Convergencia β sin convergencia σ (sección 3.4)

En tiempo discreto, supón que la brecha de cada región cumple

$$
z_{i,T} = \rho\thinspace z_{i,0} + \varepsilon_i,
\qquad 0 < \rho < 1,
$$

con choques $\varepsilon_i$ independientes de $z_{i,0}$, media cero y
varianza $\sigma_\varepsilon^2$. La regresión de $z_{i,T} - z_{i,0}$ sobre
$z_{i,0}$ tiene pendiente $\rho - 1 < 0$: hay convergencia β. Pero

$$
\sigma_T^2 = \rho^2\sigma_0^2 + \sigma_\varepsilon^2,
$$

que puede ser igual o mayor que $\sigma_0^2$. Las regiones de arriba bajan y
las de abajo suben (**regresión a la media**), mientras los choques nuevos
mantienen la dispersión. Es la falacia de Galton
([E.A1](repaso/estadistica.md#ea1)). Por eso se revisan las dos
convergencias. En México 2003–2023 no hay ninguna de las dos, así que el
problema no se presenta, pero sí explica por qué el caso con petróleo
engaña.

<a id="pp3"></a>

### P.3 La velocidad de convergencia del modelo de Solow (sección 3.2)

En el modelo de Solow, el capital por trabajador cumple
$\dot k = sk^\alpha - (n + \kappa)k$, que no es lineal. En logaritmos,

$$
\frac{d\ln k}{dt} = s\thinspace e^{-(1 - \alpha)\ln k} - (n + \kappa).
$$

Cerca del estado estacionario, donde $sk^{\ast\thinspace\alpha - 1} = n + \kappa$,
se aproxima el lado derecho por su recta tangente en $\ln k^\ast$. Su
pendiente es $-(1 - \alpha)\thinspace sk^{\ast\thinspace\alpha - 1} = -(1 - \alpha)(n + \kappa)$,
así que

$$
\frac{d}{dt}(\ln k - \ln k^\ast) \approx -(1 - \alpha)(n + \kappa)\thinspace(\ln k - \ln k^\ast).
$$

Es la ecuación de la sección 0 con $\beta = (1 - \alpha)(n + \kappa)$, y como
$\ln y = \alpha\ln k$, el ingreso converge a la misma velocidad. Con
$\alpha = 0.3$ y $n + \kappa = 0.06$, $\beta \approx 0.04$: el doble de la
regla del 2%. Barro y Sala-i-Martin (1992) interpretan la diferencia como
evidencia de que la participación del capital, entendido en sentido amplio
(con capital humano), es mayor. La aproximación lineal alrededor de un
equilibrio es el tema de las sesiones 7 y 8.

---

## Referencias

- Barro, R. J., & Sala-i-Martin, X. (1992). Convergence. *Journal of
  Political Economy*, 100(2), 223–251. https://doi.org/10.1086/261816
- Chiang, A. C., & Wainwright, K. (2006). *Métodos fundamentales de economía
  matemática* (4.ª ed.). McGraw-Hill.
