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

# ╔═╡ 5e1b7362-cf07-11f1-b1c3-a1f327fb9aa8
begin
    # Usa el entorno del curso (Code/Project.toml) en lugar del gestor de
    # paquetes propio de Pluto: un solo entorno para todo el repositorio.
    import Pkg
    Pkg.activate(@__DIR__)
    Pkg.instantiate()
    using PlutoUI, Plots, CSV, DataFrames, LinearAlgebra, Markdown
    gr()
    default(size = (720, 320), legend = false, grid = :y, gridalpha = 0.15,
            framestyle = :axes, titlefontsize = 11, guidefontsize = 9,
            tickfontsize = 8, legendfontsize = 8, foreground_color_legend = nothing,
            background_color_legend = nothing, margin = 3Plots.mm)
end

# ╔═╡ 5e1b71ac-cf07-11f1-80ec-379a5232e34b
md"""
# Sesión 14: Caso completo: inversión entre dos regiones

**Pregunta de la unidad.** ¿Conviene invertir primero donde se ahorra más o
donde se produce más?

**Cómo usar este cuaderno.** La primera mitad de la clase es de pizarrón:
el modelo, el Hamiltoniano y la solución hacia atrás con el tiempo de
cambio, en las notas, `Class_notes/s14_dos_regiones.md`. La segunda mitad
**sigue este cuaderno**: la solución con deslizadores, la calibración con
dos estados de México y la discusión de equidad. Cada sección dice en qué
momento de la clase se usa y qué hacer. Pluto es reactivo: al mover un
deslizador, todo lo que depende de él se recalcula.

**Cómo abrirlo.** Desde la raíz del repositorio:
`julia --project=Code -e 'using Pluto; Pluto.run()'` y abrir
`Code/s14_dos_regiones.jl`.
"""

# ╔═╡ 5e1b7204-cf07-11f1-a86d-d9b49297b84e
TableOfContents(title = "Contenido")

# ╔═╡ 5e1b720c-cf07-11f1-b9c8-a98243fe1feb
md"""
## 1. El modelo

*Minutos 50–58, después de la sección 3.2 de las notas.* El modelo de la
sección 1 de las notas, con ``K_i(0) = 1``. El cuaderno integra los precios
sombra **hacia atrás** desde ``p_i(T) = v_i``, encuentra el cambio donde se
cruzan y después integra el capital hacia adelante.

Productividad del capital, región 1, ``v_1``: $(@bind v1 Slider(0.10:0.01:0.40, default = 0.20, show_value = true))

Productividad del capital, región 2, ``v_2``: $(@bind v2 Slider(0.10:0.01:0.40, default = 0.25, show_value = true))

Tasa de ahorro, región 1, ``s_1``: $(@bind s1 Slider(0.05:0.01:0.50, default = 0.30, show_value = true))

Tasa de ahorro, región 2, ``s_2``: $(@bind s2 Slider(0.05:0.01:0.50, default = 0.20, show_value = true))

Horizonte del plan, ``T``: $(@bind T Slider(5:1:50, default = 30, show_value = true))
"""

# ╔═╡ 5e1b723e-cf07-11f1-8419-d525a64db705
md"""
1. Con los valores iniciales (el ejemplo de la sección 3.3 de las notas),
   **comprueba** que el tiempo de cambio numérico coincide con el analítico.
2. **Baja** ``s_1`` hasta que ``\gamma_1 < \gamma_2``: ¿qué pasa con la
   primera fase?
3. **Acorta** ``T`` por debajo de ``\tau^\ast``: ¿y ahora?
4. **Observa** los precios sombra: ¿en qué región vale más el capital al
   principio y en cuál al final?
"""

# ╔═╡ 5e1b724a-cf07-11f1-a76c-eff0496a1c1a
md"""
## 2. ¿Cuánto se gana con el reparto óptimo?

*Minutos 63–70.* El producto nacional al final con una misma fracción
``\theta`` fija para la región 1 durante todo el plan, contra el plan óptimo
(línea naranja). Con ``\theta`` fijo, el capital sigue un sistema lineal
(sesión 7).
"""

# ╔═╡ 5e1b7290-cf07-11f1-8089-6519e011e2ef
md"""
**¿Qué tan sensible es a las tasas de ahorro?** Años del plan en que se
invierte en la región 1, según su tasa de ahorro, con la de la región 2 fija.
La línea punteada es el umbral ``s_1 = s_2v_2/v_1``.
"""

