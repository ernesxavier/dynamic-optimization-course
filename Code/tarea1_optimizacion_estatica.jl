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

# ╔═╡ a5fea1c8-d0bc-11f1-8fdc-e1e90b6cd97b
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

# ╔═╡ a5fea0f8-d0bc-11f1-a2af-3b0376bf81f1
md"""
# Tarea 1, parte B: código

**Unidad I: optimización estática.** El enunciado completo, con la parte A
(analítica), está en `Class_notes/tarea1_optimizacion_estatica.md`.

**Cómo usar este cuaderno.** Reemplaza cada `missing` por tu código. Debajo
de cada ejercicio hay una **comprobación**: revisa que tu respuesta cumpla
las condiciones de optimalidad, o que dos cálculos tuyos coincidan. No la
compara con una solución, así que un "Coincide" no garantiza la
calificación completa: también cuentan las gráficas y las respuestas de
interpretación, que escribes en las celdas de texto marcadas **Tu
respuesta**. Entrega este archivo corriendo de principio a fin.

**Cómo abrirlo.** Desde la raíz del repositorio:
`julia --project=Code -e 'using Pluto; Pluto.run()'` y abrir
`Code/tarea1_optimizacion_estatica.jl`.
"""

# ╔═╡ a5fea12a-d0bc-11f1-b533-f3fa2e5003b6
TableOfContents(title = "Contenido")

# ╔═╡ a5fea12a-d0bc-11f1-8f66-4974d28b034a
md"""
## B1. El reparto entre ``n`` regiones (10 puntos)

Con ``f_i(x_i) = a_i\ln(1 + x_i)``, el reparto óptimo de un fondo ``B`` es
``x_i = \max\lbrace a_i/\lambda - 1,\ 0\rbrace``, con el ``\lambda`` que agota
el fondo (problema A2). Escribe `reparto(a, B)`, que reciba el vector `a` y
el fondo `B > 0` y devuelva la tupla `(x, λ)`: el vector de inversiones y el
multiplicador.

Encuentra ``\lambda`` por **bisección**: la inversión total
``\sum_i \max\lbrace a_i/\lambda - 1, 0\rbrace`` decrece con ``\lambda``, vale
0 en ``\lambda = \max_i a_i`` y es al menos ``B`` en
``\lambda = \sum_i a_i/(B + n)``. Detente cuando el intervalo mida menos
de ``10^{-12}``.
"""

# ╔═╡ a5fea136-d0bc-11f1-ad1c-a7aff62293d9
function reparto(a, B)
    missing  # reemplaza esta línea
end

# ╔═╡ a5fea13e-d0bc-11f1-a1d6-6d28ec032b25
md"""
**Comprobación.** Las condiciones de Kuhn-Tucker de tu reparto, en cuatro
casos: ``a = (4, 2, 1)`` con ``B = 0.5``, 3 y 6, y cuatro regiones con
``B = 2``.
"""

# ╔═╡ a5fea148-d0bc-11f1-adac-b5b4c5bbef1c
md"""
**La gráfica.** El reparto y el multiplicador según el tamaño del fondo, con
``a = (4, 2, 1)``.
"""

# ╔═╡ a5fea152-d0bc-11f1-a40a-c509657689c7
md"""
**Interpretación.** ¿En qué valores de ``B`` entra cada región? ¿Coinciden
con los umbrales de A2(c)? ¿Por qué el orden en que entran lo deciden las
``a_i`` y no el tamaño del fondo?

**Tu respuesta:**
"""

# ╔═╡ a5fea152-d0bc-11f1-a26a-6f3af0a69956
md"""
## B2. Estática comparativa con Symbolics.jl (10 puntos)

El problema A3: ``\max_{K, G} AK^\alpha G^\gamma - rK - G``. Las variables
simbólicas y el objetivo ya están definidos.
"""

# ╔═╡ a5fea170-d0bc-11f1-8205-dfce2d69d84b
@variables K G r A α γ

# ╔═╡ a5fea17a-d0bc-11f1-9111-11d8ec8cfcb4
objetivo = A * K^α * G^γ - r * K - G

