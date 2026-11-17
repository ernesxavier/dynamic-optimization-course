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

# ╔═╡ ceb7416e-cf02-11f1-a178-d745a87dd3bd
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

# ╔═╡ ceb73fca-cf02-11f1-b285-317b68e4001b
md"""
# Sesión 6: Equilibrio, diagramas de fase y ecuaciones en diferencias

**Pregunta de la unidad.** ¿Convergen los estados de México? ¿A qué
velocidad?

**Cómo usar este cuaderno.** La teoría está en las notas,
`Class_notes/s06_diagramas_de_fase.md`, y se desarrolla en el pizarrón; el
cuaderno sirve para mover los parámetros y ver qué pasa. En clase se
proyectan las secciones 0 a 5; la sección 6 y los ejercicios son para
después. Pluto es reactivo: al mover un deslizador, todo lo que depende de
él se recalcula. En las gráficas, un **punto lleno** es un equilibrio
estable y un **punto vacío**, uno inestable.

**Cómo abrirlo.** Desde la raíz del repositorio:
`julia --project=Code -e 'using Pluto; Pluto.run()'` y abrir
`Code/s06_diagramas_de_fase.jl`.
"""

# ╔═╡ ceb74010-cf02-11f1-942f-d770597eefa3
TableOfContents(title = "Contenido")

# ╔═╡ ceb7401a-cf02-11f1-b42b-adf506e12b41
md"""
## 0. La pregunta: ¿a dónde va una región?

*En clase, al inicio* (notas, sección 0). Las secciones 1 y 2 muestran, sin
resolver ninguna ecuación, a dónde va una región según dónde empieza: es lo
que la clase justifica en el pizarrón.
"""

# ╔═╡ ceb74024-cf02-11f1-aab4-8189a8bfbd56
md"""
## 1. Solow: un equilibrio estable

*En clase, después de la sección 1.4 de las notas.* Recta de fase y
trayectorias de ``\dot k = sk^\alpha - (n + \delta)k``.

Tasa de ahorro ``s``: $(@bind s Slider(0.05:0.05:0.5, default = 0.2, show_value = true))

Participación del capital ``\alpha``: $(@bind α Slider(0.2:0.05:0.6, default = 0.3, show_value = true))

Crecimiento de la población más depreciación, ``n + \delta``: $(@bind nδ Slider(0.02:0.01:0.12, default = 0.06, show_value = true))
"""

# ╔═╡ ceb74042-cf02-11f1-9f0d-0d8a3e12635f
let
    kstar = (s / nδ)^(1 / (1 - α))
    fp = -(1 - α) * nδ
    r(v) = round(v, digits = 3)
    md"""
    | | Valor |
    |:---|---:|
    | Estado estacionario ``k^\ast`` | $(r(kstar)) |
    | Pendiente ``f'(k^\ast)`` | $(r(fp)) |
    | Vida media de una desviación pequeña | $(round(log(2) / abs(fp), digits = 1)) años |

    **Mueve** ``s`` y después ``\alpha``. **Observa:** ¿cuál cambia sólo
    ``k^\ast`` y cuál también la velocidad de convergencia? ¿Se cruzan o oscilan las
    trayectorias?
    """
end

# ╔═╡ ceb74042-cf02-11f1-8cab-811c4d6ce8d8
md"""
## 2. Aglomeración: dos equilibrios estables y un umbral

*En clase, después de la sección 1.5 de las notas.* Recta de fase y
trayectorias de ``\dot L = L\,u(L)``, con ``u(L) = a + 2L - 1.5L^2``.

Ventaja de partida ``a``: $(@bind a_agl Slider(-0.6:0.05:0.1, default = -0.3, show_value = true))
"""

# ╔═╡ ceb74062-cf02-11f1-a8f7-69a5bd5f3507
md"""
### Un gran impulso

Una región empieza con ``L_0 = 0.1``, debajo del umbral. Un subsidio
``\sigma`` sube su ventaja durante ``T_s`` años y después se retira.

1. Con ``\sigma = 0.3``, **busca** la menor duración ``T_s`` que consolide la
   región.
2. Con ``T_s = 2``, **busca** el menor ``\sigma`` que lo logre.
3. ¿Cuál de las dos combinaciones es más barata, si el costo es
   ``\sigma \times T_s``? ¿Qué pasa con un subsidio que se queda justo debajo
   del umbral?

Subsidio ``\sigma``: $(@bind σ_sub Slider(0.0:0.05:0.6, default = 0.3, show_value = true))

Duración ``T_s`` (años): $(@bind T_sub Slider(0:1:20, default = 5, show_value = true))
"""

