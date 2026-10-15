# Genera las figuras de las notas de repaso (Class_notes/repaso/figuras/).
# Uso, desde la raíz del repositorio:  julia --project=Code Code/figuras_repaso.jl

ENV["GKSwstype"] = "100"          # GR sin ventana
using Plots, LinearAlgebra, DifferentialEquations
gr()

const SALIDA = joinpath(@__DIR__, "..", "Class_notes", "repaso", "figuras")
mkpath(SALIDA)

# Paleta del curso (la misma del curso de Econofísica)
const AZUL    = "#2a78d6"
const NARANJA = "#eb6834"
const AQUA    = "#1baf7a"
const GRIS    = "#52514e"
const TINTA   = "#0b0b0b"
const FONDO   = "#fcfcfb"
const RAMPA   = ["#86b6ef", "#3987e5", "#1c5cab", "#0d366b"]   # azul secuencial, claro → oscuro

default(size = (720, 320), dpi = 150, legend = false, grid = :y, gridalpha = 0.15,
        framestyle = :axes, linewidth = 2, titlefontsize = 11, guidefontsize = 9,
        tickfontsize = 8, legendfontsize = 8, background_color = FONDO,
        foreground_color_legend = nothing, background_color_legend = nothing,
        foreground_color_axis = GRIS, foreground_color_border = GRIS,
        foreground_color_guide = TINTA, foreground_color_text = GRIS,
        titlefontcolor = TINTA, margin = 4Plots.mm)

guardar(p, nombre) = (savefig(p, joinpath(SALIDA, nombre)); println("  ", nombre))
etiqueta(p, x, y, s, color = GRIS; pos = :left, tam = 8) =
    annotate!(p, x, y, text(s, tam, pos, color))

println("Generando figuras en ", normpath(SALIDA))

# ── 1. Lagrange: curvas de nivel y restricción presupuestal ──────────────────
let a1 = 2.0, a2 = 1.0, B = 10.0
    f(x1, x2) = a1 * sqrt(x1) + a2 * sqrt(x2)
    x1s = range(0, 12, length = 300); x2s = range(0, 12, length = 300)
    x1o = a1^2 / (a1^2 + a2^2) * B; x2o = B - x1o; Vo = f(x1o, x2o)
    p = contour(x1s, x2s, f; levels = [3.0, 5.0, Vo, 9.0], color = RAMPA[2], lw = 1.2, label = "",
                colorbar = false, size = (520, 420), xlims = (0, 12), ylims = (0, 12),
                aspect_ratio = :equal, grid = false,
                xlabel = "x₁ (inversión en la región 1)", ylabel = "x₂ (inversión en la región 2)",
                title = "Óptimo: tangencia entre curva de nivel y restricción")
    plot!(p, [0, B], [B, 0]; color = NARANJA, lw = 2, label = "x₁ + x₂ = 10")
    plot!(p, [NaN], [NaN]; color = RAMPA[2], lw = 1.2, label = "curvas de nivel de f")
    plot!(p; legend = :topright)
    scatter!(p, [x1o], [x2o]; color = TINTA, ms = 5, msw = 0, label = "")
    g = [a1 / (2sqrt(x1o)), a2 / (2sqrt(x2o))]; g = 2.2 .* g ./ norm(g)
    plot!(p, [x1o, x1o + g[1]], [x2o, x2o + g[2]]; arrow = true, color = TINTA, lw = 1.5, label = "")
    etiqueta(p, x1o + 0.3, x2o - 0.6, "óptimo (8, 2)", TINTA)
    etiqueta(p, x1o + g[1] + 0.2, x2o + g[2], "∇f ∥ ∇g", TINTA)
    guardar(p, "lagrange.png")
end

# ── 2. Diagramas de fase en una dimensión: Solow y telaraña ──────────────────
let s = 0.3, α = 0.3, δ = 0.1
    k = range(0, 8, length = 400)
    f(k) = s * k^α - δ * k
    kstar = (s / δ)^(1 / (1 - α))
    p1 = plot(k, f.(k); color = AZUL, xlabel = "k", ylabel = "k̇ = sk^α − δk",
              title = "Solow: diagrama de fase", ylims = (-0.25, 0.3))
    hline!(p1, [0]; color = GRIS, lw = 1)
    scatter!(p1, [0, kstar], [0, 0]; color = [:white, TINTA], ms = 5, msc = TINTA)
    for (x0, x1) in ((1.0, 2.6), (7.6, 6.0))
        plot!(p1, [x0, x1], [-0.08, -0.08]; arrow = true, color = NARANJA, lw = 1.5)
    end
    etiqueta(p1, kstar + 0.15, 0.03, "k* estable", TINTA)
    etiqueta(p1, 1.0, -0.13, "k crece", NARANJA)
    etiqueta(p1, 6.0, -0.13, "k decrece", NARANJA)

    g(x) = 2.8x * (1 - x)
    xs = range(0, 1, length = 300)
    p2 = plot(xs, g.(xs); color = AZUL, xlabel = "xₜ", ylabel = "xₜ₊₁",
              title = "Telaraña de xₜ₊₁ = 2.8xₜ(1 − xₜ)", xlims = (0, 1), ylims = (0, 1))
    plot!(p2, [0, 1], [0, 1]; color = GRIS, lw = 1, ls = :dash)
    x = 0.1; cx = [x]; cy = [0.0]
    for _ in 1:30
        y = g(x); push!(cx, x, y); push!(cy, y, y); x = y
    end
    plot!(p2, cx, cy; color = NARANJA, lw = 1)
    etiqueta(p2, 0.68, 0.30, "g′(x*) = −0.8:", TINTA)
    etiqueta(p2, 0.68, 0.23, "converge oscilando", TINTA)
    guardar(plot(p1, p2; layout = (1, 2), size = (1000, 360)), "fase_1d.png")
