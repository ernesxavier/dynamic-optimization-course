#%% hide
md"""
# Sesión 11: Principio del máximo

**Pregunta de la unidad.** ¿Conviene invertir primero donde se ahorra más o
donde se produce más?

**Pregunta de la sesión.** Una región tiene reservas de un recurso no
renovable. ¿A qué ritmo conviene extraerlo? ¿Cuánto vale una tonelada más
bajo tierra?

**Objetivos de la sesión**
1. Escribir el Hamiltoniano ``H = F + \lambda f`` y aplicar las condiciones
   del principio del máximo, incluidas las soluciones de esquina.
2. Elegir la condición de transversalidad que corresponde a cada condición
   final.
3. Leer el coestado como precio sombra del estado y comprobar que
   ``\lambda = \partial V/\partial y``.
4. Derivar la regla de Hotelling y relacionar el precio sombra con la
   escasez del recurso.

**Cómo usar este cuaderno.** Pluto es reactivo: al mover un deslizador, todo
lo que depende de él se recalcula. Las secciones marcadas **[Avanzado]** son
opcionales. Las demostraciones están en las notas formales,
`Class_notes/s11_principio_del_maximo.md`.

**Cómo abrirlo.** Desde la raíz del repositorio:
`julia --project=Code -e 'using Pluto; Pluto.run()'` y abrir
`Code/s11_principio_del_maximo.jl`.

**Repaso recomendado** (en `Class_notes/repaso/`): C.B2 y C.B4 (máximos e
integrales), C.I2 y C.I3 (concavidad y diferencial total), C.I6 (regla de
Leibniz), D.I2 (lineales de primer orden) y D.I7 (valor inicial y valor en
la frontera). Para los puntos [Avanzado]: C.A3, D.A3 y N.A1.
"""

#%% hide
TableOfContents(title = "Contenido")

#%% hide
md"""
## 1. Un recurso no renovable

La región extrae ``q(t)`` toneladas por año de reservas ``S(t)``, con
``S' = -q``, y no puede extraer más de lo que tiene: ``S(T) \ge 0``. El
beneficio de extraer ``q`` es ``B(q) = aq - q^2/2``, el área bajo la
demanda ``p = a - q``; ``a`` es el **precio de ahogo**, al que nadie compra.
El horizonte es ``T = 20`` años:

```math
\max_{q \ge 0} \int_0^T e^{-\rho t} B(q)\, dt,
\qquad S' = -q, \quad S(0) = S_0, \quad S(T) \ge 0.
```

Con ``H = e^{-\rho t}B(q) - \lambda q``, el principio del máximo da
``\lambda`` constante, ``q(t) = \max\{0,\ a - \lambda e^{\rho t}\}`` y la
holgura complementaria ``\lambda S(T) = 0`` (notas, sección 5). El cuaderno
busca por bisección el ``\lambda`` con el que la extracción total es igual a
las reservas.

Reservas iniciales, ``S_0``: $(@bind S0 Slider(10:10:250, default = 100, show_value = true))

Tasa de descuento, ``\rho``: $(@bind ρ Slider(0.01:0.01:0.10, default = 0.05, show_value = true))

Precio de ahogo, ``a``: $(@bind a Slider(5:1:20, default = 10, show_value = true))
"""

#%%
recurso = hotelling(float(S0); a = float(a), ρ, T = 20.0)

#%% hide
let
    r = recurso
    ts = range(0, r.T, length = 400)
    g1 = plot(ts, r.q.(ts); color = NARANJA, lw = 2.5, xlabel = "años", ylabel = "q(t)",
              title = "Extracción", ylims = (0, 1.1r.a))
    g2 = plot(ts, r.S.(ts); color = AZUL, lw = 2.5, xlabel = "años", ylabel = "S(t)",
              title = "Reservas", ylims = (0, 1.1max(r.S0, 1)))
    g3 = plot(ts, r.p.(ts); color = TINTA, lw = 2.5, xlabel = "años", ylabel = "p(t)",
              title = "Precio del recurso", ylims = (0, 1.15r.a))
    plot!(g3, ts, r.λ .* exp.(r.ρ .* ts); color = TINTA, lw = 1, ls = :dash)
    hline!(g3, [r.a]; color = GRIS, ls = :dot, lw = 1)
    r.τ < r.T && foreach(g -> vline!(g, [r.τ]; color = GRIS, ls = :dot, lw = 1), (g1, g2, g3))
    plot(g1, g2, g3; layout = (1, 3), size = (860, 300))