# ╔═╡ ceb7407e-cf02-11f1-a6be-ed625c81d147
md"""
## 3. Ecuaciones en diferencias lineales

*En clase, después de la sección 2.1 de las notas.* Trayectoria de
``y_{t+1} = ay_t + b``; la línea punteada es el punto fijo.

``a``: $(@bind a_d Slider(-1.5:0.1:1.5, default = -0.5, show_value = true))

``b``: $(@bind b_d Slider(0.0:0.5:5.0, default = 3.0, show_value = true))

``y_0``: $(@bind y0_d Slider(0.0:0.5:10.0, default = 0.0, show_value = true))
"""

# ╔═╡ ceb74094-cf02-11f1-bdfc-53d0550760eb
let
    regimen = a_d ≈ 1 ? "crece en línea recta, porque no hay punto fijo" :
              abs(a_d) ≈ 1 ? "oscila para siempre entre dos valores" :
              abs(a_d) < 1 ? (a_d < -1e-9 ? "converge oscilando" : a_d > 1e-9 ? "converge monótonamente" : "llega al punto fijo en un paso") :
              (a_d < 0 ? "se aleja oscilando" : "se aleja monótonamente")
    md"""
    Con ``a`` = $(a_d), la trayectoria $(regimen). **Mueve** ``a`` por las
    seis zonas de la tabla de la sección 2.1 de las notas y comprueba cada
    una.
    """
end

# ╔═╡ ceb7409c-cf02-11f1-bff8-2d89a32c5687
md"""
## 4. Ecuaciones no lineales: el diagrama de telaraña

*En clase, después de la sección 2.2 de las notas.* Telaraña y trayectoria
de tres mapas.

Mapa: $(@bind mapa Select(["mercado" => "Telaraña de un mercado regional", "solow" => "Solow discreto (sesión 1)", "logistico" => "Mapa logístico"]))

Respuesta de la oferta al precio, ``D`` (mercado, con ``B = 1``): $(@bind D_oferta Slider(0.2:0.1:1.5, default = 0.8, show_value = true))

Parámetro ``r`` (logístico): $(@bind r_log Slider(0.5:0.1:3.0, default = 2.8, show_value = true))

Punto de partida (fracción del rango): $(@bind x0_frac Slider(0.05:0.05:0.95, default = 0.15, show_value = true))
"""

# ╔═╡ ceb740ba-cf02-11f1-a97f-57c818f0ba92
md"""
## 5. El método de Euler es una ecuación en diferencias

*En clase* (notas, 2.6). El método de Euler para ``\dot y = -a(y - y^\ast)``
es una ecuación lineal en diferencias con coeficiente ``1 - a\,\Delta t``.
**Mueve** ``a\,\Delta t`` de 0.5 a 2.5 y **observa** cuándo la aproximación
oscila o diverge, aunque la ecuación diferencial sea estable.

``a\,\Delta t``: $(@bind aΔt Slider(0.1:0.1:2.5, default = 0.5, show_value = true))
"""

# ╔═╡ ceb740ce-cf02-11f1-962d-cbf6b77320c2
let
    regimen = aΔt ≈ 1 ? "exacta en el equilibrio: llega en un paso" : aΔt < 1 ? "monótona y cercana a la solución exacta" :
              aΔt ≈ 2 ? "oscilante sin converger" : aΔt < 2 ? "oscilante, aunque la ecuación no oscila" :
              "divergente, aunque la ecuación es estable"
    md"""
    El coeficiente es ``1 - a\,\Delta t`` = $(round(1 - aΔt, digits = 2)):
    la aproximación es $(regimen).
    """
end

