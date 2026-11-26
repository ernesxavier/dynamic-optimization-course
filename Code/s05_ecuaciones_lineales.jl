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

# ╔═╡ e2dcd26e-cf03-11f1-9cfe-bddfdcfa40f4
begin
    # Usa el entorno del curso (Code/Project.toml) en lugar del gestor de
    # paquetes propio de Pluto: un solo entorno para todo el repositorio.
    import Pkg
    Pkg.activate(@__DIR__)
    Pkg.instantiate()
    using PlutoUI, Plots, CSV, DataFrames, Statistics, Random, Markdown
    gr()
    default(size = (720, 320), legend = false, grid = :y, gridalpha = 0.15,
            framestyle = :axes, titlefontsize = 11, guidefontsize = 9,
            tickfontsize = 8, legendfontsize = 8, foreground_color_legend = nothing,
            background_color_legend = nothing, margin = 3Plots.mm)
end

# ╔═╡ e2dcd0ae-cf03-11f1-a2cc-556b9871b55c
md"""
# Sesión 5: Ecuaciones diferenciales lineales de primer orden

**Pregunta de la unidad.** ¿Convergen los estados de México? ¿A qué
velocidad?

**Cómo usar este cuaderno.** En esta sesión **la clase sigue el cuaderno**:
aquí se exploran los datos de las 32 entidades y se estima la convergencia.
El pizarrón se usa para dos derivaciones, la de la ecuación lineal y la del
paso del modelo a la regresión, que están completas en las notas,
`Class_notes/s05_ecuaciones_lineales.md`. Cada sección dice en qué momento
de la clase se usa y qué hacer. Pluto es reactivo: al mover un deslizador,
todo lo que depende de él se recalcula.

**Cómo abrirlo.** Desde la raíz del repositorio:
`julia --project=Code -e 'using Pluto; Pluto.run()'` y abrir
`Code/s05_ecuaciones_lineales.jl`.
"""

# ╔═╡ e2dcd0f4-cf03-11f1-992b-75392806d59e
TableOfContents(title = "Contenido")

# ╔═╡ e2dcd112-cf03-11f1-b25a-0f9f69de6588
md"""
En escala logarítmica, la distancia vertical entre dos entidades es el
logaritmo de su razón de ingresos.

1. **Elige** tu entidad, o la de tu tesis. ¿Se acerca a la Ciudad de
   México, se aleja o se mantiene?
2. **Observa** el abanico gris: si las brechas se cerraran, las líneas se
   juntarían. ¿Se juntan?
3. ¿Qué haría falta para responder con precisión? Un modelo de cómo se
   cierra una brecha: es lo que sigue en el pizarrón.
"""

# ╔═╡ e2dcd11c-cf03-11f1-82c4-0d277667b4f2
md"""
## 1. La exponencial: ``\dot y = ay``

*Si alcanza (margen de la clase), después de las secciones 1 y 2 de las notas.* Soluciones
desde varias condiciones iniciales.

``a``: $(@bind a_exp Slider(-0.5:0.05:0.5, default = -0.2, show_value = true))
"""

# ╔═╡ e2dcd130-cf03-11f1-82fc-557355515f2b
md"""
**Mueve** ``a`` de negativo a positivo. **Observa:** ¿cuándo convergen todas
las trayectorias y cuándo se alejan?
"""

# ╔═╡ e2dcd138-cf03-11f1-b4ca-e95b2070cc52
md"""
## 2. ``\dot y + ay = b``: equilibrio y estabilidad

*Si alcanza (margen de la clase).* La curva azul es la solución exacta (notas, 2.2); los
puntos naranjas, el método de Euler con paso ``\Delta t``.

``a``: $(@bind a Slider(-0.3:0.05:1.0, default = 0.5, show_value = true))

``b``: $(@bind b Slider(0.0:0.5:4.0, default = 2.0, show_value = true))

``y_0``: $(@bind y0 Slider(0.0:0.5:8.0, default = 1.0, show_value = true))

Paso de Euler ``\Delta t``: $(@bind Δt Slider([0.05, 0.1, 0.25, 0.5, 1.0, 1.5, 2.0, 2.5], default = 0.5, show_value = true))
"""

