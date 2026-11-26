### A Pluto.jl notebook ###
# v1.0.4

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    return quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 1d4da5aa-cf07-11f1-89ad-0bdbf6461250
begin
    # Usa el entorno del curso (Code/Project.toml) en lugar del gestor de
    # paquetes propio de Pluto: un solo entorno para todo el repositorio.
    import Pkg
    Pkg.activate(@__DIR__)
    Pkg.instantiate()
    using PlutoUI, Plots, CSV, DataFrames, Statistics, LinearAlgebra, Markdown
    gr()
    default(size = (720, 320), legend = false, grid = :y, gridalpha = 0.15,
            framestyle = :axes, titlefontsize = 11, guidefontsize = 9,
            tickfontsize = 8, legendfontsize = 8, foreground_color_legend = nothing,
            background_color_legend = nothing, margin = 3Plots.mm)
end

# ╔═╡ 1d4da418-cf07-11f1-aa1d-afff8038c861
md"""
# Sesión 12: Horizonte infinito y Ramsey calibrado para México

**Pregunta de la unidad.** ¿Conviene invertir primero donde se ahorra más o
donde se produce más?

**Pregunta de la sesión.** Si México ahorrara de manera óptima, ¿cuánto
ahorraría y a qué velocidad cerraría una brecha de capital? ¿Se parece a
lo que muestran los datos?

**Cómo usar este cuaderno.** La primera hora de la clase es de pizarrón (el
Hamiltoniano a valor presente, la transversalidad y el modelo de Ramsey,
en las notas, `Class_notes/s12_horizonte_infinito.md`). La segunda hora
**sigue este cuaderno**: llega con los datos cargados y la calibración
hecha, y en clase se interpreta y se mueven los supuestos. Cada sección dice
en qué momento de la clase se usa y qué hacer. Pluto es reactivo: al
cambiar un supuesto, todo lo que depende de él se recalcula.

**Cómo abrirlo.** Desde la raíz del repositorio:
`julia --project=Code -e 'using Pluto; Pluto.run()'` y abrir
`Code/s12_ramsey.jl`.
"""

# ╔═╡ 1d4da474-cf07-11f1-b4cf-89c4ee091745
TableOfContents(title = "Contenido")

# ╔═╡ 1d4da47c-cf07-11f1-9b1e-7d00bd860864
md"""
## 1. El modelo

El modelo de Ramsey de la sección 4 de las notas, con producción
``f(k) = Ak^\alpha``, depreciación ``\delta``, crecimiento del empleo ``n`` y
utilidad CRRA con parámetro ``\theta``. El cuaderno usa la regla de
Keynes-Ramsey, el estado estacionario ``f'(k^\ast) = \delta + \rho`` y la
rama estable del punto de silla, todo derivado en el pizarrón.
"""

# ╔═╡ 1d4da486-cf07-11f1-b1ab-992ba0853921
md"""
## 2. Los datos: México en la Penn World Table

*Minutos 65–70* (notas, 5.1, lectura previa). Las series de
`Data/pwt_mexico.csv` (Penn World Table 11.0); la línea punteada de cada
gráfica es el promedio del periodo que usa la calibración.

Periodo de la calibración: $(@bind desde Select([1990 => "1990–2019", 2000 => "2000–2019", 1980 => "1980–2019", 1950 => "1950–2019"]))
"""

# ╔═╡ 1d4da490-cf07-11f1-93b2-1d3aa2684013
pwt = CSV.read(joinpath(@__DIR__, "..", "Data", "pwt_mexico.csv"), DataFrame)

# ╔═╡ 1d4da4c2-cf07-11f1-ab09-ff67f89188b0
md"""
## 3. La calibración

*Minutos 70–82* (notas, 5.2–5.4). ``\delta`` y ``n`` salen de los datos;
``\alpha``, de la participación del trabajo o del valor convencional;
``\rho``, de reproducir el ``K/Y`` de los datos; ``\theta`` se supone; ``A``
normaliza el producto de estado estacionario a 1.

Participación del capital, ``\alpha``: $(@bind fuente_α Select(["pwt" => "de la PWT: 1 − participación del trabajo", "convencional" => "convencional: 1/3"]))

Aversión a la variación del consumo, ``\theta``: $(@bind θ Slider(0.5:0.5:5.0, default = 2.0, show_value = true))
"""

