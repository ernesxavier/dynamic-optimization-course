#%% hide
md"""
# Sesión 5: Ecuaciones diferenciales lineales de primer orden

**Pregunta de la unidad.** ¿Convergen los estados de México? ¿A qué
velocidad?

**Objetivos de la sesión**
1. Resolver ``\dot y + ay = b`` y leer su solución como equilibrio más una
   desviación que decae o crece.
2. Decidir cuándo el equilibrio es estable y medir la velocidad de
   convergencia con la vida media.
3. Estimar la convergencia β entre las entidades de México con datos del
   INEGI, y traducir la pendiente de la regresión a una velocidad.
4. Distinguir la convergencia β de la σ, y reconocer un resultado engañoso.

**Cómo usar este cuaderno.** Pluto es reactivo: al mover un deslizador, todo
lo que depende de él se recalcula. Las secciones marcadas **[Avanzado]** son
opcionales. Las demostraciones están en las notas formales,
`Class_notes/s05_ecuaciones_lineales.md`.

**Cómo abrirlo.** Desde la raíz del repositorio:
`julia --project=Code -e 'using Pluto; Pluto.run()'` y abrir
`Code/s05_ecuaciones_lineales.jl`.

**Repaso recomendado** (en `Class_notes/repaso/`): C.B3 (exponencial), D.B2
y D.B3 (crecimiento exponencial y método de Euler), D.I1 (lineales de primer
orden), E.B2 y E.B3 (tasas de crecimiento y mínimos cuadrados), E.I2 (error
estándar) y N.I7 (datos en Julia). Para los puntos [Avanzado]: E.A1.
"""

#%% hide
TableOfContents(title = "Contenido")

#%% hide
md"""
## 0. La pregunta: ¿se acercan las entidades pobres a las ricas?

La gráfica muestra el logaritmo del PIB per cápita sin petróleo de las 32
entidades entre 2003 y 2023 (INEGI y OCDE, `Data/entidades.csv`). Elige una
entidad para destacarla junto a la Ciudad de México y Chiapas.

Entidad: $(@bind clave_elegida Select([c => nombre_corto(n) for (c, n) in ENTIDADES]; default = 19))
"""

#%% hide
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

#%% hide
md"""
En escala logarítmica, la distancia vertical entre dos entidades es el
logaritmo de su razón de ingresos. Si las brechas se cerraran, las líneas se
juntarían. ¿Se juntan?

Para responder con precisión hace falta un modelo de cómo se cierra una
brecha: ``\dot z = -\beta z``, con ``z`` la distancia (en logaritmos) al
estado estacionario. Las secciones 1 y 2 lo resuelven; la 3 lo lleva a los
datos.
"""

#%% hide
md"""
## 1. La exponencial: ``\dot y = ay``

La solución es ``y(t) = y_0 e^{at}``: ``a`` es la tasa de crecimiento. Mueve
``a`` y observa las trayectorias desde varias condiciones iniciales.

``a``: $(@bind a_exp Slider(-0.5:0.05:0.5, default = -0.2, show_value = true))
"""

#%% hide
let
    t = range(0, 10, length = 200)
    p = plot(; xlabel = "t", ylabel = "y(t)", ylims = (-3, 3),
             title = "Soluciones de ẏ = ay con a = $a_exp")
    for y0 in -2:0.5:2
        plot!(p, t, y0 .* exp.(a_exp .* t); color = AZUL, lw = 1.5)
    end
    hline!(p, [0]; color = GRIS, ls = :dash, lw = 1)
end

#%% hide
md"""
Con ``a < 0`` todas convergen a cero; con ``a > 0``, todas (salvo
``y_0 = 0``) se alejan. La **vida media** de un decaimiento es
``\ln 2/|a|``: el tiempo en que la distancia a cero se reduce a la mitad.
"""

#%% hide
md"""
## 2. ``\dot y + ay = b``: equilibrio y estabilidad

El **equilibrio** es ``y^\ast = b/a``, donde ``\dot y = 0``. La solución es

```math
y(t) = y^\ast + (y_0 - y^\ast)\,e^{-at}:
```

equilibrio más una desviación que decae si ``a > 0`` y crece si ``a < 0``.
La curva azul es la solución exacta; los puntos naranjas, el **método de
Euler** con paso ``\Delta t`` (D.B3).

``a``: $(@bind a Slider(-0.3:0.05:1.0, default = 0.5, show_value = true))

``b``: $(@bind b Slider(0.0:0.5:4.0, default = 2.0, show_value = true))

``y_0``: $(@bind y0 Slider(0.0:0.5:8.0, default = 1.0, show_value = true))

Paso de Euler ``\Delta t``: $(@bind Δt Slider([0.05, 0.1, 0.25, 0.5, 1.0, 2.0], default = 0.5, show_value = true))
"""

