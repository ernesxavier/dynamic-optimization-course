#%% hide
md"""
# Sesión 10: Del cálculo de variaciones al Hamiltoniano

**Pregunta de la unidad.** ¿Conviene invertir primero donde se ahorra más o
donde se produce más?

**Pregunta de la sesión.** Un gobierno estatal recibe un fondo
extraordinario que rinde una tasa ``r`` y tiene ``T`` años para gastarlo.
¿Le conviene gastarlo pronto, despacio o al final?

**Objetivos de la sesión**
1. Plantear un problema en el que se elige una trayectoria completa, y
   resolverlo como un problema estático con muchas variables.
2. Derivar y leer la ecuación de Euler: en el fondo regional, la regla de
   Keynes-Ramsey.
3. Ver por qué la trayectoria óptima cumple la ecuación de Euler:
   cualquier perturbación que respete los extremos baja el valor.
4. Resolver el mismo problema con el Hamiltoniano y leer el coestado como
   el precio de un peso más en el fondo.

**Cómo usar este cuaderno.** Pluto es reactivo: al mover un deslizador, todo
lo que depende de él se recalcula. Las secciones marcadas **[Avanzado]** son
opcionales. Las demostraciones están en las notas formales,
`Class_notes/s10_calculo_de_variaciones.md`.

**Cómo abrirlo.** Desde la raíz del repositorio:
`julia --project=Code -e 'using Pluto; Pluto.run()'` y abrir
`Code/s10_calculo_de_variaciones.jl`.

**Repaso recomendado** (en `Class_notes/repaso/`): C.B1 a C.B4 (derivadas,
máximos, exponencial e integrales), C.I6 (regla de Leibniz), C.I7 (Taylor) y
D.I3 (lineales de segundo orden). Para los puntos [Avanzado]: C.A3
(funcionales y primera variación).
"""

#%% hide
TableOfContents(title = "Contenido")

#%% hide
md"""
## 1. El fondo regional: elegir una trayectoria

El fondo ``W(t)`` crece con sus rendimientos y baja con el gasto ``c(t)``:
``W' = rW - c``. El gobierno elige la trayectoria del fondo, y con ella la
del gasto, ``c = rW - W'``:

```math
\max_W \int_0^T e^{-\rho t}\, u\big(rW - W'\big)\, dt,
\qquad W(0) = W_0, \quad W(T) = W_T,
\qquad u(c) = \frac{c^{1-\theta} - 1}{1 - \theta}.
```

El cuaderno lo resuelve de dos maneras. La **línea** es la solución exacta,
con la ecuación de Euler (sección 2). Los **puntos** son la solución
numérica de la versión discreta: se divide ``[0, T]`` en 200 tramos y se
eligen los 199 saldos intermedios ``W_1, \dots, W_{199}`` con el método de
Newton, como un problema de la Unidad I con 199 variables. Fondo inicial:
``W_0 = 100``; horizonte: ``T = 20`` años.

Rendimiento del fondo, ``r``: $(@bind r Slider(0.0:0.005:0.08, default = 0.04, show_value = true))

Tasa de descuento, ``\rho``: $(@bind ρ Slider(0.0:0.005:0.08, default = 0.02, show_value = true))

Aversión a la variación del gasto, ``\theta``: $(@bind θ Slider(0.25:0.25:5.0, default = 2.0, show_value = true))

Reserva final, ``W_T``: $(@bind WT Slider(0:5:50, default = 0, show_value = true))
"""

#%%
fondo = solucion_fondo(; W0 = 100.0, WT = float(WT), r, ρ, θ, T = 20.0)

#%%
discreto = resolver_discreto(fondo; N = 200)

