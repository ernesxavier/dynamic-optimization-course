# Repaso: estadística y datos

> Cada concepto tiene una clave (por ejemplo **[E.I3](#ei3)**) y dice en qué
> sesiones se usa. El índice [README.md](./README.md) indica qué repasar antes
> de cada sesión. Los fragmentos de Julia corren en el entorno del curso
> (`julia --project=Code`).
>
> - **Básico**: lo que se supone sabido al empezar el curso.
> - **Intermedio**: lo necesario para seguir las clases, las tareas y las
>   notas formales.
> - **Avanzado**: lo necesario para los puntos [Avanzado]: demostraciones y
>   extensiones.

Esta área sostiene las sesiones con datos (convergencia en la 5, calibración
en la 12 y la 14), el ejemplo de migración con salarios inciertos (sesión 19)
y el proyecto final, que se contrasta o se calibra con datos. No es un curso
de econometría: reúne sólo lo que el curso usa. Para leer datos en Julia,
ver [N.I7](metodos_numericos.md#ni7).

---

## Nivel básico

<a id="eb1"></a>

### E.B1 Media, varianza y valor esperado
*Sesiones 5, 19, proyecto.*

Con datos $x_1, \dots, x_n$:

- **Media muestral**: $\bar x = \frac{1}{n}\sum_i x_i$.
- **Varianza muestral**: $s^2 = \frac{1}{n-1}\sum_i (x_i - \bar x)^2$; la
  **desviación estándar** $s$ está en las mismas unidades que los datos.

Con una variable aleatoria que toma los valores $x_1, \dots, x_m$ con
probabilidades $p_1, \dots, p_m$:

$$
\mathbb{E}[X] = \sum_j p_j x_j,
\qquad
\mathbb{E}[g(X)] = \sum_j p_j\thinspace g(x_j).
$$

**El valor esperado de una función no es la función del valor esperado.**
Si el salario vale 1.2 o 0.8 con probabilidad 1/2 cada uno, el salario
esperado es 1, pero con utilidad $u(w) = \ln w$:

```julia
w = [1.2, 0.8]; p = [0.5, 0.5]
sum(p .* w)              # 1.0: salario esperado
sum(p .* log.(w))        # ≈ -0.0204: utilidad esperada
log(sum(p .* w))         # 0.0: utilidad del salario esperado
```

Como $\ln$ es cóncava ([C.I2](calculo.md#ci2)),
$\mathbb{E}[\ln w] < \ln \mathbb{E}[w]$ (desigualdad de Jensen): a quien tiene aversión al riesgo le
importa la incertidumbre, no sólo el promedio. Por eso la ecuación de Bellman
con incertidumbre lleva $\mathbb{E}[V(x')]$ y no $V(\mathbb{E}[x'])$.

<a id="eb2"></a>

### E.B2 Tasas de crecimiento con datos
*Sesiones 5, 12, 14, proyecto.*

Si una variable pasa de $y_0$ a $y_T$ en $T$ años:

| Tasa | Fórmula | Uso |
|---|---|---|
| Logarítmica promedio | $g = \frac{1}{T}\ln(y_T/y_0)$ | La del curso: es la $g$ de $y_T = y_0e^{gT}$ ([C.B3](calculo.md#cb3)) |
| Compuesta anual | $(y_T/y_0)^{1/T} - 1$ | La de los reportes oficiales |
| Simple de un año | $(y_{t+1} - y_t)/y_t$ | Variaciones anuales |

Para tasas pequeñas las tres casi coinciden. Si el PIB per cápita pasa de
100 a 150 en 20 años, la tasa logarítmica es $\ln(1.5)/20 \approx 0.0203$ (2.03%) y
la compuesta, $1.5^{1/20} - 1 \approx 0.0205$ (2.05%).

Tres cuidados con los datos económicos:

- **Precios constantes.** El crecimiento se mide con series **reales** (a
  precios constantes), no nominales; si no, se mide la inflación.
- **Per cápita o por trabajador.** El PIB de una entidad crece también porque
  crece su población. Para convergencia se usa el PIB per cápita; para la
  productividad $v_i$ de la sesión 14, el PIB por trabajador (población
  ocupada).
- **Tiempo de duplicación.** Con tasa logarítmica $g$, $y$ se duplica en
  $\ln 2/g \approx 0.7/g$ años: al 2% anual, unos 35 años.

<a id="eb3"></a>

### E.B3 Mínimos cuadrados
*Sesión 5, proyecto.*

Para ajustar una recta $y_i = a + b\thinspace x_i + e_i$ a datos $(x_i, y_i)$,
**mínimos cuadrados ordinarios** (MCO) elige $a$ y $b$ que minimizan
$\sum_i e_i^2$. La solución es

$$
\hat b = \frac{\mathrm{Cov}(x, y)}{\mathrm{Var}(x)},
\qquad
\hat a = \bar y - \hat b\thinspace\bar x.
$$

El **coeficiente de determinación** $R^2$ es la fracción de la varianza de
$y$ que explica la recta; en regresión simple, $R^2$ es la correlación al
cuadrado.

**La regresión de convergencia** (sesión 5) pone en $y$ el crecimiento
promedio de cada entidad y en $x$ el logaritmo de su ingreso inicial:
$g_i = a + b\ln y_{i0} + e_i$. Si $b < 0$, las entidades que empezaron más
pobres crecieron más rápido. Con datos simulados para 32 entidades:

```julia
using Statistics, Random
rng = Xoshiro(1)
lny0 = 4 .+ 0.5 .* randn(rng, 32)                        # log del ingreso inicial
g = 0.04 .- 0.01 .* lny0 .+ 0.004 .* randn(rng, 32)      # crecimiento anual promedio
X = [ones(32) lny0]
â, b̂ = X \ g                    # mínimos cuadrados: ≈ 0.044 y -0.0108
b̂ ≈ cov(lny0, g) / var(lny0)    # true
R² = cor(lny0, g)^2             # ≈ 0.75
```

`X \ g` resuelve el problema de mínimos cuadrados directamente (con una
factorización QR), sin invertir $X^\top X$, que es más lento y menos
preciso. **Cómo se lee $\hat b \approx -0.011$**: una entidad con el doble de
ingreso inicial ($\ln 2 \approx 0.69$ más en $\ln y_0$) crece
$0.011 \times 0.69 \approx 0.75$ puntos porcentuales menos al año.

---

## Nivel intermedio

<a id="ei1"></a>

### E.I1 Esperanza condicional y cadenas de dos estados
*Sesión 19.*

$\mathbb{E}[X \mid Y = y]$ es el valor esperado de $X$ cuando ya se sabe
que $Y = y$. En la ecuación de Bellman con incertidumbre, lo que se sabe hoy
es el estado actual: $\mathbb{E}[V(w') \mid w]$ promedia el valor de mañana
con las probabilidades **de pasar de $w$ a cada $w'$**.

Un salario que vale **alto** o **bajo** y cambia de un año a otro según

$$
P = \begin{pmatrix} p & 1 - p \cr 1 - q & q \end{pmatrix}
\quad\text{(filas: hoy; columnas: mañana; alto primero)}
$$

es una **cadena de Markov de dos estados**: $p$ es la probabilidad de seguir
en alto y $q$, la de seguir en bajo. Si $p$ y $q$ están cerca de 1, el
salario es **persistente**. Si $V$ es el vector de valores en cada estado,
$PV$ es el vector de valores esperados para mañana:

```julia
P = [0.9 0.1; 0.2 0.8]
V = [10.0, 6.0]                 # valor con salario alto y con salario bajo
P * V                           # [9.6, 6.8]: E[V(w') | alto] y E[V(w') | bajo]
```

A largo plazo, la fracción del tiempo con salario alto es

$$
\psi^\ast_{\text{alto}} = \frac{1 - q}{(1 - p) + (1 - q)},
$$

que con los números de arriba vale $0.2/0.3 = 2/3$. Se obtiene de
$\psi^\ast = \psi^\ast P$: en el largo plazo, los que salen de alto
($(1 - p)\psi^\ast_{\text{alto}}$) son tantos como los que entran
($(1 - q)\psi^\ast_{\text{bajo}}$).

**Dos regiones.** Si cada región tiene su propia cadena y los salarios son
independientes, el estado conjunto tiene 4 combinaciones (alto-alto,
alto-bajo, bajo-alto, bajo-bajo) y su matriz de transición es
`kron(P1, P2)`, de $4 \times 4$. El caso general de $n$ estados está en
[L.A4](algebra_lineal.md#la4).

<a id="ei2"></a>

### E.I2 Incertidumbre en la regresión
*Sesión 5, proyecto.*

$\hat b$ es una estimación: con otra muestra (otro periodo, otros choques)
saldría distinta. Su **error estándar** mide cuánto variaría:

$$
\mathrm{se}(\hat b) = \sqrt{\frac{\hat\sigma^2}{\sum_i (x_i - \bar x)^2}},
\qquad
\hat\sigma^2 = \frac{1}{n - 2}\sum_i \hat e_i^2.
$$

Un **intervalo de confianza del 95%** es, aproximadamente,
$\hat b \pm 2\thinspace\mathrm{se}(\hat b)$. Si no contiene el cero, se dice
que $\hat b$ es **significativo** al 5%. Siguiendo el ejemplo de
[E.B3](#eb3):

```julia
n = length(g); e = g .- X * [â, b̂]
σ̂² = sum(e .^ 2) / (n - 2)
se_b = sqrt(σ̂² / sum((lny0 .- mean(lny0)) .^ 2))   # ≈ 0.0011
(b̂ - 2se_b, b̂ + 2se_b)                            # ≈ (-0.0131, -0.0085)
```

Tres cuidados con datos regionales:

- **Pocas observaciones.** Con 32 entidades, el factor exacto de la
  distribución $t$ con 30 grados de libertad es 2.04, no 1.96; el "±2" basta.
- **Varianza desigual.** Si las entidades pequeñas tienen choques más
  grandes, la fórmula de arriba subestima el error; se usan errores
  **robustos a heterocedasticidad**.
- **Vecinos parecidos.** Las entidades vecinas comparten choques, así que
  las observaciones no son independientes y la información es menor que la
  que sugiere $n = 32$. Es un tema propio de la econometría espacial.

<a id="ei3"></a>

### E.I3 Calibración
*Sesiones 12, 14, proyecto.*

**Estimar** es elegir parámetros que ajusten los datos lo mejor posible,
con su error estándar. **Calibrar** es elegir parámetros para que el modelo
reproduzca unos pocos hechos que se consideran confiables, y después
preguntar qué predice sobre otros. La calibración tiene dos pasos:

1. **Parámetros medidos directamente**: la participación del capital
   $\alpha$ (uno menos la participación del trabajo en el ingreso), la
   depreciación $\delta$, la tasa de ahorro $s$.
2. **Parámetros que se ajustan a un blanco**: los que no se miden, se fijan
   para que el modelo reproduzca un dato. En el estado estacionario de
   Ramsey sin crecimiento, $f'(k^\ast) = \rho + \delta$; con
   $f(k) = k^\alpha$, $f'(k) = \alpha\thinspace y/k$, así que

$$
\rho = \frac{\alpha}{k/y} - \delta .
$$

Con $\alpha = 0.35$, una razón capital-producto $k/y = 3$ y $\delta = 0.05$,
sale $\rho = 0.35/3 - 0.05 \approx 0.067$.

**Supuestos explícitos.** Cuando un dato no existe, como la tasa de ahorro
por entidad, se fija con un supuesto, se dice en el texto y se reporta
cuánto cambia el resultado si el supuesto cambia ([E.A2](#ea2)). Un modelo
calibrado con supuestos bien declarados es útil; uno con supuestos ocultos
no.

---

## Nivel avanzado

<a id="ea1"></a>

### E.A1 La regresión de convergencia y sus trampas
*Sesión 5.*

**De la pendiente a la velocidad.** Si cada entidad se acerca a su estado
estacionario según $\dot{z} = -\beta z$, con $z = \ln y - \ln y^\ast$
([D.I1](ecuaciones_diferenciales.md#di1)), entonces
$z_T = e^{-\beta T} z_0$ y el crecimiento promedio en $T$ años es

$$
\frac{1}{T}\ln\frac{y_T}{y_0} = -\frac{1 - e^{-\beta T}}{T}\thinspace(\ln y_0 - \ln y^\ast).
$$

La pendiente de la regresión es $b = -(1 - e^{-\beta T})/T$, no $-\beta$.
Despejando,

$$
\beta = -\frac{\ln(1 + bT)}{T}.
$$

Con $b = -0.01$ y $T = 20$: $\beta = -\ln(0.8)/20 \approx 0.0112$, y la
**vida media** de la brecha es $\ln 2/\beta \approx 62$ años. Leer $b$
directamente como $\beta$ daría 69 años.

**La falacia de Galton.** Una pendiente negativa no prueba que la
desigualdad entre entidades disminuya. Si cada año hay choques nuevos, las
entidades que empezaron muy arriba tienden a bajar y las de abajo a subir
(regresión a la media), aunque la dispersión total se mantenga igual.
Por eso se distinguen:

- **Convergencia β**: $b < 0$ en la regresión.
- **Convergencia σ**: la desviación estándar de $\ln y_i$ entre entidades
  disminuye con el tiempo.

La convergencia β es necesaria para la σ, pero no suficiente: hay que
revisar las dos. El **error de medición** en el ingreso inicial empuja
$\hat b$ hacia valores negativos por la misma razón.

<a id="ea2"></a>

### E.A2 Sensibilidad de un modelo calibrado
*Sesión 14, proyecto.*

Un resultado $R(\theta)$ que depende de un parámetro incierto $\theta$ se
reporta con su sensibilidad. Dos maneras:

- **Elasticidad**: $\varepsilon = \frac{\partial \ln R}{\partial \ln \theta}$.
  Si $\theta$ tiene un error del 10%, $R$ tiene un error de aproximadamente
  $\varepsilon$ veces 10%. Se calcula con diferencias finitas
  ([N.A4](metodos_numericos.md#na4)).
- **Barrido**: recalcular $R$ en un rango plausible de $\theta$ y reportar
  el rango del resultado. Es la forma natural en un cuaderno con
  deslizadores.

Con la calibración de $\rho$ de [E.I3](#ei3):

```julia
ρ(α; ky = 3.0, δ = 0.05) = α / ky - δ
elasticidad(f, x; Δ = 1e-6) = (f(x + Δ) - f(x - Δ)) / (2Δ) * x / f(x)
elasticidad(ρ, 0.35)                       # ≈ 1.75
elasticidad(ky -> ρ(0.35; ky), 3.0)        # ≈ -1.75
ρ(0.35; ky = 2.5), ρ(0.35; ky = 3.5)       # ≈ (0.09, 0.05)
```

Un error del 10% en $k/y$ mueve $\rho$ alrededor de 17%, y el rango
plausible $k/y \in [2.5, 3.5]$ lleva $\rho$ de 0.05 a 0.09. Ese rango, y no
sólo el valor central, es lo que se reporta.

---

## Autodiagnóstico

<details>
<summary><b>1 (B).</b> El salario vale 1.2 o 0.8 con probabilidad 1/2. Con <i>u</i>(<i>w</i>) = ln <i>w</i>, ¿qué es mayor: E[ln <i>w</i>] o ln E[<i>w</i>]? ¿Por qué?</summary>

$\ln \mathbb{E}[w] = \ln 1 = 0$ y $\mathbb{E}[\ln w] \approx -0.020$. Es
mayor el primero porque $\ln$ es cóncava (desigualdad de Jensen): la
incertidumbre reduce la utilidad esperada.
</details>

<details>
<summary><b>2 (B).</b> El PIB per cápita de una entidad pasa de 100 a 150 en 20 años. ¿Cuál es su tasa de crecimiento logarítmica promedio? ¿Y la compuesta anual?</summary>

$\ln(1.5)/20 \approx 0.0203$ (2.03%) y $1.5^{1/20} - 1 \approx 0.0205$ (2.05%).
</details>

<details>
<summary><b>3 (B).</b> Si el ingreso crece al 2% anual (tasa logarítmica), ¿en cuántos años se duplica?</summary>

$\ln 2/0.02 \approx 34.7$ años.
</details>

<details>
<summary><b>4 (B).</b> En <i>g</i> = <i>a</i> + <i>b</i> ln <i>y</i><sub>0</sub> se obtiene <i>b̂</i> = −0.01. ¿Qué significa el signo? ¿Cuánto más lento crece una entidad con el doble de ingreso inicial?</summary>

El signo negativo dice que las entidades más pobres al inicio crecieron más
rápido. Con el doble de ingreso, $\ln y_0$ es mayor en $\ln 2 \approx 0.69$:
crece $0.01 \times 0.69 \approx 0.7$ puntos porcentuales menos al año.
</details>

<details>
<summary><b>5 (B).</b> Una regresión de convergencia da <i>R</i>² = 0.75. ¿Prueba eso que el modelo de Solow es el correcto?</summary>

No. $R^2$ sólo dice qué tan bien una recta resume los datos. Varias teorías
predicen una pendiente negativa, y la correlación no dice cuál mecanismo la
produce.
</details>

<details>
<summary><b>6 (I).</b> Con <i>P</i> = [0.9 0.1; 0.2 0.8] (alto primero) y valores <i>V</i> = (10, 6), ¿cuánto vale E[<i>V</i>(<i>w</i>′) | <i>w</i>] en cada estado? ¿Qué fracción del tiempo el salario es alto a largo plazo?</summary>

$PV = (9.6, 6.8)$. A largo plazo,
$(1 - 0.8)/[(1 - 0.9) + (1 - 0.8)] = 0.2/0.3 = 2/3$ del tiempo.
</details>

<details>
<summary><b>7 (I).</b> Una regresión con 32 entidades da <i>b̂</i> = −0.011 con error estándar 0.0011. Da un intervalo de confianza del 95%. ¿Es significativa la pendiente?</summary>

Aproximadamente $-0.011 \pm 0.0022$, es decir $(-0.0132, -0.0088)$. No
contiene el cero: es significativa al 5%. Con entidades vecinas que
comparten choques, el error real puede ser mayor.
</details>

<details>
<summary><b>8 (I).</b> Calibra la tasa de descuento ρ del modelo de Ramsey sin crecimiento con α = 0.35, <i>k</i>/<i>y</i> = 3 y δ = 0.05.</summary>

$\rho = \alpha/(k/y) - \delta = 0.35/3 - 0.05 \approx 0.067$.
</details>

<details>
<summary><b>9 (A).</b> Con <i>T</i> = 20 años, la pendiente de convergencia es <i>b</i> = −0.01. ¿Cuál es la velocidad de convergencia β y la vida media de la brecha?</summary>

$\beta = -\ln(1 - 0.2)/20 \approx 0.0112$ y la vida media,
$\ln 2/\beta \approx 62$ años. Leer $b$ como $\beta$ daría 69 años.
</details>

<details>
<summary><b>10 (A).</b> La desviación estándar de ln <i>y</i> entre entidades no cambió en 20 años, pero la pendiente de convergencia es negativa. ¿Es posible?</summary>

Sí. Con choques nuevos cada año, las entidades de los extremos regresan
hacia la media (convergencia β) mientras otras se alejan, y la dispersión
total se mantiene (no hay convergencia σ). Es la falacia de Galton.
</details>

---

## Para profundizar

- Wooldridge, J. M. *Introducción a la econometría: un enfoque moderno*.
  Cengage Learning, caps. 2–4: regresión simple y múltiple, errores
  estándar e inferencia.
- Barro, R. J., y Sala-i-Martin, X. (2004). *Economic Growth* (2.ª ed.).
  MIT Press: la convergencia β y σ con datos regionales.
- Quah, D. (1993). Galton's fallacy and tests of the convergence hypothesis.
  *Scandinavian Journal of Economics*, 95(4), 427–443.
- Kydland, F. E., y Prescott, E. C. (1996). The computational experiment: An
  econometric tool. *Journal of Economic Perspectives*, 10(1), 69–85.
  https://doi.org/10.1257/jep.10.1.69
- Sargent y Stachurski, Vol. I: cadenas de Markov finitas y programación
  dinámica con incertidumbre.
