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

# ╔═╡ dfba9144-cf02-11f1-b6ea-db8dfccba4b8
begin
    # Usa el entorno del curso (Code/Project.toml) en lugar del gestor de
    # paquetes propio de Pluto: un solo entorno para todo el repositorio.
    import Pkg
    Pkg.activate(@__DIR__)
    Pkg.instantiate()
    using PlutoUI, Plots, LinearAlgebra, Markdown
    gr()
    default(size = (720, 320), legend = false, grid = :y, gridalpha = 0.15,
            framestyle = :axes, titlefontsize = 11, guidefontsize = 9,
            tickfontsize = 8, legendfontsize = 8, foreground_color_legend = nothing,
            background_color_legend = nothing, margin = 3Plots.mm)
end

# ╔═╡ dfba8ff2-cf02-11f1-8b2c-e13fa5369755
md"""
# Sesión 8: Estabilidad de sistemas no lineales

**Pregunta de la unidad.** ¿Convergen los estados de México? ¿A qué
velocidad?

**Cómo usar este cuaderno.** La teoría está en las notas,
`Class_notes/s08_estabilidad_no_lineal.md`, y se desarrolla en el pizarrón;
el cuaderno sirve para mover los parámetros y ver qué pasa. En clase se
proyectan las secciones 1 a 4; los ejercicios son para después. Pluto es
reactivo: al mover un deslizador, todo lo que depende de él se recalcula.

**Cómo abrirlo.** Desde la raíz del repositorio:
`julia --project=Code -e 'using Pluto; Pluto.run()'` y abrir
`Code/s08_estabilidad_no_lineal.jl`.
"""

# ╔═╡ dfba902e-cf02-11f1-874e-872c87bb40b4
TableOfContents(title = "Contenido")

# ╔═╡ dfba9042-cf02-11f1-9045-71b22f8951ab
md"""
## 1. Dos regiones que compiten por la misma actividad

*En clase, después de la sección 2 de las notas.* Diagrama de fase de
``\dot x = x(1 - x - ay)``, ``\dot y = y(1 - y - bx)``. Las rectas azul y
naranja son las isoclinas ``\dot x = 0`` y ``\dot y = 0``; los puntos llenos
son equilibrios estables y los vacíos, inestables o puntos de silla. Si el
equilibrio interior es un punto de silla, la curva negra es la
**separatriz**.

Cuánto le quita la región 2 a la 1, ``a``: $(@bind a_c Slider(0.2:0.1:2.5, default = 2.0, show_value = true))

Cuánto le quita la región 1 a la 2, ``b``: $(@bind b_c Slider(0.2:0.1:2.5, default = 2.0, show_value = true))
"""

# ╔═╡ dfba9060-cf02-11f1-b165-0dd9767d2f83
md"""
Recorre los tres casos de la tabla de la sección 2.4 de las notas:

1. **Competencia débil**, ``a = b = 0.5``: ¿cuántos equilibrios estables hay?
   ¿A dónde van todas las trayectorias?
2. **Competencia fuerte**, ``a = b = 2``: **observa** la separatriz. ¿A dónde
   van dos regiones que empiezan casi iguales, a uno y otro lado de ella?
3. **Mueve** ``a`` a 2.5 con ``b = 2``: ¿hacia dónde se inclina la
   separatriz? ¿Qué región tiene ahora la cuenca más grande?
4. **Una región domina**, ``a = 0.5`` y ``b = 1.5``: ¿qué pasó con el
   equilibrio interior?
5. ¿Qué tendría que cambiar una política para pasar del caso 2 al caso 1?
"""

# ╔═╡ dfba906a-cf02-11f1-8671-45cfff0f85e5
md"""
## 2. El diagrama de fase de Ramsey

*En clase, después de la sección 3.4 de las notas.* Con ``\alpha = 0.3`` y
``\delta = 0.05``. La curva azul es la isoclina ``\dot k = 0``, la recta
punteada es ``\dot c = 0`` y la curva naranja es la **rama estable**. La
trayectoria negra empieza en ``(k_0, c_0)``.

Tasa de descuento ``\rho``: $(@bind ρ Slider(0.01:0.005:0.08, default = 0.03, show_value = true))

Parámetro de aversión ``\theta``: $(@bind θ Slider(0.5:0.5:5.0, default = 2.0, show_value = true))

Capital inicial, como fracción de ``k^\ast``: $(@bind k0_frac Slider(0.2:0.1:2.0, default = 0.5, show_value = true))

Consumo inicial, como fracción del de la rama estable: $(@bind c0_frac Slider(0.85:0.01:1.15, default = 0.97, show_value = true))
"""