#%% hide
let
    ts = range(0, fondo.T, length = 300)
    marcas = 1:10:length(discreto.c)
    g1 = plot(ts, fondo.c.(ts); color = NARANJA, lw = 2.5, xlabel = "años", ylabel = "gasto c(t)",
              title = "Gasto", ylims = (0, 1.15maximum(fondo.c.(ts))))
    scatter!(g1, discreto.t[marcas], discreto.c[marcas]; color = TINTA, ms = 3, msw = 0)
    hline!(g1, [anualidad(fondo)]; color = GRIS, ls = :dot, lw = 1)
    g2 = plot(ts, fondo.W.(ts); color = AZUL, lw = 2.5, xlabel = "años", ylabel = "fondo W(t)",
              title = "Saldo del fondo", ylims = (0, 1.15maximum(fondo.W.(ts))))
    scatter!(g2, discreto.t[marcas], discreto.W[marcas]; color = TINTA, ms = 3, msw = 0)
    plot(g1, g2; layout = (1, 2), size = (780, 320))
end

#%% hide
let
    f = fondo
    rd(v, d = 3) = round(v, digits = d)
    pérdida = equivalente_anualidad(f)
    md"""
    | | Valor |
    |:---|---:|
    | Crecimiento del gasto, ``g = (r - \rho)/\theta`` | $(rd(100f.g, 2))% al año |
    | Gasto inicial, ``c_0`` (exacto / discreto) | $(rd(f.c0)) / $(rd(discreto.c[1])) |
    | Gasto final, ``c(T)`` | $(rd(f.c(f.T))) |
    | Gasto constante con el mismo presupuesto (línea punteada) | $(rd(anualidad(f))) |
    | Bienestar ``V`` con el gasto óptimo / con el gasto constante | $(rd(valor(f), 4)) / $(rd(valor_constante(f), 4)) |
    | Gastar parejo equivale a perder, cada año, | $(rd(100pérdida, 2))% del gasto |

    Los puntos caen sobre la línea: la solución de la versión discreta se
    acerca a la exacta. Iguala ``r`` y ``\rho``: el gasto óptimo es constante.
    Con ``r > \rho`` el gasto crece y con ``r < \rho`` decrece; ``\theta``
    grande aplana la trayectoria. Sube ``W_T``: el gasto baja en todos los
    años, no sólo en los últimos.
    """
end

#%% hide
md"""
## 2. La ecuación de Euler

Para ``J[y] = \int_0^T F(t, y, y')\, dt`` con extremos fijos, la trayectoria
óptima cumple

```math
F_y - \frac{d}{dt} F_{y'} = 0.
```

En la versión discreta, es la condición de primer orden respecto a cada
``y_n`` (notas, sección 2.2). Para el fondo, ``F = e^{-\rho t}u(rW - W')``.
Symbolics.jl calcula las dos derivadas parciales, tratando ``W`` y ``W'``
(aquí `Wp`) como variables independientes:
"""

#%%
let
    @variables t W Wp r_ ρ_ θ_
    F = exp(-ρ_ * t) * ((r_ * W - Wp)^(1 - θ_) - 1) / (1 - θ_)
    (F_W = simplify(Symbolics.derivative(F, W)),
     F_Wp = simplify(Symbolics.derivative(F, Wp)))
end

#%% hide
md"""
Es decir, ``F_W = r\, e^{-\rho t} u'(c)`` y ``F_{W'} = -e^{-\rho t}u'(c)``,
con ``u'(c) = c^{-\theta}``. Al sustituir en la ecuación de Euler y derivar
respecto al tiempo sale la **regla de Keynes-Ramsey**:

```math
\frac{c'}{c} = \frac{r - \rho}{\theta}.
```

**Lectura.** Gastar un peso menos hoy cuesta ``u'(c(t))``. En el fondo, ese
peso rinde ``r``, y el gobierno descuenta el futuro a la tasa ``\rho``. Si
``r > \rho``, esperar paga y el gasto crece; si ``r < \rho``, decrece.

La regla dice cómo **cambia** el gasto, pero no cuánto vale al principio.
El nivel ``c_0`` lo fijan los dos extremos: es el único con el que el fondo
llega exactamente a ``W_T`` en ``T``. A la izquierda, varias trayectorias
que cumplen la regla con distintos ``c_0``; sólo una (naranja) cumple la
condición final.
"""

