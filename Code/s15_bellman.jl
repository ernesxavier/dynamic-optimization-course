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

# ╔═╡ ea67a5ba-cf08-11f1-89bf-0fa3cf0ba632
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

# ╔═╡ ea67a45a-cf08-11f1-885a-a7c15e6b70b6
md"""
# Sesión 15: Ecuación de Bellman en horizonte finito

**Pregunta de la unidad.** ¿Cómo debe crecer una región que decide cada año
cuánto invertir?

**Cómo usar este cuaderno.** La teoría está en las notas,
`Class_notes/s15_bellman.md`, y se desarrolla en el pizarrón; el cuaderno
sirve para ver la inducción hacia atrás en una malla y compararla con las
fórmulas. En clase se proyectan las secciones 1 y 2; la sección 3 y los
ejercicios son para después. Pluto es reactivo: al mover un deslizador,
todo lo que depende de él se recalcula.

**Cómo abrirlo.** Desde la raíz del repositorio:
`julia --project=Code -e 'using Pluto; Pluto.run()'` y abrir
`Code/s15_bellman.jl`.
"""

# ╔═╡ ea67a4b6-cf08-11f1-a546-9b5511afc931
TableOfContents(title = "Contenido")

# ╔═╡ ea67a4c0-cf08-11f1-bbdb-f74e94f7d7e6
md"""
## 1. La torta: inducción hacia atrás en una malla

*En clase, minutos 60–68, después de la sección 3 de las notas.* Un fondo
de 100 se gasta en ``T`` periodos con ``r = \ln c`` y ``S = 0``. El estado se
discretiza en una malla de 401 puntos entre 0 y 100, y en cada punto se elige
el fondo que se deja para el periodo siguiente, también en la malla.

Número de periodos, ``T``: $(@bind T Slider(2:1:10, default = 3, show_value = true))

Factor de descuento, ``\beta``: $(@bind β Slider(0.80:0.01:0.99, default = 0.90, show_value = true))
"""

# ╔═╡ ea67a4ca-cf08-11f1-8742-7d8987c8e8b9
md"""
Ésta es toda la inducción hacia atrás: para cada periodo, desde el último,
y para cada estado de la malla, se prueba cada estado siguiente posible y se
queda el mejor. `recompensa(x, x′)` vale ``-\infty`` si el paso no es
factible.
"""

# ╔═╡ ea67a4de-cf08-11f1-b363-5740f1172103
function induccion_atras(malla, T, β, recompensa)
    N = length(malla)
    V = zeros(N, T + 1)                     # V[:, t] = V_{t-1}; la última columna es S = 0
    siguiente = zeros(Int, N, T)            # índice del estado siguiente óptimo
    for t in T:-1:1                         # desde el último periodo
        for i in 1:N
            valores = [recompensa(malla[i], malla[j]) + β * V[j, t + 1] for j in 1:N]
            V[i, t], siguiente[i, t] = findmax(valores)
        end
    end
    (; V, siguiente)
end

# ╔═╡ ea67a506-cf08-11f1-8ad5-6de4db3700cf
md"""
## 2. Crecimiento óptimo de una región

*En clase, minutos 90–100, después de la sección 4 de las notas.* Una región
con ``k_{t+1} = k_t^\alpha - c_t`` y ``r = \ln c``. La misma función
`induccion_atras` resuelve el problema; sólo cambia la recompensa. La región
empieza con la mitad del capital de largo plazo de la regla de la sección
4.3 de las notas.

Participación del capital, ``\alpha``: $(@bind α Slider(0.2:0.05:0.5, default = 0.3, show_value = true))

Factor de descuento, ``\beta``: $(@bind βk Slider(0.80:0.01:0.99, default = 0.95, show_value = true))

Horizonte, ``T``: $(@bind Tk Slider(2:1:20, default = 10, show_value = true))
"""