# ╔═╡ dfba909c-cf02-11f1-a39a-5d2b1134c38f
md"""
## 3. La función de política: cuánto ahorra una región pobre

*Si alcanza (margen de la clase)* (notas, 3.5). La rama estable como función ``c = \sigma(k)``, y la
tasa de ahorro que implica, ``1 - \sigma(k)/k^\alpha``.
"""

# ╔═╡ dfba90b2-cf02-11f1-b6b5-5f45b84fd79d
md"""
**Observa:** ¿ahorra más una región pobre o una rica? ¿Dónde queda el ahorro
de largo plazo respecto de la regla de oro (línea punteada)? **Mueve**
``\theta`` en la sección 2 y mira qué pasa con el ahorro de la región pobre.
"""

# ╔═╡ dfba90ba-cf02-11f1-a4cb-836cbed227a2
md"""
## 4. Un cambio inesperado en la paciencia

*Si alcanza (margen de la clase), con la sección 3.6 de las notas.* La economía está en su estado
estacionario con ``\rho = 0.04`` y, en el año 10, la tasa de descuento cambia
de manera permanente al valor ``\rho`` del deslizador de la sección 2.
"""

# ╔═╡ dfba90ce-cf02-11f1-91bd-87c8280594f1
md"""
1. **Pon** ``\rho = 0.03`` en la sección 2: la economía se vuelve más
   paciente. ¿Qué variable salta en el año 10, y hacia dónde? ¿Cuál se mueve
   despacio?
2. **Pon** ``\rho = 0.06``: ¿qué cambia en la respuesta?
3. ¿Por qué el consumo cae justo cuando la economía se vuelve más paciente,
   si a largo plazo termina más alto?
"""

# ╔═╡ dfba90d8-cf02-11f1-960e-abaca39e037c
md"""
## Ejercicios

*Después de clase.* Los ejercicios con demostraciones están en las notas
(sección 7).

### Completa el código

**1.** Escribe `jacobiano_competencia(x, y, a, b)`, el jacobiano del modelo
de competencia en el punto ``(x, y)``.
"""

# ╔═╡ dfba90d8-cf02-11f1-9500-8332f7afd7bd
function jacobiano_competencia(x, y, a, b)
    missing  # reemplaza esta línea
end

# ╔═╡ dfba90ec-cf02-11f1-8ada-b54d51f0035f
md"""
**2.** Escribe `equilibrio_interior(a, b)`, que devuelva el vector
``[x^\ast, y^\ast]`` del equilibrio interior, suponiendo ``ab \ne 1``.
"""

# ╔═╡ dfba90f6-cf02-11f1-9265-a3a322b92d3a
function equilibrio_interior(a, b)
    missing  # reemplaza esta línea
end

# ╔═╡ dfba910a-cf02-11f1-950a-97a3b05e8087
md"""
**3.** Escribe `consumo_inicial(k0)`, que encuentre por **disparo** el
consumo de la rama estable para el capital ``k_0``, con los parámetros
``\alpha = 0.3``, ``\delta = 0.05``, ``\rho = 0.03`` y ``\theta = 2``. Usa
`destino(k0, c0)`, que simula la trayectoria y devuelve `:agota` si el
capital se agota o `:acumula` si se acumula de más. Haz bisección sobre
``c_0`` entre ``10^{-6}`` y ``k_0^{0.3}``, unas 50 veces.
"""

# ╔═╡ dfba910a-cf02-11f1-9877-971dd799f03f
function consumo_inicial(k0)
    missing  # reemplaza esta línea
end

# ╔═╡ dfba911e-cf02-11f1-a697-bb0f45a61848
md"""
**4. [Avanzado]** Escribe `tasa_ahorro_ss(α, δ, ρ)`, la tasa de ahorro del
estado estacionario de Ramsey (notas, ejercicio F4).
"""

# ╔═╡ dfba9128-cf02-11f1-84a5-c9d3297ae636
tasa_ahorro_ss(α, δ, ρ) = missing  # reemplaza missing

