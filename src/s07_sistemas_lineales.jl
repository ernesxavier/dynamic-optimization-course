#%% hide
md"""
# Sesión 7: Sistemas de ecuaciones diferenciales y linealización

**Pregunta de la unidad.** ¿Convergen los estados de México? ¿A qué
velocidad?

**Cómo usar este cuaderno.** La teoría está en las notas,
`Class_notes/s07_sistemas_lineales.md`, y se desarrolla en el pizarrón; el
cuaderno sirve para mover los parámetros y ver qué pasa. En clase se
proyectan las secciones 1 a 4; los ejercicios son para después. Pluto es
reactivo: al mover un deslizador, todo lo que depende de él se recalcula.

**Cómo abrirlo.** Desde la raíz del repositorio:
`julia --project=Code -e 'using Pluto; Pluto.run()'` y abrir
`Code/s07_sistemas_lineales.jl`.
"""

#%% hide
TableOfContents(title = "Contenido")

#%% hide
md"""
## 1. Explorador: ``\dot x = Ax``

*En clase, después de la sección 2.2 de las notas.* A la izquierda, el
retrato de fase de ``\dot x = Ax`` (las rectas naranjas son los
eigenvectores, si son reales); a la derecha, dónde cae ``A`` en el plano
traza-determinante.

``a_{11}``: $(@bind a11 Slider(-2.0:0.1:2.0, default = -0.2, show_value = true))
``a_{12}``: $(@bind a12 Slider(-2.0:0.1:2.0, default = -1.0, show_value = true))

``a_{21}``: $(@bind a21 Slider(-2.0:0.1:2.0, default = 1.0, show_value = true))
``a_{22}``: $(@bind a22 Slider(-2.0:0.1:2.0, default = -0.2, show_value = true))
"""

#%% hide
A = [a11 a12; a21 a22]

#%% hide
let
    g1 = retrato_de_fase(A; titulo = "Retrato de fase")
    g2 = plano_traza_determinante(tr(A), det(A))
    plot(g1, g2; layout = (1, 2), size = (780, 380))
end

#%% hide
let
    τ, Δ = tr(A), det(A)
    λ = eigvals(A)
    r(v) = round(v, digits = 3)
    l1, l2 = r(real(λ[1])), r(real(λ[2]))
    parte_re, parte_im = r(real(λ[1])), r(abs(imag(λ[1])))
    texto_λ = all(isreal, λ) ? md"Eigenvalores reales: ``\lambda_1`` = $(l1) y ``\lambda_2`` = $(l2)." :
              md"Eigenvalores complejos: ``\lambda`` = $(parte_re) ``\pm`` $(parte_im) ``i``."
    tipo = NOMBRES_TIPO[clasificar_ref(A)]
    md"""
    Traza ``\tau`` = $(r(τ)), determinante ``\Delta`` = $(r(Δ)),
    ``\tau^2 - 4\Delta`` = $(r(τ^2 - 4Δ)).

    $(texto_λ)

    El origen es un $(tipo).

    **Mueve** las entradas para pasar por las cinco zonas del plano: punto de
    silla (``a_{12} = a_{21} = 2``, ``a_{11} = a_{22} = 1``), centro
    (``a_{11} = a_{22} = 0``, ``a_{12} = -1``, ``a_{21} = 1``), foco y nodo.
    **Observa** cómo cambia el retrato al cruzar cada frontera.
    """
end

#%% hide
md"""
## 2. Tres sistemas regionales

### 2.1 Dos regiones con derrames: un nodo estable

*En clase, después de la sección 2.3 de las notas.* La región 1 empieza
100% arriba de su estado estacionario y la región 2, 50% abajo, con
``\beta = 0.02``.

Intensidad de los derrames ``\mu``: $(@bind μ Slider(0.0:0.01:0.1, default = 0.03, show_value = true))
"""