# ╔═╡ ea67a524-cf08-11f1-a05e-8dde2b081a59
let
    fr(n) = round(100 * (1 - α * βk) / (1 - (α * βk)^n), digits = 1)
    md"""
    Fracción del producto que se consume: $(fr(Tk))% con ``T`` = $(Tk)
    periodos por delante, $(fr(2))% con dos y 100% en el último.

    1. **Observa** la trayectoria: ¿hacia dónde va el capital al principio?
       ¿Qué pasa en los últimos periodos?
    2. **Compara** las políticas de la izquierda: ¿por qué la región invierte
       menos cuando faltan pocos periodos?
    3. **Alarga** el horizonte a 20: ¿cuántos periodos pasa la región cerca
       del capital de largo plazo?
    4. **Sube** ``\beta``: ¿qué pasa con el capital de largo plazo?
    """
end

# ╔═╡ ea67a530-cf08-11f1-a22f-493451934509
md"""
## 3. [Avanzado] Lo que cuesta la malla

*Fuera de clase* (notas, sección 5). La torta con ``T = 5`` y
``\beta = 0.9``: el error máximo de la malla frente a las fórmulas, en la
función valor y en el gasto del primer periodo (fondos de 10 a 100), y el
tiempo de cálculo, según el número de puntos ``N``. Cada periodo cuesta unos
``N^2`` cálculos.
"""

# ╔═╡ ea67a538-cf08-11f1-9128-e1099698591d
md"""
**Observa:** al duplicar la malla, ¿cuánto baja el error del gasto? ¿Y el
del valor? ¿Cuánto sube el tiempo? Con dos regiones, el estado tendría dos dimensiones y la malla
``N^2`` puntos: ¿cuánto tardaría?

## Ejercicios

*Después de clase.* Los ejercicios con demostraciones están en las notas
(sección 8).

### Completa el código

**1.** Escribe `fraccion_torta(n, β)`, la fracción del fondo que se gasta
cuando faltan ``n`` periodos, con ``r = \ln c`` (notas, sección 3.2).
"""

# ╔═╡ ea67a542-cf08-11f1-a37a-3ffd1dc26972
fraccion_torta(n, β) = missing  # reemplaza missing

# ╔═╡ ea67a556-cf08-11f1-aac2-bfd89f146d60
md"""
**2.** Escribe `paso_bellman(V_sig, malla, β)`, un paso de la inducción
hacia atrás para la torta: recibe la función valor del periodo siguiente en
la malla y devuelve el vector de la función valor de este periodo. Es el
cuerpo del ciclo `for i in 1:N` de `induccion_atras`.
"""

# ╔═╡ ea67a556-cf08-11f1-92b1-690e61d327a7
function paso_bellman(V_sig, malla, β)
    missing  # reemplaza esta línea
end

# ╔═╡ ea67a574-cf08-11f1-ba9e-095d4a2d4504
md"""
**3.** Escribe `b_crecimiento(n, α, β)`, el coeficiente ``b_n`` de
``\ln k`` en la función valor del crecimiento con ``n`` periodos por delante
(notas, sección 4.2).
"""

# ╔═╡ ea67a57e-cf08-11f1-bd6a-654e203ba3dc
b_crecimiento(n, α, β) = missing  # reemplaza missing

# ╔═╡ ea67a588-cf08-11f1-ae5b-6fc25c432676
md"""
**4. [Avanzado]** Escribe `salario_reserva(c, β, w, φ)`, el salario de
reserva del primer periodo en la búsqueda de empleo de dos periodos (notas,
P.2), con ofertas posibles `w` y probabilidades `φ`.
"""

# ╔═╡ ea67a590-cf08-11f1-b1be-6dde1508f3c2
function salario_reserva(c, β, w, φ)
    missing  # reemplaza esta línea
end