# ╔═╡ 1d4da4e0-cf07-11f1-8572-6b0ed3e21b31
md"""
## 4. Diagrama de fase y transición

*Minutos 82–92.* El diagrama de fase calibrado: la isoclina ``k' = 0``
(azul), la recta ``c' = 0`` (punteada) y la rama estable (naranja), en
múltiplos del producto de estado estacionario. La economía empieza con una
fracción de ``k^\ast`` y consume lo que indica la rama estable.

Capital inicial, como fracción de ``k^\ast``: $(@bind k0_frac Slider(0.3:0.05:1.5, default = 0.5, show_value = true))
"""

# ╔═╡ 1d4da4fe-cf07-11f1-90fb-074a66ddc74d
md"""
1. **Observa** la tasa de ahorro durante la transición: ¿ahorra más una
   economía con poco capital? ¿Por qué?
2. **Mueve** ``k_0`` a 0.3 y a 1.5 de ``k^\ast``: ¿cuánto tarda en cerrarse
   la mitad de la brecha (línea vertical)?
"""

# ╔═╡ 1d4da506-cf07-11f1-981a-5f4902fcaa23
md"""
## 5. La transversalidad elige la rama

*Si alcanza (margen de la clase)* (notas, 4.5). Desde el mismo capital inicial, tres
consumos iniciales: el de la rama estable, uno 2% mayor y otro 2% menor. A
la derecha, el valor descontado del capital,
``e^{-(\rho - n)t}\mu(t)k(t)``, en escala logarítmica.
"""

# ╔═╡ 1d4da51c-cf07-11f1-9545-dbde997efd0b
md"""
**Observa** qué le pasa a cada trayectoria: ¿cuál deja de ser factible?
¿Cuál cumple todas las condiciones menos la transversalidad?
"""

# ╔═╡ 1d4da526-cf07-11f1-b124-978a805734ed
md"""
## Ejercicios

*Minutos 92–102, en parejas: ejercicio 1; el 2 y el 3, si alcanza.* Los ejercicios con
demostraciones están en las notas (sección 8).

### Completa el código

**1.** Escribe `rho_calibrado(α, δ, KY)`, la tasa de descuento con la que el
estado estacionario reproduce el cociente ``K/Y``.
"""

# ╔═╡ 1d4da530-cf07-11f1-93f0-b78ed1a28b95
rho_calibrado(α, δ, KY) = missing  # reemplaza missing

# ╔═╡ 1d4da544-cf07-11f1-83f9-939ac46f8ae5
md"""
**2.** Escribe `capital_ss(α, δ, ρ, A)`, el capital por trabajador de estado
estacionario con ``f(k) = Ak^\alpha``.
"""

# ╔═╡ 1d4da54e-cf07-11f1-b385-53f58e80a64d
capital_ss(α, δ, ρ, A) = missing  # reemplaza missing

# ╔═╡ 1d4da562-cf07-11f1-9547-f57b539355c9
md"""
**3.** Escribe `ahorro_ss(α, δ, n, ρ)`, la tasa de ahorro de estado
estacionario.
"""

# ╔═╡ 1d4da56c-cf07-11f1-bc53-03a013bbaef8
ahorro_ss(α, δ, n, ρ) = missing  # reemplaza missing

# ╔═╡ 1d4da578-cf07-11f1-842e-d971cc2aa5dd
md"""
**4. [Avanzado]** Escribe `beta_conv(α, δ, n, ρ, θ)`, la velocidad de
convergencia con Cobb-Douglas (notas, sección 4.6 y P.2). Puedes usar tu
`ahorro_ss`.
"""