#%% hide
let
    β = 0.02
    M = [-β-μ μ; μ -β-μ]
    ts = 0:0.5:100
    zs = [exp(M * t) * [1.0, -0.5] for t in ts]
    z1, z2 = first.(zs), last.(zs)
    p = plot(ts, z1; color = AZUL, lw = 2, label = "región 1", xlabel = "años",
             ylabel = "brecha z", title = "Derrames con μ = $μ", legend = :topright)
    plot!(p, ts, z2; color = NARANJA, lw = 2, label = "región 2")
    plot!(p, ts, (z1 .+ z2) ./ 2; color = GRIS, lw = 1.5, ls = :dash, label = "promedio (modo común)")
    plot!(p, ts, z1 .- z2; color = GRIS, lw = 1.5, ls = :dot, label = "diferencia (modo diferencial)")
end

#%% hide
md"""
**Mueve** ``\mu`` de 0 a 0.1. **Observa:** ¿qué curva gris cambia de
velocidad, el promedio (modo común) o la diferencia (modo diferencial)?
"""

#%% hide
md"""
### 2.2 El primer punto de silla: ``\ddot y = y``

*En clase, después de la sección 2.4 de las notas.* Con ``y(0) = 1`` dado,
**elige ``\dot y(0)``**: ¿cuál lleva al origen?

``\dot y(0)``: $(@bind dy0 Slider(-2.0:0.05:0.0, default = -0.8, show_value = true))
"""

#%% hide
let
    c1, c2 = (1 - dy0) / 2, (1 + dy0) / 2
    t = range(0, 4, length = 200)
    y = c1 .* exp.(-t) .+ c2 .* exp.(t)
    dy = -c1 .* exp.(-t) .+ c2 .* exp.(t)
    g1 = plot(t, y; color = AZUL, lw = 2, xlabel = "t", ylabel = "y(t)", ylims = (-3, 3),
              title = "y(t) con ẏ(0) = $dy0")
    hline!(g1, [0]; color = GRIS, lw = 1)
    g2 = retrato_de_fase([0.0 1.0; 1.0 0.0]; titulo = "Plano (y, ẏ)", lim = 2.0, trayectorias = false,
                         ejes = ("y", "ẏ"))
    plot!(g2, clamp.(y, -2, 2), clamp.(dy, -2, 2); color = TINTA, lw = 2.5)
    scatter!(g2, [1.0], [dy0]; color = TINTA, ms = 5, msw = 0)
    plot(g1, g2; layout = (1, 2), size = (780, 340))
end

#%% hide
md"""
**Observa** que sólo un valor de ``\dot y(0)`` no explota: el que pone el
punto de partida sobre el eigenvector estable.
"""

#%% hide
md"""
### 2.3 El ciclo inmobiliario regional: un foco

*En clase* (notas, 2.5). Precio ``p`` y acervo de vivienda ``H`` después de
un choque al precio, con ``\delta = 0.05``.

Respuesta de la construcción al precio ``\psi``: $(@bind ψ Slider(0.0:0.05:1.0, default = 0.5, show_value = true))

Corrección del precio ``\eta``: $(@bind η Slider(0.0:0.05:0.5, default = 0.2, show_value = true))
"""

#%% hide
let
    M = [-η -1.0; ψ -0.05]
    ts = 0:0.25:60
    xs = [exp(M * t) * [1.0, 0.0] for t in ts]
    g1 = plot(ts, first.(xs); color = AZUL, lw = 2, label = "precio p", xlabel = "años",
              ylabel = "desviación", title = "Precio y acervo de vivienda", legend = :topright)
    plot!(g1, ts, last.(xs); color = NARANJA, lw = 2, label = "acervo H")
    hline!(g1, [0]; color = GRIS, lw = 1, label = "")
    g2 = plot(first.(xs), last.(xs); color = TINTA, lw = 1.5, xlabel = "p", ylabel = "H",
              title = "Trayectoria en el plano (p, H)", aspect_ratio = :equal)
    scatter!(g2, [1.0], [0.0]; color = TINTA, ms = 5, msw = 0)
    plot(g1, g2; layout = (1, 2), size = (780, 340))
end

