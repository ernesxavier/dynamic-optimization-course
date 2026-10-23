#%% hide
md"""
# Sesión 1: Por qué optimizar en el tiempo

**Pregunta de la unidad.** ¿Cómo repartir un fondo de inversión entre dos
regiones?

**Cómo usar este cuaderno.** La teoría está en las notas,
`Class_notes/s01_optimizar_en_el_tiempo.md`, y se desarrolla en el
pizarrón; el cuaderno sirve para mover los parámetros y ver qué pasa. En
esta sesión el profesor proyecta las secciones 0, 2 y 3. Tú lo abres después
del Laboratorio 0 (sesión 4), cuando ya tengas Julia instalado: entonces
repasa la sección 1 y resuelve los ejercicios. Pluto es reactivo: al mover un
deslizador, todo lo que depende de él se recalcula.

**Cómo abrirlo.** Desde la raíz del repositorio:
`julia --project=Code -e 'using Pluto; Pluto.run()'` y abrir
`Code/s01_optimizar_en_el_tiempo.jl`.
"""

#%% hide
TableOfContents(title = "Contenido")

#%% hide
md"""
## 0. La pregunta: ¿se cierran solas las brechas entre regiones?

*En clase* (notas, sección 0). PIB per cápita sin petróleo de cinco
entidades, en miles de pesos de 2018 por persona (INEGI y OCDE,
`Data/entidades.csv`).
"""

#%% hide
let
    p = plot(; xlabel = "año", ylabel = "miles de pesos de 2018 por persona",
             title = "PIB per cápita sin petróleo", legend = :outerright, size = (720, 340))
    for (clave, color) in zip(CLAVES_EJEMPLO, PALETA)
        t = filter(:clave => ==(clave), entidades)
        plot!(p, t.año, t.pibpc; lw = 2, color, label = nombre_corto(first(t.entidad)))
    end
    p
end

#%% hide
md"""
**Observa:** ¿se acercan las entidades pobres a las ricas? ¿Qué pasa con la
brecha entre la Ciudad de México y Chiapas?
"""

#%% hide
md"""
## 1. Estático contra dinámico: ahorrar hoy para mañana

*Después de clase* (notas, sección 1.2). Un gobierno recibe ``y_0 = 100``
hoy y ``y_1`` mañana, invierte lo que no gasta a la tasa bruta ``R`` y
valora el gasto con ``\ln c_0 + \beta\ln c_1``. La gráfica compara el
óptimo con la regla sencilla de **gastar lo que entra**, ``c_0 = y_0``.

Ingreso de mañana ``y_1``: $(@bind y1 Slider(0:10:200, default = 50, show_value = true))

Tasa bruta ``R``: $(@bind R Slider(1.00:0.01:1.20, default = 1.05, show_value = true))

Factor de descuento ``\beta``: $(@bind β Slider(0.80:0.01:0.99, default = 0.95, show_value = true))
"""

#%% hide
let
    c0s = range(1, INGRESO_HOY + y1 / R - 1, length = 400)
    p = plot(c0s, utilidad_dos_periodos.(c0s, INGRESO_HOY, y1, β, R); color = AZUL, lw = 2,
             xlabel = "gasto hoy, c₀", ylabel = "bienestar U",
             title = "Bienestar según el gasto de hoy")
    c0 = consumo_hoy_ref(INGRESO_HOY, y1, β, R)
    for (x, nombre, color) in ((INGRESO_HOY, "gastar lo que entra", GRIS), (c0, "óptimo", NARANJA))
        u = utilidad_dos_periodos(x, INGRESO_HOY, y1, β, R)
        scatter!(p, [x], [u]; color, ms = 6, msw = 0)
        annotate!(p, x, u, text("  " * nombre, 8, :left, color))
    end
    p
end

#%% hide
let
    c0 = consumo_hoy_ref(INGRESO_HOY, y1, β, R)
    c1 = y1 + R * (INGRESO_HOY - c0)
    ahorro = INGRESO_HOY - c0
    # Dentro de md, $(...) sólo con nombres simples: sin comillas, corchetes,
    # guiones bajos ni asteriscos alrededor (el parser de md los procesa antes)
    accion = ahorro >= 0 ? "ahorra" : "se endeuda por"
    c0r, c1r, ar = round(c0, digits = 1), round(c1, digits = 1), round(abs(ahorro), digits = 1)
    izq, der = round(1 / c0, digits = 4), round(β * R / c1, digits = 4)
    md"""
    El óptimo gasta ``c_0 = `` $(c0r) hoy y ``c_1 = `` $(c1r) mañana: es
    decir, $(accion) $(ar). **Comprobación de la ecuación de Euler:**
    ``1/c_0`` = $(izq) y ``\beta R/c_1`` = $(der).

    **Mueve** ``\beta`` y ``R`` hasta que ``\beta R \approx 1``, y después
    sube ``y_1``. **Observa:** ¿cuándo ahorra el gobierno y cuándo se
    endeuda? ¿Cuándo coincide el óptimo con gastar lo que entra?
    """
