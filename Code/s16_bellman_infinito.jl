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

# ╔═╡ 3b0343e8-cf0a-11f1-a4f7-8395ca21206e
begin
    # Usa el entorno del curso (Code/Project.toml) en lugar del gestor de
    # paquetes propio de Pluto: un solo entorno para todo el repositorio.
    import Pkg
    Pkg.activate(@__DIR__)
    Pkg.instantiate()
    using PlutoUI, Plots, Markdown, LinearAlgebra
    gr()
    default(size = (720, 320), legend = false, grid = :y, gridalpha = 0.15,
            framestyle = :axes, titlefontsize = 11, guidefontsize = 9,
            tickfontsize = 8, legendfontsize = 8, foreground_color_legend = nothing,
            background_color_legend = nothing, margin = 3Plots.mm)
end

# ╔═╡ 3b034258-cf0a-11f1-be1a-ab35089641d3
md"""
# Sesión 16: Ecuación de Bellman en horizonte infinito

**Pregunta de la unidad.** ¿Cómo debe crecer una región que decide cada año
cuánto invertir?

**Cómo usar este cuaderno.** La teoría está en las notas,
`Class_notes/s16_bellman_infinito.md`, y se desarrolla en el pizarrón; el
cuaderno sirve para ver los dos métodos de la sesión trabajando sobre una
malla y compararlos con las soluciones exactas. En clase se proyectan las
secciones 1 y 2; la sección 3 y los ejercicios son para después. Pluto es
reactivo: al mover un deslizador, todo lo que depende de él se recalcula.

**Cómo abrirlo.** Desde la raíz del repositorio:
`julia --project=Code -e 'using Pluto; Pluto.run()'` y abrir
`Code/s16_bellman_infinito.jl`.
"""

# ╔═╡ 3b0342b4-cf0a-11f1-acaf-f968feb4ade9
TableOfContents(title = "Contenido")

# ╔═╡ 3b0342c6-cf0a-11f1-a7a7-8bbd3dc019b5
md"""
## 1. La iteración de la función valor

*En clase, minutos 72–82, después de la sección 4 de las notas.* El
crecimiento de una región sin final, ``k' = k^\alpha - c`` con
``\alpha = 0.3`` y ``r = \ln c``, en una malla de 301 puntos entre 0.001 y
0.5. Se empieza con ``v_0 = 0`` y se aplica el operador de Bellman una y otra
vez. Ésta es toda la iteración: en cada estado de la malla se prueba cada
estado siguiente y se queda el mejor. `R[i, j]` es la recompensa de pasar del
estado `i` al `j`, ``-\infty`` si no es factible.
"""

# ╔═╡ 3b0342d0-cf0a-11f1-a030-cd287a7c4d67
function operador_bellman(v, R, β)
    N = length(v)
    Tv, σ = zeros(N), zeros(Int, N)
    for i in 1:N
        Tv[i], σ[i] = findmax(j -> R[i, j] + β * v[j], 1:N)
    end
    Tv, σ
end

# ╔═╡ 3b0342da-cf0a-11f1-8101-d544fad736d7
md"""
Factor de descuento, ``\beta``: $(@bind β Slider(0.80:0.01:0.98, default = 0.90, show_value = true))

Iteraciones, ``n``: $(@bind n Slider(0:1:400, default = 20, show_value = true))

La solución exacta es la de la sección 4 de las notas:
``V(k) = a + \frac{\alpha}{1 - \alpha\beta}\ln k``.
"""

# ╔═╡ 3b03430c-cf0a-11f1-86c5-03e7c45c2824
md"""
## 2. Función valor contra política

*En clase, minutos 100–110, después de la sección 5 de las notas.* El mismo
crecimiento, ahora con ``\alpha`` también variable. La iteración de política
evalúa cada política con un sistema lineal (notas, 5.2) y la mejora con el
mismo operador de Bellman:
"""

# ╔═╡ 3b034318-cf0a-11f1-b094-69d23cdd6d3d
function evaluar_politica(σ, R, β)
    N = length(σ)
    P, r = zeros(N, N), zeros(N)
    for i in 1:N
        P[i, σ[i]] = 1               # desde i se pasa a σ[i]
        r[i] = R[i, σ[i]]
    end
    (I - β * P) \ r
end