# ╔═╡ dfba9132-cf02-11f1-9923-2981c32afd95
md"""
### Interpretación

5. En la competencia fuerte, dos regiones empiezan en ``(0.42, 0.40)`` y
   ``(0.40, 0.42)``. ¿Qué le pasa a cada una? ¿Qué dice esto sobre las
   políticas de "esperar a que el mercado decida"?
6. En Ramsey, ¿por qué una economía que consume demasiado al principio
   termina sin capital, y una que consume demasiado poco no es óptima,
   aunque acumule mucho?
7. Según la sección 3, ¿qué región debería tener la mayor tasa de ahorro,
   una rica o una pobre? ¿Coincide con lo que se observa entre los estados
   de México (sesión 5)? ¿Qué supuesto del modelo podría explicar la
   diferencia?

### Tu tesis

8. Si tu problema tiene un punto de silla, ¿cuál es la variable de estado,
   que no puede saltar, y cuál la de control, que salta a la rama estable?

### [Avanzado]

9. Compara la rama estable de la sección 2 con la recta del eigenvector
   estable de la sesión 7. ¿Dónde coinciden y dónde se separan?

## Para la próxima sesión

- **Sesión 9: Laboratorio 1.** Diagramas de fase con DifferentialEquations.jl:
  el modelo de Solow con dos regiones y movilidad de capital.
- Repaso: D.B3 (método de Euler), N.B1 a N.B3 (Julia, gráficas y Pluto),
  N.I3 (DifferentialEquations.jl) y N.I6 (error y convergencia).
"""

# ╔═╡ dfba913c-cf02-11f1-988b-0b27c4135428
md"""
---
## Apéndice: paquetes y funciones auxiliares

Estas celdas definen herramientas que usa el cuaderno. No es necesario
leerlas para seguir la sesión.
"""

# ╔═╡ dfba9150-cf02-11f1-a71e-a3d2731fd513
begin
    const AZUL    = "#2a78d6"   # isoclina ẋ = 0 y k̇ = 0, ahorro
    const NARANJA = "#eb6834"   # isoclina ẏ = 0, rama estable
    const GRIS    = "#52514e"   # campo y trayectorias de referencia
    const TINTA   = "#0b0b0b"   # equilibrios, separatriz, trayectoria elegida
end;

# ╔═╡ dfba915a-cf02-11f1-a28e-330af137d26b
"Un paso de Runge-Kutta de cuarto orden para ż = F(z) (dt negativo integra hacia atrás)."
function paso_rk4(F, z, dt)
    k1 = F(z); k2 = F(z .+ dt / 2 .* k1); k3 = F(z .+ dt / 2 .* k2); k4 = F(z .+ dt .* k3)
    z .+ dt / 6 .* (k1 .+ 2k2 .+ 2k3 .+ k4)
end

# ╔═╡ dfba9164-cf02-11f1-808b-472d6785aa58
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

# ╔═╡ dfba916e-cf02-11f1-9693-7766da76857a
"Dibuja el campo de direcciones (flechas de igual largo) de ż = F(z) en el rectángulo."
function campo!(p, F, xr, yr; n = 11)
    xs, ys = range(xr..., length = n), range(yr..., length = n)
    pts = [(u, v) for u in xs for v in ys]
    dirs = [F([u, v]) for (u, v) in pts]
    lx, ly = 0.35 * (xr[2] - xr[1]) / n, 0.35 * (yr[2] - yr[1]) / n
    unit(d) = d ./ max(hypot(d[1] / lx, d[2] / ly), 1e-12)
    quiver!(p, first.(pts), last.(pts); quiver = (first.(unit.(dirs)), last.(unit.(dirs))),
            color = GRIS, alpha = 0.45, lw = 0.8)
end

# ╔═╡ dfba916e-cf02-11f1-82a3-111566ec2948
"""
Las dos ramas estables de un punto de silla z⋆ con eigenvector estable vs,
integrando hacia atrás desde z⋆ ± ε vs hasta salir de los límites.
"""
function ramas_estables(F, zstar, vs; limites, ε = 1e-4, T = 400.0)
    fuera(z) = !(limites[1][1] <= z[1] <= limites[1][2] && limites[2][1] <= z[2] <= limites[2][2])
    [trayectoria(F, zstar .+ s * ε .* vs, -T; parar = fuera) for s in (1, -1)]