#%% hide
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

#%% hide
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

    Agranda ``\Delta t``: con pasos grandes, Euler se aleja de la solución
    exacta. Con ``a\,\Delta t > 1`` oscila alrededor del equilibrio, y con
    ``a\,\Delta t > 2`` diverge, aunque la ecuación sea estable. La razón se
    ve en tiempo discreto, en la sesión 6.
    """
end

#%% hide
md"""
### Completa el código

**1.** Escribe `solucion(a, b, y0, t)`, la solución de ``\dot y + ay = b``
con ``y(0) = y_0`` y ``a \ne 0``.
"""

#%%
function solucion(a, b, y0, t)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> [solucion(c...) for c in CASOS_EDO], [solucion_ref(c...) for c in CASOS_EDO];
          pista = md"Con `ystar = b / a`, la solución es `ystar + (y0 - ystar) * exp(-a * t)`.")

#%% hide
md"""
**2.** Escribe `vida_media(a)`, el tiempo en que la brecha con el equilibrio
se reduce a la mitad, para ``a > 0``.
"""

#%%
vida_media(a) = missing  # reemplaza missing

#%% hide
verificar(() -> vida_media.([0.02, 0.05, 0.5]), log(2) ./ [0.02, 0.05, 0.5];
          pista = md"Resuelve ``e^{-at} = 1/2``: `vida_media(a) = log(2) / a`.")

#%% hide
md"""
## 3. Convergencia β con los datos de México

Si la brecha de cada entidad con un estado estacionario común cumple
``\dot z = -\beta z``, su crecimiento promedio entre ``0`` y ``T`` es una
recta en el logaritmo del ingreso inicial (notas, sección 3.1):

```math
g_i = \frac{1}{T}\ln\frac{y_i(T)}{y_i(0)} = a + b\ln y_i(0),
\qquad b = -\frac{1 - e^{-\beta T}}{T}.
```

Si ``b < 0``, las entidades que empezaron más pobres crecieron más rápido.
La celda siguiente estima la recta por mínimos cuadrados (E.B3) y su error
estándar (E.I2). Léela: es el tipo de código de las tareas.
"""

#%%
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

#%% hide
md"""
Elige el periodo y si se incluye la extracción de petróleo.

Año inicial: $(@bind año0 Slider(2003:2018, default = 2003, show_value = true))

Año final: $(@bind año1 Slider(2008:2023, default = 2023, show_value = true))

Incluir el petróleo: $(@bind con_petroleo CheckBox(default = false))
"""

#%%
convergencia = estimar_convergencia(entidades, año0, max(año1, año0 + 5); con_petroleo)

#%% hide
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

#%% hide
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

    **Prueba.** Marca *Incluir el petróleo*. La pendiente se vuelve claramente
    negativa. ¿Qué entidad la produce? Busca a Campeche en la gráfica: en
    2003 tenía el mayor PIB per cápita del país por la extracción de
    petróleo, y para 2023 había caído a menos de la mitad.
    """
end

#%% hide
md"""
### Completa el código

**3.** Escribe `pendiente_mco(x, y)`, la pendiente de mínimos cuadrados de
``y`` sobre ``x``, con la fórmula ``\hat b = \mathrm{Cov}(x, y)/\mathrm{Var}(x)``.
Usa `cov` y `var` del paquete Statistics. El verificador la compara con la
pendiente de la celda de arriba.
"""

#%%
pendiente_mco(x, y) = missing  # reemplaza missing

#%% hide
verificar(() -> pendiente_mco(convergencia.x, convergencia.g), convergencia.b;
          pista = md"`pendiente_mco(x, y) = cov(x, y) / var(x)`")

#%% hide
md"""
**4.** Escribe `beta_de_pendiente(b, T)`, que traduzca la pendiente ``b`` a la
velocidad de convergencia ``\beta`` (notas, sección 3.2).
"""

