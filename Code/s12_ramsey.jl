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

# ╔═╡ 9d6ba3d2-ce8c-11f1-a330-bd7392482598
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

# ╔═╡ 9d6ba2f6-ce8c-11f1-967d-df8ac908d4fa
md"""
# Sesión 12: Horizonte infinito y Ramsey calibrado para México

**Pregunta de la unidad.** ¿Conviene invertir primero donde se ahorra más o
donde se produce más?

**Pregunta de la sesión.** Si México ahorrara de manera óptima, ¿cuánto
ahorraría y a qué velocidad cerraría una brecha de capital? ¿Se parece a
lo que muestran los datos?

**Objetivos de la sesión**
1. Usar el Hamiltoniano a valor presente y la transversalidad en horizonte
   infinito para derivar el modelo de Ramsey.
2. Calibrar el modelo con la Penn World Table: de dónde sale cada
   parámetro y cuál se elige para reproducir un dato.
3. Interpretar el estado estacionario calibrado, compararlo con los datos y
   ver cómo cambia con los supuestos.
4. Calcular la velocidad de convergencia que predice el modelo y
   compararla con la de la sesión 5.

**Cómo usar este cuaderno.** El cuaderno llega con los datos cargados y la
calibración hecha: en clase se interpreta y se mueven los supuestos. Pluto
es reactivo: al cambiar un supuesto, todo lo que depende de él se
recalcula. Las secciones marcadas **[Avanzado]** son opcionales. Las
demostraciones están en las notas formales,
`Class_notes/s12_horizonte_infinito.md`.

**Cómo abrirlo.** Desde la raíz del repositorio:
`julia --project=Code -e 'using Pluto; Pluto.run()'` y abrir
`Code/s12_ramsey.jl`.

**Repaso recomendado** (en `Class_notes/repaso/`): C.B3 y C.B4, A.B3
(descuento), E.B2 (tasas de crecimiento con datos), L.I1 y L.I2
(eigenvalores), D.I6 y D.I7 (diagramas de fase y valor en la frontera),
E.I3 (calibración) y N.I7 (datos en Julia). Para los puntos [Avanzado]:
D.A2, A.A5 y N.A1.
"""

# ╔═╡ 9d6ba328-ce8c-11f1-9325-6fe0041ed50f
TableOfContents(title = "Contenido")

# ╔═╡ 9d6ba328-ce8c-11f1-8940-0b42d2ee6a76
md"""
## 1. El modelo

Con capital por trabajador ``k``, producto ``f(k) = Ak^\alpha``, depreciación
``\delta``, crecimiento del empleo ``n`` y utilidad CRRA, el planificador
resuelve

```math
\max_c \int_0^\infty e^{-(\rho - n)t}\, \frac{c^{1-\theta} - 1}{1 - \theta}\, dt,
\qquad k' = f(k) - (\delta + n)k - c.
```

El Hamiltoniano a valor presente,
``H_c = u(c) + \mu\big(f(k) - (\delta + n)k - c\big)``, da
``u'(c) = \mu`` y ``\mu'/\mu = \rho + \delta - f'(k)``, de donde sale la regla
de Keynes-Ramsey:

```math
\frac{c'}{c} = \frac{f'(k) - \delta - \rho}{\theta}.
```

El estado estacionario cumple ``f'(k^\ast) = \delta + \rho`` y
``c^\ast = f(k^\ast) - (\delta + n)k^\ast``; la transversalidad,
``\lim e^{-(\rho - n)t}\mu(t)k(t) = 0``, elige la rama estable del punto de
silla (notas, sección 4).
"""

# ╔═╡ 9d6ba332-ce8c-11f1-986c-a1ff1e2498d9
md"""
## 2. Los datos: México en la Penn World Table

Las series vienen de `Data/pwt_mexico.csv` (Penn World Table 11.0). La
calibración usa los promedios del periodo elegido; la línea punteada de
cada gráfica es el valor que usa el modelo.

Periodo de la calibración: $(@bind desde Select([1990 => "1990–2019", 2000 => "2000–2019", 1980 => "1980–2019", 1950 => "1950–2019"]))
"""

# ╔═╡ 9d6ba33c-ce8c-11f1-af04-cb2f42379fcf
pwt = CSV.read(joinpath(@__DIR__, "..", "Data", "pwt_mexico.csv"), DataFrame)