# ╔═╡ ea67a5a6-cf08-11f1-aabb-5bd40d571ee9
md"""
### Interpretación

5. ¿Por qué en el último periodo se gasta o se consume todo? ¿Qué tendría
   que cambiar en el problema para que no fuera así?
6. En la sección 2, dos regiones tienen el mismo capital, pero a una le
   quedan 10 periodos de plan y a la otra 2. ¿Cuál invierte más? ¿Tiene
   sentido para un gobierno regional con mandato de pocos años?
7. La política depende del estado y de cuántos periodos faltan, no de cómo
   se llegó al estado. ¿Por qué eso es una ventaja si algo inesperado cambia
   el capital de la región?

### Tu tesis

8. Escribe la ecuación de Bellman de tu problema, aunque sea con palabras:
   ¿cuál es el estado, cuál el control, cuál la recompensa de cada periodo
   y qué vale el estado al final?

### [Avanzado]

9. En la sección 3, el error del gasto baja a la mitad al duplicar la malla,
   pero el del valor baja a la cuarta parte. ¿Por qué? (Pista: en el óptimo,
   la derivada del lado derecho de la ecuación de Bellman respecto del
   control es cero.)
10. Con dos regiones y 401 puntos por dimensión, ¿cuántos estados tendría la
    malla? ¿Cuántas evaluaciones costaría un periodo?

## Para la próxima sesión

- **Sesión 16: horizonte infinito.** Una sola función valor, punto fijo del
  operador de Bellman; iteración de la función valor y de la política, y la
  solución exacta de la torta para verificar el código.
- Repaso: A.B2 y A.B3 (sucesiones y series), N.B4 (punto flotante), A.I4 y
  A.I5 (normas y contracciones), N.I4 a N.I6 (mallas, interpolación y
  error). Para los puntos [Avanzado]: A.A1 a A.A3 (espacios completos,
  Banach y Blackwell) y N.A2 (iteración de política).
"""

# ╔═╡ ea67a5b0-cf08-11f1-808f-e1b8ec807fe8
md"""
---
## Apéndice: paquetes y funciones auxiliares

Estas celdas definen herramientas que usa el cuaderno. No es necesario
leerlas para seguir la sesión.
"""

# ╔═╡ ea67a5c2-cf08-11f1-b288-e5f42ed4b2fc
begin
    const AZUL    = "#2a78d6"
    const NARANJA = "#eb6834"
    const GRIS    = "#52514e"
    const TINTA   = "#0b0b0b"
    const COLORES = [AZUL, NARANJA, TINTA, "#3fa34d", "#8e5bd6", GRIS]
end;

# ╔═╡ ea67a5c2-cf08-11f1-9bca-933dc6854d8a
begin
    "Malla del fondo de la torta: 401 puntos entre 0 y 100."
    const MALLA_TORTA = collect(range(0, 100, length = 401))
    "Malla pequeña para el ejercicio 2."
    const MALLA_PRUEBA = collect(range(0, 10, length = 41))
    "Malla del capital: 301 puntos entre 0 y 0.6."
    const MALLA_K = collect(range(0, 0.6, length = 301))
end;

# ╔═╡ ea67a4e8-cf08-11f1-91aa-e1439b140802
torta = induccion_atras(MALLA_TORTA, T, β, (x, x′) -> x′ < x ? log(x - x′) : -Inf)

# ╔═╡ ea67a510-cf08-11f1-9144-4f8703813e76
region = induccion_atras(MALLA_K, Tk, βk, (k, k′) -> k′ < k^α ? log(k^α - k′) : -Inf)

# ╔═╡ ea67a5ce-cf08-11f1-a231-2deff34724e3
"Fracción del fondo que se gasta cuando faltan n periodos (torta con ln c)."
fraccion_torta_ref(n, β) = (1 - β) / (1 - β^n)

# ╔═╡ ea67a4fe-cf08-11f1-b349-9920b5d267a4
let
    x = 100.0
    i = length(MALLA_TORTA)
    filas = String[]
    for t in 1:T
        n = T - t + 1
        j = torta.siguiente[i, t]
        c_malla = MALLA_TORTA[i] - MALLA_TORTA[j]
        push!(filas, "| $(t - 1) | $n | $(round(MALLA_TORTA[i], digits = 2)) | $(round(c_malla, digits = 2)) | $(round(fraccion_torta_ref(n, β) * x, digits = 2)) |")
        x -= fraccion_torta_ref(n, β) * x
        i = j
    end
    Markdown.parse("""
    Los puntos son la malla; las líneas, las fórmulas de la sección 3.2 de
    las notas. Desde un fondo de 100:

    | Periodo | Faltan | Fondo (malla) | Gasto (malla) | Gasto (fórmula) |
    |---:|---:|---:|---:|---:|
    $(join(filas, "\n"))

    1. Con ``T = 3`` y ``\\beta = 0.9``, **compara** la tabla con la de la
       sección 3.2 de las notas.
    2. **Observa** la política: ¿por qué es una recta? ¿Por qué es más
       empinada cuando faltan menos periodos?
    3. **Sube** ``\\beta`` a 0.99: ¿cómo cambia el reparto del gasto en el
       tiempo?
    """)