# ╔═╡ ceb740d8-cf02-11f1-965e-8b65ed7d3ef6
md"""
## 6. [Avanzado] Contracciones: convergencia desde cualquier punto

*Fuera de clase* (notas, 2.3). Con ``g(x) = 1 + 0.5\cos x``, una
contracción con ``\rho = 0.5``: el error de la iteración contra la cota
``\rho^t|x_0 - x^\ast|``.

Punto de partida ``x_0``: $(@bind x0_c Slider(-10.0:1.0:10.0, default = 5.0, show_value = true))
"""

# ╔═╡ ceb740ec-cf02-11f1-931f-1f292d78ebf9
md"""
**Mueve** ``x_0`` lejos del punto fijo. **Observa** que el error siempre
queda debajo de la cota. La iteración de la función valor de la sesión 16
es este mismo argumento con funciones en lugar de números.
"""

# ╔═╡ ceb740f4-cf02-11f1-a128-2d8491f6490a
md"""
## Ejercicios

*Después de clase.* Los ejercicios con demostraciones están en las notas
(sección 6).

### Completa el código

**1.** Escribe `clasificar_continuo(fp)`, que reciba ``f'(x^\ast)`` y devuelva
`:estable`, `:inestable` o `:no_decide`.
"""

# ╔═╡ ceb74100-cf02-11f1-bff0-936155fd9b01
function clasificar_continuo(fp)
    missing  # reemplaza esta línea
end

# ╔═╡ ceb7410a-cf02-11f1-940a-854d54251270
md"""
**2.** Escribe `clasificar_discreto(gp)`, que reciba ``g'(x^\ast)`` y devuelva
`:monotona` (estable sin oscilar), `:oscilante` (estable oscilando),
`:inestable` o `:no_decide` (si ``|g'(x^\ast)| = 1``).
"""

# ╔═╡ ceb74114-cf02-11f1-a600-b1d3e2693ce7
function clasificar_discreto(gp)
    missing  # reemplaza esta línea
end

# ╔═╡ ceb74126-cf02-11f1-b904-3f47a2d83318
md"""
**3.** Escribe `iterar(g, x0, n)`, que devuelva el vector
``[x_0, x_1, \dots, x_n]`` con ``x_{t+1} = g(x_t)``.
"""

# ╔═╡ ceb74132-cf02-11f1-8fcf-6d52f8ad4c2a
function iterar(g, x0, n)
    missing  # reemplaza esta línea
end

# ╔═╡ ceb7413c-cf02-11f1-bfda-43790f1ca52a
md"""
**4.** Escribe `umbral(a, b, c)`, el umbral ``L_1`` del modelo de
aglomeración con ``u(L) = a + bL - cL^2``: la raíz menor de ``u``. Supón
``a < 0`` y ``b^2 > 4|a|c``.
"""

# ╔═╡ ceb74146-cf02-11f1-a57a-b9eda178b7a0
function umbral(a, b, c)
    missing  # reemplaza esta línea
end

# ╔═╡ ceb74158-cf02-11f1-bc47-15372f51edc3
md"""
### Interpretación

5. En el modelo de Solow, ¿por qué subir la tasa de ahorro sube ``k^\ast``
   pero no cambia la velocidad de convergencia? ¿Qué parámetro la cambia?
6. En el modelo de aglomeración, ¿por qué no se observan regiones
   exactamente en el umbral ``L_1``? Con el gran impulso, encuentra dos
   combinaciones de ``\sigma`` y ``T_s`` que consoliden la región. ¿Cuál es
   más barata, si el costo es ``\sigma \times T_s``?
7. En la telaraña del mercado, ¿qué política reduciría las oscilaciones del
   precio? Piensa en qué cambia ``D/B``.
8. ¿Por qué una ecuación diferencial de primer orden no puede oscilar y una
   ecuación en diferencias sí?

### Tu tesis

9. ¿Puede tener tu problema de tesis más de un equilibrio? Si sí, ¿qué
   determinaría a cuál llega una región? Si no, ¿qué supuesto lo impide?

## Para la próxima sesión

- **Sesión 7: sistemas de ecuaciones diferenciales y linealización.** Dos
  variables a la vez: el diagrama de fase pasa de la recta al plano, y la
  estabilidad se decide con los eigenvalores del jacobiano.
- Repaso: L.I1 a L.I3 (eigenvalores), D.I3 (lineales de segundo orden) y
  D.I5 (sistemas lineales de dos dimensiones).
"""