end

#%% hide
let
    r = recurso
    rd(v) = round(v, digits = 3)
    caso = r.λ == 0 ? md"**Recurso abundante.** Extraer hasta el precio cero no agota las reservas: sobra recurso al final y una tonelada más en el subsuelo **no vale nada**, ``\lambda = 0``." :
           r.τ < r.T ? md"**Recurso muy escaso.** El precio llega al de ahogo antes de ``T``: la extracción se detiene en ``\tau`` y desde ahí ``q = 0``. Es una **solución de esquina**: ``\partial H/\partial q = 0`` ya no vale, pero ``q = 0`` sigue maximizando ``H`` (sección 3)." :
           md"**Recurso escaso.** Las reservas se agotan exactamente en ``T``: ``\lambda > 0`` y ``S(T) = 0``. El precio sube a la tasa ``\rho`` y la extracción baja."
    md"""
    | | Valor |
    |:---|---:|
    | Precio sombra, ``\lambda`` (valor de ``t = 0``) | $(rd(r.λ)) |
    | Extracción inicial y final, ``q(0)`` y ``q(T)`` | $(rd(r.q(0.0))) y $(rd(r.q(r.T))) |
    | Fin de la extracción, ``\tau`` | $(r.τ < r.T ? rd(r.τ) : "no antes de T") |
    | Reservas al final, ``S(T)`` | $(rd(r.S(r.T))) |

    $caso

    La línea punteada de la derecha es ``\lambda e^{\rho t}``: mientras se
    extrae, el precio de mercado coincide con ella y **sube a la tasa de
    descuento** (regla de Hotelling). Baja ``S_0`` de 100 a 30 y súbelo a
    200: la escasez decide el precio sombra.
    """
end

#%% hide
md"""
## 2. ¿Cuánto vale una tonelada más bajo tierra?

El coestado es el precio sombra del estado: ``\lambda = \partial V/\partial S_0``,
donde ``V(S_0)`` es el bienestar óptimo. A la izquierda, ``\lambda`` para
cada nivel de reservas, con los ``\rho`` y ``a`` de la sección 1. A la
derecha, ``V(S_0)`` y la recta con pendiente ``\lambda`` en las reservas del
deslizador.
"""

#%% hide
let
    r = recurso
    Ss = range(5, 250, length = 120)
    λs = [hotelling(s; r.a, r.ρ, r.T).λ for s in Ss]
    g1 = plot(Ss, λs; color = NARANJA, lw = 2.5, xlabel = "reservas S₀", ylabel = "λ",
              title = "Precio sombra del recurso")
    scatter!(g1, [r.S0], [r.λ]; color = TINTA, ms = 5, msw = 0)
    vline!(g1, [r.a * r.T]; color = GRIS, ls = :dot, lw = 1)
    Vs = [valor(hotelling(s; r.a, r.ρ, r.T)) for s in Ss]
    g2 = plot(Ss, Vs; color = AZUL, lw = 2.5, xlabel = "reservas S₀", ylabel = "V(S₀)",
              title = "Valor óptimo y su pendiente")
    cerca = abs.(Ss .- r.S0) .< 60
    plot!(g2, Ss[cerca], valor(r) .+ r.λ .* (Ss[cerca] .- r.S0); color = NARANJA, lw = 1.5, ls = :dash)
    scatter!(g2, [r.S0], [valor(r)]; color = TINTA, ms = 5, msw = 0)
    plot(g1, g2; layout = (1, 2), size = (780, 320))
end