# ╔═╡ a5fea17a-d0bc-11f1-8673-c56024b17ce4
md"""
**1.** Escribe `cpo`, el vector con las dos condiciones de primer orden
(las derivadas del objetivo respecto de ``K`` y de ``G``); `jacobiano`, su
jacobiano respecto de ``(K, G)``; y `dcpo_dr`, el vector de sus derivadas
respecto de ``r``. Usa `Symbolics.derivative` y `Symbolics.jacobian`.
"""

# ╔═╡ a5fea184-d0bc-11f1-a6c8-c3424e4e067c
cpo = missing  # reemplaza missing

# ╔═╡ a5fea184-d0bc-11f1-81f7-6561976fa210
jacobiano = missing  # reemplaza missing

# ╔═╡ a5fea184-d0bc-11f1-a5e7-fb6e65fa3d0b
dcpo_dr = missing  # reemplaza missing

# ╔═╡ a5fea18e-d0bc-11f1-abd7-afd34aac1597
md"""
**2.** Escribe `optimo(r)`, la solución cerrada de A3(c) con ``A = 1``,
``\alpha = 0.3`` y ``\gamma = 0.2``: debe devolver la tupla `(K, G)`.
"""

# ╔═╡ a5fea196-d0bc-11f1-bee3-6b7b42a58fa6
optimo(r) = missing  # reemplaza missing

# ╔═╡ a5fea1a2-d0bc-11f1-89fb-59a7d32dd4b0
md"""
**Comprobación.** Primero, que tu solución cerrada cumple tus condiciones
de primer orden. Después, que la derivada de la regla de Cramer,
``\partial(K, G)/\partial r = -J^{-1}\thinspace\partial F/\partial r``, coincide
con la diferencia finita de tu solución cerrada, en ``r = 0.1`` y
``r = 0.15``.
"""

# ╔═╡ a5fea1ac-d0bc-11f1-9489-175758e57e35
md"""
**Interpretación.** El precio ``r`` no aparece en la condición de primer
orden de ``G``. ¿Por qué, entonces, ``G^\ast`` responde a ``r``? ¿Qué dice
el signo del elemento fuera de la diagonal del jacobiano?

**Tu respuesta:**
"""

# ╔═╡ a5fea1ac-d0bc-11f1-99f3-37293fca60d7
md"""
## B3. El valor de una línea de crédito (10 puntos)

El problema A1 con línea de crédito: ``\max_{c_0} \ln c_0 + \beta\ln c_1``
con ``c_1 = y_1 + R(y_0 - c_0)`` y ``c_0 \le y_0 + L``. Escribe
`gasto_hoy(y0, y1, β, R, L)`, que devuelva la tupla `(c0, μ)`: el gasto
óptimo de hoy y el multiplicador de la restricción de endeudamiento.
"""

# ╔═╡ a5fea1b6-d0bc-11f1-839c-63774aaa9988
function gasto_hoy(y0, y1, β, R, L)
    missing  # reemplaza esta línea
end

# ╔═╡ a5fea1b6-d0bc-11f1-ad1f-81314693a859
md"""
**Comprobación.** Las condiciones de Kuhn-Tucker de tu solución y el
teorema de la envolvente: ``\mu`` debe ser la derivada del valor óptimo
respecto de ``L``, que aquí se calcula con una diferencia centrada **de tu
propia función**. Con ``\beta = 0.95``, ``R = 1.05`` y ``y_0 = 60``.
"""

# ╔═╡ a5fea1c0-d0bc-11f1-8ac0-a761241cf7a0
md"""
**La gráfica.** El gasto de hoy según el ingreso de mañana, con
``y_0 = 60``. La línea punteada es el gasto sin límite de endeudamiento
(sesión 1).

Línea de crédito ``L``: $(@bind L Slider(0:5:40, default = 0, show_value = true))
"""

# ╔═╡ a5fea1c8-d0bc-11f1-a914-c91c0a417801
md"""
**Interpretación.** ¿Dónde está el quiebre de la curva y por qué ahí? A la
derecha del quiebre, ¿por qué el gasto de hoy deja de responder al ingreso
de mañana? ¿Qué implica para una región que espera un ingreso alto (por
ejemplo, una inversión que madura) pero no puede endeudarse? Mueve ``L``:
¿qué pasa con el quiebre?

**Tu respuesta:**
"""

# ╔═╡ a5fea1c8-d0bc-11f1-9c04-011737c7209b
md"""
---
## Apéndice: paquetes y funciones auxiliares

Estas celdas definen herramientas que usa el cuaderno. No es necesario
leerlas para hacer la tarea.
"""