end

# ╔═╡ dfba9182-cf02-11f1-8aa9-c53edb232071
"Jacobiano del modelo de competencia en (x, y)."
jacobiano_competencia_ref(x, y, a, b) = [1 - 2x - a * y  -a * x; -b * y  1 - 2y - b * x]

# ╔═╡ dfba9176-cf02-11f1-acc7-8363e5e7560d
"Equilibrios del modelo de competencia, con eigenvalores, tipo y eigenvector estable."
function equilibrios_competencia(a, b)
    cand = [(0.0, 0.0), (1.0, 0.0), (0.0, 1.0)]
    if abs(1 - a * b) > 1e-9
        xi, yi = (1 - a) / (1 - a * b), (1 - b) / (1 - a * b)
        xi > 0 && yi > 0 && push!(cand, (xi, yi))
    end
    map(cand) do (x, y)
        λ, V = eigen(jacobiano_competencia_ref(x, y, a, b))
        λ = real.(λ)
        tipo = all(λ .< 0) ? :estable : any(λ .< 0) ? :silla : :inestable
        (; x, y, λ, tipo, vs = real.(V[:, argmin(λ)]))
    end
end

# ╔═╡ dfba9056-cf02-11f1-b95d-2d3e75c9968b
let
    eqs = equilibrios_competencia(a_c, b_c)
    nombres = Dict(:estable => "estable", :silla => "punto de silla", :inestable => "inestable")
    filas = join(["| ($(round(e.x, digits = 3)), $(round(e.y, digits = 3))) | $(join(round.(e.λ, digits = 3), ", ")) | $(nombres[e.tipo]) |" for e in eqs], "\n")
    caso = a_c < 1 && b_c < 1 ? "**Competencia débil**: las dos regiones coexisten en el equilibrio interior, empiecen donde empiecen." :
           a_c > 1 && b_c > 1 ? "**Competencia fuerte**: una sola región se queda con la actividad. Cuál, depende de qué lado de la separatriz se empiece." :
           "**Una región domina**: el equilibrio interior no existe en el cuadrante positivo, y la misma región gana desde cualquier punto de partida."
    Markdown.parse("""
    | Equilibrio | Eigenvalores del jacobiano | Tipo |
    |:---|:---|:---|
    $filas

    $caso
    """)
end

# ╔═╡ dfba918c-cf02-11f1-932f-8562e12e1f41
"Puntos de partida de las trayectorias de la sección 1, sobre el borde del cuadrado."
const PUNTOS_INICIALES = [[u, v] for (u, v) in vcat([(t, 1.25) for t in 0.05:0.15:1.25],
                                                    [(1.25, t) for t in 0.05:0.15:1.1],
                                                    [(t, 0.02) for t in 0.1:0.3:1.0],
                                                    [(0.02, t) for t in 0.1:0.3:1.0])]

# ╔═╡ dfba904c-cf02-11f1-a15b-d559ca3d568b
let
    F(z) = [z[1] * (1 - z[1] - a_c * z[2]), z[2] * (1 - z[2] - b_c * z[1])]
    p = plot(; xlims = (0, 1.3), ylims = (0, 1.3), aspect_ratio = :equal, xlabel = "región 1, x",
             ylabel = "región 2, y", title = "Competencia con a = $a_c, b = $b_c", size = (560, 520))
    campo!(p, F, (0, 1.3), (0, 1.3))
    xs = range(0, 1.3, length = 100)
    plot!(p, xs, (1 .- xs) ./ a_c; color = AZUL, lw = 2)          # ẋ = 0
    plot!(p, xs, 1 .- b_c .* xs; color = NARANJA, lw = 2)         # ẏ = 0
    for z0 in PUNTOS_INICIALES
        tr = trayectoria(F, z0, 40)
        plot!(p, first.(tr), last.(tr); color = GRIS, lw = 1, alpha = 0.7)
    end
    eqs = equilibrios_competencia(a_c, b_c)
    for e in eqs
        if e.tipo == :silla && e.x > 0 && e.y > 0
            for rama in ramas_estables(F, [e.x, e.y], e.vs; limites = ((0, 1.3), (0, 1.3)))
                plot!(p, first.(rama), last.(rama); color = TINTA, lw = 2.5)
            end
        end
        scatter!(p, [e.x], [e.y]; color = e.tipo == :estable ? TINTA : :white,
                 markerstrokecolor = TINTA, ms = 7, msw = 1.5)
    end
    p
