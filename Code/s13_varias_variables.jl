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

# ╔═╡ ad28c6ba-cf06-11f1-91c2-4fb315715d2d
begin
    # Usa el entorno del curso (Code/Project.toml) en lugar del gestor de
    # paquetes propio de Pluto: un solo entorno para todo el repositorio.
    import Pkg
    Pkg.activate(@__DIR__)
    Pkg.instantiate()
    using PlutoUI, Plots, Random, Markdown
    gr()
    default(size = (720, 320), legend = false, grid = :y, gridalpha = 0.15,
            framestyle = :axes, titlefontsize = 11, guidefontsize = 9,
            tickfontsize = 8, legendfontsize = 8, foreground_color_legend = nothing,
            background_color_legend = nothing, margin = 3Plots.mm)
end

# ╔═╡ ad28c56e-cf06-11f1-9184-ddb1867e0db8
md"""
# Sesión 13: Varias variables de estado y de control

**Pregunta de la unidad.** ¿Conviene invertir primero donde se ahorra más o
donde se produce más?

**Cómo usar este cuaderno.** La teoría está en las notas,
`Class_notes/s13_varias_variables.md`, y se desarrolla en el pizarrón; el
cuaderno sirve para mover los parámetros, ver qué pasa y comprobar
numéricamente. En clase se proyectan las secciones 1 a 4; la sección 5 y los
ejercicios son para después. Pluto es reactivo: al mover un deslizador,
todo lo que depende de él se recalcula.

**Cómo abrirlo.** Desde la raíz del repositorio:
`julia --project=Code -e 'using Pluto; Pluto.run()'` y abrir
`Code/s13_varias_variables.jl`.
"""

# ╔═╡ ad28c5aa-cf06-11f1-ab86-41f9406fbd34
TableOfContents(title = "Contenido")

# ╔═╡ ad28c5b6-cf06-11f1-89c7-ab1549688251
md"""
## 1. Invertir o consumir

*En clase, minutos 40–55, después de la sección 3.2 de las notas.* La
práctica de la sección 3 de las notas, con ``K(0) = 1``: el precio sombra
del capital, la fracción invertida y el capital. El cuaderno resuelve hacia
atrás desde ``\mu(T) = 0``.

Productividad del capital, ``v``: $(@bind v Slider(0.02:0.01:0.40, default = 0.25, show_value = true))

Horizonte, ``T``: $(@bind T Slider(5:1:40, default = 20, show_value = true))

Tasa de descuento, ``\rho``: $(@bind ρ Slider(0.0:0.01:0.10, default = 0.0, show_value = true))
"""

# ╔═╡ ad28c5e4-cf06-11f1-a872-1ba8a799779e
md"""
## 2. ¿Y si se invierte siempre la misma fracción?

*En clase, minutos 40–55.* El bienestar de cada tasa fija de inversión
contra el del bang-bang (línea horizontal).
"""

# ╔═╡ ad28c5fa-cf06-11f1-9d31-b9b2288deb08
md"""
## 3. Varios estados: infraestructura y capital privado

*En clase, minutos 82–88, después de la sección 1.2 de las notas.* Los dos
coestados, el gasto en infraestructura y los dos estados, con ``T = 10``.

Cuánto capital privado atrae la infraestructura, ``a``: $(@bind a Slider(0.05:0.05:1.0, default = 0.2, show_value = true))
"""

# ╔═╡ ad28c60e-cf06-11f1-9dab-7b90ba6fcf73
md"""
**Observa** cómo cae ``\lambda_G`` hacia el final, más rápido que
``\lambda_K``. **Mueve** ``a``: ¿cambia el nivel del gasto, su forma o las
dos cosas?
"""

# ╔═╡ ad28c616-cf06-11f1-ac3d-a55cc4ee4539
md"""
## 4. ¿Es de verdad el óptimo? Una prueba numérica

*En clase, minutos 103–108, después de la sección 4.3 de las notas.* Dos
familias de competidores contra el bang-bang de la sección 1: 400 controles
al azar, constantes por tramos de un año (azul), y 400 bang-bang con un
tiempo de cambio al azar (gris).
"""

# ╔═╡ ad28c62c-cf06-11f1-b50a-dd739f808613
md"""
**Observa:** ¿algún competidor supera la línea naranja? ¿Cuáles se acercan
más? ¿Por qué esta prueba no sustituye al teorema de Arrow?
"""