end

# ╔═╡ ea67a5d8-cf08-11f1-9262-5d6ad50589e3
"Valor exacto de la torta con fondo x y n periodos por delante: se sigue la regla óptima."
function valor_torta_exacto(x, n, β)
    total = 0.0
    for s in 0:n-1
        c = fraccion_torta_ref(n - s, β) * x
        total += β^s * log(c)
        x -= c
    end
    total
end

# ╔═╡ ea67a4f2-cf08-11f1-8ea0-79fe1b81cff6
let
    xs = MALLA_TORTA
    g1 = plot(; xlabel = "fondo x", ylabel = "V(x)", title = "Función valor por periodo",
              legend = :bottomright, ylims = (-4, 12))
    g2 = plot(; xlabel = "fondo x", ylabel = "gasto c(x)", title = "Política por periodo",
              legend = :topleft)
    for t in 1:T
        n = T - t + 1                       # periodos que faltan
        color = COLORES[mod1(t, length(COLORES))]
        c_malla = xs .- xs[torta.siguiente[:, t]]
        scatter!(g1, xs[2:20:end], torta.V[2:20:end, t]; color, ms = 2.5, msw = 0, label = "")
        plot!(g1, xs[2:end], valor_torta_exacto.(xs[2:end], n, β); color, lw = 1.5, label = "faltan $n")
        scatter!(g2, xs[2:20:end], c_malla[2:20:end]; color, ms = 2.5, msw = 0, label = "")
        plot!(g2, xs, fraccion_torta_ref(n, β) .* xs; color, lw = 1.5, label = "faltan $n")
    end
    plot(g1, g2; layout = (1, 2), size = (800, 330))
end

# ╔═╡ ea67a614-cf08-11f1-aa07-35c860e95f13
"Capital del periodo siguiente con la regla óptima cuando faltan n periodos."
politica_k_ref(k, n, α, β) = α * β * (1 - (α * β)^(n - 1)) / (1 - (α * β)^n) * k^α

# ╔═╡ ea67a61e-cf08-11f1-a908-5d9ca7d277da
"Capital de largo plazo de la regla k′ = αβ k^α."
kstar_ref(α, β) = (α * β)^(1 / (1 - α))

# ╔═╡ ea67a628-cf08-11f1-989f-b53fa5177b5d
"""
Trayectorias del capital desde k0 durante T periodos: con la política de la
malla (partiendo del punto de malla más cercano) y con la fórmula.
"""
function trayectorias_k(sol, k0, T, α, β)
    i = argmin(abs.(MALLA_K .- k0))
    malla = [MALLA_K[i]]
    exacta = [MALLA_K[i]]
    for t in 1:T
        i = sol.siguiente[i, t]
        push!(malla, MALLA_K[i])
        push!(exacta, politica_k_ref(exacta[end], T - t + 1, α, β))
    end
    malla, exacta
end

# ╔═╡ ea67a51a-cf08-11f1-b6dd-252a71d70d1b
let
    ks = MALLA_K
    g1 = plot(; xlabel = "capital k", ylabel = "capital siguiente k′", title = "Política según los periodos que faltan",
              legend = :topleft)
    plot!(g1, ks, ks; color = GRIS, ls = :dot, lw = 1, label = "k′ = k")
    for (m, n) in enumerate(unique([1, 2, 3, min(5, Tk), Tk]))
        t = Tk - n + 1
        color = COLORES[mod1(m, length(COLORES))]
        scatter!(g1, ks[2:12:end], ks[region.siguiente[2:12:end, t]]; color, ms = 2.5, msw = 0, label = "")
        plot!(g1, ks, politica_k_ref.(ks, n, α, βk); color, lw = 1.5, label = "faltan $n")
    end
    k0 = 0.5 * kstar_ref(α, βk)
    tr_malla, tr_exacta = trayectorias_k(region, k0, Tk, α, βk)
    g2 = plot(0:Tk, tr_exacta; color = AZUL, lw = 2, label = "fórmula", xlabel = "periodo",
              ylabel = "capital k", title = "Trayectoria desde k₀", legend = :bottom)
    scatter!(g2, 0:Tk, tr_malla; color = TINTA, ms = 3.5, msw = 0, label = "malla")
    hline!(g2, [kstar_ref(α, βk)]; color = GRIS, ls = :dash, lw = 1, label = "largo plazo")
    plot(g1, g2; layout = (1, 2), size = (800, 340))