# ╔═╡ 9d6ba34e-ce8c-11f1-bc5b-db6a9b6fb256
md"""
## 3. La calibración

- ``\delta`` y ``n`` salen directamente de los datos.
- ``\alpha`` es uno menos la participación del trabajo, o el valor
  convencional ``1/3`` (notas, sección 5.4).
- ``\rho`` se elige para que el estado estacionario reproduzca el ``K/Y`` de
  los datos: ``\rho = \alpha/(K/Y) - \delta``.
- ``\theta`` no se puede obtener de estos datos: se supone.
- ``A`` sólo fija las unidades: el producto de estado estacionario es 1.

Participación del capital, ``\alpha``: $(@bind fuente_α Select(["pwt" => "de la PWT: 1 − participación del trabajo", "convencional" => "convencional: 1/3"]))

Aversión a la variación del consumo, ``\theta``: $(@bind θ Slider(0.5:0.5:5.0, default = 2.0, show_value = true))
"""

# ╔═╡ 9d6ba364-ce8c-11f1-9c37-bddd03cbbeef
md"""
## 4. Diagrama de fase y transición

Una economía empieza con una fracción de su capital de estado estacionario
y consume lo que indica la rama estable. En el diagrama, la curva azul es la
isoclina ``k' = 0``, la recta punteada es ``c' = 0`` y la curva naranja es la
rama estable. Las unidades son múltiplos del producto de estado
estacionario.

Capital inicial, como fracción de ``k^\ast``: $(@bind k0_frac Slider(0.3:0.05:1.5, default = 0.5, show_value = true))
"""

# ╔═╡ 9d6ba378-ce8c-11f1-a867-255b3fccea9d
md"""
La línea vertical marca la vida media: el tiempo en que se cierra la mitad
de la brecha de capital. Una economía con poco capital **ahorra más** que en
el estado estacionario, porque ahí el capital rinde más (sesión 8). Con la
calibración base, la vida media es de 10 a 17 años, según ``\alpha``: el
modelo predice convergencia rápida. En la sesión 5, entre los estados de
México no hubo convergencia absoluta. ¿Qué le falta al modelo, o qué
distingue a los estados? (Notas, sección 5.4.)
"""

# ╔═╡ 9d6ba378-ce8c-11f1-afee-53c57749d332
md"""
## 5. [Avanzado] La transversalidad elige la rama

Desde el mismo capital inicial, tres consumos iniciales: el de la rama
estable y uno 2% mayor y otro 2% menor. Las tres trayectorias cumplen la
regla de Keynes-Ramsey y la ecuación del capital. La gráfica de la derecha
muestra el valor descontado del capital, ``e^{-(\rho - n)t}\mu(t)k(t)`` con
``\mu = u'(c) = c^{-\theta}``, en escala logarítmica.
"""

# ╔═╡ 9d6ba380-ce8c-11f1-aef9-7bc41f11f347
md"""
Con 2% más, el capital se agota en pocas décadas y la trayectoria termina:
no es factible. Con 2% menos, el consumo cae hacia cero, el capital se
acerca a ``k_{\max}`` y el valor descontado del capital **deja de bajar y
crece**: viola la transversalidad. Sobre la rama estable tiende a cero. La
transversalidad es la condición terminal que elige ``c_0`` (notas, sección
4.5).
"""

# ╔═╡ 9d6ba396-ce8c-11f1-93a4-535470a0aeae
md"""
## Resumen

| Herramienta | Qué dice | En este cuaderno |
|---|---|---|
| Hamiltoniano a valor presente | ``\mu' = \rho\mu - \partial H_c/\partial y``; sistema autónomo | Sección 1 |
| Regla de oro modificada | ``f'(k^\ast) = \delta + \rho`` | Recta punteada del diagrama |
| Calibración | ``\rho = \alpha/(K/Y) - \delta`` reproduce el ``K/Y`` de los datos | Sección 3 |
| Ahorro de estado estacionario | ``s^\ast = (\delta + n)K/Y``: identidad, no prueba de optimalidad | Tabla de la sección 3 |
| Velocidad de convergencia | ``\beta``, el eigenvalor estable; vida media ``\ln 2/\beta`` | Sección 4 |
| Transversalidad | Elige la rama estable | Sección 5 |

## Ejercicios

### Completa el código

**1.** Escribe `rho_calibrado(α, δ, KY)`, la tasa de descuento con la que el
estado estacionario reproduce el cociente ``K/Y``.
"""

# ╔═╡ 9d6ba396-ce8c-11f1-af86-2dd7ce1d5d99
rho_calibrado(α, δ, KY) = missing  # reemplaza missing