# ╔═╡ ad28c62c-cf06-11f1-8082-cf6bad06f61e
md"""
## 5. [Avanzado] Un arco singular

*Fuera de clase* (notas, P.2). Sethi (ejemplo 2.5):
``\max \int_0^2 -\tfrac{1}{2}x^2\, dt`` con ``x' = u``,
``x(0) = 1`` y ``u \in [-1, 1]``. La función de cambio es ``\sigma = \lambda``,
con ``\lambda' = x`` y ``\lambda(2) = 0``. Se baja ``x`` lo más rápido posible
(``u = -1``) hasta que llega a cero en ``t = 1``. Después, ``\sigma = 0`` en
todo un intervalo: la condición "``u`` maximiza ``H``" no decide, y mantener
``\sigma' = \lambda' = x = 0`` exige ``u = 0``, un control **interior**.
"""

# ╔═╡ ad28c640-cf06-11f1-9410-e9469f9352a1
md"""
## Ejercicios

*Después de clase.* Los ejercicios con demostraciones están en las notas
(sección 7).

### Completa el código

**1.** Escribe `tiempo_cambio(v, T)`, el tiempo de cambio de la práctica sin
descuento. No olvides el caso en que nunca conviene invertir.
"""

# ╔═╡ ad28c648-cf06-11f1-9da0-e5138403ffed
tiempo_cambio(v, T) = missing  # reemplaza missing

# ╔═╡ ad28c668-cf06-11f1-8b41-55601e0bdbb5
md"""
**2.** Escribe `tiempo_cambio_desc(v, T, ρ)`, el tiempo de cambio con
descuento ``\rho > 0`` (notas, sección 3.3).
"""

# ╔═╡ ad28c668-cf06-11f1-b6e3-d7bd8e8aa85d
tiempo_cambio_desc(v, T, ρ) = missing  # reemplaza missing

# ╔═╡ ad28c67c-cf06-11f1-a903-bb7cabcd8c87
md"""
**3.** Escribe `consumo_tasa_fija(u, v, T)`, el consumo total
``\int_0^T (1 - u)vK\, dt`` cuando se invierte siempre la fracción ``u``,
sin descuento y con ``K(0) = 1``. Supón ``u > 0``.
"""

# ╔═╡ ad28c686-cf06-11f1-a7e6-8f5688ed3659
consumo_tasa_fija(u, v, T) = missing  # reemplaza missing

# ╔═╡ ad28c690-cf06-11f1-a451-07d400335150
md"""
**4. [Avanzado]** Escribe `gasto_infra(t, a, T)`, el gasto óptimo en
infraestructura de la sección 3.
"""

# ╔═╡ ad28c69a-cf06-11f1-a61c-f33033a718a1
gasto_infra(t, a, T) = missing  # reemplaza missing

# ╔═╡ ad28c6ae-cf06-11f1-b337-2959a17d2216
md"""
### Interpretación

5. ¿Por qué la solución óptima es invertir todo y después consumir todo?
   ¿Qué supuesto del modelo produce un resultado tan extremo?
6. Una región con ``K/Y = 10`` (``v = 0.1``) y otra con ``K/Y = 4``
   (``v = 0.25``) planean a 20 años. ¿Cuánto tiempo invierte cada una? ¿Qué
   sugiere esto para la sesión 14, si un gobierno pudiera elegir en cuál
   invertir?
7. Sube ``\rho``. ¿Por qué la impaciencia adelanta el momento de dejar de
   invertir?

### Tu tesis

8. ¿Hay en tu problema un control que entre de forma lineal y tenga
   límites? Si sí, ¿qué compara su función de cambio? ¿Qué condición
   suficiente revisarías?

### [Avanzado]

9. En la sección 5, ¿por qué no conviene seguir con ``u = -1`` después de
   ``t = 1``?
10. En la sección 4, ¿por qué una prueba con controles al azar no sustituye
    al teorema de Arrow?

## Para la próxima sesión

- **Sesión 14: Caso completo, inversión entre dos regiones.** El modelo de
  Rahman, Intriligator y Takayama: dos capitales, un reparto
  ``\theta \in [0, 1]`` y una función de cambio que compara los precios
  sombra de las dos regiones, calibrado con datos de México.
- Repaso: C.B2 (máximos), E.B2 (tasas de crecimiento con datos), D.I2
  (lineales de primer orden), N.I1 (bisección y Newton), N.I3
  (DifferentialEquations.jl), E.I3 (calibración) y N.I7 (datos en Julia).
  Para los puntos [Avanzado]: D.A3 (existencia y unicidad) y E.A2
  (sensibilidad de un modelo calibrado).
"""