end

# ╔═╡ ea67a634-cf08-11f1-80c3-69e15793f65a
"""
Errores máximos de la torta (T = 5, β = 0.9) en V₀ y en el gasto del primer
periodo, para fondos de 10 a 100, y tiempo de cálculo, para varias mallas.
"""
function costo_malla(Ns; T = 5, β = 0.9)
    recompensa(x, x′) = x′ < x ? log(x - x′) : -Inf
    induccion_atras(collect(range(0, 100, length = 11)), T, β, recompensa)  # compila antes de medir
    err_valor, err_gasto, tiempos = Float64[], Float64[], Float64[]
    for N in Ns
        malla = collect(range(0, 100, length = N))
        t = @elapsed sol = induccion_atras(malla, T, β, recompensa)
        i = findall(≥(10), malla)
        gasto = malla[i] .- malla[sol.siguiente[i, 1]]
        push!(err_valor, maximum(abs.(sol.V[i, 1] .- valor_torta_exacto.(malla[i], T, β))))
        push!(err_gasto, maximum(abs.(gasto .- fraccion_torta_ref(T, β) .* malla[i])))
        push!(tiempos, t)
    end
    Ns, err_valor, err_gasto, tiempos
end

# ╔═╡ ea67a538-cf08-11f1-9857-eb83caa3ec70
let
    Ns, err_valor, err_gasto, tiempos = costo_malla([51, 101, 201, 401, 801, 1601])
    g1 = plot(Ns, err_gasto; xscale = :log10, yscale = :log10, color = AZUL, lw = 2, marker = :circle,
              ms = 4, msw = 0, label = "gasto", xlabel = "puntos de la malla N", ylabel = "error máximo",
              title = "Error", legend = :bottomleft)
    plot!(g1, Ns, err_valor; color = TINTA, lw = 2, marker = :circle, ms = 4, msw = 0, label = "valor")
    g2 = plot(Ns, tiempos; xscale = :log10, yscale = :log10, color = NARANJA, lw = 2, marker = :circle,
              ms = 4, msw = 0, xlabel = "puntos de la malla N", ylabel = "segundos", title = "Tiempo")
    plot(g1, g2; layout = (1, 2), size = (800, 320))
end

# ╔═╡ ea67a63c-cf08-11f1-ad76-4dfda68574e3
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
                  (a isa AbstractArray && b isa AbstractArray && size(a) == size(b) && all(cerca.(a, b)))
    if pendiente(resultado)
        caja("warning", "Pendiente", md"Reemplaza `missing` por tu código.")
    elseif cerca(resultado, esperado)
        caja("correct", "¡Correcto!", md"Bien hecho.")
    else
        caja("danger", "Todavía no", pista)
    end
end

# ╔═╡ ea67a54c-cf08-11f1-a381-5de0c1099ae4
verificar(() -> [fraccion_torta(1, 0.9), fraccion_torta(3, 0.9), fraccion_torta(10, 0.95)],
          [fraccion_torta_ref(1, 0.9), fraccion_torta_ref(3, 0.9), fraccion_torta_ref(10, 0.95)];
          pista = md"La suma ``1 + \beta + \cdots + \beta^{n-1}`` es ``(1 - \beta^n)/(1 - \beta)``: `(1 - β) / (1 - β^n)`.")

# ╔═╡ ea67a55e-cf08-11f1-9ff3-cd770caf5e80
verificar(() -> paso_bellman(zeros(length(MALLA_PRUEBA)), MALLA_PRUEBA, 0.9)[2:end],
          induccion_atras(MALLA_PRUEBA, 2, 0.9, (x, x′) -> x′ < x ? log(x - x′) : -Inf).V[2:end, 2];
          pista = md"Para cada `i`, calcula `maximum(log(malla[i] - malla[j]) + β * V_sig[j] for j in 1:length(malla) if malla[j] < malla[i]; init = -Inf)`.")