# ╔═╡ 1d4da580-cf07-11f1-b341-dbfdc737778f
beta_conv(α, δ, n, ρ, θ) = missing  # reemplaza missing

# ╔═╡ 1d4da594-cf07-11f1-bf50-f7b20ea39a82
md"""
### Interpretación

5. El ahorro de estado estacionario del modelo se parece a la inversión
   observada. ¿Por qué eso no prueba que México ahorre de manera óptima?
6. Cambia la fuente de ``\alpha``. ¿Por qué el ``\rho`` calibrado cambia tanto?
   ¿Cuál de las dos calibraciones te parece más creíble y qué dato
   necesitarías para decidir?
7. El modelo predice que una brecha de capital se cierra a la mitad en 10 a
   17 años. En la sesión 5 no hubo convergencia absoluta entre los estados.
   Da dos razones posibles para la diferencia.

### Tu tesis

8. Hoy se entrega la propuesta de proyecto. En tu problema, ¿qué parámetros
   podrías obtener directamente de datos, cuáles tendrías que calibrar y con
   qué dato los calibrarías, y cuáles tendrías que suponer?

### [Avanzado]

9. En la sección 5, ¿por qué el valor descontado del capital crece despacio
   en la trayectoria de 2% menos? (Pista: compara la tasa de crecimiento de
   ``\mu`` cerca de ``k_{\max}`` con ``\rho - n``.)
10. Sube ``\theta`` y mira la vida media. ¿Por qué un planificador que no
    quiere que el consumo varíe prefiere una transición lenta?

## Para la próxima sesión

- **Sesión 13: Varias variables de estado y de control.** Control acotado,
  soluciones bang-bang y condiciones suficientes de Mangasarian y Arrow.
- Repaso: C.B2 (máximos), C.I2 (concavidad) y L.I4 (formas cuadráticas y
  definitud). Para los puntos [Avanzado]: C.A4 (concavidad y maximización
  parcial).
"""

# ╔═╡ 1d4da59e-cf07-11f1-8449-75c5cd42e514
md"""
---
## Apéndice: paquetes y funciones auxiliares

Estas celdas definen herramientas que usa el cuaderno. No es necesario
leerlas para seguir la sesión.
"""

# ╔═╡ 1d4da5b2-cf07-11f1-89a0-fdbf5aafc96d
begin
    const AZUL    = "#2a78d6"   # capital, isoclina k' = 0
    const NARANJA = "#eb6834"   # rama estable, ahorro
    const GRIS    = "#52514e"   # referencias
    const TINTA   = "#0b0b0b"   # producto, punto inicial
end;

# ╔═╡ 1d4da5b2-cf07-11f1-b58b-09ecfc6412cc
"""
Promedios y tasas de crecimiento de la PWT entre los años `desde` y `hasta`:
participación del trabajo, depreciación, crecimiento del empleo, K/Y,
inversión entre producto y crecimiento del producto por trabajador.
"""
function momentos(pwt, desde, hasta)
    d = filter(r -> desde <= r.año <= hasta, pwt)
    años = hasta - desde
    crec(x) = (log(x[end]) - log(x[1])) / años
    (; desde, hasta, labsh = mean(d.labsh), δ = mean(d.delta), n = crec(d.emp),
     KY = mean(d.rnna ./ d.rgdpna), s = mean(d.csh_i), gy = crec(d.rgdpna ./ d.emp))
end

# ╔═╡ 1d4da49a-cf07-11f1-9a46-cf7cd8e7ed1b
datos = momentos(pwt, desde, 2019)