#%% hide
let
    f = fondo
    ts = range(0, f.T, length = 300)
    p = plot(; xlabel = "años", ylabel = "fondo W(t)", title = "Misma regla, distinto c₀",
             ylims = (-20, 1.3maximum(f.W.(ts))))
    for x in (0.85, 0.92, 1.08, 1.15)
        plot!(p, ts, saldo(f, x * f.c0).(ts); color = GRIS, lw = 1, alpha = 0.7)
    end
    plot!(p, ts, f.W.(ts); color = NARANJA, lw = 2.5)
    hline!(p, [0]; color = GRIS, lw = 0.5)
    scatter!(p, [f.T], [f.WT]; color = TINTA, ms = 6, msw = 0)
    g2 = plot(ts, residuo_euler(f).(ts); color = AZUL, lw = 2, xlabel = "años",
              ylabel = "F_W − d/dt F_W′", title = "Ecuación de Euler sobre la óptima",
              ylims = (-1e-6, 1e-6))
    plot(p, g2; layout = (1, 2), size = (780, 320))
end

#%% hide
md"""
A la derecha, ``F_W - \frac{d}{dt}F_{W'}`` evaluado sobre la trayectoria
óptima: es cero en todo el horizonte (la derivada total se calcula con una
diferencia numérica, por eso aparece la escala ``10^{-6}``). Un ``c_0``
mayor agota el fondo antes de ``T``; uno menor deja más de ``W_T``. Es un
**problema de valor en la frontera**, como el disparo de la sesión 8.
"""

#%% hide
md"""
## 3. Por qué: perturbar la trayectoria óptima

Si ``W^\ast`` es óptima, cualquier trayectoria ``W^\ast + \varepsilon\eta``
con ``\eta(0) = \eta(T) = 0`` cumple los extremos y no puede dar más
bienestar. La función ``\varepsilon \mapsto J[W^\ast + \varepsilon\eta]``
tiene un máximo en ``\varepsilon = 0``, y su derivada ahí es cero: de esa
condición, para toda ``\eta``, sale la ecuación de Euler (notas, P.1).

Forma de la perturbación ``\eta``: $(@bind forma Select(["joroba" => "una joroba: adelantar o atrasar el gasto", "onda" => "una onda: gastar más y luego menos", "tres" => "tres ondas"]))

Tamaño de la perturbación, ``\varepsilon``: $(@bind ε Slider(-0.6:0.05:0.6, default = 0.3, show_value = true))
"""

#%% hide
let
    f = fondo
    η, dη = perturbacion(forma, f.T)
    ts = range(0, f.T, length = 300)
    cε(e) = t -> f.c(t) + e * (f.r * η(t) - dη(t))
    g1 = plot(ts, f.c.(ts); color = NARANJA, lw = 2.5, xlabel = "años", ylabel = "gasto c(t)",
              title = "Gasto óptimo y perturbado")
    plot!(g1, ts, cε(ε).(ts); color = TINTA, lw = 1.5, ls = :dash)
    es = range(-0.6, 0.6, length = 61)
    Js = [valor_de(f, cε(e)) for e in es]
    g2 = plot(es, Js; color = AZUL, lw = 2.5, xlabel = "ε", ylabel = "J[W* + εη]",
              title = "El bienestar es máximo en ε = 0")
    scatter!(g2, [ε], [valor_de(f, cε(ε))]; color = TINTA, ms = 5, msw = 0)
    vline!(g2, [0]; color = GRIS, ls = :dot, lw = 1)
    plot(g1, g2; layout = (1, 2), size = (780, 320))
end

#%% hide
md"""
Con la joroba, ``\varepsilon > 0`` deja más dinero en el fondo a mitad del
horizonte: se gasta menos al principio y más al final. Cualquier forma y
cualquier signo de ``\varepsilon`` bajan el bienestar, y la curva de la
derecha es plana en ``\varepsilon = 0``. La perturbación siempre gasta el
mismo presupuesto, porque respeta ``W(0)`` y ``W(T)``: lo que cambia es
**cuándo** se gasta.
"""