# ╔═╡ e2dcd14e-cf03-11f1-a947-8dd2bce4727f
let
    r(v) = round(v, digits = 2)
    texto = a > 0 ?
        md"""
        Con ``a`` = $(a) > 0, el equilibrio ``y^\ast`` = $(r(b / a)) es
        **estable**: la brecha ``y - y^\ast`` se reduce a la mitad cada
        ``\ln 2/a`` = $(r(log(2) / a)) unidades de tiempo, sin importar dónde
        empiece.
        """ : a < 0 ?
        md"""
        Con ``a`` = $(a) < 0, el equilibrio ``y^\ast`` = $(r(b / a)) es
        **inestable**: cualquier desviación crece exponencialmente.
        """ :
        md"""
        Con ``a = 0`` no hay equilibrio: ``y`` crece en línea recta,
        ``y(t) = y_0 + bt``.
        """
    md"""
    $(texto)

    1. **Mueve** ``y_0`` y ``b``: ¿cambia la vida media?
    2. **Mueve** ``a`` a un valor negativo: ¿qué pasa con el equilibrio?
    3. Con ``a = 1``, **agranda** ``\Delta t`` de 0.5 a 2.5: ¿con qué paso
       empieza Euler a oscilar y con cuál diverge, aunque la ecuación no
       oscile? La razón (comparar ``a\,\Delta t`` con 1 y con 2) se ve en la
       sesión 6.
    """
end

# ╔═╡ e2dcd158-cf03-11f1-965b-19c632e84eb1
md"""
### Completa el código

*Después de clase.*

**1.** Escribe `solucion(a, b, y0, t)`, la solución de ``\dot y + ay = b``
con ``y(0) = y_0`` y ``a \ne 0``.
"""

# ╔═╡ e2dcd162-cf03-11f1-80b7-ab209031d79f
function solucion(a, b, y0, t)
    missing  # reemplaza esta línea
end

# ╔═╡ e2dcd176-cf03-11f1-9826-e5f1f53f8631
md"""
**2.** Escribe `vida_media(a)`, el tiempo en que la brecha con el equilibrio
se reduce a la mitad, para ``a > 0``.
"""

# ╔═╡ e2dcd180-cf03-11f1-9c8e-8b942d4e8831
vida_media(a) = missing  # reemplaza missing

# ╔═╡ e2dcd194-cf03-11f1-af8e-4314ea8937ed
md"""
## 3. Convergencia β con los datos de México

*Minutos 45–75, después de las secciones 3.1 y 3.2 de las notas.* Si la
brecha de cada entidad cumple ``\dot z = -\beta z``, su crecimiento promedio
es una recta en ``\ln y_i(0)``: ``g_i = a + b\ln y_i(0)``. La celda siguiente
la estima por mínimos cuadrados (E.B3) con su error estándar (E.I2).
**Léela con calma**: es el tipo de código del proyecto.
"""

# ╔═╡ e2dcd1a8-cf03-11f1-bec2-7d569960e0f0
md"""
Elige el periodo y si se incluye la extracción de petróleo.

Año inicial: $(@bind año0 Slider(2003:2018, default = 2003, show_value = true))

Año final: $(@bind año1 Slider(2008:2023, default = 2023, show_value = true))

Incluir el petróleo: $(@bind con_petroleo CheckBox(default = false))
"""

# ╔═╡ e2dcd1d0-cf03-11f1-a018-f359a8bcb10c
md"""
### Completa el código

*Minutos 88–100, en parejas: ejercicio 3; el 4, después de clase.*

**3.** Escribe `pendiente_mco(x, y)`, la pendiente de mínimos cuadrados de
``y`` sobre ``x``, con la fórmula ``\hat b = \mathrm{Cov}(x, y)/\mathrm{Var}(x)``.
Usa `cov` y `var` del paquete Statistics. El verificador la compara con la
pendiente de la celda de arriba.
"""