# ╔═╡ a5fea1d4-d0bc-11f1-959d-99d335ce6b45
begin
    const AZUL    = "#2a78d6"
    const NARANJA = "#eb6834"
    const VERDE   = "#1a9e77"
    const GRIS    = "#52514e"
    const TINTA   = "#0b0b0b"
end;

# ╔═╡ a5fea1d4-d0bc-11f1-b75c-6daf7778ad19
begin
    # Casos de las comprobaciones
    const CASOS_REPARTO = [([4.0, 2.0, 1.0], 0.5), ([4.0, 2.0, 1.0], 3.0), ([4.0, 2.0, 1.0], 6.0),
                           ([3.0, 2.5, 1.2, 0.8], 2.0)]
    # (y0, y1, β, R, L): restricción activa, activa con crédito, inactiva
    const CASOS_CREDITO = [(60.0, 120.0, 0.95, 1.05, 0.0), (60.0, 120.0, 0.95, 1.05, 10.0),
                           (60.0, 50.0, 0.95, 1.05, 0.0)]
end;

# ╔═╡ a5fea1de-d0bc-11f1-94c1-958454b4f695
"¿La función ya está escrita? Verdadero si corre sin error y no devuelve missing."
function completo(f)
    r = try
        f()
    catch
        return false
    end
    faltante(x) = x === missing || (x isa Union{AbstractArray, Tuple} && any(faltante, x))
    !faltante(r)
end

# ╔═╡ a5fea1de-d0bc-11f1-af02-594b56451dc1
begin
    caja(tipo, titulo, texto) = Markdown.MD(Markdown.Admonition(tipo, titulo, [texto]))
    pendiente() = caja("warning", "Pendiente", md"Reemplaza `missing` por tu código.")
    "Un renglón de tabla en Markdown con los valores redondeados."
    fila(xs...) = "| " * join([x isa Number ? string(round(x, sigdigits = 5)) : string(x) for x in xs], " | ") * " |"
end;

# ╔═╡ a5fea148-d0bc-11f1-a19c-0d9b00baa237
if completo(() -> reparto([4.0, 2.0, 1.0], 3.0))
    let
        Bs = range(0.05, 8, length = 300)
        rs = [reparto([4.0, 2.0, 1.0], b) for b in Bs]
        g1 = plot(; xlabel = "fondo B", ylabel = "inversión xᵢ", title = "Reparto óptimo",
                  legend = :topleft)
        for (i, color) in zip(1:3, (AZUL, NARANJA, VERDE))
            plot!(g1, Bs, [r[1][i] for r in rs]; color, lw = 2, label = "región $i")
        end
        g2 = plot(Bs, last.(rs); color = TINTA, lw = 2, xlabel = "fondo B", ylabel = "λ(B)",
                  title = "Precio sombra del fondo")
        plot(g1, g2; layout = (1, 2), size = (780, 320))
    end
else
    pendiente()
end

# ╔═╡ a5fea1c0-d0bc-11f1-9b99-d1c4b093f43e
if completo(() -> gasto_hoy(60.0, 120.0, 0.95, 1.05, 0.0))
    let
        y1s = range(0, 200, length = 400)
        c0 = [first(gasto_hoy(60.0, y, 0.95, 1.05, float(L))) for y in y1s]
        p = plot(y1s, c0; color = AZUL, lw = 2.5, xlabel = "ingreso de mañana y₁",
                 ylabel = "gasto de hoy c₀", title = "Gasto de hoy con L = $L",
                 legend = :topleft, label = "con límite de endeudamiento")
        plot!(p, y1s, (60 .+ y1s ./ 1.05) ./ 1.95; color = GRIS, ls = :dash, lw = 1.5,
              label = "sin límite")
        hline!(p, [60 + L]; color = NARANJA, ls = :dot, lw = 1, label = "y₀ + L")
    end
else
    pendiente()
end