#%% hide
md"""
## 4. El mismo problema con el Hamiltoniano

Con estado ``W`` y control ``u = W'``, el Hamiltoniano es
``H = e^{-\rho t}u(rW - u) + \lambda u``. Sus condiciones son:

- ``\partial H/\partial u = 0``: ``\lambda = e^{-\rho t}u'(c)``.
- ``\lambda' = -\partial H/\partial W = -r\lambda``, así que
  ``\lambda(t) = \lambda_0 e^{-rt}``.

Juntas, dan otra vez ``c'/c = (r - \rho)/\theta``, sin pasar por una
ecuación de segundo orden. A la izquierda, ``\lambda(t)`` calculado de las
dos formas: con el gasto óptimo, ``e^{-\rho t}c(t)^{-\theta}``, y con la
ecuación del coestado, ``\lambda_0 e^{-rt}``.
"""

#%% hide
let
    f = fondo
    ts = range(0, f.T, length = 300)
    g1 = plot(ts, f.λ.(ts); color = NARANJA, lw = 4, alpha = 0.5, xlabel = "años", ylabel = "λ(t)",
              title = "Coestado: dos cálculos")
    plot!(g1, ts, f.λ(0) .* exp.(-f.r .* ts); color = TINTA, lw = 1.5, ls = :dash)
    Ws = 70:5:140
    g2 = plot(Ws, [valor(solucion_fondo(; W0 = w, WT = f.WT, f.r, f.ρ, f.θ, f.T)) for w in Ws];
              color = AZUL, lw = 2.5, xlabel = "fondo inicial W₀", ylabel = "V(W₀)",
              title = "Valor óptimo y su pendiente en W₀ = 100")
    plot!(g2, Ws, valor(f) .+ f.λ(0) .* (Ws .- f.W0); color = NARANJA, lw = 1.5, ls = :dash)
    scatter!(g2, [f.W0], [valor(f)]; color = TINTA, ms = 5, msw = 0)
    plot(g1, g2; layout = (1, 2), size = (780, 320))
end

#%% hide
let
    f = fondo
    vmas = valor(solucion_fondo(; W0 = f.W0 + 1, WT = f.WT, f.r, f.ρ, f.θ, f.T))
    vmenos = valor(solucion_fondo(; W0 = f.W0 - 1, WT = f.WT, f.r, f.ρ, f.θ, f.T))
    md"""
    | | Valor |
    |:---|---:|
    | Coestado inicial, ``\lambda(0) = u'(c_0)`` | $(round(f.λ(0), sigdigits = 5)) |
    | ``(V(101) - V(99))/2`` | $(round((vmas - vmenos) / 2, sigdigits = 5)) |

    **El coestado es un precio.** ``\lambda(0)`` es cuánto sube el bienestar
    total con un peso más en el fondo inicial: la pendiente de ``V(W_0)`` (la
    recta punteada, a la derecha). Es el ``V'(B) = \lambda`` de la sesión 3.
    ``\lambda(t)`` cae a la tasa ``r``: un peso en el fondo en ``t`` vale lo
    mismo que ``e^{-rt}`` pesos hoy. Sube ``W_T``: hay menos para gastar, el
    gasto baja y cada peso vale más.
    """
end

#%% hide
md"""
## 5. [Avanzado] Cuando el gasto casi no importa cómo se reparte

Con ``\theta`` pequeño, al gobierno casi no le importa que el gasto varíe, y
la utilidad se acerca a la lineal. La gráfica muestra el gasto óptimo con
``W_T = 0`` y varios valores de ``\theta``, con los ``r`` y ``\rho`` de la
sección 1.
"""

#%% hide
let
    ts = range(0, 20, length = 300)
    p = plot(; xlabel = "años", ylabel = "gasto c(t)", title = "r = $r, ρ = $ρ", legend = :topleft,
             size = (700, 340))
    for (i, th) in enumerate((5.0, 2.0, 1.0, 0.5, 0.25, 0.1))
        f = solucion_fondo(; W0 = 100.0, WT = 0.0, r, ρ, θ = th, T = 20.0)
        plot!(p, ts, f.c.(ts); lw = 2, color = TINTA, alpha = 0.2 + 0.8(i - 1) / 5, label = "θ = $th")
    end
    p