# ╔═╡ e2dcd1dc-cf03-11f1-8acc-c324e5b469c0
pendiente_mco(x, y) = missing  # reemplaza missing

# ╔═╡ e2dcd1ee-cf03-11f1-8696-859285b17ef0
md"""
**4.** Escribe `beta_de_pendiente(b, T)`, que traduzca la pendiente ``b`` a la
velocidad de convergencia ``\beta`` (notas, sección 3.2).
"""

# ╔═╡ e2dcd1f8-cf03-11f1-b57b-b3bd7ed9a100
beta_de_pendiente(b, T) = missing  # reemplaza missing

# ╔═╡ e2dcd20e-cf03-11f1-b287-1f78622cbfee
md"""
## 4. Convergencia σ: ¿baja la dispersión?

*Si alcanza (margen de la clase)* (notas, 3.4). La desviación estándar de ``\ln y_i`` entre
entidades, año por año, sin y con petróleo.
"""

# ╔═╡ e2dcd220-cf03-11f1-aeaf-cb7e923b7c60
md"""
1. **Observa** la curva sin petróleo: ¿la dispersión baja, sube o se
   mantiene? ¿Es coherente con la pendiente de la sección 3?
2. **Compara** con la curva con petróleo: ¿por qué baja? ¿Significa que las
   entidades pobres alcanzan a las ricas?
"""

# ╔═╡ e2dcd240-cf03-11f1-98e0-5f57ee23b556
md"""
## 6. [Avanzado] Convergencia β sin convergencia σ

*Fuera de clase* (notas, P.2). 32 regiones simuladas con
``z_{i,T} = \rho\, z_{i,0} + \varepsilon_i``.

``\rho``: $(@bind ρ Slider(0.5:0.05:1.0, default = 0.8, show_value = true))

Desviación estándar de los choques ``\sigma_\varepsilon``: $(@bind σε Slider(0.0:0.05:0.5, default = 0.25, show_value = true))
"""

# ╔═╡ e2dcd252-cf03-11f1-8286-35e357a97311
md"""
**Mueve** ``\sigma_\varepsilon`` hacia arriba con ``\rho = 0.8``.
**Observa:** la pendiente sigue negativa (convergencia β), pero ¿en qué
momento deja de bajar la dispersión (``\sigma_T \ge \sigma_0``)?
"""

# ╔═╡ e2dcd25c-cf03-11f1-8032-5fee8f0212f6
md"""
## Ejercicios

*Después de clase.* Los ejercicios con demostraciones están en las notas
(sección 7).

### Interpretación

5. En la sección 2, ¿por qué la vida media no depende de ``y_0`` ni de
   ``b``? ¿Qué parámetro habría que cambiar para que la región del ejemplo
   del capital (notas, sección 2.4) converja más rápido?
6. Con los deslizadores de la sección 3, prueba los periodos 2003–2013 y
   2013–2023. ¿Cambia la conclusión? ¿Qué pasa si el periodo termina en
   2020?
7. Explica con tus palabras por qué incluir el petróleo produce
   convergencia β. ¿Qué otras entidades o sectores podrían producir el mismo
   problema?
8. La regresión supone un estado estacionario común. Da dos razones por las
   que Chiapas y Nuevo León podrían tener estados estacionarios distintos.
   ¿Qué implica para la política regional?

### Tu tesis

9. ¿Hay en tu problema de tesis una variable que converja (o no) a un
   equilibrio? Escribe una ecuación ``\dot y + ay = b`` que la describa,
   aunque sea como primera aproximación, y di qué representan ``a`` y ``b``.

### [Avanzado]

10. Agrega a la regresión una variable que aproxime el estado estacionario
    de cada entidad (por ejemplo, la región del país) y estima la
    convergencia condicional. ¿Cambia ``\hat b``?

## Para la próxima sesión

- **Sesión 6: equilibrio, diagramas de fase y ecuaciones en diferencias.**
  Ecuaciones no lineales en una dimensión: cuándo un equilibrio es estable
  sin resolver la ecuación, y la versión en tiempo discreto,
  ``y_{t+1} = ay_t + b``.
- Repaso: D.I4 (puntos fijos y diagramas de fase) y A.B2 (sucesiones).
"""