# ╔═╡ 9d6ba3a0-ce8c-11f1-8a6d-8b16a0436953
md"""
**2.** Escribe `capital_ss(α, δ, ρ, A)`, el capital por trabajador de estado
estacionario con ``f(k) = Ak^\alpha``.
"""

# ╔═╡ 9d6ba3aa-ce8c-11f1-9da3-b96c8d0836ba
capital_ss(α, δ, ρ, A) = missing  # reemplaza missing

# ╔═╡ 9d6ba3aa-ce8c-11f1-9824-4d84e6e5fc02
md"""
**3.** Escribe `ahorro_ss(α, δ, n, ρ)`, la tasa de ahorro de estado
estacionario.
"""

# ╔═╡ 9d6ba3b4-ce8c-11f1-a34a-43ea3be0e977
ahorro_ss(α, δ, n, ρ) = missing  # reemplaza missing

# ╔═╡ 9d6ba3be-ce8c-11f1-9bce-9571b84c1864
md"""
**4. [Avanzado]** Escribe `beta_conv(α, δ, n, ρ, θ)`, la velocidad de
convergencia con Cobb-Douglas (notas, sección 4.6 y P.2). Puedes usar tu
`ahorro_ss`.
"""

# ╔═╡ 9d6ba3be-ce8c-11f1-851c-ad298943ccac
beta_conv(α, δ, n, ρ, θ) = missing  # reemplaza missing

# ╔═╡ 9d6ba3c8-ce8c-11f1-81d5-5b0c9516a7cf
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

# ╔═╡ 9d6ba3d2-ce8c-11f1-af7c-e1777d9564e1
md"""
---
## Apéndice: paquetes y funciones auxiliares

Estas celdas definen herramientas que usa el cuaderno. No es necesario
leerlas para seguir la sesión.
"""

# ╔═╡ 9d6ba3dc-ce8c-11f1-a138-6716f1b1491a
begin
    const AZUL    = "#2a78d6"   # capital, isoclina k' = 0
    const NARANJA = "#eb6834"   # rama estable, ahorro
    const GRIS    = "#52514e"   # referencias
    const TINTA   = "#0b0b0b"   # producto, punto inicial
end;

# ╔═╡ 9d6ba3dc-ce8c-11f1-9cfb-670526ec6f53
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

# ╔═╡ 9d6ba33c-ce8c-11f1-b87c-177cdd78c2bc
datos = momentos(pwt, desde, 2019)

# ╔═╡ 9d6ba346-ce8c-11f1-8e68-e1a05844d926
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

# ╔═╡ 9d6ba346-ce8c-11f1-9671-f1c05cee244a
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

    Desde 1980, el producto por trabajador casi no crece: por eso el modelo
    no tiene progreso técnico. El cociente ``K/Y`` sí sube: México acumuló
    capital sin que el producto por trabajador aumentara. La participación
    del trabajo es exactamente constante hasta 1993: la PWT parece extender
    un mismo valor hacia atrás, así que los periodos que empiezan antes de
    1994 la usan con esa salvedad.
    """
end

# ╔═╡ 9d6ba3e6-ce8c-11f1-8b65-ddadf36adc66
"""
Calibración de Ramsey: ρ reproduce el K/Y de los datos y A normaliza el
producto de estado estacionario a 1 (así k* = K/Y).
"""
function calibrar(m; α, θ)
    ρ = α / m.KY - m.δ
    A = m.KY^(-α)
    (; α, θ, δ = m.δ, n = m.n, ρ, A, KY = m.KY, sstar = (m.δ + m.n) * m.KY)
end

# ╔═╡ 9d6ba34e-ce8c-11f1-ace0-158e95b42722
cal = calibrar(datos; α = fuente_α == "pwt" ? 1 - datos.labsh : 1 / 3, θ)

# ╔═╡ 9d6ba3e6-ce8c-11f1-b62b-019c51c616fe
"Un paso de Runge-Kutta de cuarto orden para ż = F(z) (dt negativo integra hacia atrás)."
function paso_rk4(F, z, dt)
    k1 = F(z); k2 = F(z .+ dt / 2 .* k1); k3 = F(z .+ dt / 2 .* k2); k4 = F(z .+ dt .* k3)
    z .+ dt / 6 .* (k1 .+ 2k2 .+ 2k3 .+ k4)
end

# ╔═╡ 9d6ba3f2-ce8c-11f1-9853-412715df4787
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

# ╔═╡ 9d6ba3f2-ce8c-11f1-bfa0-4b36facbd125
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

# ╔═╡ 9d6ba35a-ce8c-11f1-abb3-0d9a263c63cc
ramsey = modelo_ramsey(cal)

# ╔═╡ 9d6ba35a-ce8c-11f1-bdde-8d8a851f1eb6
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

    El ahorro del modelo se parece al de los datos, pero es una identidad de
    cualquier estado estacionario: no prueba que México ahorre de manera
    óptima. Cambia ``\alpha``: el ``\rho`` calibrado cambia mucho, porque el
    modelo atribuye a la impaciencia todo el rendimiento del capital. Sube
    ``\theta``: el estado estacionario no cambia, pero la convergencia se
    vuelve más lenta.
    """