# ╔═╡ 5e1b72ae-cf07-11f1-b012-67fa30365717
md"""
1. Con Coahuila y Nuevo León, **busca** el ahorro de Coahuila a partir del
   cual recibe inversión. ¿Qué tan rápido pasa de "nada" a "más de una
   década"?
2. **Baja** ``\phi`` a 0.5: ¿cómo cambia el umbral? ¿Qué supuesto pesa más,
   el del ahorro o el del capital por trabajador?
3. **Elige** Chiapas y la Ciudad de México: ¿cuánto tendría que ahorrar
   Chiapas para recibir algo?
4. **Elige** dos estados que te interesen, o los de tu tesis. ¿Qué ahorro
   supondrías para cada uno, y cómo lo defenderías?
"""

# ╔═╡ 5e1b72b8-cf07-11f1-92a9-ed682b2333a7
md"""
## 4. Equidad frente a eficiencia

*Minutos 92–105* (notas, 6, lectura previa). Se pesa el producto de la
región menos productiva con ``\omega \ge 1``; con los estados y supuestos de
la sección 3.

Peso de la región menos productiva, ``\omega``: $(@bind ω Slider(1.0:0.05:3.0, default = 1.0, show_value = true))
"""

# ╔═╡ 5e1b72d6-cf07-11f1-a3fe-232f86d0614f
md"""
## 5. [Avanzado] El mapa de sensibilidad

*Fuera de clase.* Años de inversión en la región 1 para cada combinación de tasas de ahorro,
con las productividades y el horizonte de la sección 3. El punto es el
supuesto actual. La frontera entre "nada" y "algo" es la recta
``s_1/s_2 = v_2/v_1``, pero el número de años cambia rápido cerca de ella.
"""

# ╔═╡ 5e1b72ea-cf07-11f1-bfdb-7bf6ada58657
md"""
## Ejercicios

*Minutos 105–115, en parejas: ejercicios 1 a 3.* Los ejercicios con
demostraciones están en las notas (sección 9).

### Completa el código

**1.** Escribe `tau_cambio(v1, v2, s1, s2)`, los años antes del final en que
ocurre el cambio, suponiendo ``v_2 > v_1`` y ``\gamma_1 > \gamma_2``.
"""

# ╔═╡ 5e1b72f4-cf07-11f1-bb6f-dd75e208cf94
tau_cambio(v1, v2, s1, s2) = missing  # reemplaza missing

# ╔═╡ 5e1b72fe-cf07-11f1-8a4b-2599fca149c9
md"""
**2.** Escribe `s_umbral(v1, v2, s2)`, la tasa de ahorro mínima de la región
1 para que, siendo menos productiva, reciba inversión en algún momento.
"""

# ╔═╡ 5e1b7308-cf07-11f1-8eda-97886ea7cac8
s_umbral(v1, v2, s2) = missing  # reemplaza missing

# ╔═╡ 5e1b731c-cf07-11f1-a19a-4bc501455d3c
md"""
**3.** Escribe `producto_fijo(θ, v1, v2, s1, s2, T)`, el producto nacional
al final con un reparto fijo ``\theta`` y ``K_1(0) = K_2(0) = 1``. Usa la
exponencial de una matriz, `exp(M * T)`.
"""

# ╔═╡ 5e1b7326-cf07-11f1-965d-5dd4ccb89cfb
producto_fijo(θ, v1, v2, s1, s2, T) = missing  # reemplaza missing

# ╔═╡ 5e1b733a-cf07-11f1-aba3-d3374292bd85
md"""
**4. [Avanzado]** Escribe `tau_ponderado(v1, v2, s1, s2, ω1, ω2)`, el tiempo
de cambio con pesos (notas, ejercicio F4), suponiendo que la última fase es
en la región 2 (``\omega_2v_2 > \omega_1v_1``) y ``\gamma_1 > \gamma_2``.
"""

# ╔═╡ 5e1b733a-cf07-11f1-b6fa-efc6337bc8b4
tau_ponderado(v1, v2, s1, s2, ω1, ω2) = missing  # reemplaza missing