#%% hide
let
    M = [-η -1.0; ψ -0.05]
    λ = eigvals(M)
    if all(isreal, λ)
        md"""
        Eigenvalores reales, ``-`` $(round(-real(λ[1]), digits = 3)) y
        ``-`` $(round(-real(λ[2]), digits = 3)): un **nodo**, sin ciclo.
        """
    else
        ω, α = abs(imag(λ[1])), real(λ[1])
        md"""
        Eigenvalores complejos, ``-`` $(round(-α, digits = 3)) ``\pm``
        $(round(ω, digits = 3)) ``i``: un **foco**. El ciclo dura
        ``2\pi/\omega \approx`` $(round(2π / ω, digits = 1)) años, y su
        amplitud se reduce a la mitad cada ``\ln 2/|\alpha| \approx``
        $(round(log(2) / abs(α), digits = 1)) años. **Mueve** ``\psi`` hacia
        abajo hasta que desaparezca el ciclo, y ``\eta`` a cero.
        """
    end
end

#%% hide
md"""
## 3. Tiempo continuo y tiempo discreto

*En clase, después de la sección 4 de las notas.* Los eigenvalores de la
matriz ``A`` de la sección 1 en el plano complejo: a la izquierda del eje
azul, ``\dot x = Ax`` es estable; dentro del círculo naranja,
``x_{t+1} = Ax_t`` lo es.
"""

#%% hide
let
    λ = eigvals(A)
    θs = range(0, 2π, length = 200)
    p = plot(cos.(θs), sin.(θs); color = NARANJA, lw = 1.5, aspect_ratio = :equal,
             xlims = (-2.5, 2.5), ylims = (-2, 2), xlabel = "parte real", ylabel = "parte imaginaria",
             title = "Eigenvalores de A", size = (520, 420))
    vline!(p, [0]; color = AZUL, lw = 1.5)
    hline!(p, [0]; color = GRIS, lw = 0.5)
    scatter!(p, real.(λ), imag.(λ); color = TINTA, ms = 7, msw = 0)
    annotate!(p, -2.4, 1.8, text("continuo estable: a la izquierda del eje azul", 7, :left, AZUL))
    annotate!(p, -2.4, -1.8, text("discreto estable: dentro del círculo naranja", 7, :left, NARANJA))
end

#%% hide
let
    λ = eigvals(A)
    cont = all(real.(λ) .< 0) ? "estable" : "no estable"
    disc = all(abs.(λ) .< 1) ? "estable" : "no estable"
    modulos = join(round.(abs.(λ), digits = 3), " y ")
    md"""
    Con esta ``A``: en tiempo continuo, $(cont); en tiempo discreto,
    $(disc) (módulos de los eigenvalores: $(modulos)).
    **Mueve** ``A`` a ``a_{11} = a_{22} = -1.5`` con ``a_{12} = a_{21} = 0``.
    **Observa:** la misma matriz es estable en continuo e inestable en
    discreto.
    """
end

#%% hide
md"""
## 4. Linealización: el punto de silla de Ramsey

*En clase, después de la sección 5.2 de las notas.* Symbolics.jl calcula el
jacobiano del sistema de Ramsey:
"""

#%%
let
    @variables k c α δ ρ θ
    F = [k^α - δ * k - c, c / θ * (α * k^(α - 1) - δ - ρ)]
    Symbolics.jacobian(F, [k, c])
end

#%% hide
md"""
Isoclinas y direcciones del punto de silla en el estado estacionario.

Tasa de descuento ``\rho``: $(@bind ρ_r Slider(0.01:0.01:0.08, default = 0.03, show_value = true))

Parámetro de aversión ``\theta``: $(@bind θ_r Slider(0.5:0.5:5.0, default = 2.0, show_value = true))
"""

