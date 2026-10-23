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

# ╔═╡ 4974ecb6-ce91-11f1-891e-c31cf67aa3b1
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

# ╔═╡ 4974ebda-ce91-11f1-b3ea-33741759067e
md"""
# Sesión 13: Varias variables de estado y de control

**Pregunta de la unidad.** ¿Conviene invertir primero donde se ahorra más o
donde se produce más?

**Pregunta de la sesión.** Una región reparte su producto entre consumir e
invertir. ¿Hasta cuándo conviene invertir?

**Objetivos de la sesión**
1. Resolver un problema con Hamiltoniano lineal en el control: función de
   cambio, solución bang-bang y tiempo de cambio.
2. Resolver hacia atrás desde la transversalidad.
3. Plantear un problema con varios estados y leer sus precios sombra
   encadenados.
4. Verificar que un candidato es óptimo con las condiciones de Mangasarian
   y de Arrow.

**Cómo usar este cuaderno.** Pluto es reactivo: al mover un deslizador, todo
lo que depende de él se recalcula. Las secciones marcadas **[Avanzado]** son
opcionales. Las demostraciones están en las notas formales,
`Class_notes/s13_varias_variables.md`.

**Cómo abrirlo.** Desde la raíz del repositorio:
`julia --project=Code -e 'using Pluto; Pluto.run()'` y abrir
`Code/s13_varias_variables.jl`.

**Repaso recomendado** (en `Class_notes/repaso/`): C.B2 (máximos), C.I2
(concavidad) y L.I4 (formas cuadráticas y definitud). Para los puntos
[Avanzado]: C.A4 (concavidad y maximización parcial).
"""

# ╔═╡ 4974ec0c-ce91-11f1-9dab-cf2c45489ae5
TableOfContents(title = "Contenido")

# ╔═╡ 4974ec16-ce91-11f1-8803-151c81e03da0
md"""
## 1. Invertir o consumir

Una región produce ``Y = vK``, invierte una fracción ``u \in [0, 1]`` y
consume el resto. El consumo tiene utilidad lineal:

```math
\max_{u \in [0, 1]} \int_0^T e^{-\rho t}(1 - u)\, vK\, dt,
\qquad K' = uvK, \quad K(0) = 1, \quad K(T) \text{ libre}.
```

El Hamiltoniano a valor presente, ``H_c = vK + vK(\mu - 1)\,u``, es lineal
en ``u``. La **función de cambio** es ``\sigma = vK(\mu - 1)``: se invierte
todo si el precio sombra del capital, ``\mu``, es mayor que 1, y se consume
todo si es menor. El cuaderno resuelve hacia atrás desde ``\mu(T) = 0``.

Productividad del capital, ``v``: $(@bind v Slider(0.02:0.01:0.40, default = 0.25, show_value = true))

Horizonte, ``T``: $(@bind T Slider(5:1:40, default = 20, show_value = true))

Tasa de descuento, ``\rho``: $(@bind ρ Slider(0.0:0.01:0.10, default = 0.0, show_value = true))
"""

# ╔═╡ 4974ec34-ce91-11f1-9a2e-512f837f1f2d
md"""
## 2. ¿Y si se invierte siempre la misma fracción?

Una regla sencilla sería invertir siempre una fracción fija ``u``. La gráfica
compara el bienestar de cada tasa fija con el del bang-bang (línea
horizontal).
"""

# ╔═╡ 4974ec3e-ce91-11f1-80a6-9f55f344a3d6
md"""
## 3. Varios estados: infraestructura y capital privado

Un gobierno regional construye infraestructura ``G`` con un gasto ``u`` que
cuesta ``u^2/2``; la infraestructura atrae capital privado ``K``, que
produce:

```math
\max_u \int_0^T \Big(K - \frac{u^2}{2}\Big)\, dt, \qquad G' = u, \qquad K' = aG.
```

Hay dos estados y dos coestados. ``\lambda_K' = -1`` da
``\lambda_K = T - t``; ``\lambda_G' = -a\lambda_K`` da
``\lambda_G = a(T - t)^2/2``, y el gasto óptimo es ``u = \lambda_G``
(notas, sección 1.2).

Cuánto capital privado atrae la infraestructura, ``a``: $(@bind a Slider(0.05:0.05:1.0, default = 0.2, show_value = true))
"""

# ╔═╡ 4974ec48-ce91-11f1-bf9c-a997870ae819
md"""
El precio de la infraestructura sale **sólo** del capital privado que
atrae: ``\lambda_G' = -a\lambda_K``. Por eso el gasto se concentra al
principio, cuando queda tiempo para que la infraestructura atraiga capital
y el capital produzca. Los precios sombra se encadenan: el de ``G`` depende
del de ``K``. Sube ``a``: el gasto sube en todo el horizonte, pero su forma
no cambia.
"""