# ╔═╡ e2dcd266-cf03-11f1-8cf8-41c9bb065b5e
md"""
---
## Apéndice: paquetes, datos y funciones auxiliares

Estas celdas definen herramientas que usa el cuaderno. No es necesario
leerlas para seguir la sesión.
"""

# ╔═╡ e2dcd27a-cf03-11f1-8146-db382a218fa7
begin
    const AZUL    = "#2a78d6"   # serie principal
    const NARANJA = "#eb6834"   # segunda serie, recta ajustada
    const GRIS    = "#52514e"   # referencias
    const TINTA   = "#0b0b0b"   # valor elegido
end;

# ╔═╡ e2dcd126-cf03-11f1-9b29-3d4bccb8d6c7
let
    t = range(0, 10, length = 200)
    p = plot(; xlabel = "t", ylabel = "y(t)", ylims = (-3, 3),
             title = "Soluciones de ẏ = ay con a = $a_exp")
    for y0 in -2:0.5:2
        plot!(p, t, y0 .* exp.(a_exp .* t); color = AZUL, lw = 1.5)
    end
    hline!(p, [0]; color = GRIS, ls = :dash, lw = 1)
end

# ╔═╡ e2dcd248-cf03-11f1-89a7-75b5ed9619c4
let
    z0 = 0.4 .* randn(Xoshiro(1), 32)
    zT = ρ .* z0 .+ σε .* randn(Xoshiro(2), 32)
    pend = cov(z0, zT .- z0) / var(z0)
    r(v) = round(v, digits = 2)
    p = scatter(z0, zT .- z0; color = AZUL, ms = 5, msw = 0, xlabel = "brecha inicial z₀",
                ylabel = "cambio z_T − z₀", size = (620, 360),
                title = "Pendiente $(r(pend));  σ₀ = $(r(std(z0))),  σ_T = $(r(std(zT)))")
    plot!(p, [-1, 1], pend .* [-1, 1]; color = NARANJA, lw = 2)
end

# ╔═╡ e2dcd284-cf03-11f1-b963-3fd7b946e854
"Nombre corto de una entidad (sin \"de Zaragoza\", \"de Ignacio de la Llave\", etc.)."
nombre_corto(n) = replace(n, r" de (Zaragoza|Ocampo|Ignacio de la Llave)$" => "")

# ╔═╡ e2dcd19e-cf03-11f1-9469-09f9d4a71116
function estimar_convergencia(datos, año0, año1; con_petroleo = false)
    columna = con_petroleo ? :pibpc_total : :pibpc
    inicio = sort(filter(:año => ==(año0), datos), :clave)
    final = sort(filter(:año => ==(año1), datos), :clave)
    T = año1 - año0
    x = log.(inicio[!, columna])                            # ln y_i(0)
    g = log.(final[!, columna] ./ inicio[!, columna]) ./ T  # crecimiento promedio
    X = [ones(length(x)) x]
    a, b = X \ g                                            # mínimos cuadrados
    e = g .- X * [a, b]
    se = sqrt(sum(abs2, e) / (length(x) - 2) / sum(abs2, x .- mean(x)))
    (; x, g, nombres = nombre_corto.(inicio.entidad), T, a, b, se, r2 = cor(x, g)^2)
end

# ╔═╡ e2dcd28e-cf03-11f1-8b37-c7eea56a2ce9
begin
    entidades = CSV.read(joinpath(@__DIR__, "..", "Data", "entidades.csv"), DataFrame)
    # PIB por persona en miles de pesos de 2018 (el PIB está en millones),
    # sin la minería petrolera y con ella
    entidades.pibpc = (entidades.pib .- entidades.pib_petrolero) ./ entidades.poblacion .* 1e3
    entidades.pibpc_total = entidades.pib ./ entidades.poblacion .* 1e3
    const ENTIDADES = sort(unique(zip(entidades.clave, entidades.entidad)))