end

#%% hide
md"""
Si ``r > \rho``, al bajar ``\theta`` el gasto se concentra al final; si
``r < \rho``, al principio. En el límite lineal (``\theta \to 0``), la
ecuación de Euler da ``(r - \rho)e^{-\rho t} = 0``, que **ninguna
trayectoria cumple** si ``r \ne \rho``: el óptimo pide gastarlo todo en un
instante. Con un gasto acotado, ``0 \le c \le \bar c``, el óptimo es
**bang-bang**, en las esquinas del intervalo. El cálculo de variaciones no
encuentra esquinas; el Hamiltoniano sí, cuando ``\partial H/\partial u = 0``
se reemplaza por "``u`` maximiza ``H``" (sesiones 11 y 13).
"""

#%% hide
md"""
## Resumen

| Herramienta | Qué dice | En este cuaderno |
|---|---|---|
| Discretizar | Una trayectoria es una lista de números; el problema se vuelve estático | Puntos de la sección 1 |
| Ecuación de Euler | ``F_y - \frac{d}{dt}F_{y'} = 0`` en cada instante | Symbolics y residuo, sección 2 |
| Keynes-Ramsey | ``c'/c = (r - \rho)/\theta`` | Pendiente del gasto |
| Extremos fijos | Fijan el nivel ``c_0`` | Trayectorias grises, sección 2 |
| Primera variación | Perturbar la óptima baja el valor; la derivada es cero | Sección 3 |
| Hamiltoniano | ``H_u = 0`` y ``\lambda' = -H_y`` dan Euler | Sección 4 |
| Coestado | ``\lambda(0) = V'(W_0)``: precio de un peso más | Tabla de la sección 4 |

## Ejercicios

### Completa el código

**1.** Escribe `F_W(t, W, Wp)` y `F_Wp(t, W, Wp)`, las derivadas parciales de
``F = e^{-\rho t}u(rW - W')`` con ``r = 0.04``, ``\rho = 0.02`` y
``\theta = 2``.
"""

#%%
F_W(t, W, Wp) = missing  # reemplaza missing

#%%
F_Wp(t, W, Wp) = missing  # reemplaza missing

#%% hide
verificar(() -> [F_W(0.0, 100.0, -2.0), F_W(5.0, 80.0, 1.0), F_Wp(0.0, 100.0, -2.0), F_Wp(5.0, 80.0, 1.0)],
          [0.04 / 36, exp(-0.1) * 0.04 / 4.84, -1 / 36, -exp(-0.1) / 4.84];
          pista = md"Con ``c = rW - W'``: `F_W(t, W, Wp) = exp(-0.02t) * 0.04 * (0.04W - Wp)^(-2)` y `F_Wp(t, W, Wp) = -exp(-0.02t) * (0.04W - Wp)^(-2)`.")

#%% hide
md"""
**2.** Escribe `gasto_inicial(W0, WT, r, ρ, θ, T)`, el gasto inicial
óptimo (notas, sección 3.3). Supón ``r \ne g``.
"""

#%%
function gasto_inicial(W0, WT, r, ρ, θ, T)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> [gasto_inicial(100, 0, 0.04, 0.02, 2, 20), gasto_inicial(100, 20, 0.04, 0.02, 2, 20),
                 gasto_inicial(50, 10, 0.03, 0.05, 1, 15)],
          [solucion_fondo(; W0 = 100.0, WT = 0.0, r = 0.04, ρ = 0.02, θ = 2.0, T = 20.0).c0,
           solucion_fondo(; W0 = 100.0, WT = 20.0, r = 0.04, ρ = 0.02, θ = 2.0, T = 20.0).c0,
           solucion_fondo(; W0 = 50.0, WT = 10.0, r = 0.03, ρ = 0.05, θ = 1.0, T = 15.0).c0];
          pista = md"Con `g = (r - ρ) / θ`: `(r - g) * (W0 - exp(-r * T) * WT) / (1 - exp(-(r - g) * T))`.")