# ╔═╡ 1d4da4a2-cf07-11f1-bf59-ef03beb128a9
let
    d = filter(r -> r.año <= 2019, pwt)
    periodo(g) = vspan!(g, [desde, 2019]; color = GRIS, alpha = 0.08)
    g1 = plot(d.año, d.rnna ./ d.rgdpna; color = AZUL, lw = 2, title = "Capital entre producto, K/Y")
    hline!(g1, [datos.KY]; color = AZUL, ls = :dot)
    g2 = plot(d.año, 100 .* d.csh_i; color = NARANJA, lw = 2, title = "Inversión entre producto (%)")
    hline!(g2, [100datos.s]; color = NARANJA, ls = :dot)
    g3 = plot(d.año, d.labsh; color = TINTA, lw = 2, title = "Participación del trabajo")
    hline!(g3, [datos.labsh]; color = TINTA, ls = :dot)
    g4 = plot(d.año, d.rgdpna ./ d.emp ./ 1000; color = GRIS, lw = 2,
              title = "Producto por trabajador (miles de USD)")
    foreach(periodo, (g1, g2, g3, g4))
    plot(g1, g2, g3, g4; layout = (2, 2), size = (800, 520))
end

# ╔═╡ 1d4da4b8-cf07-11f1-85ec-9dd5e90fdda2
let
    d = datos
    pct(v) = string(round(100v, digits = 2), "%")
    md"""
    | Dato ($(desde)–2019) | Valor |
    |:---|---:|
    | Participación del trabajo, `labsh` | $(round(d.labsh, digits = 3)) |
    | Depreciación, `delta` | $(round(d.δ, digits = 4)) |
    | Crecimiento del empleo, ``n`` | $(pct(d.n)) anual |
    | Capital entre producto, ``K/Y`` | $(round(d.KY, digits = 2)) |
    | Inversión entre producto, `csh_i` | $(pct(d.s)) |
    | Crecimiento del producto por trabajador | $(pct(d.gy)) anual |

    1. **Observa** el producto por trabajador desde 1980: ¿crece? ¿Qué
       implica para el modelo?
    2. **Compara** ``K/Y`` con el producto por trabajador: ¿qué acumuló
       México sin que el producto creciera?
    3. **Cambia** el periodo a 1950–2019: ¿qué pasa con la participación del
       trabajo antes de 1994? (Notas, 5.1.)
    """
end

# ╔═╡ 1d4da5bc-cf07-11f1-8155-2573c5be04d6
"""
Calibración de Ramsey: ρ reproduce el K/Y de los datos y A normaliza el
producto de estado estacionario a 1 (así k* = K/Y).
"""
function calibrar(m; α, θ)
    ρ = α / m.KY - m.δ
    A = m.KY^(-α)
    (; α, θ, δ = m.δ, n = m.n, ρ, A, KY = m.KY, sstar = (m.δ + m.n) * m.KY)
end

# ╔═╡ 1d4da4cc-cf07-11f1-b669-d50b4c65f1ee
cal = calibrar(datos; α = fuente_α == "pwt" ? 1 - datos.labsh : 1 / 3, θ)

# ╔═╡ 1d4da5c6-cf07-11f1-be21-a1f1ed1e7ead
"Un paso de Runge-Kutta de cuarto orden para ż = F(z) (dt negativo integra hacia atrás)."
function paso_rk4(F, z, dt)
    k1 = F(z); k2 = F(z .+ dt / 2 .* k1); k3 = F(z .+ dt / 2 .* k2); k4 = F(z .+ dt .* k3)
    z .+ dt / 6 .* (k1 .+ 2k2 .+ 2k3 .+ k4)
end

# ╔═╡ 1d4da5d0-cf07-11f1-8da0-0144e5f8f20f
"Trayectoria de ż = F(z) desde z0 durante T (o hasta que `parar(z)` sea verdadero)."
function trayectoria(F, z0, T; dt = 0.05, parar = z -> false)
    z = float.(z0)
    pts = [z]
    for _ in 1:round(Int, abs(T) / dt)
        z = paso_rk4(F, z, sign(T) * dt)
        (any(isnan, z) || parar(z)) && break
        push!(pts, z)
    end
    pts
end