# ╔═╡ ad28c6ba-cf06-11f1-b686-4b94584581f3
md"""
---
## Apéndice: paquetes y funciones auxiliares

Estas celdas definen herramientas que usa el cuaderno. No es necesario
leerlas para seguir la sesión.
"""

# ╔═╡ ad28c6c2-cf06-11f1-8509-0b5328111ff6
begin
    const AZUL    = "#2a78d6"   # capital, valores
    const NARANJA = "#eb6834"   # precio sombra, óptimo
    const GRIS    = "#52514e"   # referencias
    const TINTA   = "#0b0b0b"   # control
end;

# ╔═╡ ad28c636-cf06-11f1-8618-37e8a5e7c1ad
let
    ts = range(0, 2, length = 400)
    x(t) = t <= 1 ? 1 - t : 0.0
    λ(t) = t <= 1 ? -(1 - t)^2 / 2 : 0.0
    u(t) = t < 1 ? -1.0 : 0.0
    g1 = plot(ts, x.(ts); color = AZUL, lw = 2.5, xlabel = "t", ylabel = "x(t)", title = "Estado")
    g2 = plot(ts, λ.(ts); color = NARANJA, lw = 2.5, xlabel = "t", ylabel = "σ = λ(t)",
              title = "Función de cambio")
    hline!(g2, [0]; color = GRIS, lw = 0.5)
    g3 = plot(ts, u.(ts); color = TINTA, lw = 2.5, xlabel = "t", ylabel = "u(t)", title = "Control",
              ylims = (-1.2, 1.2), linetype = :steppost)
    foreach(g -> vline!(g, [1]; color = GRIS, ls = :dot, lw = 1), (g1, g2, g3))
    plot(g1, g2, g3; layout = (1, 3), size = (860, 290))
end

# ╔═╡ ad28c6cc-cf06-11f1-94b9-5bc65894ea08
"Integral de f en [0, T] con la regla de Simpson y n tramos (n par)."
function integral(f, T; n = 2000)
    h = T / n
    h / 3 * (f(0.0) + f(T) + 4sum(f((2i - 1) * h) for i in 1:n ÷ 2) + 2sum(f(2i * h) for i in 1:n ÷ 2 - 1))
end

# ╔═╡ ad28c6d6-cf06-11f1-ab31-e9f40153f0fa
"""
Solución de invertir o consumir con K(0) = 1: tiempo de cambio tc, precio
sombra en valor corriente μ(t), control u(t), capital K(t) y bienestar.
"""
function invertir_o_consumir(v, T, ρ)
    # Años de consumo al final: 1/v sin descuento; -ln(1 - ρ/v)/ρ con descuento
    plazo = v <= ρ ? Inf : (ρ == 0 ? 1 / v : -log(1 - ρ / v) / ρ)
    tc = max(0.0, T - plazo)
    # Fase final (u = 0): μ' = ρμ - v con μ(T) = 0; fase inicial (u = 1): μ' = (ρ - v)μ con μ(tc) = 1
    μfin(t) = ρ == 0 ? v * (T - t) : v / ρ * (1 - exp(-ρ * (T - t)))
    μ(t) = t >= tc ? μfin(t) : exp((v - ρ) * (tc - t))
    u(t) = t < tc ? 1.0 : 0.0
    K(t) = exp(v * min(t, tc))
    valor = integral(t -> exp(-ρ * t) * (1 - u(t)) * v * K(t), T; n = 4000)
    (; v, T, ρ, tc, μ, u, K, valor)
end

# ╔═╡ ad28c5c8-cf06-11f1-b1d7-d1a4cbea5c59
region = invertir_o_consumir(v, float(T), ρ)

# ╔═╡ ad28c5d2-cf06-11f1-81a0-f50de033d1a3
let
    r = region
    ts = range(0, r.T, length = 600)
    g1 = plot(ts, r.μ.(ts); color = NARANJA, lw = 2.5, xlabel = "años", ylabel = "μ(t)",
              title = "Precio sombra del capital")
    hline!(g1, [1]; color = GRIS, ls = :dot, lw = 1)
    g2 = plot(ts, r.u.(ts); color = TINTA, lw = 2.5, xlabel = "años", ylabel = "u(t)",
              title = "Fracción invertida", ylims = (-0.1, 1.1), linetype = :steppost)
    g3 = plot(ts, r.K.(ts); color = AZUL, lw = 2.5, xlabel = "años", ylabel = "K(t)",
              title = "Capital")
    plot!(g3, ts, (1 .- r.u.(ts)) .* r.v .* r.K.(ts); color = NARANJA, lw = 1.5, ls = :dash)
    foreach(g -> vline!(g, [r.tc]; color = GRIS, ls = :dot, lw = 1), (g1, g2, g3))
    plot(g1, g2, g3; layout = (1, 3), size = (860, 300))