# ╔═╡ 3b034320-cf0a-11f1-80e2-bb025c8283e7
md"""
Participación del capital, ``\alpha``: $(@bind α Slider(0.2:0.05:0.5, default = 0.3, show_value = true))

Factor de descuento, ``\beta``: $(@bind βk Slider(0.80:0.01:0.99, default = 0.95, show_value = true))

Las dos se detienen con la misma tolerancia, ``10^{-6}`` en el valor.
"""

# ╔═╡ 3b034352-cf0a-11f1-a34d-9fee1b599234
md"""
## 3. [Avanzado] La política llega antes que el valor

*Fuera de clase.* En la iteración de la función valor de la sección 2, el
número de puntos de la malla donde la política de la iteración ``n`` todavía
difiere de la final, y la distancia del valor al final. Con los
deslizadores de la sección 2.
"""

# ╔═╡ 3b034366-cf0a-11f1-a756-43b82d3cfe47
md"""
**Observa:** ¿en qué iteración deja de cambiar la política? ¿Qué tan lejos
está el valor en ese momento? Es la idea de la iteración de política
optimista (notas, 5.4): no hace falta evaluar con exactitud una política
para mejorarla.

## Ejercicios

*Después de clase.* Los ejercicios con demostraciones están en las notas
(sección 8).

### Completa el código

**1.** Escribe `valor_torta(x, β)`, la función valor exacta de la torta sin
final con ``r = \ln c`` (notas, sección 3).
"""

# ╔═╡ 3b034370-cf0a-11f1-9ab0-0f4fa7817cdf
valor_torta(x, β) = missing  # reemplaza missing

# ╔═╡ 3b034384-cf0a-11f1-a77e-132144e3a9f6
md"""
**2.** Escribe `iteraciones_necesarias(β, reduccion)`, el menor número
entero de iteraciones ``n`` con ``\beta^n \le`` `reduccion` (notas,
sección 2.3).
"""

# ╔═╡ 3b034398-cf0a-11f1-846d-c9a2811724eb
iteraciones_necesarias(β, reduccion) = missing  # reemplaza missing

# ╔═╡ 3b0343a2-cf0a-11f1-afff-d1ec60416713
md"""
**3.** Escribe `valor_fraccion(x, γ, β)`, el valor de gastar para siempre
la fracción ``\gamma`` del fondo de la torta (notas, sección 5.2 y F2).
"""

# ╔═╡ 3b0343aa-cf0a-11f1-9771-4f9f4aba8a41
valor_fraccion(x, γ, β) = missing  # reemplaza missing

# ╔═╡ 3b0343c0-cf0a-11f1-a4b1-87ed5132615a
md"""
**4. [Avanzado]** Escribe `evaluar_aproximada(σ, R, β, m)`: en lugar del
sistema lineal de `evaluar_politica`, empieza con ``v = 0`` y aplica ``m``
veces ``v \mapsto r_\sigma + \beta P_\sigma v``, es decir,
`v[i] = R[i, σ[i]] + β * v[σ[i]]` para todos los `i` a la vez.
"""

# ╔═╡ 3b0343ca-cf0a-11f1-8409-5728507c8109
function evaluar_aproximada(σ, R, β, m)
    missing  # reemplaza esta línea
end

# ╔═╡ 3b0343d4-cf0a-11f1-89a3-49e82e075109
md"""
### Interpretación

5. En la sección 1, ¿por qué el error deja de bajar aunque se sigan haciendo
   iteraciones? ¿Qué habría que cambiar para bajarlo más? ¿Por qué la torta
   sin final no se puede resolver así en una malla? (Notas, sección 4.)
6. Una región muy paciente (``\beta`` cerca de 1), ¿es más difícil de
   resolver con la iteración de la función valor? ¿Y con la de política?
   ¿Por qué?
7. En la sección 2, la región ahorra la fracción ``\alpha\beta`` del producto
   con cualquier capital. ¿Qué tendría que cambiar en el modelo para que una
   región pobre ahorrara una fracción distinta que una rica? (Pista: notas,
   sección 4, y sesión 12.)

### Tu tesis

8. ¿Tu problema tiene un final natural, o tiene sentido pensarlo sin final?
   Si no tiene final, ¿cuál sería la política estacionaria que buscas?

### [Avanzado]

9. En la sección 3, la política deja de cambiar mucho antes de que el valor
   converja. ¿Por qué basta una aproximación del valor para elegir bien?
10. ¿Por qué la iteración de política termina en un número finito de pasos
    en la malla, pero no necesariamente en un problema con estados
    continuos?

## Para la próxima sesión

- **Sesión 17: Laboratorio 2.** La iteración de la función valor con la
  regla de paro: primero la torta, contra la solución exacta, y después el
  crecimiento de una región con los parámetros calibrados en la sesión 12.
- Repaso: N.B1 a N.B3 (Julia básico), A.I4 (normas), N.I4 a N.I6 (mallas,
  maximizar y medir el error). Para los puntos [Avanzado]: A.A2 (Banach y
  la regla de paro).
"""