# ╔═╡ ceb74164-cf02-11f1-a156-59fe6162871e
md"""
---
## Apéndice: paquetes y funciones auxiliares

Estas celdas definen herramientas que usa el cuaderno. No es necesario
leerlas para seguir la sesión.
"""

# ╔═╡ ceb74178-cf02-11f1-bf52-cd309704ed25
begin
    const AZUL    = "#2a78d6"   # serie principal
    const NARANJA = "#eb6834"   # flechas, telaraña, subsidio
    const GRIS    = "#52514e"   # referencias
    const TINTA   = "#0b0b0b"   # equilibrios
end;

# ╔═╡ ceb740c6-cf02-11f1-8620-a71691e90ec6
let
    t = range(0, 12, length = 300)
    k = 0:round(Int, 12 / aΔt)
    p = plot(t, exp.(-t); color = AZUL, lw = 2, label = "solución exacta",
             xlabel = "t", ylabel = "y − y*", ylims = (-2, 2), legend = :topright,
             title = "Euler con a Δt = $aΔt (a = 1)")
    plot!(p, k .* aΔt, (1 - aΔt) .^ k; color = NARANJA, lw = 1, marker = :circle, ms = 3,
          msw = 0, label = "Euler")
end

# ╔═╡ ceb74182-cf02-11f1-af9d-f5299e1d376d
"Simula ẋ = f(x, t) con Runge-Kutta de cuarto orden y paso dt; devuelve tiempos y valores."
function simular(f, x0, T; dt = 0.02)
    n = round(Int, T / dt)
    x = zeros(n + 1)
    x[1] = x0
    for i in 1:n
        t = (i - 1) * dt
        k1 = f(x[i], t)
        k2 = f(x[i] + dt / 2 * k1, t + dt / 2)
        k3 = f(x[i] + dt / 2 * k2, t + dt / 2)
        k4 = f(x[i] + dt * k3, t + dt)
        x[i + 1] = x[i] + dt / 6 * (k1 + 2k2 + 2k3 + k4)
    end
    (0:n) .* dt, x
end

# ╔═╡ ceb74074-cf02-11f1-85db-35ecbd5d03dd
let
    u(L) = a_agl + 2L - 1.5L^2
    _, Ls = simular((L, t) -> L * (u(L) + (t < T_sub ? σ_sub : 0.0)), 0.1, 40)
    Ls[end] > 0.5 ?
        md"**La región se consolida**: el subsidio (franja naranja) la llevó por encima del umbral (línea punteada) y, una vez retirado, siguió creciendo sola." :
        md"**La región se vacía**: el subsidio no bastó para cruzar el umbral, y al retirarlo la región vuelve a perder población. Lo gastado se pierde."
end

# ╔═╡ ceb7418c-cf02-11f1-bf77-bbc41e02503a
"""
Recta de fase de ẋ = f(x) en [xmin, xmax]: la curva f, flechas sobre el eje
según el signo de f y los equilibrios (llenos si son estables, vacíos si no).
"""
function recta_de_fase(f, eqs, estables, xmin, xmax; titulo = "", etiqueta = "x")
    xs = range(xmin, xmax, length = 400)
    p = plot(xs, f.(xs); color = AZUL, lw = 2, xlabel = etiqueta, ylabel = "ẋ = f(x)",
             title = titulo)
    hline!(p, [0]; color = GRIS, lw = 1)
    bordes = sort(unique([xmin; filter(e -> xmin < e < xmax, eqs); xmax]))
    largo = 0.06 * (xmax - xmin)
    for (izq, der) in zip(bordes[1:end-1], bordes[2:end])
        medio = (izq + der) / 2
        dir = sign(f(medio)) * min(largo, 0.5 * (der - izq))
        plot!(p, [medio - dir / 2, medio + dir / 2], [0, 0]; arrow = true, color = NARANJA, lw = 2)
    end
    for (e, est) in zip(eqs, estables)
        scatter!(p, [e], [0]; color = est ? TINTA : :white, markerstrokecolor = TINTA,
                 ms = 6, msw = 1.5)
    end
    p
end