end

# ╔═╡ dfba9196-cf02-11f1-85b9-fd865051adcf
"""
Modelo de Ramsey con f(k) = k^α: campo, estado estacionario, regla de oro y la
rama estable (calculada hacia atrás), ordenada por k.
"""
function modelo_ramsey(α, δ, ρ, θ)
    F(z) = (k = max(z[1], 1e-9); [k^α - δ * z[1] - z[2], z[2] / θ * (α * k^(α - 1) - δ - ρ)])
    kstar = (α / (δ + ρ))^(1 / (1 - α))
    cstar = kstar^α - δ * kstar
    kro = (α / δ)^(1 / (1 - α))
    J = [ρ -1.0; cstar * α * (α - 1) * kstar^(α - 2) / θ 0.0]
    λ, V = eigen(J)
    vs = V[:, argmin(λ)]
    lim = ((0.01kstar, 3kstar), (0.0, 3cstar))
    ramas = [trayectoria(F, [kstar, cstar] .+ s * 1e-5 .* vs, -2000.0; dt = 0.02,
                         parar = z -> !(lim[1][1] <= z[1] <= lim[1][2] && lim[2][1] <= z[2] <= lim[2][2]))
             for s in (1, -1)]
    # Tiempos hacia atrás de cada punto (para reconstruir la trayectoria hacia adelante)
    pts = vcat(reverse(ramas[2]), ramas[1])
    orden = sortperm(first.(pts))
    (; α, δ, ρ, θ, F, kstar, cstar, kro, λs = minimum(λ), vs, ramas,
     rama_k = first.(pts[orden]), rama_c = last.(pts[orden]))
end

# ╔═╡ dfba9074-cf02-11f1-99d0-21cdfdfd66f4
ramsey = modelo_ramsey(0.3, 0.05, ρ, θ)

# ╔═╡ dfba91a0-cf02-11f1-a1f4-694b176e21d6
"Consumo de la rama estable para el capital k (interpolación lineal)."
function politica(r, k)
    i = clamp(searchsortedlast(r.rama_k, k), 1, length(r.rama_k) - 1)
    w = (k - r.rama_k[i]) / (r.rama_k[i + 1] - r.rama_k[i])
    (1 - w) * r.rama_c[i] + w * r.rama_c[i + 1]
end

# ╔═╡ dfba9080-cf02-11f1-ac1d-d966d7f52041
let
    r = ramsey
    k0 = k0_frac * r.kstar
    c0 = c0_frac * politica(r, k0)
    kmax = 2.4r.kstar
    p = plot(; xlims = (0, kmax), ylims = (0, 2r.cstar), xlabel = "capital k", ylabel = "consumo c",
             title = "Ramsey: ρ = $ρ, θ = $θ", size = (700, 440))
    campo!(p, r.F, (0.02kmax, kmax), (0.02r.cstar, 2r.cstar); n = 13)
    ks = range(0.01, kmax, length = 300)
    plot!(p, ks, ks .^ r.α .- r.δ .* ks; color = AZUL, lw = 2)
    vline!(p, [r.kstar]; color = AZUL, lw = 1.5, ls = :dash)
    plot!(p, r.rama_k, r.rama_c; color = NARANJA, lw = 3)
    tr = trayectoria(r.F, [k0, c0], 300; parar = z -> z[1] < 0.02 || z[1] > kmax || z[2] > 2r.cstar)
    plot!(p, first.(tr), last.(tr); color = TINTA, lw = 2)
    scatter!(p, [k0], [c0]; color = TINTA, ms = 5, msw = 0)
    scatter!(p, [r.kstar], [r.cstar]; color = :white, markerstrokecolor = TINTA, ms = 7, msw = 1.5)
end