# ╔═╡ 3b0343de-cf0a-11f1-8b70-b5643a23f4c2
md"""
---
## Apéndice: paquetes y funciones auxiliares

Estas celdas definen herramientas que usa el cuaderno. No es necesario
leerlas para seguir la sesión.
"""

# ╔═╡ 3b0343fc-cf0a-11f1-a1d6-8b217c2e673a
begin
    const AZUL    = "#2a78d6"
    const NARANJA = "#eb6834"
    const GRIS    = "#52514e"
    const TINTA   = "#0b0b0b"
    const COLORES = [AZUL, TINTA, "#3fa34d", "#8e5bd6", GRIS]
end;

# ╔═╡ 3b034406-cf0a-11f1-805f-4b0fbfbb5e0a
begin
    "Malla del capital: 301 puntos entre 0.001 y 0.5."
    const MALLA_K = collect(range(0.001, 0.5, length = 301))
    "Recompensa de pasar del capital k al k′ en la malla, con α = 0.3."
    const R_K = [k′ < k^0.3 ? log(k^0.3 - k′) : -Inf for k in MALLA_K, k′ in MALLA_K]
end;

# ╔═╡ 3b0342ee-cf0a-11f1-9d79-f18ac9e4dd85
iteraciones = let
    v = zeros(length(MALLA_K))
    vs = [v]
    for _ in 1:400
        v, _ = operador_bellman(v, R_K, β)
        push!(vs, v)
    end
    vs
end;

# ╔═╡ 3b034406-cf0a-11f1-9563-39f82a5f44cf
"Valor exacto de la torta sin final con fondo x y r = ln c."
valor_torta_ref(x, β) = log(1 - β) / (1 - β) + β * log(β) / (1 - β)^2 + log(x) / (1 - β)

# ╔═╡ 3b034410-cf0a-11f1-b2ae-55cd58656e69
"Valor exacto del crecimiento sin final con capital k, A = 1 y r = ln c."
valor_k_ref(k, α, β) = (log(1 - α * β) + α * β / (1 - α * β) * log(α * β)) / (1 - β) + α / (1 - α * β) * log(k)

# ╔═╡ 3b0342f8-cf0a-11f1-aae3-d94184f434d7
let
    ks = MALLA_K
    exacta = valor_k_ref.(ks, 0.3, β)
    g1 = plot(ks, exacta; color = GRIS, lw = 3, alpha = 0.5, label = "V exacta",
              xlabel = "capital k", ylabel = "valor", title = "Iteraciones de la función valor",
              legend = :right)
    for (m, k) in enumerate(unique(sort([1, 5, 20, n])))
        k == 0 && continue
        plot!(g1, ks, iteraciones[k + 1]; color = k == n ? NARANJA : COLORES[mod1(m, 3)],
              lw = k == n ? 2.5 : 1.2, label = "v$k")
    end
    errores = [maximum(abs.(v .- exacta)) for v in iteraciones]
    difs = [maximum(abs.(iteraciones[k + 1] .- iteraciones[k])) for k in 1:400]
    g2 = plot(0:400, errores; yscale = :log10, color = AZUL, lw = 2, label = "error ‖vₙ − V‖",
              xlabel = "iteración n", title = "Error y diferencia entre iteraciones",
              legend = :topright, ylims = (1e-8, 1e3))
    plot!(g2, 1:400, difs; color = TINTA, lw = 1.5, label = "‖vₙ − vₙ₋₁‖")
    plot!(g2, 0:400, errores[1] .* β .^ (0:400); color = GRIS, ls = :dash, lw = 1, label = "βⁿ‖v₀ − V‖")
    vline!(g2, [n]; color = NARANJA, lw = 1.5, label = "")
    plot(g1, g2; layout = (1, 2), size = (800, 340))