# ╔═╡ ceb7402e-cf02-11f1-adb1-0b9048aad257
let
    f(k) = s * k^α - nδ * k
    kstar = (s / nδ)^(1 / (1 - α))
    kmax = 2.2kstar
    g1 = recta_de_fase(f, [0.0, kstar], [false, true], 0, kmax;
                       titulo = "Recta de fase", etiqueta = "k")
    g2 = plot(; xlabel = "años", ylabel = "k(t)", title = "Trayectorias desde varios k₀")
    for k0 in (0.05, 0.3, 0.7, 1.4, 2.0) .* kstar
        ts, ks = simular((k, t) -> f(k), k0, 120)
        plot!(g2, ts, ks; color = AZUL, lw = 1.5)
    end
    hline!(g2, [kstar]; color = GRIS, ls = :dash, lw = 1)
    plot(g1, g2; layout = (1, 2), size = (760, 320))
end

# ╔═╡ ceb74196-cf02-11f1-999f-bd6da72a1ab6
"Equilibrios de L̇ = L(a + 2L − 1.5L²) en L ≥ 0 y si son estables."
function equilibrios_aglomeracion(a; b = 2.0, c = 1.5)
    disc = b^2 + 4a * c
    if disc < 0
        return [0.0], [true]
    end
    L1, L2 = (b - sqrt(disc)) / (2c), (b + sqrt(disc)) / (2c)
    a < 0 ? ([0.0, L1, L2], [true, false, true]) : ([0.0, L2], [false, true])
end

# ╔═╡ ceb7404c-cf02-11f1-97da-1f2dc6b7bca4
let
    u(L) = a_agl + 2L - 1.5L^2
    f(L) = L * u(L)
    eqs, estables = equilibrios_aglomeracion(a_agl)
    g1 = recta_de_fase(f, eqs, estables, 0, 1.6; titulo = "Recta de fase", etiqueta = "L")
    g2 = plot(; xlabel = "años", ylabel = "L(t)", title = "Trayectorias desde varios L₀",
              ylims = (0, 1.6))
    for L0 in (0.05, 0.12, 0.16, 0.19, 0.25, 0.6, 1.5)
        ts, Ls = simular((L, t) -> f(L), L0, 30)
        plot!(g2, ts, Ls; color = AZUL, lw = 1.5)
    end
    plot(g1, g2; layout = (1, 2), size = (760, 320))
end

# ╔═╡ ceb74056-cf02-11f1-a7e3-134aca5d6b7c
let
    eqs, estables = equilibrios_aglomeracion(a_agl)
    r(v) = round(v, digits = 3)
    if length(eqs) == 3
        md"""
        Tres equilibrios: ``L = 0``, el umbral ``L_1`` = $(r(eqs[2])) y
        ``L_2`` = $(r(eqs[3])).

        1. **Observa** las trayectorias que empiezan cerca del umbral, a uno y
           otro lado: ¿a dónde va cada una?
        2. **Mueve** ``a`` de ``-0.3`` a ``-0.1``: ¿el umbral sube o baja? ¿Qué
           significa para una región pequeña?
        3. **Mueve** ``a`` a ``0.05``: ¿qué pasa con el equilibrio ``L = 0`` y
           con el umbral?
        4. Regresa a ``a = -0.3`` para el gran impulso.
        """
    elseif length(eqs) == 2
        md"""
        Con ``a`` = $(a_agl) ``\ge 0``, ``L = 0`` es **inestable**: cualquier región
        con algo de población crece hasta ``L_2`` = $(r(eqs[2])). Ya no hay
        umbral.
        """
    else
        md"""
        Con ``a`` = $(a_agl), la ventaja nunca es positiva: toda región se
        vacía. El único equilibrio es ``L = 0``.
        """
    end
end

# ╔═╡ ceb7406a-cf02-11f1-b4b7-75cde2b33fd4
let
    eqs, _ = equilibrios_aglomeracion(a_agl)
    u(L) = a_agl + 2L - 1.5L^2
    ts, Ls = simular((L, t) -> L * (u(L) + (t < T_sub ? σ_sub : 0.0)), 0.1, 40)
    p = plot(ts, Ls; color = AZUL, lw = 2, xlabel = "años", ylabel = "L(t)", ylims = (0, 1.6),
             title = "Subsidio de $σ_sub durante $T_sub años")
    T_sub > 0 && vspan!(p, [0, T_sub]; color = NARANJA, alpha = 0.12)
    length(eqs) == 3 && hline!(p, [eqs[2]]; color = GRIS, ls = :dash, lw = 1)
    p