# ╔═╡ dfba9092-cf02-11f1-a19e-452adb1aad47
let
    r = ramsey
    rd(v) = round(v, digits = 3)
    md"""
    | | Valor |
    |:---|---:|
    | Estado estacionario ``(k^\ast, c^\ast)`` | ($(rd(r.kstar)), $(rd(r.cstar))) |
    | Regla de oro, ``k_{RO}`` (``f'(k) = \delta``) | $(rd(r.kro)) |
    | Tasa de ahorro en el estado estacionario, ``\alpha\delta/(\delta + \rho)`` | $(rd(r.α * r.δ / (r.δ + ρ))) |
    | Consumo óptimo con ``k_0`` = $(rd(k0_frac * r.kstar)) | $(rd(politica(r, k0_frac * r.kstar))) |

    1. Con ``k_0 = 0.5k^\ast``, **pon** ``c_0`` en 1 (la rama estable), en
       1.03 y en 0.97: son los tres destinos de la sección 3.4 de las notas.
    2. **Mueve** ``k_0`` por encima de ``k^\ast``: ¿qué rama sigue ahora la
       economía? ¿El consumo sube o baja en la transición?
    3. **Baja** ``\rho``: ¿hacia dónde se mueve la recta ``\dot c = 0``? ¿Se
       acerca ``k^\ast`` a la regla de oro?
    4. **Sube** ``\theta``: ¿qué le pasa a la rama estable cerca de
       ``k^\ast``?
    """
end

# ╔═╡ dfba90a6-cf02-11f1-b3b0-13e2885fd9e1
let
    r = ramsey
    ks = range(0.15r.kstar, 2r.kstar, length = 200)
    cs = politica.(Ref(r), ks)
    g1 = plot(ks, cs; color = NARANJA, lw = 2.5, xlabel = "capital k", ylabel = "consumo σ(k)",
              title = "Función de política")
    vline!(g1, [r.kstar]; color = GRIS, ls = :dash, lw = 1)
    g2 = plot(ks, 100 .* (1 .- cs ./ ks .^ r.α); color = AZUL, lw = 2.5, xlabel = "capital k",
              ylabel = "tasa de ahorro (%)", title = "Ahorro óptimo")
    vline!(g2, [r.kstar]; color = GRIS, ls = :dash, lw = 1)
    hline!(g2, [100r.α]; color = GRIS, ls = :dot, lw = 1)
    plot(g1, g2; layout = (1, 2), size = (780, 320))
end

# ╔═╡ dfba91aa-cf02-11f1-a32f-8f91f87eed5a
"Destino de la trayectoria de Ramsey desde (k0, c0): :agota, :acumula o :llega."
function destino_ref(r, k0, c0; T = 400.0, dt = 0.05)
    z = [k0, c0]
    for _ in 1:round(Int, T / dt)
        z = paso_rk4(r.F, z, dt)
        (z[1] < 0.01r.kstar || any(isnan, z)) && return :agota
        (z[2] < 0.01r.cstar || z[1] > 1.5max(r.kstar, k0)) && return :acumula
    end
    :llega
end

# ╔═╡ dfba9088-cf02-11f1-bcfc-dfde479046f4
let
    r = ramsey
    k0 = k0_frac * r.kstar
    destino = destino_ref(r, k0, c0_frac * politica(r, k0))
    lectura = abs(c0_frac - 1) < 0.005 ?
        md"Con el consumo de la **rama estable**, la economía llega al estado estacionario. Cualquier error, por pequeño que sea, la saca de ahí con el tiempo: es un punto de silla." :
        destino == :agota ?
        md"Con un consumo inicial **mayor** que el de la rama estable, el consumo sigue subiendo, cruza la isoclina ``\dot k = 0`` y el capital se **agota** en tiempo finito. No es factible." :
        md"Con un consumo inicial **menor** que el de la rama estable, el capital pasa de ``k^\ast``, el consumo se desploma y el capital se **acumula** sin consumirse nunca. La condición de transversalidad la descarta (sesión 12)."
    lectura
end

# ╔═╡ dfba91b4-cf02-11f1-8735-4b751dded5f5
begin
    # Modelo de Ramsey con los parámetros del ejercicio 3, y el destino de la
    # trayectoria desde (k0, c0) con esos parámetros
    const RAMSEY_BASE = modelo_ramsey(0.3, 0.05, 0.03, 2.0)
    destino(k0, c0) = destino_ref(RAMSEY_BASE, k0, c0)
end