#%%
beta_de_pendiente(b, T) = missing  # reemplaza missing

#%% hide
verificar(() -> [beta_de_pendiente(-0.012, 20), beta_de_pendiente(-0.01, 20), beta_de_pendiente(-0.02, 10)],
          [-log(1 - 0.012 * 20) / 20, -log(0.8) / 20, -log(0.8) / 10];
          pista = md"Despeja ``\beta`` de ``b = -(1 - e^{-\beta T})/T``: `-log(1 + b * T) / T`.")

#%% hide
md"""
## 4. Convergencia σ: ¿baja la dispersión?

La convergencia β dice que las entidades pobres crecen más rápido. La
**convergencia σ** pregunta otra cosa: si la dispersión de los ingresos,
la desviación estándar de ``\ln y_i`` entre entidades, baja con el tiempo.
"""

#%% hide
let
    σ = combine(groupby(entidades, :año), :pibpc => (y -> std(log.(y))) => :sin,
                :pibpc_total => (y -> std(log.(y))) => :con)
    p = plot(σ.año, σ.sin; color = AZUL, lw = 2, marker = :circle, ms = 3, msw = 0,
             label = "sin petróleo", legend = :topright, xlabel = "año",
             ylabel = "desviación estándar de ln y", title = "Dispersión entre entidades")
    plot!(p, σ.año, σ.con; color = NARANJA, lw = 2, marker = :circle, ms = 3, msw = 0,
          label = "con petróleo")
end

#%% hide
md"""
- **Sin petróleo**, la dispersión subió de 0.38 en 2003 a 0.41 en 2019 y
  terminó en 0.40: no hay convergencia σ. Es coherente con ``\hat b \approx 0``.
- **Con petróleo**, la dispersión baja, pero sólo porque Campeche, que
  empezó muy arriba, cayó. No es que las entidades pobres alcancen a las
  ricas.

**Conclusión.** Entre 2003 y 2023, las brechas entre las entidades de México
no se cerraron solas. Ésa es la motivación del curso: si esperar no basta,
¿cómo debe invertir un gobierno entre regiones?
"""

#%% hide
md"""
## 5. ¿Cuánto tardaría en cerrarse la brecha?

En 2023, el PIB per cápita sin petróleo de la Ciudad de México era
$(round(RAZON_2023, digits = 1)) veces el de Chiapas. Si las dos fueran al
mismo estado estacionario con velocidad ``\beta``, la brecha en logaritmos
cumpliría ``z(t) = z_0 e^{-\beta t}``, y la razón de ingresos sería
``e^{z(t)}``. La línea punteada marca una razón de 2.

``\beta``: $(@bind β_sim Slider(0.0025:0.0025:0.05, default = 0.02, show_value = true))
"""

#%% hide
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

#%% hide
let
    años = round(Int, log(log(RAZON_2023) / log(2)) / β_sim)
    md"""
    Con ``\beta`` = $(β_sim), la razón bajaría a 2 en unos $(años) años. Con la "regla del 2%"
    de Barro y Sala-i-Martin, tomaría medio siglo; con la ``\beta`` que se
    estima sin petróleo, prácticamente nunca. Y esto suponiendo un estado
    estacionario común (convergencia absoluta), que los datos no apoyan.
    """
end

#%% hide
md"""
## 6. [Avanzado] Convergencia β sin convergencia σ

La falacia de Galton (notas, P.2): con choques nuevos cada periodo, puede
haber ``b < 0`` sin que la dispersión baje. La simulación genera 32 regiones
con brechas iniciales ``z_{i,0}`` y las mueve con
``z_{i,T} = \rho\, z_{i,0} + \varepsilon_i``.

``\rho``: $(@bind ρ Slider(0.5:0.05:1.0, default = 0.8, show_value = true))

Desviación estándar de los choques ``\sigma_\varepsilon``: $(@bind σε Slider(0.0:0.05:0.5, default = 0.25, show_value = true))
"""

#%% hide
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

#%% hide
md"""
Con ``\rho < 1`` la pendiente es negativa: hay convergencia β. Pero sube
``\sigma_\varepsilon`` hasta que ``\sigma_T`` iguale o supere a
``\sigma_0``: la dispersión no baja. Por eso se revisan las dos
convergencias.
"""