end

# ╔═╡ 3b034302-cf0a-11f1-a79e-bd5baf2e7b23
let
    v = iteraciones[n + 1]
    dif = n == 0 ? NaN : maximum(abs.(v .- iteraciones[n]))
    err = maximum(abs.(v .- valor_k_ref.(MALLA_K, 0.3, β)))
    Markdown.parse("""
    Con ``n`` = $n iteraciones, error máximo en la malla: $(round(err, sigdigits = 3));
    diferencia con la iteración anterior: $(round(dif, sigdigits = 3)); cota de la
    sección 2.3, ``\\beta/(1 - \\beta)`` veces la diferencia: $(round(β / (1 - β) * dif, sigdigits = 3)).

    1. **Mueve** ``n`` desde 0: ¿desde dónde se acercan las iteraciones a
       ``V``? Compara con la sesión 15: ``v_n`` es la región con ``n``
       periodos por delante.
    2. **Observa** la gráfica de la derecha: ¿cae el error como ``\\beta^n``?
       ¿Por qué deja de caer? (Pista: notas de la sesión 15, sección 5.)
    3. **Compara** el error con la cota: ¿se cumple? ¿Qué tan holgada es?
    4. **Sube** ``\\beta`` a 0.98: ¿cuántas iteraciones hacen falta ahora para
       llegar al piso?
    """)
end

# ╔═╡ 3b03441c-cf0a-11f1-add4-b14260ed57d7
"Valor de gastar para siempre la fracción γ del fondo x."
valor_fraccion_ref(x, γ, β) = (log(γ) + β * log(1 - γ) / (1 - β)) / (1 - β) + log(x) / (1 - β)

# ╔═╡ 3b034424-cf0a-11f1-aee6-7fe874a09b24
"Iteración de la función valor desde v = 0, con la regla de paro de las notas (2.3)."
function iterar_valor(R, β; tol = 1e-6, maxiter = 10_000)
    v = zeros(size(R, 1))
    historia = Vector{Float64}[]
    σ = zeros(Int, size(R, 1))
    for _ in 1:maxiter
        v_nuevo, σ = operador_bellman(v, R, β)
        push!(historia, v_nuevo)
        dif = maximum(abs.(v_nuevo .- v))
        v = v_nuevo
        dif ≤ tol * (1 - β) / β && break
    end
    (; v, σ, historia)
end

# ╔═╡ 3b03442e-cf0a-11f1-912e-0faa1d11f012
"Iteración de política desde la política de dejar el menor capital de la malla."
function iterar_politica(R, β; maxiter = 100)
    σ = ones(Int, size(R, 1))
    historia = Vector{Float64}[]
    v = evaluar_politica(σ, R, β)
    for _ in 1:maxiter
        _, σ_nueva = operador_bellman(v, R, β)
        v = evaluar_politica(σ_nueva, R, β)
        push!(historia, v)
        σ_nueva == σ && break
        σ = σ_nueva
    end
    (; v, σ, historia)
end

# ╔═╡ 3b03432a-cf0a-11f1-8d90-71c0dbd35127
comparacion = let
    R = [k′ < k^α ? log(k^α - k′) : -Inf for k in MALLA_K, k′ in MALLA_K]
    vfi = iterar_valor(R, βk)
    hpi = iterar_politica(R, βk)
    (; R, vfi, hpi)
end;

# ╔═╡ 3b034334-cf0a-11f1-9735-1ff1c27eb03a
let
    (; vfi, hpi) = comparacion
    ks = MALLA_K
    g1 = plot(ks, α * βk .* ks .^ α; color = GRIS, lw = 3, alpha = 0.5, label = "k′ = αβkᵅ",
              xlabel = "capital k", ylabel = "capital siguiente k′", title = "Política",
              legend = :bottomright)
    plot!(g1, ks, ks; color = GRIS, ls = :dot, lw = 1, label = "k′ = k")
    scatter!(g1, ks[1:10:end], ks[vfi.σ[1:10:end]]; color = AZUL, ms = 3, msw = 0, label = "función valor")
    scatter!(g1, ks[5:10:end], ks[hpi.σ[5:10:end]]; color = NARANJA, ms = 3, msw = 0, label = "política")
    Vf = hpi.v
    g2 = plot(1:length(vfi.historia), [maximum(abs.(v .- Vf)) for v in vfi.historia];
              yscale = :log10, color = AZUL, lw = 2, label = "función valor",
              xlabel = "paso", ylabel = "distancia al valor final", title = "Convergencia",
              legend = :topright)
    plot!(g2, 1:length(hpi.historia), [max(maximum(abs.(v .- Vf)), 1e-12) for v in hpi.historia];
          color = NARANJA, lw = 2, marker = :circle, ms = 4, msw = 0, label = "política")
    plot(g1, g2; layout = (1, 2), size = (800, 340))