# ╔═╡ dfba91b4-cf02-11f1-a05e-fb3806e84194
"""
Capital y consumo cuando ρ cambia en t_cambio: antes, el estado estacionario
viejo; después, la rama estable del modelo nuevo, recorrida hacia adelante.
"""
function respuesta_a_cambio(viejo, nuevo; t_cambio = 10.0, horizonte = 120.0, dt = 0.02)
    k0 = viejo.kstar
    # La rama del lado de k0, recorrida desde lejos hacia el estado estacionario
    izquierda = nuevo.ramas[1][end][1] < nuevo.kstar ? nuevo.ramas[1] : nuevo.ramas[2]
    derecha = izquierda === nuevo.ramas[1] ? nuevo.ramas[2] : nuevo.ramas[1]
    rama = k0 < nuevo.kstar ? izquierda : derecha
    i = findfirst(z -> (k0 < nuevo.kstar ? z[1] <= k0 : z[1] >= k0), rama)
    camino = i === nothing ? [[nuevo.kstar, nuevo.cstar]] : reverse(rama[1:i])
    n_antes = round(Int, t_cambio / dt)
    t = vcat(range(0, t_cambio, length = n_antes), t_cambio .+ dt .* (0:length(camino) - 1))
    k = vcat(fill(viejo.kstar, n_antes), first.(camino))
    c = vcat(fill(viejo.cstar, n_antes), last.(camino))
    dentro = t .<= horizonte
    # Después de recorrer la rama, la economía se queda en el estado estacionario
    if t[end] < horizonte
        extra = range(t[end] + dt, horizonte, step = dt)
        t = vcat(t, extra); k = vcat(k, fill(nuevo.kstar, length(extra))); c = vcat(c, fill(nuevo.cstar, length(extra)))
        dentro = trues(length(t))
    end
    t[dentro], k[dentro], c[dentro]
end

# ╔═╡ dfba90c4-cf02-11f1-b117-b7a1a06b1c27
let
    viejo = modelo_ramsey(0.3, 0.05, 0.04, θ)
    nuevo = ramsey
    t, k, c = respuesta_a_cambio(viejo, nuevo; t_cambio = 10.0, horizonte = 120.0)
    g1 = plot(t, k; color = AZUL, lw = 2, xlabel = "años", ylabel = "capital k", title = "Capital")
    g2 = plot(t, c; color = NARANJA, lw = 2, xlabel = "años", ylabel = "consumo c", title = "Consumo")
    for g in (g1, g2)
        vline!(g, [10]; color = GRIS, ls = :dot, lw = 1)
    end
    plot(g1, g2; layout = (1, 2), size = (780, 300))
end

# ╔═╡ dfba91c8-cf02-11f1-a346-cb8f5e5eda43
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

# ╔═╡ dfba90e4-cf02-11f1-90b6-63f8974c95ca
verificar(() -> [jacobiano_competencia(1.0, 0.0, 2.0, 2.0), jacobiano_competencia(0.3, 0.6, 0.5, 1.5)],
          [jacobiano_competencia_ref(1.0, 0.0, 2.0, 2.0), jacobiano_competencia_ref(0.3, 0.6, 0.5, 1.5)];
          pista = md"`[1 - 2x - a*y  -a*x; -b*y  1 - 2y - b*x]`")

# ╔═╡ dfba9100-cf02-11f1-8f87-275b457d96f4
verificar(() -> [equilibrio_interior(0.5, 0.5), equilibrio_interior(2.0, 2.0), equilibrio_interior(0.3, 0.8)],
          [[2 / 3, 2 / 3], [1 / 3, 1 / 3], [0.7 / 0.76, 0.2 / 0.76]];
          pista = md"Resuelve el sistema lineal ``x + ay = 1``, ``bx + y = 1``: ``x^\ast = (1 - a)/(1 - ab)``, ``y^\ast = (1 - b)/(1 - ab)``.")

# ╔═╡ dfba9112-cf02-11f1-a992-654b599292ce
verificar(() -> consumo_inicial.([1.65, 3.3, 9.9]),
          politica.(Ref(RAMSEY_BASE), [1.65, 3.3, 9.9]);
          rtol = 1e-3,
          pista = md"Con `lo, hi = 1e-6, k0^0.3`, repite: `m = (lo + hi) / 2`; si `destino(k0, m) == :agota`, el consumo es demasiado alto y `hi = m`; si no, `lo = m`. Devuelve `(lo + hi) / 2`.")