end;

# ╔═╡ e2dcd0fe-cf03-11f1-bfda-fb5e19f94bc3
md"""
## 0. La pregunta: ¿se acercan las entidades pobres a las ricas?

*Minutos 0–5.* El logaritmo del PIB per cápita sin petróleo de las 32
entidades, 2003–2023 (INEGI y OCDE, `Data/entidades.csv`), con la Ciudad
de México, Chiapas y una entidad a elegir.

Entidad: $(@bind clave_elegida Select([c => nombre_corto(n) for (c, n) in ENTIDADES]; default = 19))
"""

# ╔═╡ e2dcd106-cf03-11f1-a77b-2585d10dbb47
let
    p = plot(; xlabel = "año", ylabel = "ln PIB per cápita (miles de pesos de 2018)",
             title = "Las 32 entidades, sin petróleo", legend = :outerright, size = (720, 360))
    for t in groupby(entidades, :clave)
        plot!(p, t.año, log.(t.pibpc); color = GRIS, alpha = 0.25, lw = 1, label = "")
    end
    for (c, color) in ((9, AZUL), (7, NARANJA), (clave_elegida, TINTA))
        t = filter(:clave => ==(c), entidades)
        plot!(p, t.año, log.(t.pibpc); color, lw = 2.5, label = nombre_corto(first(t.entidad)))
    end
    p
end

# ╔═╡ e2dcd1b2-cf03-11f1-926e-534d8222f420
convergencia = estimar_convergencia(entidades, año0, max(año1, año0 + 5); con_petroleo)

# ╔═╡ e2dcd1bc-cf03-11f1-aaa7-afaf46b63a28
let
    c = convergencia
    p = scatter(c.x, 100 .* c.g; color = AZUL, ms = 5, msw = 0, alpha = 0.8,
                xlabel = "ln PIB per cápita en $(año0)", ylabel = "crecimiento promedio (% anual)",
                title = "Convergencia β, $(año0)–$(año0 + c.T)" * (con_petroleo ? ", con petróleo" : ", sin petróleo"),
                size = (720, 380))
    xs = range(extrema(c.x)..., length = 2)
    plot!(p, xs, 100 .* (c.a .+ c.b .* xs); color = NARANJA, lw = 2)
    for n in ("Ciudad de México", "Chiapas", "Campeche", "Nuevo León", "Oaxaca", "Tabasco")
        i = findfirst(==(n), c.nombres)
        lado = c.x[i] > 5.6 ? :right : :center
        annotate!(p, c.x[i], 100 * c.g[i] + 0.12, text(n, 7, lado, GRIS))
    end
    p
end

# ╔═╡ e2dcd1c6-cf03-11f1-859c-1ddca388f277
let
    c = convergencia
    r(v, d = 4) = round(v, digits = d)
    β = 1 + c.b * c.T > 0 ? -log(1 + c.b * c.T) / c.T : NaN
    ic = (c.b - 2c.se, c.b + 2c.se)
    texto_β = isnan(β) ? "no definida" : string(r(β))
    texto_vida = β > 0 ? string(round(Int, log(2) / β), " años") : "no se cierra"
    lectura = ic[1] < 0 < ic[2] ?
        md"El intervalo incluye el cero: **no hay evidencia de convergencia β** en este periodo." :
        c.b < 0 ?
        md"El intervalo está por debajo de cero: hay **convergencia β**. Revisa la sección 4 antes de concluir que las brechas se cierran." :
        md"El intervalo está por encima de cero: las entidades ricas crecieron más rápido (**divergencia**)."
    md"""
    | | Valor |
    |:---|---:|
    | Pendiente ``\hat b`` | $(r(c.b)) |
    | Error estándar | $(r(c.se)) |
    | Intervalo del 95%, ``\hat b \pm 2\,\mathrm{se}`` | ($(r(ic[1])), $(r(ic[2]))) |
    | ``R^2`` | $(r(c.r2, 3)) |
    | ``\beta = -\ln(1 + bT)/T`` | $(texto_β) |
    | Vida media de la brecha, ``\ln 2/\beta`` | $(texto_vida) |

    $(año1 < año0 + 5 ? md"*El año final debe ser al menos cinco años posterior al inicial; se usa $(año0 + c.T).*" : md"")

    $(lectura)

    1. **Lee** la tabla para 2003–2023 sin petróleo: ¿hay convergencia? ¿Qué
       dice el intervalo?
    2. **Cambia** el periodo a 2003–2013 y a 2013–2023. ¿Cambia la
       conclusión? ¿Y si el periodo termina en 2020?
    3. **Marca** *Incluir el petróleo*. La pendiente se vuelve negativa:
       ¿qué entidad la produce? Búscala en la gráfica.
    4. Si las entidades tuvieran estados estacionarios distintos, ¿qué
       mediría esta regresión? (Notas, 3.3.)
    """