# ╔═╡ 1d4da5dc-cf07-11f1-8374-35a7a2a8d8f5
"""
Modelo de Ramsey calibrado: campo, estado estacionario, velocidad de
convergencia β y las dos mitades de la rama estable (calculadas hacia atrás
desde el punto de silla, con paso dt), además de la rama ordenada por k.
"""
function modelo_ramsey(c; dt = 0.05)
    (; α, θ, δ, n, ρ, A) = c
    f(k) = A * max(k, 1e-12)^α
    F(z) = (k = max(z[1], 1e-12); [A * k^α - (δ + n) * z[1] - z[2], z[2] / θ * (α * A * k^(α - 1) - δ - ρ)])
    kstar = (α * A / (δ + ρ))^(1 / (1 - α))
    cstar = f(kstar) - (δ + n) * kstar
    J = [ρ-n -1.0; cstar * α * (α - 1) * A * kstar^(α - 2) / θ 0.0]
    λ, V = eigen(J)
    vs = real.(V[:, argmin(real.(λ))])
    vs = vs[1] > 0 ? vs : -vs                     # apunta hacia k mayor
    dentro(z) = 0.05kstar <= z[1] <= 3kstar && 0 < z[2] <= 3cstar
    ramas = [trayectoria(F, [kstar, cstar] .+ s * 1e-6 .* vs, -5000.0; dt, parar = !dentro) for s in (-1, 1)]
    pts = vcat(reverse(ramas[1]), ramas[2])
    orden = sortperm(first.(pts))
    (; α, θ, δ, n, ρ, A, f, F, kstar, cstar, β = -minimum(real.(λ)), dt,
     izquierda = ramas[1], derecha = ramas[2], rama_k = first.(pts[orden]), rama_c = last.(pts[orden]))
end

# ╔═╡ 1d4da4cc-cf07-11f1-af9f-d7da25c967ae
ramsey = modelo_ramsey(cal)

# ╔═╡ 1d4da4d4-cf07-11f1-81f1-cddf6aa594ae
let
    c = cal
    r = ramsey
    pct(v) = string(round(100v, digits = 1), "%")
    aviso = c.ρ > c.n ? md"" :
        md"**Atención:** con estos datos, ``\rho \le n``: la utilidad total no converge y el modelo no tiene solución. Cambia el periodo o ``\alpha``."
    md"""
    | Parámetro o resultado | Valor |
    |:---|---:|
    | ``\alpha`` | $(round(c.α, digits = 3)) |
    | ``\delta``, ``n`` | $(round(c.δ, digits = 4)), $(round(c.n, digits = 4)) |
    | ``\rho`` calibrado ``= \alpha/(K/Y) - \delta`` | $(pct(c.ρ)) |
    | Rendimiento neto del capital, ``f'(k^\ast) - \delta`` | $(pct(c.ρ)) |
    | Ahorro de estado estacionario, ``s^\ast = (\delta + n)K/Y`` | $(pct(c.sstar)) (datos: $(pct(datos.s))) |
    | Consumo entre producto, ``c^\ast/y^\ast`` | $(pct(1 - c.sstar)) |
    | Velocidad de convergencia, ``\beta`` | $(pct(r.β)) anual |
    | Vida media de la brecha, ``\ln 2/\beta`` | $(round(log(2) / r.β, digits = 1)) años |

    $aviso

    1. **Compara** el ahorro del modelo con el de los datos. ¿Prueba que
       México ahorra de manera óptima? (Pista: ¿de qué depende ``s^\ast``?)
    2. **Cambia** ``\alpha`` a 1/3: ¿cuánto cambia el ``\rho`` calibrado? ¿Por
       qué tanto?
    3. **Sube** ``\theta``: ¿qué cambia, el estado estacionario o la
       velocidad de convergencia?
    4. **Compara** la vida media con la convergencia que se midió entre los
       estados en la sesión 5.
    """
end