#%% hide
let
    r = recurso
    vmas = valor(hotelling(r.S0 + 1; r.a, r.ρ, r.T))
    vmenos = valor(hotelling(r.S0 - 1; r.a, r.ρ, r.T))
    md"""
    | | Valor |
    |:---|---:|
    | Coestado, ``\lambda`` | $(round(r.λ, sigdigits = 5)) |
    | ``(V(S_0 + 1) - V(S_0 - 1))/2`` | $(round((vmas - vmenos) / 2, sigdigits = 5)) |

    El precio sombra es cero mientras el recurso sobra (a la derecha de la
    línea punteada, ``S_0 \ge aT``) y crece a medida que escasea. ``V(S_0)``
    es cóncava: cada tonelada adicional vale menos que la anterior. Un
    ``\lambda`` positivo dice cuánto bienestar, en valor de hoy, le da a la
    región una tonelada más en el subsuelo.
    """
end

#%% hide
md"""
## 3. La condición 1: ``q`` maximiza ``H``

En cada instante, el control maximiza el Hamiltoniano
``H(q) = e^{-\rho t}B(q) - \lambda q`` sobre ``q \ge 0``. La gráfica muestra
``H`` como función de ``q`` en el instante elegido, con el ``\lambda`` de la
sección 1, y marca su máximo.

Instante ``t``: $(@bind t_h Slider(0.0:0.5:20.0, default = 5.0, show_value = true))
"""

#%% hide
let
    r = recurso
    qs = range(0, 1.2r.a, length = 300)
    H(q) = exp(-r.ρ * t_h) * (r.a * q - q^2 / 2) - r.λ * q
    qopt = r.q(t_h)
    p = plot(qs, H.(qs); color = AZUL, lw = 2.5, xlabel = "extracción q", ylabel = "H(q)",
             title = "Hamiltoniano en t = $t_h", size = (640, 320))
    hline!(p, [0]; color = GRIS, lw = 0.5)
    scatter!(p, [qopt], [H(qopt)]; color = NARANJA, ms = 7, msw = 0)
    p
end

#%% hide
md"""
Antes de ``\tau``, el máximo es interior y ahí ``\partial H/\partial q = 0``:
``e^{-\rho t}B'(q) = \lambda``. Si el recurso es muy escaso (prueba
``S_0 = 30``) y ``t > \tau``, ``H`` es decreciente desde ``q = 0``: el máximo
está en la esquina, ``q = 0``, con ``\partial H/\partial q < 0``. La
ecuación de Euler no encuentra esta solución; el principio del máximo sí.
"""

#%% hide
md"""
## 4. Condiciones terminales

El ejemplo de las notas (sección 3): ``\max \int_0^2 (y - u^2/2)\, dt`` con
``y' = u`` e ``y(0) = 0``. Las condiciones dan ``u = \lambda`` y
``\lambda(t) = \lambda(2) + 2 - t``. Lo único que cambia con la condición
final es ``\lambda(2)``:

- ``y(2)`` libre: ``\lambda(2) = 0``.
- ``y(2) \ge y_{\min}``: ``\lambda(2) \ge 0`` con holgura complementaria.
- ``y(2) = y_{\min}`` fijo: ``\lambda(2)`` es el que cumple esa condición, sin
  importar su signo.

Estado mínimo al final, ``y_{\min}``: $(@bind ymin Slider(0.0:0.25:4.0, default = 3.0, show_value = true))
"""

#%% hide
let
    ts = range(0, 2, length = 200)
    casos = [("libre", 0.0, GRIS), ("y(2) ≥ y_min", max(0, (ymin - 2) / 2), NARANJA),
             ("y(2) = y_min", (ymin - 2) / 2, AZUL)]
    g1 = plot(; xlabel = "t", ylabel = "y(t)", title = "Estado", legend = :topleft)
    g2 = plot(; xlabel = "t", ylabel = "λ(t)", title = "Coestado")
    for (i, (nombre, k, color)) in enumerate(casos)
        plot!(g1, ts, k .* ts .+ 2ts .- ts .^ 2 ./ 2; color, lw = 4 - i, label = nombre)
        plot!(g2, ts, k .+ 2 .- ts; color, lw = 4 - i)
    end
    hline!(g1, [ymin]; color = GRIS, ls = :dot, lw = 1, label = "")
    hline!(g2, [0]; color = GRIS, lw = 0.5)
    plot(g1, g2; layout = (1, 2), size = (780, 320))