#%% hide
let
    r = ramsey_ref(0.3, 0.05, ρ_r, θ_r)
    k = range(0.5, 2.2r.kstar, length = 300)
    p = plot(k, k .^ 0.3 .- 0.05 .* k; color = AZUL, lw = 2, label = "k̇ = 0",
             xlabel = "capital k", ylabel = "consumo c", ylims = (0, 2.5r.cstar),
             title = "Ramsey: isoclinas y direcciones del punto de silla", legend = :topright)
    vline!(p, [r.kstar]; color = AZUL, lw = 2, ls = :dash, label = "ċ = 0")
    for (v, color, nombre) in ((r.vs, NARANJA, "dirección estable"), (r.vu, GRIS, "dirección inestable"))
        s = 0.6r.kstar
        plot!(p, r.kstar .+ s .* [-v[1], v[1]], r.cstar .+ s .* [-v[2], v[2]]; color, lw = 2, label = nombre)
    end
    scatter!(p, [r.kstar], [r.cstar]; color = TINTA, ms = 6, msw = 0, label = "")
end

#%% hide
let
    r = ramsey_ref(0.3, 0.05, ρ_r, θ_r)
    rd(v) = round(v, digits = 3)
    velocidad = string(rd(-r.λs), " (", round(-100r.λs, digits = 1), "% anual)")
    md"""
    | | Valor |
    |:---|---:|
    | Estado estacionario ``(k^\ast, c^\ast)`` | ($(rd(r.kstar)), $(rd(r.cstar))) |
    | Eigenvalores de ``J`` | $(rd(r.λs)) y $(rd(r.λu)) |
    | Velocidad de convergencia sobre la rama estable | $(velocidad) |
    | Vida media de la brecha | $(round(log(2) / -r.λs, digits = 1)) años |

    La recta naranja es la aproximación lineal de la rama estable. **Mueve**
    ``\rho`` y ``\theta``. **Observa** cuál cambia el estado estacionario y la
    velocidad de convergencia, y cuál sólo la velocidad. La sesión 8 dibuja la rama completa.
    """
end

#%% hide
md"""
## Ejercicios

*Después de clase.* Los ejercicios con demostraciones están en las notas
(sección 8).

### Completa el código

**1.** Escribe `clasificar(A)`, que devuelva `:silla`, `:nodo_estable`,
`:foco_estable`, `:centro`, `:nodo_inestable`, `:foco_inestable` o
`:no_hiperbolico` (si ``\Delta = 0``), con la tabla de las notas (sección
2.2). Usa `tr(A)` y `det(A)`; compara con cero con una tolerancia, por
ejemplo `abs(Δ) < 1e-12`.
"""

#%%
function clasificar(A)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> clasificar.(MATRICES_PRUEBA), clasificar_ref.(MATRICES_PRUEBA);
          pista = md"Calcula `τ, Δ = tr(A), det(A)`. Primero `Δ < 0` (silla) y `Δ ≈ 0`; después `τ ≈ 0` (centro); por último el signo de `τ` y si `τ^2 >= 4Δ` (nodo) o no (foco).")

#%% hide
md"""
**2.** Escribe `es_estable_discreto(A)`, que devuelva `true` si
``x_{t+1} = Ax_t`` es estable: todos los eigenvalores con módulo menor que 1.
"""

#%%
function es_estable_discreto(A)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> es_estable_discreto.(MATRICES_PRUEBA),
          [all(abs.(eigvals(M)) .< 1) for M in MATRICES_PRUEBA];
          pista = md"`all(abs.(eigvals(A)) .< 1)`")

#%% hide
md"""
**3.** Escribe `matriz_segundo_orden(a1, a2)`, la matriz del sistema
equivalente a ``\ddot y + a_1\dot y + a_2 y = 0`` en ``x = (y, \dot y)``.
"""

#%%
function matriz_segundo_orden(a1, a2)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> [matriz_segundo_orden(0.4, 4.0), matriz_segundo_orden(-1.0, 2.0)],
          [[0.0 1.0; -4.0 -0.4], [0.0 1.0; -2.0 1.0]];
          pista = md"La primera fila dice ``\dot y = \dot y``: `[0 1]`. La segunda dice ``\ddot y = -a_2 y - a_1 \dot y``: `[-a2 -a1]`.")