# ╔═╡ 1d4da5e4-cf07-11f1-9913-8b5d6942e0e7
"Consumo de la rama estable para el capital k (interpolación lineal)."
function politica(r, k)
    i = clamp(searchsortedlast(r.rama_k, k), 1, length(r.rama_k) - 1)
    w = (k - r.rama_k[i]) / (r.rama_k[i + 1] - r.rama_k[i])
    (1 - w) * r.rama_c[i] + w * r.rama_c[i + 1]
end

# ╔═╡ 1d4da4ea-cf07-11f1-ae39-0b46d296a836
let
    r = ramsey
    k0 = k0_frac * r.kstar
    kmax = 2.4r.kstar
    p = plot(; xlims = (0, kmax), ylims = (0, 1.6r.cstar), xlabel = "capital por trabajador k",
             ylabel = "consumo por trabajador c", title = "Ramsey calibrado", size = (700, 420))
    ks = range(0.01, kmax, length = 300)
    plot!(p, ks, r.f.(ks) .- (r.δ + r.n) .* ks; color = AZUL, lw = 2)
    vline!(p, [r.kstar]; color = AZUL, lw = 1.5, ls = :dash)
    plot!(p, r.rama_k, r.rama_c; color = NARANJA, lw = 3)
    scatter!(p, [k0], [politica(r, k0)]; color = TINTA, ms = 6, msw = 0)
    scatter!(p, [r.kstar], [r.cstar]; color = :white, markerstrokecolor = TINTA, ms = 7, msw = 1.5)
end

# ╔═╡ 1d4da5e4-cf07-11f1-b03f-692ca4660afd
"""
Trayectoria óptima desde k0: la mitad de la rama estable del lado de k0,
recorrida hacia el estado estacionario; después, el estado estacionario.
"""
function camino(r, k0; horizonte = 80.0)
    rama = k0 < r.kstar ? r.izquierda : r.derecha
    i = findfirst(z -> k0 < r.kstar ? z[1] <= k0 : z[1] >= k0, rama)
    pts = i === nothing ? [[r.kstar, r.cstar]] : reverse(rama[1:i])
    n = round(Int, horizonte / r.dt) + 1
    pts = length(pts) >= n ? pts[1:n] : vcat(pts, fill([r.kstar, r.cstar], n - length(pts)))
    t = r.dt .* (0:n - 1)
    t, first.(pts), last.(pts)
end

# ╔═╡ 1d4da4f4-cf07-11f1-a3b6-5d98575c270c
let
    r = ramsey
    t, k, c = camino(r, k0_frac * r.kstar; horizonte = 80.0)
    y = r.f.(k)
    vm = log(2) / r.β
    g1 = plot(t, k ./ r.kstar; color = AZUL, lw = 2.5, xlabel = "años", ylabel = "k/k*",
              title = "Capital (fracción de k*)")
    g2 = plot(t, 100 .* (1 .- c ./ y); color = NARANJA, lw = 2.5, xlabel = "años",
              ylabel = "ahorro (%)", title = "Tasa de ahorro")
    hline!(g2, [100cal.sstar]; color = GRIS, ls = :dot, lw = 1)
    g3 = plot(t, y; color = TINTA, lw = 2.5, xlabel = "años", ylabel = "y", title = "Producto por trabajador")
    foreach(g -> vline!(g, [vm]; color = GRIS, ls = :dot, lw = 1), (g1, g2, g3))
    plot(g1, g2, g3; layout = (1, 3), size = (860, 300))
end

# ╔═╡ 1d4da5ee-cf07-11f1-a9c7-41a4307f509e
"Valor descontado del capital, e^{-(ρ-n)t} u'(c) k, en el instante t y el punto z = (k, c)."
tvc(r, t, z) = exp(-(r.ρ - r.n) * t) * z[2]^(-r.θ) * z[1]