end

#%% hide
md"""
## 2. Estado, control y ecuación de movimiento

*En clase* (notas, secciones 2 y 3). Una región con capital ``K_t``
(estado) invierte una fracción fija ``s`` de su producto (control):
``K_{t+1} = (1 - \delta)K_t + sK_t^{\alpha}``, con ``\alpha = 0.3``,
``\delta = 0.05``, ``K_0 = 1`` y ``T = 40`` años. El objetivo es
``\sum_t \beta^t\ln c_t``, con el ``\beta`` de la sección 1.

Tasa de inversión ``s``: $(@bind s Slider(0.0:0.01:0.9, default = 0.5, show_value = true))
"""

#%% hide
let
    s_mejor = mejor_tasa_ref(β)
    K, c = trayectoria_ref(s)
    Km, cm = trayectoria_ref(s_mejor)
    pK = plot(0:HORIZONTE, K; color = AZUL, lw = 2, label = "s = $s",
              xlabel = "año", ylabel = "capital Kₜ", title = "Estado: el capital")
    plot!(pK, 0:HORIZONTE, Km; color = NARANJA, lw = 2, ls = :dash, label = "mejor s constante = $s_mejor")
    pc = plot(0:HORIZONTE-1, c; color = AZUL, lw = 2, xlabel = "año", ylabel = "gasto cₜ",
              title = "Lo que se gasta cada año")
    plot!(pc, 0:HORIZONTE-1, cm; color = NARANJA, lw = 2, ls = :dash)
    plot(pK, pc; layout = (1, 2), legend = [:topleft false], size = (720, 300))
end

#%% hide
let
    ss = 0:0.01:0.9
    w = bienestar_ref.(ss, β)
    p = plot(ss, w; color = AZUL, lw = 2, xlabel = "tasa de inversión s",
             ylabel = "bienestar", title = "Bienestar en 40 años según la tasa de inversión (β = $β)",
             ylims = (maximum(w) - 8, maximum(w) + 1))
    i = argmax(w)
    scatter!(p, [ss[i]], [w[i]]; color = NARANJA, ms = 6, msw = 0)
    annotate!(p, ss[i], w[i], text("  mejor s = $(ss[i])", 8, :left, NARANJA))
    scatter!(p, [s], [bienestar_ref(s, β)]; color = TINTA, ms = 4, msw = 0)
end

#%% hide
md"""
**Mueve** ``s`` de 0.1 a 0.8, y después ``\beta`` en la sección 1.
**Observa:** ¿qué se gana y qué se pierde al invertir más? ¿Cómo cambia la
mejor tasa constante con ``\beta``? Mira el capital en el año 40: ¿sirve de
algo el que sobra? Por eso una regla que **cambia con el tiempo** puede ser
mejor que cualquier tasa fija (notas, sección 3.3).
"""

#%% hide
md"""
## 3. El hilo conductor: invertir en una región o en otra

*En clase* (notas, sección 4). Dos regiones con ``Y_i = v_iK_i`` y ahorro
``s_iY_i``; el planificador manda una fracción ``\theta`` de la inversión
total a la región 1 y el resto a la 2, y busca el mayor producto en
``T = 30``. La política que se simula invierte todo en la región 1 hasta el
año ``t_c`` y todo en la región 2 después.

Ahorro de la región 1, ``s_1``: $(@bind s₁ Slider(0.05:0.05:0.40, default = 0.30, show_value = true))

Productividad de la región 1, ``v_1``: $(@bind v₁ Slider(0.10:0.05:0.50, default = 0.25, show_value = true))

Ahorro de la región 2, ``s_2``: $(@bind s₂ Slider(0.05:0.05:0.40, default = 0.15, show_value = true))

Productividad de la región 2, ``v_2``: $(@bind v₂ Slider(0.10:0.05:0.50, default = 0.35, show_value = true))

Año del cambio, ``t_c``: $(@bind t_c Slider(0:1:30, default = 10, show_value = true))
"""