end

#%% hide
md"""
Sin restricción, ``y(2) = 2``. Si ``y_{\min} \le 2``, la restricción
``y(2) \ge y_{\min}`` no está activa: la curva naranja coincide con la gris
y ``\lambda(2) = 0``. Si ``y_{\min} > 2``, se activa: ``\lambda(2) =
(y_{\min} - 2)/2 > 0``, el precio de exigir una unidad más al final. Con
``y_{\min} < 2`` y el estado final **fijo** (azul), ``\lambda(2) < 0``:
obligar a terminar con menos de lo que convendría tiene un precio negativo.
Es Kuhn-Tucker en el instante final (sesión 2).
"""

#%% hide
md"""
## 5. [Avanzado] Hamiltoniano lineal: bang-bang

Chiang (sec. 7.2, ejemplo 2): ``\max \int_0^2 (2y - 3u)\, dt`` con
``y' = y + u``, ``y(0) = 4``, ``y(2)`` libre y ``u \in [0, 2]``. El
Hamiltoniano ``H = (2 + \lambda)y + (\lambda - 3)u`` es **lineal** en ``u``:
el máximo está en un extremo, ``u = 2`` si ``\lambda > 3`` y ``u = 0`` si
``\lambda < 3``. La **función de cambio** es ``\partial H/\partial u = \lambda - 3``.
Con ``\lambda' = -(2 + \lambda)`` y ``\lambda(2) = 0``,
``\lambda(t) = 2e^{2 - t} - 2``.
"""

#%% hide
let
    ts = range(0, 2, length = 400)
    ts_c = 2 - log(2.5)
    λ(t) = 2exp(2 - t) - 2
    u(t) = λ(t) > 3 ? 2.0 : 0.0
    y(t) = t <= ts_c ? 6exp(t) - 2 : (6exp(ts_c) - 2) * exp(t - ts_c)
    g1 = plot(ts, λ.(ts) .- 3; color = AZUL, lw = 2.5, xlabel = "t", ylabel = "λ(t) − 3",
              title = "Función de cambio")
    hline!(g1, [0]; color = GRIS, lw = 0.5)
    g2 = plot(ts, u.(ts); color = NARANJA, lw = 2.5, xlabel = "t", ylabel = "u(t)",
              title = "Control", ylims = (-0.2, 2.2), linetype = :steppost)
    g3 = plot(ts, y.(ts); color = TINTA, lw = 2.5, xlabel = "t", ylabel = "y(t)", title = "Estado")
    foreach(g -> vline!(g, [ts_c]; color = GRIS, ls = :dot, lw = 1), (g1, g2, g3))
    plot(g1, g2, g3; layout = (1, 3), size = (860, 290))
end

#%% hide
md"""
El control salta de ``u = 2`` a ``u = 0`` en ``t = 2 - \ln 2.5 \approx 1.08``,
cuando la función de cambio cruza el cero. Al principio, una unidad de
estado vale mucho (``\lambda`` grande) porque todavía tiene tiempo de
crecer; cerca del final vale poco, porque ``\lambda(2) = 0``. Es la
estructura de la sesión 13 y del reparto ``\theta(t) \in [0, 1]`` entre dos
regiones de la sesión 14.
"""

#%% hide
md"""
## Resumen

| Herramienta | Qué dice | En este cuaderno |
|---|---|---|
| Hamiltoniano | ``H = F + \lambda f``: beneficio de hoy más el valor del cambio del estado | Secciones 1 y 3 |
| Condición 1 | ``u`` maximiza ``H``; puede haber esquinas | ``q = 0`` después de ``\tau``; bang-bang |
| Coestado | ``\lambda' = -H_y``; en el recurso, constante | Sección 1 |
| Hotelling | El precio sube a la tasa ``\rho`` mientras se extrae | Línea punteada, sección 1 |
| Transversalidad | ``\lambda(T) = 0``, holgura complementaria o estado fijo | Sección 4 |
| Precio sombra | ``\lambda = \partial V/\partial y``; cero si el recurso sobra | Sección 2 |

## Ejercicios

### Completa el código

**1.** Escribe `extraccion(t, λ)`, la extracción óptima en el instante ``t``
con precio sombra ``\lambda``, para ``a = 10``, ``b = 1`` y ``\rho = 0.05``.
No olvides que ``q \ge 0``.
"""