# ╔═╡ 5e1b734e-cf07-11f1-887f-b1dee422ef6d
md"""
### Interpretación

5. En la sección 1, ¿por qué el plan invierte primero en la región que
   produce menos? ¿Qué pasaría si el objetivo fuera el producto en el año 1
   en lugar del año ``T``?
6. En la sección 3, ¿qué tasa de ahorro supondrías para cada estado y cómo
   la defenderías? ¿Con qué datos podrías acotarla?
7. En la sección 4, ¿a partir de qué peso cambia la política? ¿Qué le dirías
   a un gobierno que pregunta cuánto cuesta la equidad?

### Tu tesis

8. ¿Cuál es, en tu problema, el análogo del tiempo de cambio? ¿Qué
   parámetro de tu modelo no se mide directamente, y cómo mostrarías qué tan
   sensible es tu resultado a él?

### [Avanzado]

9. ¿Por qué no hay un segundo cambio? (Notas, sección 3.1.)
10. Si los estados ricos tienen más capital por trabajador, la diferencia
    real de ``v_i`` es menor que la calibrada. ¿Cómo cambiaría el umbral de
    ahorro y la política en la sección 3?

## Para la próxima sesión

- **Sesión 15: Ecuación de Bellman en horizonte finito.** Empieza la
  Unidad IV: la función valor, la inducción hacia atrás y el problema de la
  torta en tiempo discreto.
- Repaso: C.B3 (exponencial y logaritmo), A.B3 (series y descuento), A.I1
  a A.I3 (supremo, conjuntos compactos y teorema de Weierstrass) y N.I5
  (maximizar en una variable). Para los puntos [Avanzado]: L.A4 (cadenas de
  Markov).
"""

# ╔═╡ 5e1b7358-cf07-11f1-969f-9f030f38b0e0
md"""
---
## Apéndice: paquetes y funciones auxiliares

Estas celdas definen herramientas que usa el cuaderno. No es necesario
leerlas para seguir la sesión.
"""

# ╔═╡ 5e1b736c-cf07-11f1-80ec-6173093e5ba8
begin
    const AZUL    = "#2a78d6"   # región 1
    const NARANJA = "#eb6834"   # región 2
    const GRIS    = "#52514e"   # referencias
    const TINTA   = "#0b0b0b"   # reparto, producto total
end;

# ╔═╡ 5e1b736c-cf07-11f1-af63-9dcb98b5f851
"""
Productividad del capital por entidad en el año dado: v_i = v̄ (y_i/ȳ)^φ,
con y_i el PIB sin minería petrolera por trabajador y v̄ = 1/(K/Y) de la PWT
(promedio 1990–2019, sesión 12). Con φ = 1, el capital por trabajador es el
mismo en todos los estados.
"""
function productividades(datos, año; KY = 3.66, φ = 1.0)
    d = sort(filter(r -> r.año == año, datos), :clave)
    y = (d.pib .- d.pib_petrolero) ./ d.empleo
    ybar = sum(d.pib .- d.pib_petrolero) / sum(d.empleo)
    (; entidad = String.(d.entidad), v = (y ./ ybar) .^ φ ./ KY)
end

# ╔═╡ 5e1b7374-cf07-11f1-831e-b1daee98b329
"Opciones del selector de estados: clave => nombre, en el orden de las claves del INEGI."
const OPCIONES_ESTADOS = let
    d = CSV.read(joinpath(@__DIR__, "..", "Data", "entidades.csv"), DataFrame)
    u = unique(select(d, :clave, :entidad), :clave)
    sort!(u, :clave)
    [c => String(e) for (c, e) in zip(u.clave, u.entidad)]
end

# ╔═╡ 5e1b7268-cf07-11f1-9cf1-3f4c56aaffe3
md"""
## 3. Calibración: dos estados de México

*Minutos 70–92* (notas, 5). Las productividades salen de los datos (INEGI y
OCDE, 2023), con ``v_i = \bar v\,(y_i/\bar y)^\phi``; las tasas de ahorro
**no se publican por entidad** y se suponen alrededor de la nacional
(0.19).

Región 1: $(@bind e1 Select(OPCIONES_ESTADOS; default = 5))

Región 2: $(@bind e2 Select(OPCIONES_ESTADOS; default = 19))

Tasa de ahorro supuesta, región 1: $(@bind σ1 Slider(0.10:0.01:0.40, default = 0.25, show_value = true))

Tasa de ahorro supuesta, región 2: $(@bind σ2 Slider(0.10:0.01:0.40, default = 0.19, show_value = true))

Horizonte del plan: $(@bind Tm Slider(5:1:40, default = 20, show_value = true))

Cuánto de la diferencia de PIB por trabajador se atribuye a ``v_i``, ``\phi``: $(@bind φ Slider(0.0:0.1:1.0, default = 1.0, show_value = true))
"""