end

# ╔═╡ ad28c5dc-cf06-11f1-8fba-433afe41df60
let
    r = region
    rd(x) = round(x, digits = 2)
    texto = r.tc == 0 ? md"**Nunca conviene invertir**: el plazo de recuperación es más largo que lo que queda del horizonte (o ``v \le \rho``). La región consume todo lo que produce desde el principio." :
        md"Se invierte todo hasta ``t^\ast``, cuando el precio sombra del capital cae a 1, y después se consume todo (la línea punteada de la derecha es el consumo). Con ``\rho = 0``, ``t^\ast = T - 1/v``: se deja de invertir cuando faltan ``1/v`` años, el **plazo de recuperación** de una unidad de capital."
    md"""
    | | Valor |
    |:---|---:|
    | Plazo de recuperación, ``1/v`` | $(rd(1 / r.v)) años |
    | Tiempo de cambio, ``t^\ast`` | $(rd(r.tc)) |
    | Años de consumo al final, ``T - t^\ast`` | $(rd(r.T - r.tc)) |
    | Capital al final, ``K(T)`` | $(rd(r.K(r.T))) |
    | Bienestar óptimo | $(rd(r.valor)) |

    $texto

    1. Con ``v = 0.25`` y ``T = 20``, **comprueba** ``t^\ast = T - 1/v``.
       ¿Dónde cruza ``\mu`` la línea punteada?
    2. **Baja** ``v``: ¿qué pasa con la fase de inversión? ¿Con qué ``v``
       desaparece?
    3. **Sube** ``\rho``: ¿el cambio se adelanta o se atrasa?
    """
end

# ╔═╡ ad28c6e0-cf06-11f1-869c-ef309b82c058
"Bienestar de invertir siempre la fracción u (con K(0) = 1)."
function valor_tasa_fija(u, r)
    g = u * r.v - r.ρ
    abs(g) < 1e-12 ? (1 - u) * r.v * r.T : (1 - u) * r.v * (exp(g * r.T) - 1) / g
end

# ╔═╡ ad28c5f0-cf06-11f1-8ce1-c105df07c349
let
    r = region
    us = range(0, 1, length = 201)
    Ws = [valor_tasa_fija(u, r) for u in us]
    p = plot(us, Ws; color = AZUL, lw = 2.5, xlabel = "fracción invertida fija u",
             ylabel = "bienestar", title = "Tasa fija contra bang-bang", size = (640, 320))
    hline!(p, [r.valor]; color = NARANJA, lw = 2)
    i = argmax(Ws)
    scatter!(p, [us[i]], [Ws[i]]; color = TINTA, ms = 5, msw = 0)
    p
end

# ╔═╡ ad28c5f0-cf06-11f1-ab2c-579c766f78a7
let
    r = region
    us = range(0, 1, length = 201)
    Ws = [valor_tasa_fija(u, r) for u in us]
    i = argmax(Ws)
    md"""
    La mejor tasa fija es ``u = `` $(round(us[i], digits = 2)) y da
    $(round(Ws[i], digits = 2)), contra $(round(r.valor, digits = 2)) del
    bang-bang. **Mueve** ``v`` y ``T`` en la sección 1: ¿cuándo se parecen
    la mejor tasa fija y el bang-bang? ¿Qué supuesto del modelo hace que el
    óptimo sea tan extremo?
    """
end

# ╔═╡ ad28c6e0-cf06-11f1-ab76-ed6d62780710
"""
Bienestar de n controles al azar, constantes en tramos de un año (el
último tramo puede ser más corto); el capital se integra exactamente en
cada tramo.
"""
function valores_al_azar(r; n = 400, semilla = 13)
    rng = MersenneTwister(semilla)
    cortes = collect(0.0:1.0:r.T)
    cortes[end] < r.T && push!(cortes, r.T)
    map(1:n) do _
        us = rand(rng, length(cortes) - 1)
        K, W = 1.0, 0.0
        for (i, u) in enumerate(us)
            a, b = cortes[i], cortes[i + 1]
            # En el tramo, K(t) = K(a) e^{uv(t - a)} y el consumo es (1 - u) v K(t)
            W += integral(t -> exp(-r.ρ * (a + t)) * (1 - u) * r.v * K * exp(u * r.v * t), b - a; n = 20)
            K *= exp(u * r.v * (b - a))
        end
        W
    end