# ╔═╡ 1d4da512-cf07-11f1-935d-e17b3c9ce012
let
    r = ramsey
    k0 = k0_frac * r.kstar
    c0 = politica(r, k0)
    g1 = plot(; xlabel = "k", ylabel = "c", title = "Tres consumos iniciales", xlims = (0, 3r.kstar),
              ylims = (0, 1.6r.cstar))
    plot!(g1, r.rama_k, r.rama_c; color = NARANJA, lw = 1, alpha = 0.5)
    g2 = plot(; xlabel = "años", ylabel = "valor descontado del capital", title = "Condición de transversalidad",
              yscale = :log10, legend = :bottomleft)
    for (x, color, nombre) in ((1.02, AZUL, "2% más"), (0.98, TINTA, "2% menos"))
        tr = trayectoria(r.F, [k0, x * c0], 400.0; parar = z -> z[1] < 0.01r.kstar || z[2] < 1e-12)
        ts = 0.05 .* (0:length(tr) - 1)
        plot!(g1, first.(tr), last.(tr); color, lw = 2)
        plot!(g2, ts, tvc.(Ref(r), ts, tr); color, lw = 2, label = nombre)
    end
    t, k, c = camino(r, k0; horizonte = 400.0)
    plot!(g1, k, c; color = NARANJA, lw = 2.5)
    plot!(g2, t, tvc.(Ref(r), t, [[ki, ci] for (ki, ci) in zip(k, c)]); color = NARANJA, lw = 2.5,
          label = "rama estable")
    plot(g1, g2; layout = (1, 2), size = (800, 330))
end

# ╔═╡ 1d4da5f8-cf07-11f1-a14f-6b1356b38f4f
"Velocidad de convergencia con Cobb-Douglas (notas, P.2)."
function beta_ref(α, δ, n, ρ, θ)
    s = α * (δ + n) / (δ + ρ)
    a = ρ - n
    (sqrt(a^2 + 4(1 - α) * (1 - s) * (δ + ρ)^2 / (α * θ)) - a) / 2
end

# ╔═╡ 1d4da602-cf07-11f1-8229-250338a602cc
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

# ╔═╡ 1d4da544-cf07-11f1-a301-6df595051bb1
verificar(() -> [rho_calibrado(0.646, 0.035, 3.66), rho_calibrado(1 / 3, 0.05, 3.0)],
          [0.646 / 3.66 - 0.035, 1 / 9 - 0.05];
          pista = md"En el estado estacionario, ``f'(k^\ast) = \alpha y^\ast/k^\ast = \alpha/(K/Y) = \delta + \rho``: `α / KY - δ`.")

# ╔═╡ 1d4da558-cf07-11f1-bb14-15582d8f19fd
verificar(() -> [capital_ss(0.3, 0.05, 0.03, 1.0), capital_ss(0.646, 0.035, 0.141, 2.0)],
          [(0.3 / 0.08)^(1 / 0.7), (0.646 * 2 / 0.176)^(1 / 0.354)];
          pista = md"De ``\alpha A k^{\alpha - 1} = \delta + \rho``: `(α * A / (δ + ρ))^(1 / (1 - α))`.")

# ╔═╡ 1d4da56c-cf07-11f1-983a-9b84e911cb35
verificar(() -> [ahorro_ss(0.3, 0.05, 0.01, 0.03), ahorro_ss(0.646, 0.035, 0.023, 0.141)],
          [0.3 * 0.06 / 0.08, 0.646 * 0.058 / 0.176];
          pista = md"El ahorro repone la depreciación y la dilución: ``s^\ast = (\delta + n)k^\ast/f(k^\ast)``, y ``k^\ast/f(k^\ast) = \alpha/(\delta + \rho)``: `α * (δ + n) / (δ + ρ)`.")

# ╔═╡ 1d4da58a-cf07-11f1-9f93-6348f68b19e1
verificar(() -> [beta_conv(0.646, 0.035, 0.023, 0.141, 2.0), beta_conv(0.3, 0.05, 0.01, 0.03, 1.0)],
          [beta_ref(0.646, 0.035, 0.023, 0.141, 2.0), beta_ref(0.3, 0.05, 0.01, 0.03, 1.0)];
          pista = md"Con `s = α * (δ + n) / (δ + ρ)` y `a = ρ - n`: `(sqrt(a^2 + 4(1 - α) * (1 - s) * (δ + ρ)^2 / (α * θ)) - a) / 2`.")