end

# ╔═╡ e2dcd216-cf03-11f1-b605-077dbde0be89
let
    σ = combine(groupby(entidades, :año), :pibpc => (y -> std(log.(y))) => :sin,
                :pibpc_total => (y -> std(log.(y))) => :con)
    p = plot(σ.año, σ.sin; color = AZUL, lw = 2, marker = :circle, ms = 3, msw = 0,
             label = "sin petróleo", legend = :topright, xlabel = "año",
             ylabel = "desviación estándar de ln y", title = "Dispersión entre entidades")
    plot!(p, σ.año, σ.con; color = NARANJA, lw = 2, marker = :circle, ms = 3, msw = 0,
          label = "con petróleo")
end

# ╔═╡ e2dcd298-cf03-11f1-b6c0-9fbb6bca6e62
# Razón del PIB per cápita sin petróleo de la Ciudad de México (9) y Chiapas (7) en 2023
const RAZON_2023 = let
    y(c) = only(filter(r -> r.clave == c && r.año == 2023, entidades).pibpc)
    y(9) / y(7)
end

# ╔═╡ e2dcd220-cf03-11f1-a854-6f7301f9612c
md"""
## 5. ¿Cuánto tardaría en cerrarse la brecha?

*Minutos 75–88.* En 2023, el PIB per cápita sin petróleo de la Ciudad de
México era $(round(RAZON_2023, digits = 1)) veces el de Chiapas. Si las dos
fueran al mismo estado estacionario con velocidad ``\beta``, la razón sería
``e^{z_0e^{-\beta t}}``; la línea punteada marca una razón de 2.

``\beta``: $(@bind β_sim Slider(0.0025:0.0025:0.05, default = 0.02, show_value = true))
"""

# ╔═╡ e2dcd22a-cf03-11f1-9e30-9dbeb92594f0
let
    t = range(0, 150, length = 300)
    z0 = log(RAZON_2023)
    años = log(z0 / log(2)) / β_sim
    p = plot(2023 .+ t, exp.(z0 .* exp.(-β_sim .* t)); color = AZUL, lw = 2,
             xlabel = "año", ylabel = "razón CDMX / Chiapas", ylims = (1, 7),
             title = "Brecha con β = $β_sim")
    hline!(p, [2]; color = GRIS, ls = :dash, lw = 1)
    años <= 150 && scatter!(p, [2023 + años], [2]; color = NARANJA, ms = 6, msw = 0)
    p
end

# ╔═╡ e2dcd234-cf03-11f1-a3e7-3980e61d9031
let
    años = round(Int, log(log(RAZON_2023) / log(2)) / β_sim)
    md"""
    Con ``\beta`` = $(β_sim), la razón bajaría a 2 en unos $(años) años.

    1. **Pon** ``\beta = 0.02``, la "regla del 2%" de Barro y Sala-i-Martin:
       ¿cuántos años tomaría?
    2. **Baja** ``\beta`` al mínimo, cerca de la que se estima sin petróleo:
       ¿y ahora?
    3. ¿Qué supuesto de este cálculo no apoyan los datos?
    """