end

# ╔═╡ 3b03433e-cf0a-11f1-be6f-8da7de2e7059
let
    (; vfi, hpi) = comparacion
    t_vfi = @elapsed iterar_valor(comparacion.R, βk)
    t_pi = @elapsed iterar_politica(comparacion.R, βk)
    md"""
    | | Función valor | Política |
    |---|---:|---:|
    | Pasos | $(length(vfi.historia)) | $(length(hpi.historia)) |
    | Segundos | $(round(t_vfi, sigdigits = 2)) | $(round(t_pi, sigdigits = 2)) |
    | Segundos por paso | $(round(t_vfi / length(vfi.historia), sigdigits = 2)) | $(round(t_pi / length(hpi.historia), sigdigits = 2)) |
    | ¿Misma política? | $(vfi.σ == hpi.σ ? "sí" : "no, en $(count(vfi.σ .!= hpi.σ)) puntos") | |

    1. **Compara** los pasos y el tiempo por paso: ¿cuál método da pasos más
       caros? ¿Cuál gana en total?
    2. **Sube** ``\beta`` a 0.99: ¿cuánto crecen los pasos de cada método?
       Compara con la tabla de la sección 2.3 de las notas.
    3. **Observa** la política: ¿coincide con la regla exacta de la sección
       4 de las notas? ¿Dónde cruza la recta ``k' = k``?
    """
end

# ╔═╡ 3b034438-cf0a-11f1-9d1a-e7420d72ac9b
"Por iteración de la función valor: puntos donde la política difiere de la final y distancia al valor final."
function politica_contra_valor(R, β, final)
    v = zeros(size(R, 1))
    cambios, distancias = Int[], Float64[]
    for _ in 1:1000
        v, σ = operador_bellman(v, R, β)
        push!(cambios, count(σ .!= final.σ))
        push!(distancias, maximum(abs.(v .- final.v)))
        distancias[end] < 1e-6 && break
    end
    cambios, distancias
end

# ╔═╡ 3b03435c-cf0a-11f1-baef-01b6574ccc5e
let
    cambios, distancias = politica_contra_valor(comparacion.R, βk, comparacion.hpi)
    g1 = plot(1:length(cambios), cambios; color = NARANJA, lw = 2, xlabel = "iteración n",
              ylabel = "puntos", title = "Puntos donde la política aún cambia")
    g2 = plot(1:length(distancias), distancias; yscale = :log10, color = AZUL, lw = 2,
              xlabel = "iteración n", title = "Distancia al valor final")
    plot(g1, g2; layout = (1, 2), size = (800, 320))
end

# ╔═╡ 3b034442-cf0a-11f1-811c-896d8a15047d
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

# ╔═╡ 3b034378-cf0a-11f1-8888-fb72ec530e2c
verificar(() -> [valor_torta(100.0, 0.9), valor_torta(1.0, 0.95), valor_torta(50.0, 0.8)],
          valor_torta_ref.([100.0, 1.0, 50.0], [0.9, 0.95, 0.8]);
          pista = md"``a + \ln x/(1 - \beta)``, con ``a = \ln(1 - \beta)/(1 - \beta) + \beta\ln\beta/(1 - \beta)^2``.")

# ╔═╡ 3b0343a2-cf0a-11f1-802d-6378c579a8c4
verificar(() -> [iteraciones_necesarias(0.9, 1e-6), iteraciones_necesarias(0.95, 1e-6),
                 iteraciones_necesarias(0.99, 1e-6), iteraciones_necesarias(0.5, 0.25)],
          [132, 270, 1375, 2];
          pista = md"``n \ge \ln(\text{reduccion})/\ln\beta``; redondea hacia arriba con `ceil(Int, ...)`.")