end

# ╔═╡ 9d6ba3fa-ce8c-11f1-bbd7-73881cf12562
"Consumo de la rama estable para el capital k (interpolación lineal)."
function politica(r, k)
    i = clamp(searchsortedlast(r.rama_k, k), 1, length(r.rama_k) - 1)
    w = (k - r.rama_k[i]) / (r.rama_k[i + 1] - r.rama_k[i])
    (1 - w) * r.rama_c[i] + w * r.rama_c[i + 1]
end

# ╔═╡ 9d6ba36e-ce8c-11f1-9453-a9592e50069b
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

# ╔═╡ 9d6ba3fa-ce8c-11f1-aa69-9dc931c50e11
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

# ╔═╡ 9d6ba36e-ce8c-11f1-83f8-692fc18f04ca
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

# ╔═╡ 9d6ba404-ce8c-11f1-9792-395690cfb4a4
"Valor descontado del capital, e^{-(ρ-n)t} u'(c) k, en el instante t y el punto z = (k, c)."
tvc(r, t, z) = exp(-(r.ρ - r.n) * t) * z[2]^(-r.θ) * z[1]

# ╔═╡ 9d6ba380-ce8c-11f1-9fb1-6d2a53a43990
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

# ╔═╡ 9d6ba404-ce8c-11f1-b163-9922800e3e0c
"Velocidad de convergencia con Cobb-Douglas (notas, P.2)."
function beta_ref(α, δ, n, ρ, θ)
    s = α * (δ + n) / (δ + ρ)
    a = ρ - n
    (sqrt(a^2 + 4(1 - α) * (1 - s) * (δ + ρ)^2 / (α * θ)) - a) / 2
end

# ╔═╡ 9d6ba40e-ce8c-11f1-b71b-fb7ea7be6984
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

# ╔═╡ 9d6ba3a0-ce8c-11f1-847c-f5aeb02898c5
verificar(() -> [rho_calibrado(0.646, 0.035, 3.66), rho_calibrado(1 / 3, 0.05, 3.0)],
          [0.646 / 3.66 - 0.035, 1 / 9 - 0.05];
          pista = md"En el estado estacionario, ``f'(k^\ast) = \alpha y^\ast/k^\ast = \alpha/(K/Y) = \delta + \rho``: `α / KY - δ`.")

# ╔═╡ 9d6ba3aa-ce8c-11f1-b55d-3d213e0cd479
verificar(() -> [capital_ss(0.3, 0.05, 0.03, 1.0), capital_ss(0.646, 0.035, 0.141, 2.0)],
          [(0.3 / 0.08)^(1 / 0.7), (0.646 * 2 / 0.176)^(1 / 0.354)];
          pista = md"De ``\alpha A k^{\alpha - 1} = \delta + \rho``: `(α * A / (δ + ρ))^(1 / (1 - α))`.")

# ╔═╡ 9d6ba3b4-ce8c-11f1-b84e-43322caff791
verificar(() -> [ahorro_ss(0.3, 0.05, 0.01, 0.03), ahorro_ss(0.646, 0.035, 0.023, 0.141)],
          [0.3 * 0.06 / 0.08, 0.646 * 0.058 / 0.176];
          pista = md"El ahorro repone la depreciación y la dilución: ``s^\ast = (\delta + n)k^\ast/f(k^\ast)``, y ``k^\ast/f(k^\ast) = \alpha/(\delta + \rho)``: `α * (δ + n) / (δ + ρ)`.")