end

# ╔═╡ ad28c6ec-cf06-11f1-a87e-33c14f589bf4
"""
Bienestar de n controles bang-bang con un tiempo de cambio al azar en
[0, T]: se invierte todo antes del cambio y se consume todo después.
"""
function valores_cambio_al_azar(r; n = 400, semilla = 31)
    rng = MersenneTwister(semilla)
    map(1:n) do _
        tc = r.T * rand(rng)
        K = exp(r.v * tc)                 # capital al momento del cambio
        integral(t -> t < tc ? 0.0 : exp(-r.ρ * t) * r.v * K, r.T; n = 2000)
    end
end

# ╔═╡ ad28c622-cf06-11f1-bd65-ed61bed9def0
let
    r = region
    Ws = valores_al_azar(r; n = 400)
    Wb = valores_cambio_al_azar(r; n = 400)
    cortes = range(0, r.valor, length = 41)      # las barras terminan en el óptimo
    p = histogram(Ws; bins = cortes, color = AZUL, alpha = 0.6, xlabel = "bienestar",
                  ylabel = "controles al azar", title = "Ningún control al azar supera al bang-bang",
                  size = (640, 320), linecolor = :white)
    histogram!(p, Wb; bins = cortes, color = GRIS, alpha = 0.5, linecolor = :white)
    vline!(p, [r.valor]; color = NARANJA, lw = 2.5)
    p
end

# ╔═╡ ad28c6f4-cf06-11f1-97b2-49d7e1ca9dd2
"Capital privado del ejemplo de infraestructura con G(0) = K(0) = 0: K(t) = a ∫₀ᵗ G."
infra_K(t, a, T) = a^2 * (T^3 * t / 6 + ((T - t)^4 - T^4) / 24)

# ╔═╡ ad28c604-cf06-11f1-be15-034b564ea8b3
let
    Tf = 10.0
    ts = range(0, Tf, length = 300)
    λK = Tf .- ts
    λG = a .* (Tf .- ts) .^ 2 ./ 2
    G = a .* (Tf^3 .- (Tf .- ts) .^ 3) ./ 6          # ∫ u, con G(0) = 0
    K = infra_K.(ts, a, Tf)                          # ∫ aG, con K(0) = 0
    g1 = plot(ts, λK; color = AZUL, lw = 2.5, xlabel = "años", ylabel = "precio sombra",
              title = "Coestados (T = 10)", label = "λ_K: capital privado", legend = :topright)
    plot!(g1, ts, λG; color = NARANJA, lw = 2.5, label = "λ_G: infraestructura")
    g2 = plot(ts, λG; color = NARANJA, lw = 2.5, xlabel = "años", ylabel = "u(t)",
              title = "Gasto en infraestructura")
    g3 = plot(ts, G; color = NARANJA, lw = 2.5, xlabel = "años", ylabel = "stock",
              title = "Estados", label = "G", legend = :topleft)
    plot!(g3, ts, K; color = AZUL, lw = 2.5, label = "K")
    plot(g1, g2, g3; layout = (1, 3), size = (860, 300))
end

# ╔═╡ ad28c6fe-cf06-11f1-9e00-a533c8a6f8f7
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

# ╔═╡ ad28c654-cf06-11f1-aa69-b9c295ab06bf
verificar(() -> [tiempo_cambio(0.25, 20), tiempo_cambio(0.1, 20), tiempo_cambio(0.04, 20)], [16.0, 10.0, 0.0];
          pista = md"Se invierte hasta que faltan ``1/v`` años, pero ``t^\ast`` no puede ser negativo: `max(0.0, T - 1 / v)`.")

# ╔═╡ ad28c672-cf06-11f1-9cf6-036772f8f2ed
verificar(() -> [tiempo_cambio_desc(0.25, 20, 0.03), tiempo_cambio_desc(0.1, 20, 0.03), tiempo_cambio_desc(0.02, 20, 0.03)],
          [invertir_o_consumir(0.25, 20.0, 0.03).tc, invertir_o_consumir(0.1, 20.0, 0.03).tc, 0.0];
          pista = md"Si `v <= ρ`, nunca se invierte. Si no, `max(0.0, T + log(1 - ρ / v) / ρ)`: el logaritmo es negativo, así que se resta.")