#%%
function extraccion(t, λ)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> [extraccion(0.0, 2.0), extraccion(10.0, 2.0), extraccion(15.0, 5.0)],
          [8.0, 10 - 2exp(0.5), 0.0];
          pista = md"De ``e^{-\rho t}(a - q) = \lambda``: `max(0.0, 10 - λ * exp(0.05t))`.")

#%% hide
md"""
**2.** Escribe `lambda_recurso(S0)`, que encuentre por bisección el precio
sombra con ``a = 10``, ``\rho = 0.05`` y ``T = 20``. Usa `extraido(λ)`, que
devuelve la extracción total ``\int_0^T q\, dt`` con ese ``\lambda``. Si
`extraido(0.0) <= S0`, el recurso sobra y ``\lambda = 0``; si no, busca entre
0 y 10.
"""

#%%
function lambda_recurso(S0)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> lambda_recurso.([30.0, 100.0, 150.0, 250.0]),
          [hotelling(s; a = 10.0, ρ = 0.05, T = 20.0).λ for s in (30.0, 100.0, 150.0, 250.0)];
          rtol = 1e-6,
          pista = md"`extraido(0.0) <= S0 && return 0.0`; después, con `lo, hi = 0.0, 10.0`, repite unas 60 veces: `m = (lo + hi) / 2`; si `extraido(m) > S0`, el precio es demasiado bajo (se extrae de más) y `lo = m`; si no, `hi = m`.")

#%% hide
md"""
**3.** Escribe `lambda_final(ymin)`, el valor de ``\lambda(2)`` en el
ejemplo de la sección 4 con la condición ``y(2) \ge y_{\min}``.
"""

#%%
lambda_final(ymin) = missing  # reemplaza missing

#%% hide
verificar(() -> lambda_final.([1.0, 2.0, 3.0, 4.0]), [0.0, 0.0, 0.5, 1.0];
          pista = md"Con ``\lambda(2) = k``, ``y(2) = 2k + 2``. Si la solución libre (``k = 0``) cumple ``y(2) \ge y_{\min}``, ``k = 0``; si no, ``2k + 2 = y_{\min}``: `max(0.0, (ymin - 2) / 2)`.")

#%% hide
md"""
**4. [Avanzado]** Escribe `coestado_bb(t)`, la solución de
``\lambda' = -(2 + \lambda)`` con ``\lambda(2) = 0`` del problema de la
sección 5.
"""

#%%
coestado_bb(t) = missing  # reemplaza missing

#%% hide
verificar(() -> coestado_bb.([0.0, 1.0, 2.0]), [2exp(2) - 2, 2exp(1) - 2, 0.0];
          pista = md"Con ``z = 2 + \lambda``, ``z' = -z``, así que ``z(t) = z(2)e^{2-t} = 2e^{2-t}``: `2exp(2 - t) - 2`.")