# ╔═╡ 3b0343b6-cf0a-11f1-9492-d38574436532
verificar(() -> [valor_fraccion(100.0, 0.2, 0.9), valor_fraccion(100.0, 0.1, 0.9), valor_fraccion(10.0, 0.5, 0.95)],
          valor_fraccion_ref.([100.0, 100.0, 10.0], [0.2, 0.1, 0.5], [0.9, 0.9, 0.95]);
          pista = md"Con ``b = 1/(1 - \beta)``, la constante cumple ``a = \ln\gamma + \beta a + \beta b\ln(1 - \gamma)``.")

# ╔═╡ 3b0343d4-cf0a-11f1-808d-4773084187e2
verificar(() -> evaluar_aproximada(comparacion.hpi.σ, comparacion.R, 0.9, 400),
          evaluar_politica(comparacion.hpi.σ, comparacion.R, 0.9); rtol = 1e-6,
          pista = md"Dentro de un ciclo de `m` vueltas: `v = [R[i, σ[i]] + β * v[σ[i]] for i in eachindex(σ)]`.")

# ╔═╡ Cell order:
# ╟─3b034258-cf0a-11f1-be1a-ab35089641d3
# ╟─3b0342b4-cf0a-11f1-acaf-f968feb4ade9
# ╟─3b0342c6-cf0a-11f1-a7a7-8bbd3dc019b5
# ╠═3b0342d0-cf0a-11f1-a030-cd287a7c4d67
# ╟─3b0342da-cf0a-11f1-8101-d544fad736d7
# ╠═3b0342ee-cf0a-11f1-9d79-f18ac9e4dd85
# ╟─3b0342f8-cf0a-11f1-aae3-d94184f434d7
# ╟─3b034302-cf0a-11f1-a79e-bd5baf2e7b23
# ╟─3b03430c-cf0a-11f1-86c5-03e7c45c2824
# ╠═3b034318-cf0a-11f1-b094-69d23cdd6d3d
# ╟─3b034320-cf0a-11f1-80e2-bb025c8283e7
# ╠═3b03432a-cf0a-11f1-8d90-71c0dbd35127
# ╟─3b034334-cf0a-11f1-9735-1ff1c27eb03a
# ╟─3b03433e-cf0a-11f1-be6f-8da7de2e7059
# ╟─3b034352-cf0a-11f1-a34d-9fee1b599234
# ╟─3b03435c-cf0a-11f1-baef-01b6574ccc5e
# ╟─3b034366-cf0a-11f1-a756-43b82d3cfe47
# ╠═3b034370-cf0a-11f1-9ab0-0f4fa7817cdf
# ╟─3b034378-cf0a-11f1-8888-fb72ec530e2c
# ╟─3b034384-cf0a-11f1-a77e-132144e3a9f6
# ╠═3b034398-cf0a-11f1-846d-c9a2811724eb
# ╟─3b0343a2-cf0a-11f1-802d-6378c579a8c4
# ╟─3b0343a2-cf0a-11f1-afff-d1ec60416713
# ╠═3b0343aa-cf0a-11f1-9771-4f9f4aba8a41
# ╟─3b0343b6-cf0a-11f1-9492-d38574436532
# ╟─3b0343c0-cf0a-11f1-a4b1-87ed5132615a
# ╠═3b0343ca-cf0a-11f1-8409-5728507c8109
# ╟─3b0343d4-cf0a-11f1-808d-4773084187e2
# ╟─3b0343d4-cf0a-11f1-89a3-49e82e075109
# ╟─3b0343de-cf0a-11f1-8b70-b5643a23f4c2
# ╠═3b0343e8-cf0a-11f1-a4f7-8395ca21206e
# ╠═3b0343fc-cf0a-11f1-a1d6-8b217c2e673a
# ╠═3b034406-cf0a-11f1-805f-4b0fbfbb5e0a
# ╠═3b034406-cf0a-11f1-9563-39f82a5f44cf
# ╠═3b034410-cf0a-11f1-b2ae-55cd58656e69
# ╠═3b03441c-cf0a-11f1-add4-b14260ed57d7
# ╠═3b034424-cf0a-11f1-aee6-7fe874a09b24
# ╠═3b03442e-cf0a-11f1-912e-0faa1d11f012
# ╠═3b034438-cf0a-11f1-9d1a-e7420d72ac9b
# ╠═3b034442-cf0a-11f1-811c-896d8a15047d