#%% hide
md"""
**3.** Escribe `precio_sombra(W0)`, una aproximación numérica de
``V'(W_0)`` con una diferencia centrada. Usa `valor_base(W0)`, que
devuelve el bienestar óptimo con ``W_T = 0``, ``r = 0.04``, ``\rho = 0.02``,
``\theta = 2`` y ``T = 20``.
"""

#%%
function precio_sombra(W0)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> precio_sombra.([100.0, 50.0]),
          [solucion_fondo(; W0 = w, WT = 0.0, r = 0.04, ρ = 0.02, θ = 2.0, T = 20.0).λ(0) for w in (100.0, 50.0)];
          rtol = 1e-4,
          pista = md"Con un paso pequeño, por ejemplo `Δ = 0.01`: `(valor_base(W0 + Δ) - valor_base(W0 - Δ)) / (2Δ)`.")

#%% hide
md"""
**4. [Avanzado]** El problema F1 de las notas es
``\int_0^2 \big(12ty + (y')^2\big)\, dt`` con ``y(0) = 0`` e ``y(2) = 8``.
En su versión discreta con ``N`` tramos de largo ``h = 2/N``, la condición
de primer orden respecto a cada ``y_n`` es

```math
y_{n+1} - 2y_n + y_{n-1} = 6h^2 t_n, \qquad n = 1, \dots, N - 1.
```

Escribe `extremal_discreta(N)`, que resuelva ese sistema lineal y devuelva
el vector ``[y_0, y_1, \dots, y_N]``.
"""

#%%
function extremal_discreta(N)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> [extremal_discreta(4), extremal_discreta(10)],
          [collect(range(0, 2, length = 5)) .^ 3, collect(range(0, 2, length = 11)) .^ 3];
          rtol = 1e-6,
          pista = md"Con `h = 2 / N` y `t = collect(h .* (1:N-1))` (`collect` vuelve el rango un vector que se puede modificar): la matriz es `SymTridiagonal(fill(-2.0, N - 1), fill(1.0, N - 2))`; el lado derecho es `6h^2 .* t`, con `8` restado en la última entrada (el extremo ``y_N = 8`` pasa al lado derecho). Resuelve con `\`, y agrega ``y_0 = 0`` y ``y_N = 8`` al principio y al final.")

#%% hide
md"""
### Interpretación

5. En la sección 1, con ``r = \rho``, el gasto es constante. ¿Por qué, si el
   fondo rinde ``r``, no conviene gastar más al final?
6. ¿Por qué exigir una reserva ``W_T > 0`` baja el gasto desde el primer año
   y no sólo en los últimos? Relaciónalo con el precio ``\lambda(0)``.
7. Un estado con ingresos petroleros tiene una tasa de descuento alta,
   porque sus necesidades actuales son urgentes. Según la regla de
   Keynes-Ramsey, ¿cómo debería verse su gasto? ¿Qué papel tiene
   ``\theta``?

### Tu tesis

8. Escribe el problema de tu tesis, si puedes, como
   ``\max \int_0^T F(t, y, y')\, dt``. ¿Cuál es ``y``? ¿Qué condiciones de
   extremo tiene? ¿Hay límites sobre ``y'`` que el cálculo de variaciones
   no pueda manejar?

### [Avanzado]

9. En la sección 3, ¿por qué la curva de la derecha es más curva con la
   perturbación de tres ondas que con la joroba, si las dos tienen el mismo
   tamaño?
10. En la sección 1, con ``\theta = 0.25`` y ``r = 0.08``, ``\rho = 0``, los
    puntos se separan un poco de la línea al final. ¿Por qué la versión
    discreta pierde precisión cuando el gasto crece rápido?

## Para la próxima sesión

- **Sesión 11: Principio del máximo.** El Hamiltoniano general
  ``H = F + \lambda f``, las condiciones terminales y el coestado como precio
  sombra.
- Repaso: C.B2 y C.B4 (máximos e integrales), C.I2 (concavidad), C.I3
  (regla de la cadena y diferencial total), C.I6 (regla de Leibniz), D.I2
  (lineales de primer orden con coeficientes variables) y D.I7 (valor
  inicial y valor en la frontera). Para los puntos [Avanzado]: C.A3, D.A3
  (existencia y unicidad) y N.A1 (disparo).
"""