# ╔═╡ 4974ec52-ce91-11f1-8ac3-57de9e177123
md"""
## 4. ¿Es de verdad el óptimo? Una prueba numérica

En la práctica de la sección 1, ``f = uvK`` no es cóncava en ``(K, u)``:
Mangasarian no aplica. Arrow sí, porque el Hamiltoniano maximizado,
``H^0 = vK\max\{1, \mu\}``, es lineal en ``K`` (notas, sección 4.3). Una
prueba numérica con dos familias de competidores: 400 controles al azar,
constantes por tramos de un año con valores en ``[0, 1]`` (azul), y 400
controles bang-bang con un tiempo de cambio al azar (gris), que se parecen
mucho más al óptimo.
"""

# ╔═╡ 4974ec5e-ce91-11f1-8944-89facb67652f
md"""
La línea naranja es el bienestar del bang-bang óptimo. Ningún control la
supera, como garantiza el teorema de Arrow. Los bang-bang con cambio al azar
(gris) se acercan, y los mejores son los que cambian cerca de ``t^\ast``.
No es una demostración (podría haber un control mejor que no se generó),
pero es una buena verificación de que el candidato no tiene un error.
"""

# ╔═╡ 4974ec66-ce91-11f1-8cd2-f928381c6a02
md"""
## 5. [Avanzado] Un arco singular

Sethi (ejemplo 2.5): ``\max \int_0^2 -\tfrac{1}{2}x^2\, dt`` con ``x' = u``,
``x(0) = 1`` y ``u \in [-1, 1]``. La función de cambio es ``\sigma = \lambda``,
con ``\lambda' = x`` y ``\lambda(2) = 0``. Se baja ``x`` lo más rápido posible
(``u = -1``) hasta que llega a cero en ``t = 1``. Después, ``\sigma = 0`` en
todo un intervalo: la condición "``u`` maximiza ``H``" no decide, y mantener
``\sigma' = \lambda' = x = 0`` exige ``u = 0``, un control **interior**.
"""

# ╔═╡ 4974ec70-ce91-11f1-9e40-b3286c3eb68d
md"""
## Resumen

| Herramienta | Qué dice | En este cuaderno |
|---|---|---|
| Función de cambio | ``\sigma = \partial H/\partial u``; su signo decide el extremo | ``vK(\mu - 1)``, sección 1 |
| Bang-bang | Todo o nada; el control salta cuando ``\sigma`` cambia de signo | Sección 1 |
| Resolver hacia atrás | La transversalidad fija la última fase | ``\mu(T) = 0`` |
| Plazo de recuperación | Se invierte hasta que faltan ``1/v`` años | Tabla de la sección 1 |
| Varios estados | Un coestado por estado; precios encadenados | Sección 3 |
| Arrow | ``H^0`` cóncavo en el estado basta | Sección 4 |
| Arco singular | ``\sigma = 0`` en un intervalo; control interior | Sección 5 |

## Ejercicios

### Completa el código

**1.** Escribe `tiempo_cambio(v, T)`, el tiempo de cambio de la práctica sin
descuento. No olvides el caso en que nunca conviene invertir.
"""

# ╔═╡ 4974ec70-ce91-11f1-83a1-f97633bb388a
tiempo_cambio(v, T) = missing  # reemplaza missing

# ╔═╡ 4974ec84-ce91-11f1-81f8-19c3af83e0e2
md"""
**2.** Escribe `tiempo_cambio_desc(v, T, ρ)`, el tiempo de cambio con
descuento ``\rho > 0`` (notas, sección 3.3).
"""

# ╔═╡ 4974ec84-ce91-11f1-9ce8-6757a6690b47
tiempo_cambio_desc(v, T, ρ) = missing  # reemplaza missing

# ╔═╡ 4974ec90-ce91-11f1-8f4d-bb4aee9b8e1d
md"""
**3.** Escribe `consumo_tasa_fija(u, v, T)`, el consumo total
``\int_0^T (1 - u)vK\, dt`` cuando se invierte siempre la fracción ``u``,
sin descuento y con ``K(0) = 1``. Supón ``u > 0``.
"""

# ╔═╡ 4974ec90-ce91-11f1-a50b-a98b446c36ee
consumo_tasa_fija(u, v, T) = missing  # reemplaza missing

# ╔═╡ 4974ec98-ce91-11f1-a22d-ed42ef86404e
md"""
**4. [Avanzado]** Escribe `gasto_infra(t, a, T)`, el gasto óptimo en
infraestructura de la sección 3.
"""

# ╔═╡ 4974eca2-ce91-11f1-90e8-8b5ec2bbac02
gasto_infra(t, a, T) = missing  # reemplaza missing