# ╔═╡ 5e1b7270-cf07-11f1-9aba-c9b97ce1db96
estados = productividades(CSV.read(joinpath(@__DIR__, "..", "Data", "entidades.csv"), DataFrame), 2023; φ)

# ╔═╡ 5e1b7380-cf07-11f1-843a-29a9d69ec5f7
"""
Resuelve el modelo de dos regiones. Los precios sombra se integran hacia
atrás desde p_i(T) = ω_i v_i con p_i' = -γ_i max(p₁, p₂) (RK4 por tramos); los
cambios se localizan donde p₁ - p₂ cambia de signo (interpolación lineal),
y el capital se integra hacia adelante con el reparto resultante.
"""
function resolver_rit(v1, v2, s1, s2, T; ω = (1.0, 1.0), n = 4000, nombres = ("Región 1", "Región 2"))
    γ = (s1 * v1, s2 * v2)
    dt = T / n
    t = collect(range(0, T, length = n + 1))
    P(p) = max(p[1], p[2])
    F(p) = [-γ[1] * P(p), -γ[2] * P(p)]
    p = Vector{Vector{Float64}}(undef, n + 1)
    p[end] = [ω[1] * v1, ω[2] * v2]
    for k in n:-1:1                       # hacia atrás: paso -dt
        z = p[k + 1]
        a = F(z); b = F(z .- dt / 2 .* a); c = F(z .- dt / 2 .* b); d = F(z .- dt .* c)
        p[k] = z .- dt / 6 .* (a .+ 2b .+ 2c .+ d)
    end
    dif = [q[1] - q[2] for q in p]
    θ = [d > 0 ? 1.0 : 0.0 for d in dif]
    cambios = Float64[]
    for k in 1:n
        if dif[k] * dif[k + 1] < 0          # cambio de signo estricto
            push!(cambios, t[k] + dt * dif[k] / (dif[k] - dif[k + 1]))
        end
    end
    # Capital hacia adelante: exacto en cada paso, con el reparto del inicio del paso
    K = Vector{Vector{Float64}}(undef, n + 1)
    K[1] = [1.0, 1.0]
    for k in 1:n
        M = [θ[k] * γ[1] θ[k] * γ[2]; (1 - θ[k]) * γ[1] (1 - θ[k]) * γ[2]]
        K[k + 1] = exp(M * dt) * K[k]
    end
    Yi = [[v1 * k[1], v2 * k[2]] for k in K]
    # Tiempo de cambio analítico (sin pesos, caso v2 > v1 y γ1 > γ2, o el simétrico)
    τ = if γ[1] > γ[2] && ω[2] * v2 > ω[1] * v1
        log((γ[1] * ω[2] * v2 - γ[2] * ω[1] * v1) / (ω[2] * v2 * (γ[1] - γ[2]))) / γ[2]
    elseif γ[2] > γ[1] && ω[1] * v1 > ω[2] * v2
        log((γ[2] * ω[1] * v1 - γ[1] * ω[2] * v2) / (ω[1] * v1 * (γ[2] - γ[1]))) / γ[1]
    else
        Inf
    end
    (; v1, v2, s1, s2, T, γ, ω, nombres, t, p, θ, cambios, τ, K, Yi, Y = sum.(Yi))
end

# ╔═╡ 5e1b7222-cf07-11f1-845b-cd8c56314432
plan = resolver_rit(v1, v2, s1, s2, float(T))

# ╔═╡ 5e1b727c-cf07-11f1-95fa-4199b0c0cf1b
mexico = resolver_rit(estados.v[e1], estados.v[e2], σ1, σ2, float(Tm);
                      nombres = (estados.entidad[e1], estados.entidad[e2]))