end

# ╔═╡ e2dcd2a0-cf03-11f1-82bf-2f76c2cedcb4
"Solución de ẏ + ay = b con y(0) = y0, para a ≠ 0."
solucion_ref(a, b, y0, t) = a == 0 ? y0 + b * t : b / a + (y0 - b / a) * exp(-a * t)

# ╔═╡ e2dcd2a0-cf03-11f1-82c7-1b1c1045a472
"Método de Euler para ẏ = b − ay: devuelve los tiempos y los valores."
function euler_lineal(a, b, y0, Δt, tmax)
    n = round(Int, tmax / Δt)
    y = zeros(n + 1)
    y[1] = y0
    for k in 1:n
        y[k + 1] = y[k] + (b - a * y[k]) * Δt
    end
    (0:n) .* Δt, y
end

# ╔═╡ e2dcd144-cf03-11f1-ac75-758c1a9027a9
let
    tmax = 12
    t = range(0, tmax, length = 300)
    yex = solucion_ref.(a, b, y0, t)
    tk, yk = euler_lineal(a, b, y0, Δt, tmax)
    p = plot(t, yex; color = AZUL, lw = 2, xlabel = "t", ylabel = "y(t)",
             ylims = (-1, 9), title = "ẏ + $a y = $b,  y(0) = $y0")
    scatter!(p, tk, yk; color = NARANJA, ms = 3, msw = 0)
    if a != 0
        hline!(p, [b / a]; color = GRIS, ls = :dash, lw = 1)
        annotate!(p, tmax, b / a + 0.4, text("y* = $(round(b / a, digits = 2))", 8, :right, GRIS))
    end
    p
end

# ╔═╡ e2dcd2ac-cf03-11f1-87c2-bdeebf70b8bb
"Casos de prueba (a, b, y0, t) para la solución de ẏ + ay = b."
const CASOS_EDO = [(0.5, 2.0, 1.0, 2.0), (0.05, 10.0, 100.0, 30.0), (-0.1, 1.0, 5.0, 4.0), (2.0, 0.0, 3.0, 0.5)]

# ╔═╡ e2dcd2b6-cf03-11f1-91d7-01b3134c79bc
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

# ╔═╡ e2dcd16a-cf03-11f1-8615-51f79686e54e
verificar(() -> [solucion(c...) for c in CASOS_EDO], [solucion_ref(c...) for c in CASOS_EDO];
          pista = md"Con `ystar = b / a`, la solución es `ystar + (y0 - ystar) * exp(-a * t)`.")

# ╔═╡ e2dcd18a-cf03-11f1-be97-39dfc044ceb1
verificar(() -> vida_media.([0.02, 0.05, 0.5]), log(2) ./ [0.02, 0.05, 0.5];
          pista = md"Resuelve ``e^{-at} = 1/2``: `vida_media(a) = log(2) / a`.")

# ╔═╡ e2dcd1e4-cf03-11f1-a012-9be9a6f88349
verificar(() -> pendiente_mco(convergencia.x, convergencia.g), convergencia.b;
          pista = md"`pendiente_mco(x, y) = cov(x, y) / var(x)`")

# ╔═╡ e2dcd202-cf03-11f1-b6b8-47dc83800c2d
verificar(() -> [beta_de_pendiente(-0.012, 20), beta_de_pendiente(-0.01, 20), beta_de_pendiente(-0.02, 10)],
          [-log(1 - 0.012 * 20) / 20, -log(0.8) / 20, -log(0.8) / 10];
          pista = md"Despeja ``\beta`` de ``b = -(1 - e^{-\beta T})/T``: `-log(1 + b * T) / T`.")