#%% hide
md"""
---
## Apéndice: paquetes y funciones auxiliares

Estas celdas definen herramientas que usa el cuaderno. No es necesario
leerlas para seguir la sesión.
"""

#%%
begin
    # Usa el entorno del curso (Code/Project.toml) en lugar del gestor de
    # paquetes propio de Pluto: un solo entorno para todo el repositorio.
    import Pkg
    Pkg.activate(@__DIR__)
    Pkg.instantiate()
    using PlutoUI, Plots, Symbolics, LinearAlgebra, Markdown
    gr()
    default(size = (720, 320), legend = false, grid = :y, gridalpha = 0.15,
            framestyle = :axes, titlefontsize = 11, guidefontsize = 9,
            tickfontsize = 8, legendfontsize = 8, foreground_color_legend = nothing,
            background_color_legend = nothing, margin = 3Plots.mm)
end

#%%
begin
    const AZUL    = "#2a78d6"   # fondo, valor óptimo, residuo
    const NARANJA = "#eb6834"   # trayectoria óptima, coestado
    const GRIS    = "#52514e"   # referencias
    const TINTA   = "#0b0b0b"   # solución discreta, perturbación
end;

#%%
begin
    "Utilidad CRRA (logarítmica si θ = 1) y utilidad marginal."
    u(c, θ) = θ == 1 ? log(c) : (c^(1 - θ) - 1) / (1 - θ)
    du(c, θ) = c^(-θ)
end

#%%
"Integral de f en [0, T] con la regla de Simpson y n tramos (n par)."
function integral(f, T; n = 2000)
    h = T / n
    h / 3 * (f(0.0) + f(T) + 4sum(f((2i - 1) * h) for i in 1:n ÷ 2) + 2sum(f(2i * h) for i in 1:n ÷ 2 - 1))
end

#%%
"""
Solución exacta del fondo regional: crecimiento g, gasto inicial c0 y las
funciones c(t), W(t) y λ(t) = e^{-ρt}u'(c(t)).
"""
function solucion_fondo(; W0, WT, r, ρ, θ, T)
    g = (r - ρ) / θ
    a = r - g
    # ∫₀ᵗ e^{-a s} ds, con el límite t cuando a = 0
    A(t) = abs(a) < 1e-10 ? t : (1 - exp(-a * t)) / a
    c0 = (W0 - exp(-r * T) * WT) / A(T)
    c(t) = c0 * exp(g * t)
    W(t) = exp(r * t) * (W0 - c0 * A(t))
    λ(t) = exp(-ρ * t) * du(c(t), θ)
    (; W0, WT, r, ρ, θ, T, g, c0, c, W, λ, A)
end

#%%
"Saldo del fondo si se sigue la regla de Keynes-Ramsey desde un gasto inicial c0."
saldo(f, c0) = t -> exp(f.r * t) * (f.W0 - c0 * f.A(t))

#%%
begin
    "Bienestar de una trayectoria de gasto c(t) (una función)."
    valor_de(f, c) = integral(t -> exp(-f.ρ * t) * u(max(c(t), 1e-9), f.θ), f.T)
    "Bienestar óptimo."
    valor(f) = valor_de(f, f.c)
    "Bienestar óptimo con los parámetros del ejercicio 3."
    valor_base(W0) = valor(solucion_fondo(; W0, WT = 0.0, r = 0.04, ρ = 0.02, θ = 2.0, T = 20.0))
end

#%%
begin
    "Gasto constante que cumple la misma restricción presupuestal."
    anualidad(f) = (f.W0 - exp(-f.r * f.T) * f.WT) / (abs(f.r) < 1e-10 ? f.T : (1 - exp(-f.r * f.T)) / f.r)
    valor_constante(f) = valor_de(f, t -> anualidad(f))