# ╔═╡ 5e1b72c2-cf07-11f1-9560-0d7c93f4e40a
let
    m = mexico
    pobre = m.v1 <= m.v2 ? 1 : 2
    pesos(w) = pobre == 1 ? (w, 1.0) : (1.0, w)
    ws = range(1, 3, length = 81)
    planes = [resolver_rit(m.v1, m.v2, m.s1, m.s2, m.T; ω = pesos(w)) for w in ws]
    Ymax = m.Y[end]
    costo = [100 * (1 - p.Y[end] / Ymax) for p in planes]
    brecha = [p.Yi[end][pobre] / p.Yi[end][3 - pobre] for p in planes]
    g1 = plot(ws, costo; color = NARANJA, lw = 2.5, xlabel = "peso ω", ylabel = "% de Y(T)",
              title = "Costo de la equidad")
    vline!(g1, [ω]; color = GRIS, ls = :dot, lw = 1)
    g2 = plot(ws, brecha; color = AZUL, lw = 2.5, xlabel = "peso ω",
              ylabel = "Y pobre / Y rica en T", title = "Brecha al final del plan")
    vline!(g2, [ω]; color = GRIS, ls = :dot, lw = 1)
    plot(g1, g2; layout = (1, 2), size = (780, 320))
end

# ╔═╡ 5e1b7394-cf07-11f1-8283-fdc1712b3cf4
"""
Años del plan en que se invierte en la región 1, con la solución analítica
(notas, sección 3): la última fase es en la región con mayor v; antes, en la
de mayor γ, si el horizonte alcanza.
"""
function años_region1(v1, v2, s1, s2, T)
    γ1, γ2 = s1 * v1, s2 * v2
    if v2 > v1                           # al final, región 2
        γ1 > γ2 || return 0.0
        τ = log(v1 * (s1 - s2) / (γ1 - γ2)) / γ2
        max(0.0, T - τ)
    else                                 # al final, región 1
        γ2 > γ1 || return float(T)
        τ = log(v2 * (s2 - s1) / (γ2 - γ1)) / γ1
        min(float(T), τ)
    end
end

# ╔═╡ 5e1b72a4-cf07-11f1-ab28-ff5117caf0e2
let
    m = mexico
    ss = range(0.10, 0.45, length = 141)
    años = [años_region1(m.v1, m.v2, s, m.s2, m.T) for s in ss]
    g = plot(ss, años; color = AZUL, lw = 2.5, xlabel = "tasa de ahorro de $(m.nombres[1])",
             ylabel = "años", title = "Años de inversión en $(m.nombres[1])", size = (640, 320),
             ylims = (-0.5, m.T + 0.5))
    vline!(g, [m.s2 * m.v2 / m.v1]; color = GRIS, ls = :dot, lw = 1)
    scatter!(g, [m.s1], [años_region1(m.v1, m.v2, m.s1, m.s2, m.T)]; color = NARANJA, ms = 6, msw = 0)
    g
end

# ╔═╡ 5e1b72e2-cf07-11f1-94d8-e590ec08c20f
let
    m = mexico
    ss = range(0.10, 0.40, length = 61)
    años = [años_region1(m.v1, m.v2, a, b, m.T) for b in ss, a in ss]
    g = heatmap(ss, ss, años; color = cgrad([:white, AZUL]), xlabel = "ahorro de $(m.nombres[1])",
                ylabel = "ahorro de $(m.nombres[2])", title = "Años de inversión en $(m.nombres[1])",
                colorbar = true, size = (600, 480), aspect_ratio = :equal, xlims = (0.1, 0.4),
                ylims = (0.1, 0.4))
    plot!(g, ss, ss .* m.v1 ./ m.v2; color = GRIS, ls = :dot, lw = 1)
    scatter!(g, [m.s1], [m.s2]; color = NARANJA, ms = 6, msw = 0)
    g
end

# ╔═╡ 5e1b739e-cf07-11f1-87ff-ab32a9cb018c
"Descripción en palabras de la política óptima."
function describir_politica(r)
    a, b = r.nombres
    primero = r.θ[1] == 1 ? a : b
    if isempty(r.cambios)
        "toda la inversión va a $primero durante todo el plan."
    else
        segundo = primero == a ? b : a
        "toda la inversión va a $primero hasta el año $(round(r.cambios[1], digits = 1)) y después a $segundo."
    end
end