end

# ── 3. Sistemas lineales: nodo, silla, foco, centro ──────────────────────────
let casos = [("Nodo estable", [-1.0 0.0; 0.0 -3.0], 6.0),
             ("Punto de silla", [0.0 1.0; 1.0 0.0], 2.5),
             ("Foco estable", [-0.3 1.0; -1.0 -0.3], 12.0),
             ("Centro", [0.0 1.0; -1.0 0.0], 6.3)]
    paneles = []
    for (titulo, A, T) in casos
        λ = eigvals(A)
        p = plot(; title = titulo, xlims = (-1.6, 1.6), ylims = (-1.6, 1.6),
                 aspect_ratio = :equal, grid = false, xticks = false, yticks = false,
                 framestyle = :zerolines)
        iniciales = titulo == "Punto de silla" ?
            [[x, y] for x in (-1.5, 1.5) for y in range(-1.5, 1.5, length = 7)] ∪
            [[x, y] for y in (-1.5, 1.5) for x in range(-1.5, 1.5, length = 7)] :
            [[1.5cos(θ), 1.5sin(θ)] for θ in range(0, 2π, length = 13)[1:end-1]]
        if titulo == "Centro"
            iniciales = [[r, 0.0] for r in (0.4, 0.8, 1.2, 1.5)]
        end
        for x0 in iniciales
            ts = range(0, T, length = 300)
            tray = [exp(A * t) * x0 for t in ts]
            plot!(p, first.(tray), last.(tray); color = AZUL, lw = 1, alpha = 0.7)
        end
        if titulo == "Punto de silla"
            plot!(p, [-1.6, 1.6], [1.6, -1.6]; color = NARANJA, lw = 2.5)     # estable: (1, −1)
            plot!(p, [-1.6, 1.6], [-1.6, 1.6]; color = GRIS, lw = 1, ls = :dash)
        end
        tipo = isreal(λ) ? "λ = $(round.(real.(λ), digits = 1))" :
                           "λ = $(round(real(λ[1]), digits = 1)) ± $(round(abs(imag(λ[1])), digits = 1))i"
        etiqueta(p, -1.5, -1.42, tipo, TINTA; tam = 7)
        push!(paneles, p)
    end
    guardar(plot(paneles...; layout = (1, 4), size = (1100, 310)), "sistemas_lineales.png")
end

# ── 4. Ramsey: isoclinas y rama estable ──────────────────────────────────────
let p = (α = 0.3, δ = 0.05, ρ = 0.03, θ = 2.0)
    f(k) = k^p.α
    kstar = (p.α / (p.δ + p.ρ))^(1 / (1 - p.α))
    cstar = f(kstar) - p.δ * kstar
    function ramsey!(du, u, p, t)
        k, c = max(u[1], 1e-8), u[2]          # evita k < 0 en un paso antes de detenerse
        du[1] = k^p.α - p.δ * k - c
        du[2] = c * (p.α * k^(p.α - 1) - p.δ - p.ρ) / p.θ
    end
    fuera(u, t, integrator) = u[1] < 0.05 || u[1] > 26 || u[2] < 0.01 || u[2] > 3.2
    alto = DiscreteCallback(fuera, terminate!)

    # Rama estable: integrar hacia atrás desde el estado estacionario
    J = [p.ρ -1.0; cstar * p.α * (p.α - 1) * kstar^(p.α - 2) / p.θ 0.0]
    vals, vecs = eigen(J)
    vs = real.(vecs[:, argmin(real.(vals))])
    ramas = map((-1, 1)) do signo
        u0 = [kstar, cstar] .+ signo * 1e-4 .* vs
        solve(ODEProblem(ramsey!, u0, (0.0, -400.0), p), Tsit5(); callback = alto,
              reltol = 1e-9, abstol = 1e-9, saveat = -0.25)
    end

    ks = range(0.01, 26, length = 400)
    fig = plot(ks, f.(ks) .- p.δ .* ks; color = AZUL, xlims = (0, 26), ylims = (0, 3.2),
               xlabel = "capital k", ylabel = "consumo c", size = (720, 420),
               title = "Ramsey: sólo la rama estable llega al estado estacionario")
    vline!(fig, [kstar]; color = AQUA, lw = 2)
    for (k0, c0) in ((2.0, 0.6), (2.0, 1.0), (24.0, 1.4), (24.0, 2.6))
        s = solve(ODEProblem(ramsey!, [k0, c0], (0.0, 300.0), p), Tsit5(); callback = alto,
                  saveat = 0.25)
        plot!(fig, first.(s.u), last.(s.u); color = GRIS, lw = 1, alpha = 0.8)
    end
    for r in ramas
        plot!(fig, first.(r.u), last.(r.u); color = NARANJA, lw = 2.5)
    end
    scatter!(fig, [kstar], [cstar]; color = TINTA, ms = 5, msw = 0)
    etiqueta(fig, 15.5, 1.92, "k̇ = 0", AZUL)
    etiqueta(fig, kstar + 0.3, 3.0, "ċ = 0", AQUA)
    etiqueta(fig, kstar + 0.4, cstar - 0.15, "(k*, c*)", TINTA)
    etiqueta(fig, 0.8, 0.25, "rama estable", NARANJA)
    guardar(fig, "silla.png")