# ╔═╡ Cell order:
# ╟─e2dcd0ae-cf03-11f1-a2cc-556b9871b55c
# ╟─e2dcd0f4-cf03-11f1-992b-75392806d59e
# ╟─e2dcd0fe-cf03-11f1-bfda-fb5e19f94bc3
# ╟─e2dcd106-cf03-11f1-a77b-2585d10dbb47
# ╟─e2dcd112-cf03-11f1-b25a-0f9f69de6588
# ╟─e2dcd11c-cf03-11f1-82c4-0d277667b4f2
# ╟─e2dcd126-cf03-11f1-9b29-3d4bccb8d6c7
# ╟─e2dcd130-cf03-11f1-82fc-557355515f2b
# ╟─e2dcd138-cf03-11f1-b4ca-e95b2070cc52
# ╟─e2dcd144-cf03-11f1-ac75-758c1a9027a9
# ╟─e2dcd14e-cf03-11f1-a947-8dd2bce4727f
# ╟─e2dcd158-cf03-11f1-965b-19c632e84eb1
# ╠═e2dcd162-cf03-11f1-80b7-ab209031d79f
# ╟─e2dcd16a-cf03-11f1-8615-51f79686e54e
# ╟─e2dcd176-cf03-11f1-9826-e5f1f53f8631
# ╠═e2dcd180-cf03-11f1-9c8e-8b942d4e8831
# ╟─e2dcd18a-cf03-11f1-be97-39dfc044ceb1
# ╟─e2dcd194-cf03-11f1-af8e-4314ea8937ed
# ╠═e2dcd19e-cf03-11f1-9469-09f9d4a71116
# ╟─e2dcd1a8-cf03-11f1-bec2-7d569960e0f0
# ╠═e2dcd1b2-cf03-11f1-926e-534d8222f420
# ╟─e2dcd1bc-cf03-11f1-aaa7-afaf46b63a28
# ╟─e2dcd1c6-cf03-11f1-859c-1ddca388f277
# ╟─e2dcd1d0-cf03-11f1-a018-f359a8bcb10c
# ╠═e2dcd1dc-cf03-11f1-8acc-c324e5b469c0
# ╟─e2dcd1e4-cf03-11f1-a012-9be9a6f88349
# ╟─e2dcd1ee-cf03-11f1-8696-859285b17ef0
# ╠═e2dcd1f8-cf03-11f1-b57b-b3bd7ed9a100
# ╟─e2dcd202-cf03-11f1-b6b8-47dc83800c2d
# ╟─e2dcd20e-cf03-11f1-b287-1f78622cbfee
# ╟─e2dcd216-cf03-11f1-b605-077dbde0be89
# ╟─e2dcd220-cf03-11f1-aeaf-cb7e923b7c60
# ╟─e2dcd220-cf03-11f1-a854-6f7301f9612c
# ╟─e2dcd22a-cf03-11f1-9e30-9dbeb92594f0
# ╟─e2dcd234-cf03-11f1-a3e7-3980e61d9031
# ╟─e2dcd240-cf03-11f1-98e0-5f57ee23b556
# ╟─e2dcd248-cf03-11f1-89a7-75b5ed9619c4
# ╟─e2dcd252-cf03-11f1-8286-35e357a97311
# ╟─e2dcd25c-cf03-11f1-8032-5fee8f0212f6
# ╟─e2dcd266-cf03-11f1-8cf8-41c9bb065b5e
# ╠═e2dcd26e-cf03-11f1-9cfe-bddfdcfa40f4
# ╠═e2dcd27a-cf03-11f1-8146-db382a218fa7
# ╠═e2dcd284-cf03-11f1-b963-3fd7b946e854
# ╠═e2dcd28e-cf03-11f1-8b37-c7eea56a2ce9
# ╠═e2dcd298-cf03-11f1-b6c0-9fbb6bca6e62
# ╠═e2dcd2a0-cf03-11f1-82bf-2f76c2cedcb4
# ╠═e2dcd2a0-cf03-11f1-82c7-1b1c1045a472
# ╠═e2dcd2ac-cf03-11f1-87c2-bdeebf70b8bb
# ╠═e2dcd2b6-cf03-11f1-91d7-01b3134c79bc