end

#%%
"""
Fracción x del gasto que se pierde, cada año, al gastar parejo en lugar de
óptimamente: el gasto óptimo multiplicado por (1 - x) da el mismo bienestar
que la anualidad (bisección).
"""
function equivalente_anualidad(f)
    objetivo = valor_constante(f)
    lo, hi = 0.0, 0.5
    for _ in 1:60
        m = (lo + hi) / 2
        valor_de(f, t -> (1 - m) * f.c(t)) > objetivo ? (lo = m) : (hi = m)
    end
    (lo + hi) / 2
end

#%%
"""
Residuo de la ecuación de Euler, F_W - d/dt F_W′, sobre la trayectoria
óptima (la derivada total con una diferencia centrada).
"""
function residuo_euler(f; dt = 1e-4)
    FW(t) = f.r * exp(-f.ρ * t) * du(f.c(t), f.θ)
    FWp(t) = -exp(-f.ρ * t) * du(f.c(t), f.θ)
    t -> FW(t) - (FWp(t + dt) - FWp(t - dt)) / (2dt)
end

#%%
"""
Versión discreta del fondo con N tramos: elige W₁, …, W_{N-1} con el método
de Newton (el hessiano es tridiagonal). Devuelve la malla, los saldos y el
gasto c_n = rW_n - (W_{n+1} - W_n)/h de cada tramo.
"""
function resolver_discreto(f; N = 200, tol = 1e-10)
    (; W0, WT, r, ρ, θ, T) = f
    h = T / N
    t = h .* (0:N)
    β = exp.(-ρ .* t[1:N])
    W = collect(range(W0, WT, length = N + 1))   # punto de partida: una recta
    gasto(W) = r .* W[1:N] .- diff(W) ./ h
    for _ in 1:100
        c = gasto(W)
        d1, d2 = β .* c .^ (-θ), β .* (-θ) .* c .^ (-θ - 1)
        # Condición de primer orden respecto a W_m: la ecuación de Euler discreta
        grad = d1[2:N] .* (1 + r * h) .- d1[1:N-1]
        diagonal = d2[2:N] .* (1 + r * h) .* (r + 1 / h) .+ d2[1:N-1] ./ h
        fuera = -d2[2:N-1] .* (1 + r * h) ./ h
        Δ = -(SymTridiagonal(diagonal, fuera) \ grad)
        α = 1.0
        while any(gasto(vcat(W[1], W[2:N] .+ α .* Δ, W[end])) .<= 0)
            α /= 2
        end
        W[2:N] .+= α .* Δ
        maximum(abs, Δ) < tol && break
    end
    (; t, W, c = gasto(W))
end

#%%
"Perturbación η(t) con η(0) = η(T) = 0, de tamaño 10, y su derivada."
function perturbacion(forma, T)
    k = forma == "joroba" ? 1 : forma == "onda" ? 2 : 3
    (t -> 10sin(k * π * t / T), t -> 10k * π / T * cos(k * π * t / T))
end

#%%
"Muestra si la respuesta de un ejercicio es correcta."
function verificar(f, esperado; rtol = 1e-8, pista = md"")
    caja(tipo, titulo, texto) = Markdown.MD(Markdown.Admonition(tipo, titulo, [texto]))
    resultado = try
        f()
    catch e
        return caja("danger", "Tu código produce un error", md"$(sprint(showerror, e))")
    end
    pendiente(x) = x === missing || (x isa AbstractArray && any(pendiente, x))
    cerca(a, b) = (a isa Number && b isa Number && isapprox(a, b; rtol, atol = 1e-12)) ||
                  (a isa Symbol && b isa Symbol && a == b) ||
                  (a isa AbstractArray && b isa AbstractArray && size(a) == size(b) && all(cerca.(a, b)))
    if pendiente(resultado)
        caja("warning", "Pendiente", md"Reemplaza `missing` por tu código.")
    elseif cerca(resultado, esperado)
        caja("correct", "¡Correcto!", md"Bien hecho.")
    else
        caja("danger", "Todavía no", pista)
    end
end