#%% hide
let
    ts = range(0, HORIZONTE_REGIONES, length = 301)
    K = [capital_cambio_ref(t, t_c, s₁, v₁, s₂, v₂) for t in ts]
    p = plot(ts, first.(K); color = AZUL, lw = 2, label = "K₁ (ahorra más)",
             xlabel = "año", ylabel = "capital", title = "Capital de cada región, con cambio en t_c = $t_c",
             legend = :topleft)
    plot!(p, ts, last.(K); color = NARANJA, lw = 2, label = "K₂ (produce más)")
    vline!(p, [t_c]; color = GRIS, ls = :dot, label = "")
end

#%% hide
let
    tcs = 0:0.1:HORIZONTE_REGIONES
    YT = [produccion_final_ref(tc, s₁, v₁, s₂, v₂) for tc in tcs]
    i = argmax(YT)
    p = plot(tcs, YT; color = AZUL, lw = 2, label = "cambiar en t_c",
             xlabel = "año del cambio, t_c", ylabel = "producto total en T = 30",
             title = "Producto final según el momento del cambio", legend = :bottomright)
    hline!(p, [produccion_fija_ref(0.5, s₁, v₁, s₂, v₂)]; color = GRIS, ls = :dash, label = "mitad y mitad siempre")
    scatter!(p, [tcs[i]], [YT[i]]; color = NARANJA, ms = 6, msw = 0, label = "mejor cambio: t_c = $(tcs[i])")
    scatter!(p, [t_c], [produccion_final_ref(t_c, s₁, v₁, s₂, v₂)]; color = TINTA, ms = 4, msw = 0, label = "")
end

#%% hide
let
    tcs = 0:0.1:HORIZONTE_REGIONES
    YT = [produccion_final_ref(tc, s₁, v₁, s₂, v₂) for tc in tcs]
    i = argmax(YT)
    # Dentro de md, $(...) sólo con nombres simples (ver la sección 1)
    ytodo2, ytodo1, ymejor = round.((YT[1], YT[end], YT[i]), digits = 2)
    tmejor = tcs[i]
    md"""
    Todo a la región 2 siempre (``t_c = 0``): $(ytodo2). Todo a la región 1
    siempre (``t_c = 30``): $(ytodo1). Lo mejor: la región 1 hasta el año
    $(tmejor) y la región 2 después, con $(ymejor).

    **Mueve** ``t_c`` y busca el máximo. Después iguala ``s_1`` y ``s_2``, y
    prueba una región 1 que ahorre más **y** produzca más. **Observa:**
    ¿cuándo deja de convenir el cambio? La sesión 14 da la fórmula exacta del
    mejor momento.
    """
end

#%% hide
md"""
## Ejercicios

*Después del Laboratorio 0 (sesión 4).* Los ejercicios con demostraciones
están en las notas (sección 8).

### Completa el código

**1.** Escribe `siguiente_capital(K, s)`, la ecuación de movimiento de la
sección 2: devuelve ``(1 - \delta) K + s K^{\alpha}`` con ``\alpha = 0.3`` y
``\delta = 0.05``.
"""

#%%
function siguiente_capital(K, s)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> [siguiente_capital(K, s) for (K, s) in CASOS_CAPITAL],
          [siguiente_capital_ref(K, s) for (K, s) in CASOS_CAPITAL];
          pista = md"Devuelve `(1 - 0.05) * K + s * K^0.3`.")

#%% hide
md"""
**2.** Escribe `gasto_hoy_optimo(y0, y1, β, R)`, el gasto óptimo de hoy en el
problema de dos periodos (notas, sección 1.2).
"""

#%%
function gasto_hoy_optimo(y0, y1, β, R)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> [gasto_hoy_optimo(c...) for c in CASOS_DOS_PERIODOS],
          [consumo_hoy_ref(c...) for c in CASOS_DOS_PERIODOS];
          pista = md"La ecuación de Euler da ``c_1 = \beta R c_0``. Sustituye en ``c_1 = y_1 + R(y_0 - c_0)`` y despeja: ``c_0 = (y_0 + y_1/R)/(1 + \beta)``.")

#%% hide
md"""
**3.** Escribe `mejor_tasa(β)`, que busque en la malla `0:0.01:0.99` la tasa
de inversión constante con mayor bienestar. Usa la función
`bienestar_ref(s, β)`, que calcula ``\sum_t \beta^t \ln c_t`` para una tasa
``s``. El verificador la prueba con ``\beta = 0.9``, ``0.95`` y ``0.99``.
"""

#%%
function mejor_tasa(β)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> [mejor_tasa(b) for b in (0.9, 0.95, 0.99)],
          [mejor_tasa_ref(b) for b in (0.9, 0.95, 0.99)];
          pista = md"Con `ss = 0:0.01:0.99`, calcula `w = [bienestar_ref(s, β) for s in ss]` y devuelve `ss[argmax(w)]`.")