end

# ╔═╡ ceb741a0-cf02-11f1-8e97-5384696f36a7
"Umbral de masa crítica: la raíz menor de a + bL − cL²."
umbral_ref(a, b, c) = (b - sqrt(b^2 + 4a * c)) / (2c)

# ╔═╡ ceb741aa-cf02-11f1-a35d-0fcc0a26468f
"Iteraciones x₀, x₁, …, xₙ de x_{t+1} = g(x_t)."
function iterar_ref(g, x0, n)
    x = [float(x0)]
    for _ in 1:n
        push!(x, g(x[end]))
    end
    x
end

# ╔═╡ ceb74088-cf02-11f1-910e-0b8f811e7de3
let
    ys = iterar_ref(y -> a_d * y + b_d, y0_d, 20)
    p = scatter(0:20, ys; color = AZUL, ms = 4, msw = 0, xlabel = "t", ylabel = "yₜ",
                title = "yₜ₊₁ = $(a_d) yₜ + $(b_d)", ylims = (-10, 20))
    plot!(p, 0:20, ys; color = AZUL, lw = 0.8, alpha = 0.5)
    !(a_d ≈ 1) && hline!(p, [b_d / (1 - a_d)]; color = GRIS, ls = :dash, lw = 1)
    p
end

# ╔═╡ ceb740e2-cf02-11f1-8a53-0b25a57e065c
let
    g(x) = 1 + 0.5cos(x)
    xstar = iterar_ref(g, 1.0, 200)[end]
    xs = iterar_ref(g, x0_c, 30)
    err = abs.(xs .- xstar)
    p = plot(0:30, max.(err, 1e-17); yscale = :log10, color = AZUL, lw = 2, marker = :circle,
             ms = 3, msw = 0, label = "error |xₜ − x*|", xlabel = "t", ylabel = "error",
             title = "Iteración de g(x) = 1 + 0.5 cos x", legend = :topright)
    plot!(p, 0:30, err[1] .* 0.5 .^ (0:30); color = NARANJA, ls = :dash, lw = 1.5,
          label = "cota ρᵗ |x₀ − x*|")
end

# ╔═╡ ceb741b4-cf02-11f1-b5f8-e354750ac240
"Los tres mapas de la sección 4: función, rango, punto fijo y g′ en el punto fijo."
function mapa_ref(nombre, D, r)
    if nombre == "solow"
        s, α, δ = 0.2, 0.3, 0.05
        Kstar = (s / δ)^(1 / (1 - α))
        (g = K -> (1 - δ) * K + s * max(K, 0)^α, rango = (0.0, 12.0), xstar = Kstar,
         gprima = 1 - (1 - α) * δ, nombre = "Solow: Kₜ₊₁ = 0.95Kₜ + 0.2Kₜ^0.3")
    elseif nombre == "mercado"
        A, B, C = 10.0, 1.0, 1.0
        (g = p -> (A - C) / B - D / B * p, rango = (0.0, 12.0), xstar = (A - C) / (B + D),
         gprima = -D / B, nombre = "Mercado: pₜ = 9 − $(D) pₜ₋₁")
    else
        (g = x -> r * x * (1 - x), rango = (0.0, 1.0), xstar = max(1 - 1 / r, 0.0),
         gprima = r > 1 ? 2 - r : r, nombre = "Logístico: xₜ₊₁ = $(r) xₜ(1 − xₜ)")
    end
end