#%% hide
md"""
## Resumen

| Concepto | Qué dice | En los datos de México, 2003–2023 |
|---|---|---|
| Equilibrio | ``y^\ast = b/a`` | — |
| Solución | ``y(t) = y^\ast + (y_0 - y^\ast)e^{-at}`` | — |
| Estabilidad | Estable si y sólo si ``a > 0`` | — |
| Vida media | ``\ln 2/a`` | — |
| Convergencia β | ``b < 0`` en ``g_i = a + b\ln y_i(0)``; ``\beta = -\ln(1 + bT)/T`` | Sin petróleo, ``\hat b \approx 0`` |
| Convergencia σ | La dispersión de ``\ln y_i`` baja | Sin petróleo, sube un poco |
| Datos engañosos | Una región que cae desde arriba simula convergencia | Campeche con petróleo |

## Ejercicios

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
11. En la sección 6, encuentra la ``\sigma_\varepsilon`` con la que la
    dispersión se mantiene constante (notas, ejercicio F7) y compárala con
    la simulación.

## Para la próxima sesión

- **Sesión 6: equilibrio, diagramas de fase y ecuaciones en diferencias.**
  Ecuaciones no lineales en una dimensión: cuándo un equilibrio es estable
  sin resolver la ecuación, y la versión en tiempo discreto,
  ``y_{t+1} = ay_t + b``.
- Repaso: D.I4 (puntos fijos y diagramas de fase) y A.B2 (sucesiones).
"""

#%% hide
md"""
---
## Apéndice: paquetes, datos y funciones auxiliares

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
    using PlutoUI, Plots, CSV, DataFrames, Statistics, Random, Markdown
    gr()
    default(size = (720, 320), legend = false, grid = :y, gridalpha = 0.15,
            framestyle = :axes, titlefontsize = 11, guidefontsize = 9,
            tickfontsize = 8, legendfontsize = 8, foreground_color_legend = nothing,
            background_color_legend = nothing, margin = 3Plots.mm)
end

#%%
begin
    const AZUL    = "#2a78d6"   # serie principal
    const NARANJA = "#eb6834"   # segunda serie, recta ajustada
    const GRIS    = "#52514e"   # referencias
    const TINTA   = "#0b0b0b"   # valor elegido
end;

#%%
"Nombre corto de una entidad (sin \"de Zaragoza\", \"de Ignacio de la Llave\", etc.)."
nombre_corto(n) = replace(n, r" de (Zaragoza|Ocampo|Ignacio de la Llave)$" => "")

#%%
begin
    entidades = CSV.read(joinpath(@__DIR__, "..", "Data", "entidades.csv"), DataFrame)
    # PIB por persona en miles de pesos de 2018 (el PIB está en millones),
    # sin la minería petrolera y con ella
    entidades.pibpc = (entidades.pib .- entidades.pib_petrolero) ./ entidades.poblacion .* 1e3
    entidades.pibpc_total = entidades.pib ./ entidades.poblacion .* 1e3
    const ENTIDADES = sort(unique(zip(entidades.clave, entidades.entidad)))
end;

#%%
# Razón del PIB per cápita sin petróleo de la Ciudad de México (9) y Chiapas (7) en 2023
const RAZON_2023 = let
    y(c) = only(filter(r -> r.clave == c && r.año == 2023, entidades).pibpc)
    y(9) / y(7)
end

#%%
"Solución de ẏ + ay = b con y(0) = y0, para a ≠ 0."
solucion_ref(a, b, y0, t) = a == 0 ? y0 + b * t : b / a + (y0 - b / a) * exp(-a * t)

#%%
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

#%%
"Casos de prueba (a, b, y0, t) para la solución de ẏ + ay = b."
const CASOS_EDO = [(0.5, 2.0, 1.0, 2.0), (0.05, 10.0, 100.0, 30.0), (-0.1, 1.0, 5.0, 4.0), (2.0, 0.0, 3.0, 0.5)]

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
                  (a isa AbstractArray && b isa AbstractArray && size(a) == size(b) && all(cerca.(a, b)))
    if pendiente(resultado)
        caja("warning", "Pendiente", md"Reemplaza `missing` por tu código.")
    elseif cerca(resultado, esperado)
        caja("correct", "¡Correcto!", md"Bien hecho.")
    else
        caja("danger", "Todavía no", pista)
    end
end