#%% hide
md"""
**4. [Avanzado]** Escribe `velocidad_ramsey(α, δ, ρ, θ)`, que devuelva el
eigenvalor estable (negativo) del jacobiano de Ramsey en el estado
estacionario, con ``f(k) = k^\alpha``. Usa la matriz de las notas (sección
5.2).
"""

#%%
function velocidad_ramsey(α, δ, ρ, θ)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> [velocidad_ramsey(0.3, 0.05, 0.03, 2.0), velocidad_ramsey(0.35, 0.06, 0.02, 1.0)],
          [ramsey_ref(0.3, 0.05, 0.03, 2.0).λs, ramsey_ref(0.35, 0.06, 0.02, 1.0).λs];
          pista = md"Calcula `k = (α / (δ + ρ))^(1 / (1 - α))`, `c = k^α - δ * k` y `J = [ρ -1; c * α * (α - 1) * k^(α - 2) / θ 0]`; devuelve `minimum(eigvals(J))`.")

#%% hide
md"""
### Interpretación

5. En el modelo de derrames, un programa federal aumenta ``\mu`` (más
   comercio entre las regiones). ¿Qué brecha se cierra más rápido y cuál
   no cambia? ¿Qué política haría falta para acelerar la otra?
6. En el ciclo inmobiliario, ¿qué hace que el mercado oscile en lugar de
   ajustarse directamente? Propón una política que reduzca la amplitud del
   ciclo y di qué parámetro cambia.
7. ¿Por qué, en el punto de silla de ``\ddot y = y``, no basta conocer
   ``y(0)`` para saber qué trayectoria sigue el sistema? ¿Qué información
   adicional usa un problema de optimización para elegirla?

### Tu tesis

8. Si tu problema tiene dos variables de estado que interactúan, escribe el
   sistema y su jacobiano en el equilibrio. ¿Esperas un nodo, un foco o un
   punto de silla? ¿Por qué?

### [Avanzado]

9. Muestra numéricamente que el ciclo inmobiliario es un centro cuando
   ``\eta = \delta = 0`` y que cualquier amortiguamiento lo convierte en
   foco. (Cambia ``\delta = 0.05`` en el código de la sección 2.3.)

## Para la próxima sesión

- **Sesión 8: estabilidad de sistemas no lineales.** El diagrama de fase en
  el plano con isoclinas, y la rama estable completa del modelo de Ramsey.
- Repaso: D.I6 (diagramas de fase en el plano). Para los puntos
  [Avanzado]: D.A2 (variedades estable e inestable).
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
    const AZUL    = "#2a78d6"   # trayectorias, serie principal
    const NARANJA = "#eb6834"   # eigenvectores, dirección estable
    const GRIS    = "#52514e"   # referencias, campo de direcciones
    const TINTA   = "#0b0b0b"   # equilibrio, trayectoria elegida
end;

#%%
"Tipo de equilibrio del origen de ẋ = Ax, según la traza y el determinante."
function clasificar_ref(A)
    τ, Δ = tr(A), det(A)
    Δ < -1e-12 && return :silla
    abs(Δ) <= 1e-12 && return :no_hiperbolico
    abs(τ) <= 1e-12 && return :centro
    nodo = τ^2 >= 4Δ
    τ < 0 ? (nodo ? :nodo_estable : :foco_estable) : (nodo ? :nodo_inestable : :foco_inestable)
end

#%%
const NOMBRES_TIPO = Dict(:silla => "punto de silla (inestable)", :nodo_estable => "nodo estable",
                          :foco_estable => "foco estable", :centro => "centro (órbitas cerradas)",
                          :nodo_inestable => "nodo inestable", :foco_inestable => "foco inestable",
                          :no_hiperbolico => "caso no hiperbólico (Δ = 0)")

#%%
"""
Retrato de fase de ẋ = Ax en [−lim, lim]²: campo de direcciones, trayectorias
desde un círculo de puntos y eigenvectores si son reales.
"""
function retrato_de_fase(A; titulo = "", lim = 3.0, trayectorias = true, ejes = ("x₁", "x₂"))
    p = plot(; xlims = (-lim, lim), ylims = (-lim, lim), aspect_ratio = :equal,
             xlabel = ejes[1], ylabel = ejes[2], title = titulo, grid = false)
    malla = range(-0.9lim, 0.9lim, length = 11)
    pts = [(u, v) for u in malla for v in malla]
    dirs = [A * [u, v] for (u, v) in pts]
    escala = 0.08lim
    quiver!(p, first.(pts), last.(pts);
            quiver = ([escala * d[1] / max(norm(d), 1e-9) for d in dirs],
                      [escala * d[2] / max(norm(d), 1e-9) for d in dirs]),
            color = GRIS, alpha = 0.5, lw = 0.8)
    λ, V = eigen(A)
    if all(isreal, λ)
        for i in 1:2
            v = real.(V[:, i])
            plot!(p, 2lim .* [-v[1], v[1]], 2lim .* [-v[2], v[2]]; color = NARANJA, lw = 2)
        end
    end
    if trayectorias
        for φ in range(0, 2π, length = 13)[1:end-1]
            x0 = 0.85lim .* [cos(φ), sin(φ)]
            xs = [exp(A * t) * x0 for t in range(0, 12, length = 300)]
            dentro = findfirst(x -> maximum(abs.(x)) > 1.05lim, xs)
            xs = dentro === nothing ? xs : xs[1:dentro]
            plot!(p, first.(xs), last.(xs); color = AZUL, lw = 1.2)
        end
    end
    scatter!(p, [0], [0]; color = TINTA, ms = 4, msw = 0)
end

#%%
"Plano traza-determinante con la parábola Δ = τ²/4 y el punto (τ, Δ)."
function plano_traza_determinante(τ, Δ)
    ts = range(-4, 4, length = 200)
    p = plot(ts, ts .^ 2 ./ 4; color = AZUL, lw = 1.5, xlims = (-4, 4), ylims = (-4, 4),
             xlabel = "traza τ", ylabel = "determinante Δ", title = "Plano traza-determinante")
    hline!(p, [0]; color = GRIS, lw = 1)
    plot!(p, [0, 0], [0, 4]; color = GRIS, lw = 1)
    annotate!(p, 0, -2.5, text("puntos de silla", 8, GRIS))
    annotate!(p, -2.6, 3.5, text("focos estables", 8, GRIS))
    annotate!(p, 2.6, 3.5, text("focos inestables", 8, GRIS))
    annotate!(p, -3.2, 0.9, text("nodos\nestables", 8, GRIS))
    annotate!(p, 3.2, 0.9, text("nodos\ninestables", 8, GRIS))
    scatter!(p, [clamp(τ, -3.9, 3.9)], [clamp(Δ, -3.9, 3.9)]; color = NARANJA, ms = 7, msw = 0)
end

#%%
"Estado estacionario, eigenvalores y direcciones estable e inestable de Ramsey con f(k) = k^α."
function ramsey_ref(α, δ, ρ, θ)
    kstar = (α / (δ + ρ))^(1 / (1 - α))
    cstar = kstar^α - δ * kstar
    J = [ρ -1.0; cstar * α * (α - 1) * kstar^(α - 2) / θ 0.0]
    λ, V = eigen(J)
    is, iu = argmin(λ), argmax(λ)
    (; kstar, cstar, J, λs = λ[is], λu = λ[iu], vs = V[:, is], vu = V[:, iu])
end

#%%
"Matrices de prueba para los ejercicios: un ejemplo de cada tipo."
const MATRICES_PRUEBA = [[-1.0 2.0; 0.0 -3.0], [1.0 2.0; 2.0 1.0], [-1.0 -4.0; 1.0 -1.0],
                         [0.0 -1.0; 1.0 0.0], [1.0 0.0; 0.0 2.0], [0.5 -1.0; 1.0 0.5],
                         [1.0 2.0; 2.0 4.0], [0.5 0.4; 0.3 0.6]]

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