# ╔═╡ a5fea1e8-d0bc-11f1-a595-df3905d96b3d
"Revisa las condiciones de Kuhn-Tucker de un reparto (x, λ) con fᵢ = aᵢ ln(1 + xᵢ)."
function revisar_kt(a, B, x, λ; tol = 1e-6)
    d = a ./ (1 .+ x) .- λ                         # ∂L/∂xᵢ
    holgura = B - sum(x)
    ok = all(x .>= -tol) && holgura >= -tol && λ >= -tol && all(d .<= tol) &&
         all(abs.(x .* d) .<= tol) && abs(λ * holgura) <= tol
    filas = [fila("región $i", x[i], d[i], x[i] * d[i]) for i in eachindex(a)]
    tabla = Markdown.parse("""
    a = $(a), B = $(B): λ = $(round(λ, sigdigits = 6)), B − Σxᵢ = $(round(holgura, sigdigits = 3))

    | | xᵢ | ∂L/∂xᵢ (≤ 0) | xᵢ ∂L/∂xᵢ (= 0) |
    |:---|---:|---:|---:|
    $(join(filas, "\n"))
    """)
    caja(ok ? "correct" : "danger", ok ? "Cumple Kuhn-Tucker" : "No cumple Kuhn-Tucker", tabla)
end

# ╔═╡ a5fea13e-d0bc-11f1-8372-d15b7ad39497
if completo(() -> reparto([4.0, 2.0, 1.0], 3.0))
    Markdown.MD([revisar_kt(a, B, reparto(a, B)...) for (a, B) in CASOS_REPARTO]...)
else
    pendiente()
end

# ╔═╡ a5fea1e8-d0bc-11f1-94ce-3d304a7f38c6
"Evalúa una expresión simbólica (o un arreglo) en los valores de `valores` y la convierte a Float64."
numerico(e, valores) = Float64.(Symbolics.value.(substitute.(e, Ref(valores))))

# ╔═╡ a5fea1f2-d0bc-11f1-81cb-b742ef44ff7a
"Revisa la solución cerrada de A3 contra las condiciones de primer orden y la regla de Cramer contra una diferencia finita."
function revisar_estatica(rr, cpo, jacobiano, dcpo_dr, optimo; h = 1e-6)
    K0, G0 = optimo(rr)
    valores = Dict(K => K0, G => G0, r => rr, A => 1.0, α => 0.3, γ => 0.2)
    residuo = maximum(abs.(numerico(cpo, valores)))
    cramer = -(numerico(jacobiano, valores) \ numerico(dcpo_dr, valores))
    finita = (collect(optimo(rr + h)) .- collect(optimo(rr - h))) ./ 2h
    ok = residuo < 1e-8 && isapprox(cramer, finita; rtol = 1e-4)
    texto = Markdown.parse("""
    r = $(rr): K* = $(round(K0, sigdigits = 5)), G* = $(round(G0, sigdigits = 5)); residuo de las condiciones de primer orden: $(round(residuo, sigdigits = 2))

    | | ∂K*/∂r | ∂G*/∂r |
    |:---|---:|---:|
    $(fila("Regla de Cramer", cramer...))
    $(fila("Diferencia finita", finita...))
    """)
    caja(ok ? "correct" : "danger", ok ? "Coincide" : "No coincide", texto)
end

# ╔═╡ a5fea1a2-d0bc-11f1-a20c-874f7af6ff33
if completo(() -> (cpo, jacobiano, dcpo_dr, optimo(0.1)))
    Markdown.MD([revisar_estatica(rr, cpo, jacobiano, dcpo_dr, optimo) for rr in (0.1, 0.15)]...)
else
    pendiente()
end

# ╔═╡ a5fea1f2-d0bc-11f1-bc74-1f0c92d9b165
"Revisa Kuhn-Tucker y la envolvente V′(L) = μ en el problema de dos periodos con línea de crédito."
function revisar_credito(y0, y1, β, R, L, gasto_hoy; h = 1e-5, tol = 1e-6)
    c0, μ = gasto_hoy(y0, y1, β, R, L)
    c1 = y1 + R * (y0 - c0)
    V(ℓ) = (c = first(gasto_hoy(y0, y1, β, R, ℓ)); log(c) + β * log(y1 + R * (y0 - c)))
    dV = (V(L + h) - V(L - h)) / 2h
    holgura = y0 + L - c0
    foc = 1 / c0 - β * R / c1 - μ
    ok = c1 > 0 && holgura >= -tol && μ >= -tol && abs(μ * holgura) <= tol &&
         abs(foc) <= tol && isapprox(dV, μ; atol = 1e-6)
    texto = Markdown.parse("""
    y₁ = $(y1), L = $(L): c₀ = $(round(c0, sigdigits = 6)), c₁ = $(round(c1, sigdigits = 6)), μ = $(round(μ, sigdigits = 5))

    | Condición | Valor |
    |:---|---:|
    $(fila("Holgura y₀ + L − c₀ (≥ 0)", holgura))
    $(fila("μ × holgura (= 0)", μ * holgura))
    $(fila("1/c₀ − βR/c₁ − μ (= 0)", foc))
    $(fila("V′(L) por diferencia finita (= μ)", dV))
    """)
    caja(ok ? "correct" : "danger", ok ? "Cumple Kuhn-Tucker y la envolvente" : "No cumple", texto)