# ╔═╡ ceb740b0-cf02-11f1-8c6d-df61c8201a1d
let
    m = mapa_ref(mapa, D_oferta, r_log)
    gp = m.gprima
    lectura = abs(gp) < 1 ? (gp >= 0 ? "estable, con convergencia monótona" : "estable, con convergencia oscilante") :
              abs(gp) > 1 ? "inestable" : "en el límite: el criterio no decide"
    md"""
    Punto fijo ``x^\ast`` = $(round(m.xstar, digits = 3)), con
    ``g'(x^\ast)`` = $(round(gp, digits = 3)): $(lectura).

    1. **Mercado** (notas, 2.5): con ``D = 0.8``, la telaraña es una espiral
       que se cierra. **Mueve** ``D`` a 1 y después a 1.2: ¿qué pasa con las
       oscilaciones del precio? ¿Por qué depende de ``D/B``?
    2. **Solow discreto** (notas, 2.4): **observa** lo pequeños que son los
       peldaños con ``g'(K^\ast) = 0.965``. ¿Por qué el capital tarda tanto en
       llegar?
    3. **Logístico:** prueba ``r = 1.5``, ``2.8`` y ``3``. ¿En cuál converge
       sin oscilar, en cuál oscilando y en cuál el criterio no decide?
    """
end

# ╔═╡ ceb741be-cf02-11f1-8dee-331bd6941499
"Diagrama de telaraña de g para la trayectoria xs en el rango dado."
function telarana(g, xs, rango; titulo = "")
    grid = range(rango..., length = 300)
    p = plot(grid, g.(grid); color = AZUL, lw = 2, xlims = rango, ylims = rango,
             xlabel = "xₜ", ylabel = "xₜ₊₁", title = titulo, aspect_ratio = :equal)
    plot!(p, collect(rango), collect(rango); color = GRIS, ls = :dash, lw = 1)
    px, py = [xs[1]], [rango[1]]
    for t in 1:length(xs) - 1
        push!(px, xs[t]); push!(py, xs[t + 1])        # vertical: aplicar g
        push!(px, xs[t + 1]); push!(py, xs[t + 1])    # horizontal: a la diagonal
    end
    plot!(p, px, clamp.(py, rango...); color = NARANJA, lw = 1)
end

# ╔═╡ ceb740a6-cf02-11f1-8f8c-f597bf2e56f3
let
    m = mapa_ref(mapa, D_oferta, r_log)
    x0 = m.rango[1] + x0_frac * (m.rango[2] - m.rango[1])
    xs = iterar_ref(m.g, x0, 40)
    g1 = telarana(m.g, xs, m.rango; titulo = m.nombre)
    g2 = plot(0:40, xs; color = AZUL, lw = 1, marker = :circle, ms = 3, msw = 0,
              xlabel = "t", ylabel = "xₜ", title = "Trayectoria", ylims = m.rango)
    hline!(g2, [m.xstar]; color = GRIS, ls = :dash, lw = 1)
    plot(g1, g2; layout = (1, 2), size = (760, 340))
end

# ╔═╡ ceb741ca-cf02-11f1-a45c-95fdaf186c3d
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

# ╔═╡ ceb7410a-cf02-11f1-8836-79e4f916f65f
verificar(() -> clasificar_continuo.([-0.042, 0.255, 0.0, -1.72]),
          [:estable, :inestable, :no_decide, :estable];
          pista = md"Usa `fp < 0 ? :estable : fp > 0 ? :inestable : :no_decide`.")

# ╔═╡ ceb7411e-cf02-11f1-bc61-6d98e7b79e37
verificar(() -> clasificar_discreto.([0.965, -0.8, 1.5, -1.2, 1.0, -1.0, 0.0]),
          [:monotona, :oscilante, :inestable, :inestable, :no_decide, :no_decide, :monotona];
          pista = md"Primero compara `abs(gp)` con 1; si es menor, decide por el signo de `gp` (con `gp >= 0` monótona).")

# ╔═╡ ceb74132-cf02-11f1-b603-6bd698abeed5
verificar(() -> [iterar(y -> -0.5y + 3, 0.0, 4); iterar(cos, 1.0, 3)],
          [iterar_ref(y -> -0.5y + 3, 0.0, 4); iterar_ref(cos, 1.0, 3)];
          pista = md"Crea `x = [x0]` y en un ciclo `for t in 1:n` agrega `push!(x, g(x[end]))`; devuelve `x`.")

# ╔═╡ ceb74150-cf02-11f1-a361-85729409cc30
verificar(() -> [umbral(-0.3, 2.0, 1.5), umbral(-0.1, 2.0, 1.5), umbral(-0.5, 3.0, 2.0)],
          [umbral_ref(-0.3, 2.0, 1.5), umbral_ref(-0.1, 2.0, 1.5), umbral_ref(-0.5, 3.0, 2.0)];
          pista = md"Las raíces de ``-cL^2 + bL + a = 0`` son ``\big(b \mp \sqrt{b^2 + 4ac}\big)/(2c)``; la menor lleva el signo menos.")