# ╔═╡ dfba9128-cf02-11f1-a3dd-d7f9b3e8129b
verificar(() -> [tasa_ahorro_ss(0.3, 0.05, 0.03), tasa_ahorro_ss(0.35, 0.06, 0.02)],
          [0.3 * 0.05 / 0.08, 0.35 * 0.06 / 0.08];
          pista = md"En el estado estacionario, el ahorro repone la depreciación: ``s = \delta k^\ast/(k^\ast)^\alpha = \delta (k^\ast)^{1-\alpha}``, y ``(k^\ast)^{1-\alpha} = \alpha/(\delta + \rho)``.")

# ╔═╡ Cell order:
# ╟─dfba8ff2-cf02-11f1-8b2c-e13fa5369755
# ╟─dfba902e-cf02-11f1-874e-872c87bb40b4
# ╟─dfba9042-cf02-11f1-9045-71b22f8951ab
# ╟─dfba904c-cf02-11f1-a15b-d559ca3d568b
# ╟─dfba9056-cf02-11f1-b95d-2d3e75c9968b
# ╟─dfba9060-cf02-11f1-b165-0dd9767d2f83
# ╟─dfba906a-cf02-11f1-8671-45cfff0f85e5
# ╠═dfba9074-cf02-11f1-99d0-21cdfdfd66f4
# ╟─dfba9080-cf02-11f1-ac1d-d966d7f52041
# ╟─dfba9088-cf02-11f1-bcfc-dfde479046f4
# ╟─dfba9092-cf02-11f1-a19e-452adb1aad47
# ╟─dfba909c-cf02-11f1-a39a-5d2b1134c38f
# ╟─dfba90a6-cf02-11f1-b3b0-13e2885fd9e1
# ╟─dfba90b2-cf02-11f1-b6b5-5f45b84fd79d
# ╟─dfba90ba-cf02-11f1-a4cb-836cbed227a2
# ╟─dfba90c4-cf02-11f1-b117-b7a1a06b1c27
# ╟─dfba90ce-cf02-11f1-91bd-87c8280594f1
# ╟─dfba90d8-cf02-11f1-960e-abaca39e037c
# ╠═dfba90d8-cf02-11f1-9500-8332f7afd7bd
# ╟─dfba90e4-cf02-11f1-90b6-63f8974c95ca
# ╟─dfba90ec-cf02-11f1-8ada-b54d51f0035f
# ╠═dfba90f6-cf02-11f1-9265-a3a322b92d3a
# ╟─dfba9100-cf02-11f1-8f87-275b457d96f4
# ╟─dfba910a-cf02-11f1-950a-97a3b05e8087
# ╠═dfba910a-cf02-11f1-9877-971dd799f03f
# ╟─dfba9112-cf02-11f1-a992-654b599292ce
# ╟─dfba911e-cf02-11f1-a697-bb0f45a61848
# ╠═dfba9128-cf02-11f1-84a5-c9d3297ae636
# ╟─dfba9128-cf02-11f1-a3dd-d7f9b3e8129b
# ╟─dfba9132-cf02-11f1-9923-2981c32afd95
# ╟─dfba913c-cf02-11f1-988b-0b27c4135428
# ╠═dfba9144-cf02-11f1-b6ea-db8dfccba4b8
# ╠═dfba9150-cf02-11f1-a71e-a3d2731fd513
# ╠═dfba915a-cf02-11f1-a28e-330af137d26b
# ╠═dfba9164-cf02-11f1-808b-472d6785aa58
# ╠═dfba916e-cf02-11f1-9693-7766da76857a
# ╠═dfba916e-cf02-11f1-82a3-111566ec2948
# ╠═dfba9176-cf02-11f1-acc7-8363e5e7560d
# ╠═dfba9182-cf02-11f1-8aa9-c53edb232071
# ╠═dfba918c-cf02-11f1-932f-8562e12e1f41
# ╠═dfba9196-cf02-11f1-85b9-fd865051adcf
# ╠═dfba91a0-cf02-11f1-a1f4-694b176e21d6
# ╠═dfba91aa-cf02-11f1-a32f-8f91f87eed5a
# ╠═dfba91b4-cf02-11f1-8735-4b751dded5f5
# ╠═dfba91b4-cf02-11f1-a05e-fb3806e84194
# ╠═dfba91c8-cf02-11f1-a346-cb8f5e5eda43