# ╔═╡ 4974ecac-ce91-11f1-bec1-a1882b85d399
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

# ╔═╡ 4974ecac-ce91-11f1-b2df-fdd28d75449e
md"""
---
## Apéndice: paquetes y funciones auxiliares

Estas celdas definen herramientas que usa el cuaderno. No es necesario
leerlas para seguir la sesión.
"""

# ╔═╡ 4974ecb6-ce91-11f1-87dc-a3e348012ee0
begin
    const AZUL    = "#2a78d6"   # capital, valores
    const NARANJA = "#eb6834"   # precio sombra, óptimo
    const GRIS    = "#52514e"   # referencias
    const TINTA   = "#0b0b0b"   # control
end;

# ╔═╡ 4974ec66-ce91-11f1-9ba8-e71ee8f03870
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

# ╔═╡ 4974ecb6-ce91-11f1-b7a9-ab8535f9764a
"Integral de f en [0, T] con la regla de Simpson y n tramos (n par)."
function integral(f, T; n = 2000)
    h = T / n
    h / 3 * (f(0.0) + f(T) + 4sum(f((2i - 1) * h) for i in 1:n ÷ 2) + 2sum(f(2i * h) for i in 1:n ÷ 2 - 1))
end

# ╔═╡ 4974ecc2-ce91-11f1-b964-fb4b9e0124b1
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

# ╔═╡ 4974ec16-ce91-11f1-9cea-f1caae8f730a
region = invertir_o_consumir(v, float(T), ρ)

# ╔═╡ 4974ec20-ce91-11f1-90c9-b3d881bc1a9c
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