end

# ── 5. Iteración de la función valor: problema de la torta ───────────────────
let β = 0.9, n = 300
    xs = exp.(range(log(1e-4), log(10), length = n))      # malla más densa cerca de 0
    A = (log(1 - β) + β * log(β) / (1 - β)) / (1 - β)
    exacta = A .+ log.(xs) ./ (1 - β)
    function bellman(V)
        TV = similar(V)
        TV[1] = log(xs[1]) + β * V[1]                       # en el nodo mínimo se come todo
        for i in 2:n
            TV[i] = maximum(log(xs[i] - xs[j]) + β * V[j] for j in 1:i-1)
        end
        TV
    end
    iteraciones = [zeros(n)]
    for _ in 1:400; push!(iteraciones, bellman(iteraciones[end])); end
    Vinf = iteraciones[end]
    distancias = [maximum(abs.(V .- Vinf)) for V in iteraciones[1:150]]

    rango = xs .>= 0.5
    p1 = plot(xlabel = "tamaño de la torta x", ylabel = "V(x)", legend = :bottomright,
              title = "Iteraciones de la función valor")
    for (c, k) in zip(RAMPA, (1, 5, 20, 60))
        plot!(p1, xs[rango], iteraciones[k+1][rango]; color = c, label = "V$(k)")
    end
    plot!(p1, xs[rango], exacta[rango]; color = NARANJA, lw = 2, ls = :dash, label = "exacta")

    p2 = plot(0:length(distancias)-1, distancias; yscale = :log10, color = AZUL,
              xlabel = "iteración n", ylabel = "‖Vₙ − V‖∞",
              title = "La distancia al punto fijo cae como βⁿ", yticks = 10.0 .^ (-6:2:2))
    plot!(p2, 0:149, distancias[1] .* β .^ (0:149); color = NARANJA, ls = :dash, lw = 1.5)
    etiqueta(p2, 60, distancias[1] * β^35, "0.9ⁿ", NARANJA)
    guardar(plot(p1, p2; layout = (1, 2), size = (1000, 360)), "contraccion.png")
end

# ── 6. Orden de Euler y de RK4 ───────────────────────────────────────────────
let f(x) = -x
    euler(h, n) = (x = 1.0; for _ in 1:n; x += h * f(x); end; x)
    function rk4(h, n)
        x = 1.0
        for _ in 1:n
            k1 = f(x); k2 = f(x + h / 2 * k1); k3 = f(x + h / 2 * k2); k4 = f(x + h * k3)
            x += h / 6 * (k1 + 2k2 + 2k3 + k4)
        end
        x
    end
    ns = unique(round.(Int, 10 .^ range(0.3, 3, length = 18)))
    hs = 1 ./ ns
    eE = [abs(euler(h, n) - exp(-1)) for (h, n) in zip(hs, ns)]
    eR = [abs(rk4(h, n) - exp(-1)) for (h, n) in zip(hs, ns)]
    p = plot(hs, eE; xscale = :log10, yscale = :log10, color = AZUL, marker = :circle, ms = 3,
             xlabel = "tamaño del paso h", ylabel = "error en t = 1",
             title = "Error contra paso: pendiente = orden del método", size = (620, 380),
             yticks = 10.0 .^ (-14:2:0))
    plot!(p, hs, eR; color = NARANJA, marker = :circle, ms = 3)
    etiqueta(p, 0.05, 0.002, "Euler: pendiente 1", AZUL)
    etiqueta(p, 0.08, 2e-8, "RK4: pendiente 4", NARANJA)
    guardar(p, "euler_rk.png")
end

println("Listo.")