#%% hide
md"""
**4. [Avanzado]** Escribe `mejor_cambio(s1, v1, s2, v2)`, que busque en la
malla `0:0.01:30` el año de cambio con mayor producto final. Usa
`produccion_final_ref(tc, s1, v1, s2, v2)`. Compara el resultado para los
valores de la sección 3 con lo que muestra la gráfica.
"""

#%%
function mejor_cambio(s1, v1, s2, v2)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> [mejor_cambio(c...) for c in CASOS_REGIONES],
          [mejor_cambio_ref(c...) for c in CASOS_REGIONES];
          pista = md"Igual que en el ejercicio 3: evalúa `produccion_final_ref` en cada `tc` de la malla y devuelve el que da el máximo.")

#%% hide
md"""
### Interpretación

5. En la sección 1, ¿por qué el gobierno ahorra cuando ``y_1`` es pequeño y
   se endeuda cuando ``y_1`` es grande? ¿Qué papel juega ``\beta R``?
6. En la sección 2, ¿por qué la mejor tasa constante sube con ``\beta``?
   Describe con palabras una regla que cambie con el tiempo y que mejore a la
   mejor tasa constante.
7. En la sección 3, ¿qué pasa con el momento del cambio si el horizonte es
   más largo? ¿Y si la región 1 ahorra más y además produce más?
8. La política que maximiza el producto total puede dejar a una región sin
   inversión durante décadas. ¿Qué tendría que cambiar en el objetivo para
   que el planificador también se preocupe por la equidad?

### Tu tesis

9. Escribe un problema de tu tesis en el que una decisión de hoy cambie lo
   que se puede hacer después. Di cuál es el **estado**, cuál el **control**,
   cuál la **ecuación de movimiento** (aunque sea con palabras) y cuál el
   **objetivo**. Este problema es el punto de partida de tu propuesta de
   proyecto (sesión 12).

### [Avanzado]

10. Con ``\theta`` constante, el modelo de la sección 3 es un sistema lineal
    ``\dot K = MK``. Escribe la matriz ``M`` y verifica que la inversión
    total ``I`` crece a la tasa ``\theta\gamma_1 + (1 - \theta)\gamma_2``
    (notas, sección P.2).

## Para la próxima sesión

- **Sesión 2: Lagrange, concavidad y Kuhn-Tucker.** La versión estática del
  hilo conductor: repartir un fondo fijo entre dos regiones. Veremos cuándo
  conviene dar algo a cada región y cuánto vale un peso más en el fondo.
- Lectura: Chiang y Wainwright (2006), caps. 11–13.
- Repaso: C.B2, C.B5, C.I1–I2 y C.I5.
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
    using PlutoUI, Plots, LinearAlgebra, Markdown, CSV, DataFrames
    gr()
    default(size = (720, 320), legend = false, grid = :y, gridalpha = 0.15,
            framestyle = :axes, titlefontsize = 11, guidefontsize = 9,
            tickfontsize = 8, legendfontsize = 8, foreground_color_legend = nothing,
            background_color_legend = nothing, margin = 3Plots.mm)
end

#%%
begin
    const AZUL    = "#2a78d6"   # serie principal
    const NARANJA = "#eb6834"   # punto destacado, segunda serie
    const GRIS    = "#52514e"   # referencias
    const TINTA   = "#0b0b0b"   # valor elegido con el deslizador
    const PALETA  = [AZUL, NARANJA, "#1a9e77", "#7b5ea7", GRIS]
end;

#%%
begin
    entidades = CSV.read(joinpath(@__DIR__, "..", "Data", "entidades.csv"), DataFrame)
    # PIB sin petróleo por persona, en miles de pesos de 2018 (el PIB está en millones)
    entidades.pibpc = (entidades.pib .- entidades.pib_petrolero) ./ entidades.poblacion .* 1e3
    # Ciudad de México, Nuevo León, Coahuila, Oaxaca y Chiapas
    const CLAVES_EJEMPLO = [9, 19, 5, 20, 7]
end;

#%%
"Nombre corto de una entidad (sin \"de Zaragoza\", \"de Ignacio de la Llave\", etc.)."
nombre_corto(n) = replace(n, r" de (Zaragoza|Ocampo|Ignacio de la Llave)$" => "")

#%%
const INGRESO_HOY = 100.0

#%%
"Bienestar del problema de dos periodos: ln c₀ + β ln c₁, con c₁ = y₁ + R(y₀ − c₀)."
utilidad_dos_periodos(c0, y0, y1, β, R) = log(c0) + β * log(y1 + R * (y0 - c0))

#%%
"Gasto óptimo de hoy en el problema de dos periodos."
consumo_hoy_ref(y0, y1, β, R) = (y0 + y1 / R) / (1 + β)

#%%
begin
    const ALFA, DEPRECIACION, HORIZONTE = 0.3, 0.05, 40
    "Ecuación de movimiento del capital con tasa de inversión s."
    siguiente_capital_ref(K, s) = (1 - DEPRECIACION) * K + s * K^ALFA
end

#%%
"Capital (años 0 a T) y gasto (años 0 a T − 1) con una tasa de inversión constante s."
function trayectoria_ref(s; K0 = 1.0)
    K = zeros(HORIZONTE + 1)
    c = zeros(HORIZONTE)
    K[1] = K0
    for t in 1:HORIZONTE
        c[t] = (1 - s) * K[t]^ALFA
        K[t + 1] = siguiente_capital_ref(K[t], s)
    end
    K, c
end

#%%
"Bienestar ∑ βᵗ ln cₜ de una tasa de inversión constante s."
function bienestar_ref(s, β)
    c = trayectoria_ref(s)[2]
    sum(β^(t - 1) * log(c[t]) for t in eachindex(c))
end

#%%
"La mejor tasa de inversión constante en la malla 0:0.01:0.99."
function mejor_tasa_ref(β)
    ss = 0:0.01:0.99
    ss[argmax([bienestar_ref(s, β) for s in ss])]
end

#%%
const HORIZONTE_REGIONES = 30.0

#%%
"""
Capital (K₁, K₂) en el año t si se invierte todo en la región 1 hasta t_c y
todo en la región 2 después, con K₁(0) = K₂(0) = 1. Mientras toda la
inversión va a una región, el sistema es lineal y tiene solución exacta.
"""
function capital_cambio_ref(t, tc, s1, v1, s2, v2)
    g1, g2 = s1 * v1, s2 * v2
    K1, K2 = 1.0, 1.0
    t1 = min(t, tc)
    K1 = (K1 + g2 * K2 / g1) * exp(g1 * t1) - g2 * K2 / g1
    t <= tc && return (K1, K2)
    K2 = (K2 + g1 * K1 / g2) * exp(g2 * (t - tc)) - g1 * K1 / g2
    (K1, K2)
end

#%%
"Producto total v₁K₁(T) + v₂K₂(T) con cambio de región en t_c."
function produccion_final_ref(tc, s1, v1, s2, v2)
    K1, K2 = capital_cambio_ref(HORIZONTE_REGIONES, tc, s1, v1, s2, v2)
    v1 * K1 + v2 * K2
end

#%%
"Producto total en T si siempre se manda la fracción θ de la inversión a la región 1."
function produccion_fija_ref(θ, s1, v1, s2, v2)
    g1, g2 = s1 * v1, s2 * v2
    M = [θ*g1 θ*g2; (1 - θ)*g1 (1 - θ)*g2]
    K = exp(M * HORIZONTE_REGIONES) * [1.0, 1.0]
    v1 * K[1] + v2 * K[2]
end

#%%
"El mejor año de cambio en la malla 0:0.01:30."
function mejor_cambio_ref(s1, v1, s2, v2)
    tcs = 0:0.01:HORIZONTE_REGIONES
    tcs[argmax([produccion_final_ref(tc, s1, v1, s2, v2) for tc in tcs])]
end

#%%
begin
    # Casos de prueba de los ejercicios
    const CASOS_CAPITAL = [(1.0, 0.2), (5.0, 0.3), (0.5, 0.0), (10.0, 0.9)]
    const CASOS_DOS_PERIODOS = [(100.0, 50.0, 0.95, 1.05), (100.0, 150.0, 0.9, 1.1), (50.0, 0.0, 0.99, 1.0)]
    const CASOS_REGIONES = [(0.30, 0.25, 0.15, 0.35), (0.40, 0.20, 0.10, 0.45), (0.20, 0.30, 0.20, 0.40)]
end;

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
    cerca(a, b) = a isa Number && b isa Number && isapprox(a, b; rtol, atol = 1e-12)
    if pendiente(resultado)
        caja("warning", "Pendiente", md"Reemplaza `missing` por tu código.")
    elseif (resultado isa AbstractArray && size(resultado) == size(esperado) &&
            all(cerca.(resultado, esperado))) || cerca(resultado, esperado)
        caja("correct", "¡Correcto!", md"Bien hecho.")
    else
        caja("danger", "Todavía no", pista)
    end
end