# ╔═╡ 4974ec2a-ce91-11f1-87f3-d56737754cfe
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

    Baja ``v``: la fase de inversión se acorta. Con ``v < 1/T`` desaparece.
    Sube ``\rho``: el cambio se adelanta, porque el consumo futuro vale
    menos.
    """
end

# ╔═╡ 4974ecc2-ce91-11f1-adcd-35bb79efba63
"Bienestar de invertir siempre la fracción u (con K(0) = 1)."
function valor_tasa_fija(u, r)
    g = u * r.v - r.ρ
    abs(g) < 1e-12 ? (1 - u) * r.v * r.T : (1 - u) * r.v * (exp(g * r.T) - 1) / g
end

# ╔═╡ 4974ec34-ce91-11f1-ab5d-85d09ba7860c
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

# ╔═╡ 4974ec3e-ce91-11f1-b787-c191fd95bc2a
let
    r = region
    us = range(0, 1, length = 201)
    Ws = [valor_tasa_fija(u, r) for u in us]
    i = argmax(Ws)
    md"""
    La mejor tasa fija es ``u = `` $(round(us[i], digits = 2)) y da
    $(round(Ws[i], digits = 2)), contra $(round(r.valor, digits = 2)) del
    bang-bang. Con utilidad lineal, al consumidor no le importa cuándo
    consume: conviene concentrar toda la inversión al principio, cuando
    todavía queda mucho tiempo para que rinda, y todo el consumo al final.
    Con utilidad cóncava (sesiones 10 y 12) el óptimo sería más suave.
    """
end

# ╔═╡ 4974ecca-ce91-11f1-872b-07dd8b501b57
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

# ╔═╡ 4974ecca-ce91-11f1-92bb-9df600b136f7
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

# ╔═╡ 4974ec5e-ce91-11f1-a005-759d8d6b413a
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

# ╔═╡ 4974ecd4-ce91-11f1-a9cb-635868a3225d
"Capital privado del ejemplo de infraestructura con G(0) = K(0) = 0: K(t) = a ∫₀ᵗ G."
infra_K(t, a, T) = a^2 * (T^3 * t / 6 + ((T - t)^4 - T^4) / 24)

# ╔═╡ 4974ec48-ce91-11f1-9bcc-51bf8bc3fa23
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

# ╔═╡ 4974ecd4-ce91-11f1-aff5-dfe60d5959d8
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

# ╔═╡ 4974ec7a-ce91-11f1-b67b-6d17a1567f75
verificar(() -> [tiempo_cambio(0.25, 20), tiempo_cambio(0.1, 20), tiempo_cambio(0.04, 20)], [16.0, 10.0, 0.0];
          pista = md"Se invierte hasta que faltan ``1/v`` años, pero ``t^\ast`` no puede ser negativo: `max(0.0, T - 1 / v)`.")

# ╔═╡ 4974ec90-ce91-11f1-96fe-03c07cc30e18
verificar(() -> [tiempo_cambio_desc(0.25, 20, 0.03), tiempo_cambio_desc(0.1, 20, 0.03), tiempo_cambio_desc(0.02, 20, 0.03)],
          [invertir_o_consumir(0.25, 20.0, 0.03).tc, invertir_o_consumir(0.1, 20.0, 0.03).tc, 0.0];
          pista = md"Si `v <= ρ`, nunca se invierte. Si no, `max(0.0, T + log(1 - ρ / v) / ρ)`: el logaritmo es negativo, así que se resta.")

# ╔═╡ 4974ec98-ce91-11f1-b452-afd026bc8ce7
verificar(() -> [consumo_tasa_fija(0.2, 0.25, 20), consumo_tasa_fija(0.73, 0.25, 20), consumo_tasa_fija(0.5, 0.1, 10)],
          [valor_tasa_fija(u, invertir_o_consumir(v, float(T), 0.0)) for (u, v, T) in ((0.2, 0.25, 20), (0.73, 0.25, 20), (0.5, 0.1, 10))];
          rtol = 1e-6,
          pista = md"Con ``K(t) = e^{uvt}``: ``\int_0^T (1 - u)v e^{uvt}\, dt = (1 - u)(e^{uvT} - 1)/u``.")

# ╔═╡ 4974eca2-ce91-11f1-bd2a-09e0f4fdc940
verificar(() -> [gasto_infra(0.0, 0.2, 10.0), gasto_infra(5.0, 0.2, 10.0), gasto_infra(10.0, 0.5, 10.0)],
          [10.0, 2.5, 0.0];
          pista = md"``u = \lambda_G`` y ``\lambda_G(t) = a(T - t)^2/2``: `a * (T - t)^2 / 2`.")

# ╔═╡ Cell order:
# ╟─4974ebda-ce91-11f1-b3ea-33741759067e
# ╟─4974ec0c-ce91-11f1-9dab-cf2c45489ae5
# ╟─4974ec16-ce91-11f1-8803-151c81e03da0
# ╠═4974ec16-ce91-11f1-9cea-f1caae8f730a
# ╟─4974ec20-ce91-11f1-90c9-b3d881bc1a9c
# ╟─4974ec2a-ce91-11f1-87f3-d56737754cfe
# ╟─4974ec34-ce91-11f1-9a2e-512f837f1f2d
# ╟─4974ec34-ce91-11f1-ab5d-85d09ba7860c
# ╟─4974ec3e-ce91-11f1-b787-c191fd95bc2a
# ╟─4974ec3e-ce91-11f1-80a6-9f55f344a3d6
# ╟─4974ec48-ce91-11f1-9bcc-51bf8bc3fa23
# ╟─4974ec48-ce91-11f1-bf9c-a997870ae819
# ╟─4974ec52-ce91-11f1-8ac3-57de9e177123
# ╟─4974ec5e-ce91-11f1-a005-759d8d6b413a
# ╟─4974ec5e-ce91-11f1-8944-89facb67652f
# ╟─4974ec66-ce91-11f1-8cd2-f928381c6a02
# ╟─4974ec66-ce91-11f1-9ba8-e71ee8f03870
# ╟─4974ec70-ce91-11f1-9e40-b3286c3eb68d
# ╠═4974ec70-ce91-11f1-83a1-f97633bb388a
# ╟─4974ec7a-ce91-11f1-b67b-6d17a1567f75
# ╟─4974ec84-ce91-11f1-81f8-19c3af83e0e2
# ╠═4974ec84-ce91-11f1-9ce8-6757a6690b47
# ╟─4974ec90-ce91-11f1-96fe-03c07cc30e18
# ╟─4974ec90-ce91-11f1-8f4d-bb4aee9b8e1d
# ╠═4974ec90-ce91-11f1-a50b-a98b446c36ee
# ╟─4974ec98-ce91-11f1-b452-afd026bc8ce7
# ╟─4974ec98-ce91-11f1-a22d-ed42ef86404e
# ╠═4974eca2-ce91-11f1-90e8-8b5ec2bbac02
# ╟─4974eca2-ce91-11f1-bd2a-09e0f4fdc940
# ╟─4974ecac-ce91-11f1-bec1-a1882b85d399
# ╟─4974ecac-ce91-11f1-b2df-fdd28d75449e
# ╠═4974ecb6-ce91-11f1-891e-c31cf67aa3b1
# ╠═4974ecb6-ce91-11f1-87dc-a3e348012ee0
# ╠═4974ecb6-ce91-11f1-b7a9-ab8535f9764a
# ╠═4974ecc2-ce91-11f1-b964-fb4b9e0124b1
# ╠═4974ecc2-ce91-11f1-adcd-35bb79efba63
# ╠═4974ecca-ce91-11f1-872b-07dd8b501b57
# ╠═4974ecca-ce91-11f1-92bb-9df600b136f7
# ╠═4974ecd4-ce91-11f1-a9cb-635868a3225d
# ╠═4974ecd4-ce91-11f1-aff5-dfe60d5959d8