# ╔═╡ Cell order:
# ╟─ceb73fca-cf02-11f1-b285-317b68e4001b
# ╟─ceb74010-cf02-11f1-942f-d770597eefa3
# ╟─ceb7401a-cf02-11f1-b42b-adf506e12b41
# ╟─ceb74024-cf02-11f1-aab4-8189a8bfbd56
# ╟─ceb7402e-cf02-11f1-adb1-0b9048aad257
# ╟─ceb74042-cf02-11f1-9f0d-0d8a3e12635f
# ╟─ceb74042-cf02-11f1-8cab-811c4d6ce8d8
# ╟─ceb7404c-cf02-11f1-97da-1f2dc6b7bca4
# ╟─ceb74056-cf02-11f1-a7e3-134aca5d6b7c
# ╟─ceb74062-cf02-11f1-a8f7-69a5bd5f3507
# ╟─ceb7406a-cf02-11f1-b4b7-75cde2b33fd4
# ╟─ceb74074-cf02-11f1-85db-35ecbd5d03dd
# ╟─ceb7407e-cf02-11f1-a6be-ed625c81d147
# ╟─ceb74088-cf02-11f1-910e-0b8f811e7de3
# ╟─ceb74094-cf02-11f1-bdfc-53d0550760eb
# ╟─ceb7409c-cf02-11f1-bff8-2d89a32c5687
# ╟─ceb740a6-cf02-11f1-8f8c-f597bf2e56f3
# ╟─ceb740b0-cf02-11f1-8c6d-df61c8201a1d
# ╟─ceb740ba-cf02-11f1-a97f-57c818f0ba92
# ╟─ceb740c6-cf02-11f1-8620-a71691e90ec6
# ╟─ceb740ce-cf02-11f1-962d-cbf6b77320c2
# ╟─ceb740d8-cf02-11f1-965e-8b65ed7d3ef6
# ╟─ceb740e2-cf02-11f1-8a53-0b25a57e065c
# ╟─ceb740ec-cf02-11f1-931f-1f292d78ebf9
# ╟─ceb740f4-cf02-11f1-a128-2d8491f6490a
# ╠═ceb74100-cf02-11f1-bff0-936155fd9b01
# ╟─ceb7410a-cf02-11f1-8836-79e4f916f65f
# ╟─ceb7410a-cf02-11f1-940a-854d54251270
# ╠═ceb74114-cf02-11f1-a600-b1d3e2693ce7
# ╟─ceb7411e-cf02-11f1-bc61-6d98e7b79e37
# ╟─ceb74126-cf02-11f1-b904-3f47a2d83318
# ╠═ceb74132-cf02-11f1-8fcf-6d52f8ad4c2a
# ╟─ceb74132-cf02-11f1-b603-6bd698abeed5
# ╟─ceb7413c-cf02-11f1-bfda-43790f1ca52a
# ╠═ceb74146-cf02-11f1-a57a-b9eda178b7a0
# ╟─ceb74150-cf02-11f1-a361-85729409cc30
# ╟─ceb74158-cf02-11f1-bc47-15372f51edc3
# ╟─ceb74164-cf02-11f1-a156-59fe6162871e
# ╠═ceb7416e-cf02-11f1-a178-d745a87dd3bd
# ╠═ceb74178-cf02-11f1-bf52-cd309704ed25
# ╠═ceb74182-cf02-11f1-af9d-f5299e1d376d
# ╠═ceb7418c-cf02-11f1-bf77-bbc41e02503a
# ╠═ceb74196-cf02-11f1-999f-bd6da72a1ab6
# ╠═ceb741a0-cf02-11f1-8e97-5384696f36a7
# ╠═ceb741aa-cf02-11f1-a35d-0fcc0a26468f
# ╠═ceb741b4-cf02-11f1-b5f8-e354750ac240
# ╠═ceb741be-cf02-11f1-8dee-331bd6941499
# ╠═ceb741ca-cf02-11f1-a45c-95fdaf186c3d