# ╔═╡ ad28c690-cf06-11f1-b38c-615929e22b99
verificar(() -> [consumo_tasa_fija(0.2, 0.25, 20), consumo_tasa_fija(0.73, 0.25, 20), consumo_tasa_fija(0.5, 0.1, 10)],
          [valor_tasa_fija(u, invertir_o_consumir(v, float(T), 0.0)) for (u, v, T) in ((0.2, 0.25, 20), (0.73, 0.25, 20), (0.5, 0.1, 10))];
          rtol = 1e-6,
          pista = md"Con ``K(t) = e^{uvt}``: ``\int_0^T (1 - u)v e^{uvt}\, dt = (1 - u)(e^{uvT} - 1)/u``.")

# ╔═╡ ad28c6a4-cf06-11f1-aef6-0730dbd337ca
verificar(() -> [gasto_infra(0.0, 0.2, 10.0), gasto_infra(5.0, 0.2, 10.0), gasto_infra(10.0, 0.5, 10.0)],
          [10.0, 2.5, 0.0];
          pista = md"``u = \lambda_G`` y ``\lambda_G(t) = a(T - t)^2/2``: `a * (T - t)^2 / 2`.")

# ╔═╡ Cell order:
# ╟─ad28c56e-cf06-11f1-9184-ddb1867e0db8
# ╟─ad28c5aa-cf06-11f1-ab86-41f9406fbd34
# ╟─ad28c5b6-cf06-11f1-89c7-ab1549688251
# ╠═ad28c5c8-cf06-11f1-b1d7-d1a4cbea5c59
# ╟─ad28c5d2-cf06-11f1-81a0-f50de033d1a3
# ╟─ad28c5dc-cf06-11f1-8fba-433afe41df60
# ╟─ad28c5e4-cf06-11f1-a872-1ba8a799779e
# ╟─ad28c5f0-cf06-11f1-8ce1-c105df07c349
# ╟─ad28c5f0-cf06-11f1-ab2c-579c766f78a7
# ╟─ad28c5fa-cf06-11f1-9d31-b9b2288deb08
# ╟─ad28c604-cf06-11f1-be15-034b564ea8b3
# ╟─ad28c60e-cf06-11f1-9dab-7b90ba6fcf73
# ╟─ad28c616-cf06-11f1-ac3d-a55cc4ee4539
# ╟─ad28c622-cf06-11f1-bd65-ed61bed9def0
# ╟─ad28c62c-cf06-11f1-b50a-dd739f808613
# ╟─ad28c62c-cf06-11f1-8082-cf6bad06f61e
# ╟─ad28c636-cf06-11f1-8618-37e8a5e7c1ad
# ╟─ad28c640-cf06-11f1-9410-e9469f9352a1
# ╠═ad28c648-cf06-11f1-9da0-e5138403ffed
# ╟─ad28c654-cf06-11f1-aa69-b9c295ab06bf
# ╟─ad28c668-cf06-11f1-8b41-55601e0bdbb5
# ╠═ad28c668-cf06-11f1-b6e3-d7bd8e8aa85d
# ╟─ad28c672-cf06-11f1-9cf6-036772f8f2ed
# ╟─ad28c67c-cf06-11f1-a903-bb7cabcd8c87
# ╠═ad28c686-cf06-11f1-a7e6-8f5688ed3659
# ╟─ad28c690-cf06-11f1-b38c-615929e22b99
# ╟─ad28c690-cf06-11f1-a451-07d400335150
# ╠═ad28c69a-cf06-11f1-a61c-f33033a718a1
# ╟─ad28c6a4-cf06-11f1-aef6-0730dbd337ca
# ╟─ad28c6ae-cf06-11f1-b337-2959a17d2216
# ╟─ad28c6ba-cf06-11f1-b686-4b94584581f3
# ╠═ad28c6ba-cf06-11f1-91c2-4fb315715d2d
# ╠═ad28c6c2-cf06-11f1-8509-0b5328111ff6
# ╠═ad28c6cc-cf06-11f1-94b9-5bc65894ea08
# ╠═ad28c6d6-cf06-11f1-ab31-e9f40153f0fa
# ╠═ad28c6e0-cf06-11f1-869c-ef309b82c058
# ╠═ad28c6e0-cf06-11f1-ab76-ed6d62780710
# ╠═ad28c6ec-cf06-11f1-a87e-33c14f589bf4
# ╠═ad28c6f4-cf06-11f1-97b2-49d7e1ca9dd2
# ╠═ad28c6fe-cf06-11f1-9e00-a533c8a6f8f7