# ╔═╡ 5e1b72cc-cf07-11f1-9938-55c9018dcd10
let
    m = mexico
    pobre = m.v1 <= m.v2 ? 1 : 2
    p = resolver_rit(m.v1, m.v2, m.s1, m.s2, m.T; ω = pobre == 1 ? (ω, 1.0) : (1.0, ω),
                     nombres = m.nombres)
    md"""
    Con ``\omega = `` $ω: $(describir_politica(p)) El producto nacional al
    final es $(round(100 * (1 - p.Y[end] / m.Y[end]), digits = 1))% menor que
    con el plan de eficiencia, y la región menos productiva produce
    $(round(100 * p.Yi[end][pobre] / p.Yi[end][3 - pobre], digits = 1))% de lo
    que produce la otra (con eficiencia:
    $(round(100 * m.Yi[end][pobre] / m.Yi[end][3 - pobre], digits = 1))%).

    1. **Sube** ``\omega`` poco a poco desde 1: ¿cuándo empieza a costar la
       equidad? ¿En qué valor salta la política?
    2. **Observa** la brecha al final: ¿se cierra, o se invierte?
    3. Si fueras el gobierno, ¿qué ``\omega`` elegirías y cómo lo
       justificarías? El modelo no lo decide: lo hace explícito y le pone
       precio.
    """
end

# ╔═╡ 5e1b739e-cf07-11f1-a76f-e7049eb44b87
"Gráficas de un plan: precios sombra, reparto y capital."
function graficar_plan(r)
    a, b = r.nombres
    g1 = plot(r.t, first.(r.p); color = AZUL, lw = 2.5, xlabel = "años", ylabel = "precio sombra",
              title = "Precios sombra del capital", label = a, legend = :topright)
    plot!(g1, r.t, last.(r.p); color = NARANJA, lw = 2.5, label = b)
    g2 = plot(r.t, r.θ; color = TINTA, lw = 2.5, xlabel = "años", ylabel = "θ(t)",
              title = "Fracción a $(a)", ylims = (-0.1, 1.1), linetype = :steppost)
    g3 = plot(r.t, first.(r.K); color = AZUL, lw = 2.5, xlabel = "años", ylabel = "capital",
              title = "Capital", label = a, legend = :topleft)
    plot!(g3, r.t, last.(r.K); color = NARANJA, lw = 2.5, label = b)
    for g in (g1, g2, g3), c in r.cambios
        vline!(g, [c]; color = GRIS, ls = :dot, lw = 1, label = "")
    end
    plot(g1, g2, g3; layout = (1, 3), size = (880, 310))
end

# ╔═╡ 5e1b722c-cf07-11f1-b1ce-51b090b24e85
graficar_plan(plan)

# ╔═╡ 5e1b7286-cf07-11f1-be78-bdb463fdbad1
graficar_plan(mexico)

# ╔═╡ 5e1b73a6-cf07-11f1-ab7e-c1c407c60943
"Tabla de resultados de un plan."
function tabla_plan(r)
    a, b = r.nombres
    rd(x, d = 3) = round(x, digits = d)
    analitico = isfinite(r.τ) ? (r.τ < r.T ? string(rd(r.T - r.τ, 2)) : "ninguno (τ* = $(rd(r.τ, 1)) ≥ T)") : "ninguno"
    numerico = isempty(r.cambios) ? "ninguno" : string(rd(r.cambios[1], 2))
    Markdown.parse("""
    | | $a | $b |
    |:---|---:|---:|
    | Productividad del capital, ``v_i`` | $(rd(r.v1)) | $(rd(r.v2)) |
    | Tasa de ahorro, ``s_i`` | $(rd(r.s1, 2)) | $(rd(r.s2, 2)) |
    | Tasa interna de crecimiento, ``\\gamma_i = s_iv_i`` | $(rd(r.γ[1], 4)) | $(rd(r.γ[2], 4)) |
    | Producto al final, ``Y_i(T)`` | $(rd(r.Yi[end][1])) | $(rd(r.Yi[end][2])) |

    **Política óptima:** $(describir_politica(r))

    Tiempo de cambio ``t^\\ast``: analítico, $analitico; numérico, $numerico.
    Producto nacional al final: ``Y(T) = `` $(rd(r.Y[end])).
    """)
end

# ╔═╡ 5e1b7236-cf07-11f1-bacb-6548d5d85032
tabla_plan(plan)

# ╔═╡ 5e1b7286-cf07-11f1-b2ee-2d32b93fad8d
tabla_plan(mexico)

# ╔═╡ 5e1b73b2-cf07-11f1-96f8-19ced5f4e64a
"Producto nacional al final con un reparto fijo θ y K(0) = (1, 1)."
function producto_fijo_ref(θ, v1, v2, s1, s2, T)
    M = [θ * s1 * v1 θ * s2 * v2; (1 - θ) * s1 * v1 (1 - θ) * s2 * v2]
    dot([v1, v2], exp(M * T) * [1.0, 1.0])