# ╔═╡ ea67a588-cf08-11f1-877b-8f46c8b92907
verificar(() -> [b_crecimiento(1, 0.3, 0.95), b_crecimiento(3, 0.3, 0.95), b_crecimiento(10, 0.4, 0.9)],
          [0.3, 0.3 * (1 + 0.285 + 0.285^2), 0.4 * (1 - 0.36^10) / (1 - 0.36)];
          pista = md"`α * (1 - (α * β)^n) / (1 - α * β)`, o la recursión ``b_n = \alpha(1 + \beta b_{n-1})`` con ``b_1 = \alpha``.")

# ╔═╡ ea67a59c-cf08-11f1-b459-4399887d35a4
verificar(() -> [salario_reserva(10.0, 0.96, [10.0, 30.0, 50.0], fill(1 / 3, 3)),
                 salario_reserva(20.0, 0.9, [10.0, 40.0], [0.5, 0.5])],
          [(10 + 0.96 * 30) / 1.96, (20 + 0.9 * 30) / 1.9];
          pista = md"Con `h = c + β * sum(max.(c, w) .* φ)`, el salario de reserva es `h / (1 + β)`.")

# ╔═╡ Cell order:
# ╟─ea67a45a-cf08-11f1-885a-a7c15e6b70b6
# ╟─ea67a4b6-cf08-11f1-a546-9b5511afc931
# ╟─ea67a4c0-cf08-11f1-bbdb-f74e94f7d7e6
# ╟─ea67a4ca-cf08-11f1-8742-7d8987c8e8b9
# ╠═ea67a4de-cf08-11f1-b363-5740f1172103
# ╠═ea67a4e8-cf08-11f1-91aa-e1439b140802
# ╟─ea67a4f2-cf08-11f1-8ea0-79fe1b81cff6
# ╟─ea67a4fe-cf08-11f1-b349-9920b5d267a4
# ╟─ea67a506-cf08-11f1-8ad5-6de4db3700cf
# ╠═ea67a510-cf08-11f1-9144-4f8703813e76
# ╟─ea67a51a-cf08-11f1-b6dd-252a71d70d1b
# ╟─ea67a524-cf08-11f1-a05e-8dde2b081a59
# ╟─ea67a530-cf08-11f1-a22f-493451934509
# ╟─ea67a538-cf08-11f1-9857-eb83caa3ec70
# ╟─ea67a538-cf08-11f1-9128-e1099698591d
# ╠═ea67a542-cf08-11f1-a37a-3ffd1dc26972
# ╟─ea67a54c-cf08-11f1-a381-5de0c1099ae4
# ╟─ea67a556-cf08-11f1-aac2-bfd89f146d60
# ╠═ea67a556-cf08-11f1-92b1-690e61d327a7
# ╟─ea67a55e-cf08-11f1-9ff3-cd770caf5e80
# ╟─ea67a574-cf08-11f1-ba9e-095d4a2d4504
# ╠═ea67a57e-cf08-11f1-bd6a-654e203ba3dc
# ╟─ea67a588-cf08-11f1-877b-8f46c8b92907
# ╟─ea67a588-cf08-11f1-ae5b-6fc25c432676
# ╠═ea67a590-cf08-11f1-b1be-6dde1508f3c2
# ╟─ea67a59c-cf08-11f1-b459-4399887d35a4
# ╟─ea67a5a6-cf08-11f1-aabb-5bd40d571ee9
# ╟─ea67a5b0-cf08-11f1-808f-e1b8ec807fe8
# ╠═ea67a5ba-cf08-11f1-89bf-0fa3cf0ba632
# ╠═ea67a5c2-cf08-11f1-b288-e5f42ed4b2fc
# ╠═ea67a5c2-cf08-11f1-9bca-933dc6854d8a
# ╠═ea67a5ce-cf08-11f1-a231-2deff34724e3
# ╠═ea67a5d8-cf08-11f1-9262-5d6ad50589e3
# ╠═ea67a614-cf08-11f1-aa07-35c860e95f13
# ╠═ea67a61e-cf08-11f1-a908-5d9ca7d277da
# ╠═ea67a628-cf08-11f1-989f-b53fa5177b5d
# ╠═ea67a634-cf08-11f1-80c3-69e15793f65a
# ╠═ea67a63c-cf08-11f1-ad76-4dfda68574e3