# ╔═╡ 9d6ba3c8-ce8c-11f1-b1c8-bf518e8e45d4
verificar(() -> [beta_conv(0.646, 0.035, 0.023, 0.141, 2.0), beta_conv(0.3, 0.05, 0.01, 0.03, 1.0)],
          [beta_ref(0.646, 0.035, 0.023, 0.141, 2.0), beta_ref(0.3, 0.05, 0.01, 0.03, 1.0)];
          pista = md"Con `s = α * (δ + n) / (δ + ρ)` y `a = ρ - n`: `(sqrt(a^2 + 4(1 - α) * (1 - s) * (δ + ρ)^2 / (α * θ)) - a) / 2`.")

# ╔═╡ Cell order:
# ╟─9d6ba2f6-ce8c-11f1-967d-df8ac908d4fa
# ╟─9d6ba328-ce8c-11f1-9325-6fe0041ed50f
# ╟─9d6ba328-ce8c-11f1-8940-0b42d2ee6a76
# ╟─9d6ba332-ce8c-11f1-986c-a1ff1e2498d9
# ╠═9d6ba33c-ce8c-11f1-af04-cb2f42379fcf
# ╠═9d6ba33c-ce8c-11f1-b87c-177cdd78c2bc
# ╟─9d6ba346-ce8c-11f1-8e68-e1a05844d926
# ╟─9d6ba346-ce8c-11f1-9671-f1c05cee244a
# ╟─9d6ba34e-ce8c-11f1-bc5b-db6a9b6fb256
# ╠═9d6ba34e-ce8c-11f1-ace0-158e95b42722
# ╠═9d6ba35a-ce8c-11f1-abb3-0d9a263c63cc
# ╟─9d6ba35a-ce8c-11f1-bdde-8d8a851f1eb6
# ╟─9d6ba364-ce8c-11f1-9c37-bddd03cbbeef
# ╟─9d6ba36e-ce8c-11f1-9453-a9592e50069b
# ╟─9d6ba36e-ce8c-11f1-83f8-692fc18f04ca
# ╟─9d6ba378-ce8c-11f1-a867-255b3fccea9d
# ╟─9d6ba378-ce8c-11f1-afee-53c57749d332
# ╟─9d6ba380-ce8c-11f1-9fb1-6d2a53a43990
# ╟─9d6ba380-ce8c-11f1-aef9-7bc41f11f347
# ╟─9d6ba396-ce8c-11f1-93a4-535470a0aeae
# ╠═9d6ba396-ce8c-11f1-af86-2dd7ce1d5d99
# ╟─9d6ba3a0-ce8c-11f1-847c-f5aeb02898c5
# ╟─9d6ba3a0-ce8c-11f1-8a6d-8b16a0436953
# ╠═9d6ba3aa-ce8c-11f1-9da3-b96c8d0836ba
# ╟─9d6ba3aa-ce8c-11f1-b55d-3d213e0cd479
# ╟─9d6ba3aa-ce8c-11f1-9824-4d84e6e5fc02
# ╠═9d6ba3b4-ce8c-11f1-a34a-43ea3be0e977
# ╟─9d6ba3b4-ce8c-11f1-b84e-43322caff791
# ╟─9d6ba3be-ce8c-11f1-9bce-9571b84c1864
# ╠═9d6ba3be-ce8c-11f1-851c-ad298943ccac
# ╟─9d6ba3c8-ce8c-11f1-b1c8-bf518e8e45d4
# ╟─9d6ba3c8-ce8c-11f1-81d5-5b0c9516a7cf
# ╟─9d6ba3d2-ce8c-11f1-af7c-e1777d9564e1
# ╠═9d6ba3d2-ce8c-11f1-a330-bd7392482598
# ╠═9d6ba3dc-ce8c-11f1-a138-6716f1b1491a
# ╠═9d6ba3dc-ce8c-11f1-9cfb-670526ec6f53
# ╠═9d6ba3e6-ce8c-11f1-8b65-ddadf36adc66
# ╠═9d6ba3e6-ce8c-11f1-b62b-019c51c616fe
# ╠═9d6ba3f2-ce8c-11f1-9853-412715df4787
# ╠═9d6ba3f2-ce8c-11f1-bfa0-4b36facbd125
# ╠═9d6ba3fa-ce8c-11f1-bbd7-73881cf12562
# ╠═9d6ba3fa-ce8c-11f1-aa69-9dc931c50e11
# ╠═9d6ba404-ce8c-11f1-9792-395690cfb4a4
# ╠═9d6ba404-ce8c-11f1-b163-9922800e3e0c
# ╠═9d6ba40e-ce8c-11f1-b71b-fb7ea7be6984