end

# ╔═╡ 5e1b724a-cf07-11f1-8029-c3e75415e59c
let
    p = plan
    θs = range(0, 1, length = 101)
    Ys = [producto_fijo_ref(θ, p.v1, p.v2, p.s1, p.s2, p.T) for θ in θs]
    g = plot(θs, Ys; color = AZUL, lw = 2.5, xlabel = "fracción fija a la región 1, θ",
             ylabel = "Y(T)", title = "Repartos fijos contra el óptimo", size = (640, 320))
    hline!(g, [p.Y[end]]; color = NARANJA, lw = 2)
    i = argmax(Ys)
    scatter!(g, [θs[i]], [Ys[i]]; color = TINTA, ms = 5, msw = 0)
    g
end

# ╔═╡ 5e1b725e-cf07-11f1-b2f1-c7a7c5ffd13d
let
    p = plan
    θs = range(0, 1, length = 101)
    Ys = [producto_fijo_ref(θ, p.v1, p.v2, p.s1, p.s2, p.T) for θ in θs]
    i = argmax(Ys)
    mitad = producto_fijo_ref(0.5, p.v1, p.v2, p.s1, p.s2, p.T)
    md"""
    El mejor reparto fijo (``\theta = `` $(round(θs[i], digits = 2))) da
    ``Y(T) = `` $(round(Ys[i], digits = 3)); repartir a la mitad da
    $(round(mitad, digits = 3)); el plan óptimo da $(round(p.Y[end], digits = 3))
    (línea naranja), $(round(100 * (p.Y[end] / Ys[i] - 1), digits = 1))% más que
    el mejor reparto fijo.

    **Mueve** los parámetros de la sección 1 para que no haya cambio. ¿Qué
    pasa entonces con la diferencia entre el mejor reparto fijo y el
    óptimo? ¿Qué importa más, cuánto recibe cada región o **cuándo**?
    """
end

# ╔═╡ 5e1b73bc-cf07-11f1-8714-bbd6711da300
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

# ╔═╡ 5e1b72fe-cf07-11f1-8bd1-dd1f76fe2b94
verificar(() -> [tau_cambio(0.20, 0.25, 0.30, 0.20), tau_cambio(0.40, 0.461, 0.25, 0.19)],
          [20log(2), log(0.40 * 0.06 / (0.25 * 0.40 - 0.19 * 0.461)) / (0.19 * 0.461)];
          pista = md"Con `γ1 = s1 * v1` y `γ2 = s2 * v2`: `log(v1 * (s1 - s2) / (γ1 - γ2)) / γ2`.")

# ╔═╡ 5e1b7314-cf07-11f1-965e-13b502acd065
verificar(() -> [s_umbral(0.40, 0.461, 0.19), s_umbral(0.114, 0.530, 0.19)],
          [0.19 * 0.461 / 0.40, 0.19 * 0.530 / 0.114];
          pista = md"Hace falta ``\gamma_1 > \gamma_2``, es decir, ``s_1v_1 > s_2v_2``: `s2 * v2 / v1`.")

# ╔═╡ 5e1b7330-cf07-11f1-ac1a-41f637442a52
verificar(() -> [producto_fijo(0.5, 0.20, 0.25, 0.30, 0.20, 30.0), producto_fijo(1.0, 0.40, 0.461, 0.25, 0.19, 20.0)],
          [producto_fijo_ref(0.5, 0.20, 0.25, 0.30, 0.20, 30.0), producto_fijo_ref(1.0, 0.40, 0.461, 0.25, 0.19, 20.0)];
          rtol = 1e-6,
          pista = md"`M = [θ*s1*v1  θ*s2*v2; (1-θ)*s1*v1  (1-θ)*s2*v2]`; después `[v1 v2] * exp(M * T) * [1.0, 1.0]`, y toma el único elemento con `only` o `[1]`.")

# ╔═╡ 5e1b7346-cf07-11f1-9056-ad69a6872055
verificar(() -> [tau_ponderado(0.20, 0.25, 0.30, 0.20, 1.0, 1.0), tau_ponderado(0.20, 0.25, 0.30, 0.20, 1.1, 1.0)],
          [resolver_rit(0.20, 0.25, 0.30, 0.20, 60.0).τ, resolver_rit(0.20, 0.25, 0.30, 0.20, 60.0; ω = (1.1, 1.0)).τ];
          rtol = 1e-3,
          pista = md"Igualando ``p_1 = p_2`` en la última fase: ``e^{\gamma_2\tau} = (\gamma_1\omega_2v_2 - \gamma_2\omega_1v_1)/(\omega_2v_2(\gamma_1 - \gamma_2))``.")