# ╔═╡ Cell order:
# ╟─1d4da418-cf07-11f1-aa1d-afff8038c861
# ╟─1d4da474-cf07-11f1-b4cf-89c4ee091745
# ╟─1d4da47c-cf07-11f1-9b1e-7d00bd860864
# ╟─1d4da486-cf07-11f1-b1ab-992ba0853921
# ╠═1d4da490-cf07-11f1-93b2-1d3aa2684013
# ╠═1d4da49a-cf07-11f1-9a46-cf7cd8e7ed1b
# ╟─1d4da4a2-cf07-11f1-bf59-ef03beb128a9
# ╟─1d4da4b8-cf07-11f1-85ec-9dd5e90fdda2
# ╟─1d4da4c2-cf07-11f1-ab09-ff67f89188b0
# ╠═1d4da4cc-cf07-11f1-b669-d50b4c65f1ee
# ╠═1d4da4cc-cf07-11f1-af9f-d7da25c967ae
# ╟─1d4da4d4-cf07-11f1-81f1-cddf6aa594ae
# ╟─1d4da4e0-cf07-11f1-8572-6b0ed3e21b31
# ╟─1d4da4ea-cf07-11f1-ae39-0b46d296a836
# ╟─1d4da4f4-cf07-11f1-a3b6-5d98575c270c
# ╟─1d4da4fe-cf07-11f1-90fb-074a66ddc74d
# ╟─1d4da506-cf07-11f1-981a-5f4902fcaa23
# ╟─1d4da512-cf07-11f1-935d-e17b3c9ce012
# ╟─1d4da51c-cf07-11f1-9545-dbde997efd0b
# ╟─1d4da526-cf07-11f1-b124-978a805734ed
# ╠═1d4da530-cf07-11f1-93f0-b78ed1a28b95
# ╟─1d4da544-cf07-11f1-a301-6df595051bb1
# ╟─1d4da544-cf07-11f1-83f9-939ac46f8ae5
# ╠═1d4da54e-cf07-11f1-b385-53f58e80a64d
# ╟─1d4da558-cf07-11f1-bb14-15582d8f19fd
# ╟─1d4da562-cf07-11f1-9547-f57b539355c9
# ╠═1d4da56c-cf07-11f1-bc53-03a013bbaef8
# ╟─1d4da56c-cf07-11f1-983a-9b84e911cb35
# ╟─1d4da578-cf07-11f1-842e-d971cc2aa5dd
# ╠═1d4da580-cf07-11f1-b341-dbfdc737778f
# ╟─1d4da58a-cf07-11f1-9f93-6348f68b19e1
# ╟─1d4da594-cf07-11f1-bf50-f7b20ea39a82
# ╟─1d4da59e-cf07-11f1-8449-75c5cd42e514
# ╠═1d4da5aa-cf07-11f1-89ad-0bdbf6461250
# ╠═1d4da5b2-cf07-11f1-89a0-fdbf5aafc96d
# ╠═1d4da5b2-cf07-11f1-b58b-09ecfc6412cc
# ╠═1d4da5bc-cf07-11f1-8155-2573c5be04d6
# ╠═1d4da5c6-cf07-11f1-be21-a1f1ed1e7ead
# ╠═1d4da5d0-cf07-11f1-8da0-0144e5f8f20f
# ╠═1d4da5dc-cf07-11f1-8374-35a7a2a8d8f5
# ╠═1d4da5e4-cf07-11f1-9913-8b5d6942e0e7
# ╠═1d4da5e4-cf07-11f1-b03f-692ca4660afd
# ╠═1d4da5ee-cf07-11f1-a9c7-41a4307f509e
# ╠═1d4da5f8-cf07-11f1-a14f-6b1356b38f4f
# ╠═1d4da602-cf07-11f1-8229-250338a602cc