end

# ╔═╡ a5fea1b6-d0bc-11f1-9037-d7d770247736
if completo(() -> gasto_hoy(60.0, 120.0, 0.95, 1.05, 0.0))
    Markdown.MD([revisar_credito(c..., gasto_hoy) for c in CASOS_CREDITO]...)
else
    pendiente()
end

# ╔═╡ Cell order:
# ╟─a5fea0f8-d0bc-11f1-a2af-3b0376bf81f1
# ╟─a5fea12a-d0bc-11f1-b533-f3fa2e5003b6
# ╟─a5fea12a-d0bc-11f1-8f66-4974d28b034a
# ╠═a5fea136-d0bc-11f1-ad1c-a7aff62293d9
# ╟─a5fea13e-d0bc-11f1-a1d6-6d28ec032b25
# ╟─a5fea13e-d0bc-11f1-8372-d15b7ad39497
# ╟─a5fea148-d0bc-11f1-adac-b5b4c5bbef1c
# ╟─a5fea148-d0bc-11f1-a19c-0d9b00baa237
# ╟─a5fea152-d0bc-11f1-a40a-c509657689c7
# ╟─a5fea152-d0bc-11f1-a26a-6f3af0a69956
# ╠═a5fea170-d0bc-11f1-8205-dfce2d69d84b
# ╠═a5fea17a-d0bc-11f1-9111-11d8ec8cfcb4
# ╟─a5fea17a-d0bc-11f1-8673-c56024b17ce4
# ╠═a5fea184-d0bc-11f1-a6c8-c3424e4e067c
# ╠═a5fea184-d0bc-11f1-81f7-6561976fa210
# ╠═a5fea184-d0bc-11f1-a5e7-fb6e65fa3d0b
# ╟─a5fea18e-d0bc-11f1-abd7-afd34aac1597
# ╠═a5fea196-d0bc-11f1-bee3-6b7b42a58fa6
# ╟─a5fea1a2-d0bc-11f1-89fb-59a7d32dd4b0
# ╟─a5fea1a2-d0bc-11f1-a20c-874f7af6ff33
# ╟─a5fea1ac-d0bc-11f1-9489-175758e57e35
# ╟─a5fea1ac-d0bc-11f1-99f3-37293fca60d7
# ╠═a5fea1b6-d0bc-11f1-839c-63774aaa9988
# ╟─a5fea1b6-d0bc-11f1-ad1f-81314693a859
# ╟─a5fea1b6-d0bc-11f1-9037-d7d770247736
# ╟─a5fea1c0-d0bc-11f1-8ac0-a761241cf7a0
# ╟─a5fea1c0-d0bc-11f1-9b99-d1c4b093f43e
# ╟─a5fea1c8-d0bc-11f1-a914-c91c0a417801
# ╟─a5fea1c8-d0bc-11f1-9c04-011737c7209b
# ╠═a5fea1c8-d0bc-11f1-8fdc-e1e90b6cd97b
# ╠═a5fea1d4-d0bc-11f1-959d-99d335ce6b45
# ╠═a5fea1d4-d0bc-11f1-b75c-6daf7778ad19
# ╠═a5fea1de-d0bc-11f1-94c1-958454b4f695
# ╠═a5fea1de-d0bc-11f1-af02-594b56451dc1
# ╠═a5fea1e8-d0bc-11f1-a595-df3905d96b3d
# ╠═a5fea1e8-d0bc-11f1-94ce-3d304a7f38c6
# ╠═a5fea1f2-d0bc-11f1-81cb-b742ef44ff7a
# ╠═a5fea1f2-d0bc-11f1-bc74-1f0c92d9b165