# ╔═╡ Cell order:
# ╟─5e1b71ac-cf07-11f1-80ec-379a5232e34b
# ╟─5e1b7204-cf07-11f1-a86d-d9b49297b84e
# ╟─5e1b720c-cf07-11f1-b9c8-a98243fe1feb
# ╠═5e1b7222-cf07-11f1-845b-cd8c56314432
# ╟─5e1b722c-cf07-11f1-b1ce-51b090b24e85
# ╟─5e1b7236-cf07-11f1-bacb-6548d5d85032
# ╟─5e1b723e-cf07-11f1-8419-d525a64db705
# ╟─5e1b724a-cf07-11f1-a76c-eff0496a1c1a
# ╟─5e1b724a-cf07-11f1-8029-c3e75415e59c
# ╟─5e1b725e-cf07-11f1-b2f1-c7a7c5ffd13d
# ╟─5e1b7268-cf07-11f1-9cf1-3f4c56aaffe3
# ╠═5e1b7270-cf07-11f1-9aba-c9b97ce1db96
# ╠═5e1b727c-cf07-11f1-95fa-4199b0c0cf1b
# ╟─5e1b7286-cf07-11f1-be78-bdb463fdbad1
# ╟─5e1b7286-cf07-11f1-b2ee-2d32b93fad8d
# ╟─5e1b7290-cf07-11f1-8089-6519e011e2ef
# ╟─5e1b72a4-cf07-11f1-ab28-ff5117caf0e2
# ╟─5e1b72ae-cf07-11f1-b012-67fa30365717
# ╟─5e1b72b8-cf07-11f1-92a9-ed682b2333a7
# ╟─5e1b72c2-cf07-11f1-9560-0d7c93f4e40a
# ╟─5e1b72cc-cf07-11f1-9938-55c9018dcd10
# ╟─5e1b72d6-cf07-11f1-a3fe-232f86d0614f
# ╟─5e1b72e2-cf07-11f1-94d8-e590ec08c20f
# ╟─5e1b72ea-cf07-11f1-bfdb-7bf6ada58657
# ╠═5e1b72f4-cf07-11f1-bb6f-dd75e208cf94
# ╟─5e1b72fe-cf07-11f1-8bd1-dd1f76fe2b94
# ╟─5e1b72fe-cf07-11f1-8a4b-2599fca149c9
# ╠═5e1b7308-cf07-11f1-8eda-97886ea7cac8
# ╟─5e1b7314-cf07-11f1-965e-13b502acd065
# ╟─5e1b731c-cf07-11f1-a19a-4bc501455d3c
# ╠═5e1b7326-cf07-11f1-965d-5dd4ccb89cfb
# ╟─5e1b7330-cf07-11f1-ac1a-41f637442a52
# ╟─5e1b733a-cf07-11f1-aba3-d3374292bd85
# ╠═5e1b733a-cf07-11f1-b6fa-efc6337bc8b4
# ╟─5e1b7346-cf07-11f1-9056-ad69a6872055
# ╟─5e1b734e-cf07-11f1-887f-b1dee422ef6d
# ╟─5e1b7358-cf07-11f1-969f-9f030f38b0e0
# ╠═5e1b7362-cf07-11f1-b1c3-a1f327fb9aa8
# ╠═5e1b736c-cf07-11f1-80ec-6173093e5ba8
# ╠═5e1b736c-cf07-11f1-af63-9dcb98b5f851
# ╠═5e1b7374-cf07-11f1-831e-b1daee98b329
# ╠═5e1b7380-cf07-11f1-843a-29a9d69ec5f7
# ╠═5e1b7394-cf07-11f1-8283-fdc1712b3cf4
# ╠═5e1b739e-cf07-11f1-87ff-ab32a9cb018c
# ╠═5e1b739e-cf07-11f1-a76f-e7049eb44b87
# ╠═5e1b73a6-cf07-11f1-ab7e-c1c407c60943
# ╠═5e1b73b2-cf07-11f1-96f8-19ced5f4e64a
# ╠═5e1b73bc-cf07-11f1-8714-bbd6711da300