#%% hide
md"""
### Interpretación

5. En la sección 1, la demanda no cambia con el tiempo. ¿Por qué entonces
   la extracción óptima baja año con año?
6. Con ``S_0 = 250``, ``\lambda = 0``. ¿Qué significa que una tonelada más
   no valga nada? ¿Le serviría a esa región una política de conservación?
7. Sube ``\rho``. ¿Qué pasa con la extracción inicial y con ``\lambda``?
   Compáralo con el gasto del fondo regional de la sesión 10 cuando el
   gobierno es impaciente.

### Tu tesis

8. En tu problema, ¿cuál es el estado, cuál el control y qué condición
   final tiene? ¿Qué mide el coestado, en palabras, y en qué unidades?

### [Avanzado]

9. En la sección 3, con ``S_0 = 30`` y ``t > \tau``, ``\partial H/\partial q < 0``
   en ``q = 0``. ¿Por qué esto no contradice que ``q = 0`` sea óptimo?
10. En la sección 5, ¿por qué el cambio ocurre antes de ``t = 2``? ¿Qué
    pasaría con el instante de cambio si el horizonte fuera más largo?

## Para la próxima sesión

- **Sesión 12: Horizonte infinito y descuento.** El Hamiltoniano a valor
  presente, la transversalidad en horizonte infinito y el modelo de Ramsey
  calibrado para México.
- Repaso: C.B3 y C.B4 (exponencial e integrales), A.B3 (series y
  descuento), E.B2 (tasas de crecimiento con datos), L.I1 y L.I2
  (eigenvalores), D.I2, D.I6 y D.I7 (diagramas de fase y valor en la
  frontera), N.I1 (bisección y Newton), N.I3 (DifferentialEquations.jl),
  E.I3 (calibración) y N.I7 (datos en Julia). Para los puntos [Avanzado]:
  D.A2, A.A5 y N.A1.
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
    using PlutoUI, Plots, Markdown
    gr()
    default(size = (720, 320), legend = false, grid = :y, gridalpha = 0.15,
            framestyle = :axes, titlefontsize = 11, guidefontsize = 9,
            tickfontsize = 8, legendfontsize = 8, foreground_color_legend = nothing,
            background_color_legend = nothing, margin = 3Plots.mm)
end

#%%
begin
    const AZUL    = "#2a78d6"   # reservas, valor óptimo, Hamiltoniano
    const NARANJA = "#eb6834"   # extracción, precio sombra, óptimo
    const GRIS    = "#52514e"   # referencias
    const TINTA   = "#0b0b0b"   # precio de mercado, estado
end;

#%%
"Integral de f en [0, T] con la regla de Simpson y n tramos (n par)."
function integral(f, T; n = 2000)
    h = T / n
    h / 3 * (f(0.0) + f(T) + 4sum(f((2i - 1) * h) for i in 1:n ÷ 2) + 2sum(f(2i * h) for i in 1:n ÷ 2 - 1))
end

#%%
"""
Extracción total en [0, T] con precio sombra λ y demanda p = a - bq: la
extracción es positiva hasta τ = min(T, ln(a/λ)/ρ).
"""
function total_extraido(λ; a, b = 1.0, ρ, T)
    λ >= a && return 0.0
    τ = λ <= 0 ? T : min(T, log(a / λ) / ρ)
    (a * τ - λ * (exp(ρ * τ) - 1) / ρ) / b
end

#%%
"""
Solución del recurso no renovable con B(q) = aq - bq²/2: precio sombra λ
(por bisección), fin de la extracción τ, y las funciones q(t), S(t) y el
precio p(t) = a - bq(t).
"""
function hotelling(S0; a, b = 1.0, ρ, T)
    λ = if total_extraido(0.0; a, b, ρ, T) <= S0
        0.0                                  # el recurso sobra
    else
        lo, hi = 0.0, a
        for _ in 1:200
            m = (lo + hi) / 2
            total_extraido(m; a, b, ρ, T) > S0 ? (lo = m) : (hi = m)
        end
        (lo + hi) / 2
    end
    τ = λ <= 0 ? T : min(T, log(a / λ) / ρ)
    q(t) = max(0.0, (a - λ * exp(ρ * t)) / b)
    # Reservas: S0 menos lo extraído hasta t
    S(t) = S0 - (a * min(t, τ) - λ * (exp(ρ * min(t, τ)) - 1) / ρ) / b
    p(t) = a - b * q(t)
    (; S0, a, b, ρ, T, λ, τ, q, S, p)
end

#%%
"Bienestar óptimo del recurso: ∫ e^{-ρt} B(q(t)) dt."
valor(r) = integral(t -> exp(-r.ρ * t) * (r.a * r.q(t) - r.b * r.q(t)^2 / 2), r.T; n = 4000)

#%%
"Extracción total con precio sombra λ y los parámetros del ejercicio 2."
extraido(λ) = total_extraido(λ; a = 10.0, ρ = 0.05, T = 20.0)

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
