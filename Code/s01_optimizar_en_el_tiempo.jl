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

# ╔═╡ 6e8ad906-ce42-11f1-af7e-df6f12b6102d
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

# ╔═╡ 6e8ad80a-ce42-11f1-8b7e-af8d69536afc
md"""
# Sesión 1: Por qué optimizar en el tiempo

**Pregunta de la unidad.** ¿Cómo repartir un fondo de inversión entre dos
regiones?

**Objetivos de la sesión**
1. Distinguir un problema de optimización estático de uno dinámico: en el
   dinámico, lo que se decide hoy cambia lo que se puede hacer mañana.
2. Identificar los ingredientes de un problema dinámico: el estado, el
   control, la ecuación de movimiento y el objetivo.
3. Conocer el hilo conductor del curso, el reparto de la inversión entre dos
   regiones, y ver por qué su versión dinámica tiene una respuesta distinta
   de la estática.
4. Plantear con estos ingredientes un problema de tu tesis.

**Cómo usar este cuaderno.** Pluto es reactivo: al mover un deslizador, todo
lo que depende de él se recalcula. Las secciones marcadas **[Avanzado]** son
opcionales. Las definiciones y las demostraciones están en las notas
formales, `Class_notes/s01_optimizar_en_el_tiempo.md`.

**Cómo abrirlo.** Desde la raíz del repositorio:
`julia --project=Code -e 'using Pluto; Pluto.run()'` y abrir
`Code/s01_optimizar_en_el_tiempo.jl`.

**Antes de la sesión** resuelve el diagnóstico de matemáticas,
`Class_notes/repaso/diagnostico_inicial.md`: te dice qué claves del nivel
básico conviene repasar.
"""

# ╔═╡ 6e8ad85c-ce42-11f1-b288-43268b016e41
TableOfContents(title = "Contenido")

# ╔═╡ 6e8ad85c-ce42-11f1-8520-77a9b76a7bac
md"""
## 0. La pregunta: ¿se cierran solas las brechas entre regiones?

La gráfica muestra el PIB per cápita de cinco entidades entre 2003 y 2023,
sin contar la extracción de petróleo, en miles de pesos de 2018 por persona.
Los datos son del INEGI (PIB por entidad) y de la OCDE (población); están en
`Data/entidades.csv`.
"""

# ╔═╡ 6e8ad86e-ce42-11f1-9ae0-27800787a36f
md"""
La brecha entre la Ciudad de México y Chiapas no se cerró en veinte años: se
abrió. La Unidad II mide esto con todas las entidades (convergencia, sesión
5). La pregunta de este curso es otra: **si un gobierno puede invertir en
las regiones, ¿cómo debe hacerlo?** Invertir hoy en una región aumenta su
capital mañana, y con él lo que se podrá producir e invertir después. Ésa
es la marca de un problema **dinámico**.
"""

# ╔═╡ 6e8ad86e-ce42-11f1-8a87-9fff5543890b
md"""
## 1. Estático contra dinámico: ahorrar hoy para mañana

Un gobierno regional recibe ``y_0 = 100`` hoy y ``y_1`` mañana. Lo que no
gasta hoy lo invierte a una tasa bruta ``R`` (cada peso invertido rinde
``R`` pesos mañana). Gasta ``c_0`` hoy y ``c_1 = y_1 + R(y_0 - c_0)``
mañana, y valora el gasto con

```math
U = \ln c_0 + \beta \ln c_1 ,
```

donde ``\beta < 1`` es el **factor de descuento**: el bienestar de mañana
pesa menos que el de hoy.

Una regla sencilla es **gastar lo que entra**, ``c_0 = y_0``. Es la mejor
respuesta del problema estático "maximizar el bienestar de hoy con el
ingreso de hoy". Pero hoy y mañana están ligados por el ahorro, y la regla
sencilla no lo aprovecha.

Ingreso de mañana ``y_1``: $(@bind y1 Slider(0:10:200, default = 50, show_value = true))

Tasa bruta ``R``: $(@bind R Slider(1.00:0.01:1.20, default = 1.05, show_value = true))

Factor de descuento ``\beta``: $(@bind β Slider(0.80:0.01:0.99, default = 0.95, show_value = true))
"""

# ╔═╡ 6e8ad88e-ce42-11f1-8b59-77a6954f591f
md"""
## 2. Estado, control y ecuación de movimiento

Con más de dos periodos, la decisión de cada año cambia el capital con el
que empieza el siguiente. Una región produce ``y_t = K_t^{\alpha}`` con su
capital ``K_t``, invierte una fracción ``s`` del producto y gasta el resto:

```math
c_t = (1 - s)\thinspace y_t, \qquad
K_{t+1} = (1 - \kappa) K_t + s\thinspace y_t .
```

| Ingrediente | Aquí | Qué es |
|---|---|---|
| **Estado** | ``K_t`` | Lo que se hereda del pasado; no se puede cambiar de golpe |
| **Control** | ``s`` | Lo que se decide cada periodo |
| **Ecuación de movimiento** | ``K_{t+1} = (1 - \kappa)K_t + s K_t^{\alpha}`` | Cómo el control de hoy cambia el estado de mañana |
| **Objetivo** | ``\sum_{t=0}^{T-1} \beta^t \ln c_t`` | Lo que se quiere lograr, sumado en el tiempo |

Con ``\alpha = 0.3``, depreciación ``\kappa = 0.05``, ``K_0 = 1`` y
``T = 40`` años, mueve la tasa de inversión. El factor de descuento ``\beta``
es el de la sección 1.

Tasa de inversión ``s``: $(@bind s Slider(0.0:0.01:0.9, default = 0.5, show_value = true))
"""

# ╔═╡ 6e8ad898-ce42-11f1-8b3c-1f860f7fb6c9
md"""
Invertir poco da más gasto hoy y menos capital después; invertir mucho, lo
contrario. La mejor tasa **constante** equilibra las dos cosas, y sube cuando
``\beta`` sube: quien valora más el futuro invierte más.

Pero nada obliga a que la tasa sea constante. Mira el capital al final: en
el año 40 sobra capital que ya no se va a usar, porque el objetivo termina
ahí. Una regla que **cambia con el tiempo** (invertir al principio, gastar
al final) lo haría mejor. Encontrar la mejor regla que cambia con el tiempo
es exactamente el problema del control óptimo (Unidad III) y de la
programación dinámica (Unidad IV).
"""

# ╔═╡ 6e8ad8a2-ce42-11f1-a0fd-6d5cff12333f
md"""
## 3. El hilo conductor: invertir en una región o en otra

El curso vuelve tres veces a la misma pregunta:

| Sesión | Versión | Herramienta |
|---|---|---|
| 2 | Repartir un fondo fijo ``B`` hoy | Lagrange y Kuhn-Tucker |
| 14 | Repartir la inversión de cada momento durante ``T`` años | Principio del máximo |
| 17 | Lo mismo, año por año | Programación dinámica (extensión opcional) |

En la versión dinámica (Rahman, 1963; Intriligator, 1964), cada región
produce ``Y_i = v_i K_i`` y ahorra una fracción ``s_i`` de su producto. Toda
la inversión ``I = s_1 Y_1 + s_2 Y_2`` se junta, y el planificador manda una
fracción ``\delta`` a la región 1 y el resto a la región 2:

```math
\dot K_1 = \delta I, \qquad \dot K_2 = (1 - \delta) I, \qquad 0 \le \delta \le 1 .
```

El objetivo es el producto total al final del horizonte,
``Y(T) = v_1 K_1(T) + v_2 K_2(T)``. El **estado** es ``(K_1, K_2)`` y el
**control** es ``\delta``. Con ``\gamma_i = s_i v_i``, cada peso de capital
en la región ``i`` genera ``\gamma_i`` pesos de inversión al año.

Abajo, la región 1 **ahorra más** y la región 2 **produce más** con cada
peso de capital. Las dos empiezan con ``K_i(0) = 1`` y el horizonte es
``T = 30`` años. La política que se simula invierte todo en la región 1
hasta el año ``t_c`` y todo en la región 2 después.

Ahorro de la región 1, ``s_1``: $(@bind s₁ Slider(0.05:0.05:0.40, default = 0.30, show_value = true))

Productividad de la región 1, ``v_1``: $(@bind v₁ Slider(0.10:0.05:0.50, default = 0.25, show_value = true))

Ahorro de la región 2, ``s_2``: $(@bind s₂ Slider(0.05:0.05:0.40, default = 0.15, show_value = true))

Productividad de la región 2, ``v_2``: $(@bind v₂ Slider(0.10:0.05:0.50, default = 0.35, show_value = true))

Año del cambio, ``t_c``: $(@bind t_c Slider(0:1:30, default = 10, show_value = true))
"""

# ╔═╡ 6e8ad8c0-ce42-11f1-bc89-1b9924e0d695
md"""
## Resumen

| Concepto | Qué es | En la sesión |
|---|---|---|
| Problema dinámico | Lo que se decide hoy cambia lo que se puede hacer mañana | Ahorro de dos periodos |
| Estado | Lo que se hereda; no se puede cambiar de golpe | El capital ``K_t`` |
| Control | Lo que se decide cada periodo | La tasa de inversión ``s``, el reparto ``\delta`` |
| Ecuación de movimiento | Cómo el control cambia el estado | ``K_{t+1} = (1-\kappa)K_t + s y_t``; ``\dot K_1 = \delta I`` |
| Ecuación de Euler | Gastar hoy o invertir para mañana rinde lo mismo en el margen | ``1/c_0 = \beta R / c_1`` |
| Reglas que cambian en el tiempo | Pueden ser mejores que cualquier regla fija | Cambiar de región en ``t_c`` |
"""

# ╔═╡ 6e8ad8c0-ce42-11f1-883b-7ba433b89b98
md"""
## Ejercicios

### Completa el código

**1.** Escribe `siguiente_capital(K, s)`, la ecuación de movimiento de la
sección 2: devuelve ``(1 - \kappa) K + s K^{\alpha}`` con ``\alpha = 0.3`` y
``\kappa = 0.05``.
"""

# ╔═╡ 6e8ad8ca-ce42-11f1-894f-d191ec34029a
function siguiente_capital(K, s)
    missing  # reemplaza esta línea
end

# ╔═╡ 6e8ad8d4-ce42-11f1-a6e0-0fc18241a975
md"""
**2.** Escribe `gasto_hoy_optimo(y0, y1, β, R)`, el gasto óptimo de hoy en el
problema de dos periodos de la sección 1. Despeja ``c_0`` de la ecuación de
Euler ``1/c_0 = \beta R/c_1``, usando ``c_1 = y_1 + R(y_0 - c_0)``.
"""

# ╔═╡ 6e8ad8d4-ce42-11f1-a9a0-516f583eb6bb
function gasto_hoy_optimo(y0, y1, β, R)
    missing  # reemplaza esta línea
end

# ╔═╡ 6e8ad8e0-ce42-11f1-8473-45017e7315cf
md"""
**3.** Escribe `mejor_tasa(β)`, que busque en la malla `0:0.01:0.99` la tasa
de inversión constante con mayor bienestar. Usa la función
`bienestar_ref(s, β)`, que calcula ``\sum_t \beta^t \ln c_t`` para una tasa
``s``. El verificador la prueba con ``\beta = 0.9``, ``0.95`` y ``0.99``.
"""

# ╔═╡ 6e8ad8e0-ce42-11f1-bf58-83d9a879e5a6
function mejor_tasa(β)
    missing  # reemplaza esta línea
end

# ╔═╡ 6e8ad8e8-ce42-11f1-8f94-636b50f938fc
md"""
**4. [Avanzado]** Escribe `mejor_cambio(s1, v1, s2, v2)`, que busque en la
malla `0:0.01:30` el año de cambio con mayor producto final. Usa
`produccion_final_ref(tc, s1, v1, s2, v2)`. Compara el resultado para los
valores de la sección 3 con lo que muestra la gráfica.
"""

# ╔═╡ 6e8ad8f2-ce42-11f1-9a23-1f08951a41dd
function mejor_cambio(s1, v1, s2, v2)
    missing  # reemplaza esta línea
end

# ╔═╡ 6e8ad8fc-ce42-11f1-adde-bfd5bca96c19
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

10. Con ``\delta`` constante, el modelo de la sección 3 es un sistema lineal
    ``\dot K = MK``. Escribe la matriz ``M`` y verifica que la inversión
    total ``I`` crece a la tasa ``\delta\gamma_1 + (1 - \delta)\gamma_2``
    (notas, sección P.2).

## Para la próxima sesión

- **Sesión 2: Lagrange, concavidad y Kuhn-Tucker.** La versión estática del
  hilo conductor: repartir un fondo fijo entre dos regiones. Veremos cuándo
  conviene dar algo a cada región y cuánto vale un peso más en el fondo.
- Lectura: Chiang y Wainwright (2006), caps. 11–13.
- Repaso: C.B2, C.B5, C.I1–I2 y C.I5.
"""

# ╔═╡ 6e8ad8fc-ce42-11f1-a474-27b2dfa50aab
md"""
---
## Apéndice: paquetes y funciones auxiliares

Estas celdas definen herramientas que usa el cuaderno. No es necesario
leerlas para seguir la sesión.
"""

# ╔═╡ 6e8ad906-ce42-11f1-a522-fd6b90ad0374
begin
    const AZUL    = "#2a78d6"   # serie principal
    const NARANJA = "#eb6834"   # punto destacado, segunda serie
    const GRIS    = "#52514e"   # referencias
    const TINTA   = "#0b0b0b"   # valor elegido con el deslizador
    const PALETA  = [AZUL, NARANJA, "#1a9e77", "#7b5ea7", GRIS]
end;

# ╔═╡ 6e8ad912-ce42-11f1-8fe1-b9579217f61f
begin
    entidades = CSV.read(joinpath(@__DIR__, "..", "Data", "entidades.csv"), DataFrame)
    # PIB sin petróleo por persona, en miles de pesos de 2018 (el PIB está en millones)
    entidades.pibpc = (entidades.pib .- entidades.pib_petrolero) ./ entidades.poblacion .* 1e3
    # Ciudad de México, Nuevo León, Coahuila, Oaxaca y Chiapas
    const CLAVES_EJEMPLO = [9, 19, 5, 20, 7]
end;

# ╔═╡ 6e8ad912-ce42-11f1-a2f5-a54beac6bdd8
"Nombre corto de una entidad (sin \"de Zaragoza\", \"de Ignacio de la Llave\", etc.)."
nombre_corto(n) = replace(n, r" de (Zaragoza|Ocampo|Ignacio de la Llave)$" => "")

# ╔═╡ 6e8ad866-ce42-11f1-8630-fbca34454840
let
    p = plot(; xlabel = "año", ylabel = "miles de pesos de 2018 por persona",
             title = "PIB per cápita sin petróleo", legend = :outerright, size = (720, 340))
    for (clave, color) in zip(CLAVES_EJEMPLO, PALETA)
        t = filter(:clave => ==(clave), entidades)
        plot!(p, t.año, t.pibpc; lw = 2, color, label = nombre_corto(first(t.entidad)))
    end
    p
end

# ╔═╡ 6e8ad912-ce42-11f1-90c1-33b28f52309d
const INGRESO_HOY = 100.0

# ╔═╡ 6e8ad91a-ce42-11f1-b7f1-d3761dc12642
"Bienestar del problema de dos periodos: ln c₀ + β ln c₁, con c₁ = y₁ + R(y₀ − c₀)."
utilidad_dos_periodos(c0, y0, y1, β, R) = log(c0) + β * log(y1 + R * (y0 - c0))

# ╔═╡ 6e8ad91a-ce42-11f1-821f-81ea8d4c5ea6
"Gasto óptimo de hoy en el problema de dos periodos."
consumo_hoy_ref(y0, y1, β, R) = (y0 + y1 / R) / (1 + β)

# ╔═╡ 6e8ad884-ce42-11f1-89af-ff7fcb7e5411
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

# ╔═╡ 6e8ad884-ce42-11f1-8cda-9ba568ce55cc
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
    decir, $(accion) $(ar).

    En el óptimo se cumple la **ecuación de Euler**,

    ```math
    \frac{1}{c_0} = \beta R \frac{1}{c_1},
    ```

    que aquí vale $(izq) ``=`` $(der):
    el beneficio de gastar un peso más hoy es igual al de invertirlo y gastar
    ``R`` pesos mañana, descontados con ``\beta``. Esta condición reaparece en
    todo el curso (sesiones 10, 12 y 18).

    Prueba con ``\beta R`` cerca de 1 (por ejemplo, ``\beta = 0.95`` y
    ``R = 1.05``, que dan ``\beta R \approx 0.998``): ¿qué pasa con ``c_0`` y
    ``c_1``? ¿Y si ``y_1`` es muy grande?
    """
end

# ╔═╡ 6e8ad924-ce42-11f1-a2dc-59a881084eef
begin
    const ALFA, DEPRECIACION, HORIZONTE = 0.3, 0.05, 40
    "Ecuación de movimiento del capital con tasa de inversión s."
    siguiente_capital_ref(K, s) = (1 - DEPRECIACION) * K + s * K^ALFA
end

# ╔═╡ 6e8ad924-ce42-11f1-b739-2f402656e3d6
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

# ╔═╡ 6e8ad924-ce42-11f1-94e1-1b995626e052
"Bienestar ∑ βᵗ ln cₜ de una tasa de inversión constante s."
function bienestar_ref(s, β)
    c = trayectoria_ref(s)[2]
    sum(β^(t - 1) * log(c[t]) for t in eachindex(c))
end

# ╔═╡ 6e8ad898-ce42-11f1-8147-573cfa3d7eeb
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

# ╔═╡ 6e8ad92e-ce42-11f1-b0e8-6db137c557c8
"La mejor tasa de inversión constante en la malla 0:0.01:0.99."
function mejor_tasa_ref(β)
    ss = 0:0.01:0.99
    ss[argmax([bienestar_ref(s, β) for s in ss])]
end

# ╔═╡ 6e8ad88e-ce42-11f1-ab4f-9339f79f0fbd
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

# ╔═╡ 6e8ad92e-ce42-11f1-9bcc-992567cce947
const HORIZONTE_REGIONES = 30.0

# ╔═╡ 6e8ad938-ce42-11f1-839b-c75aaeae7aa5
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

# ╔═╡ 6e8ad8ac-ce42-11f1-9925-832cbec95187
let
    ts = range(0, HORIZONTE_REGIONES, length = 301)
    K = [capital_cambio_ref(t, t_c, s₁, v₁, s₂, v₂) for t in ts]
    p = plot(ts, first.(K); color = AZUL, lw = 2, label = "K₁ (ahorra más)",
             xlabel = "año", ylabel = "capital", title = "Capital de cada región, con cambio en t_c = $t_c",
             legend = :topleft)
    plot!(p, ts, last.(K); color = NARANJA, lw = 2, label = "K₂ (produce más)")
    vline!(p, [t_c]; color = GRIS, ls = :dot, label = "")
end

# ╔═╡ 6e8ad938-ce42-11f1-8208-db8d187df92a
"Producto total v₁K₁(T) + v₂K₂(T) con cambio de región en t_c."
function produccion_final_ref(tc, s1, v1, s2, v2)
    K1, K2 = capital_cambio_ref(HORIZONTE_REGIONES, tc, s1, v1, s2, v2)
    v1 * K1 + v2 * K2
end

# ╔═╡ 6e8ad8b6-ce42-11f1-899c-375703470277
let
    tcs = 0:0.1:HORIZONTE_REGIONES
    YT = [produccion_final_ref(tc, s₁, v₁, s₂, v₂) for tc in tcs]
    i = argmax(YT)
    # Dentro de md, $(...) sólo con nombres simples (ver la sección 1)
    ytodo2, ytodo1, ymejor = round.((YT[1], YT[end], YT[i]), digits = 2)
    tmejor = tcs[i]
    md"""
    Los extremos de la curva son las políticas sin cambio. Invertir todo en la
    región 2 siempre (``t_c = 0``) da un producto final de $(ytodo2); invertir
    todo en la región 1 siempre (``t_c = 30``) da $(ytodo1). Con estos valores, lo mejor
    es invertir en la región 1 hasta el año $(tmejor) y en la región 2
    después: producto final $(ymejor).

    **Primero se crece donde se ahorra más; al final se produce donde rinde
    más.** Al principio conviene la región que reinvierte más
    (``\gamma_1 > \gamma_2``), porque su capital genera más inversión para
    después. Cerca del final ya no hay tiempo de reinvertir, y conviene la
    región donde el capital produce más (``v_2 > v_1``). Un problema estático
    no puede ver esta tensión. En la sesión 14 el principio del máximo da la
    fórmula exacta del momento del cambio.

    Prueba con ``s_1 = s_2``: ¿sigue conviniendo cambiar? ¿Y si la región 1
    ahorra más **y** produce más?
    """
end

# ╔═╡ 6e8ad938-ce42-11f1-8341-f5a0047bb074
"Producto total en T si siempre se manda la fracción δ de la inversión a la región 1."
function produccion_fija_ref(δ, s1, v1, s2, v2)
    g1, g2 = s1 * v1, s2 * v2
    M = [δ*g1 δ*g2; (1 - δ)*g1 (1 - δ)*g2]
    K = exp(M * HORIZONTE_REGIONES) * [1.0, 1.0]
    v1 * K[1] + v2 * K[2]
end

# ╔═╡ 6e8ad8ac-ce42-11f1-90ec-b1245b92bd38
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

# ╔═╡ 6e8ad944-ce42-11f1-9d95-6592689fe229
"El mejor año de cambio en la malla 0:0.01:30."
function mejor_cambio_ref(s1, v1, s2, v2)
    tcs = 0:0.01:HORIZONTE_REGIONES
    tcs[argmax([produccion_final_ref(tc, s1, v1, s2, v2) for tc in tcs])]
end

# ╔═╡ 6e8ad944-ce42-11f1-b1a3-83a3791661ec
begin
    # Casos de prueba de los ejercicios
    const CASOS_CAPITAL = [(1.0, 0.2), (5.0, 0.3), (0.5, 0.0), (10.0, 0.9)]
    const CASOS_DOS_PERIODOS = [(100.0, 50.0, 0.95, 1.05), (100.0, 150.0, 0.9, 1.1), (50.0, 0.0, 0.99, 1.0)]
    const CASOS_REGIONES = [(0.30, 0.25, 0.15, 0.35), (0.40, 0.20, 0.10, 0.45), (0.20, 0.30, 0.20, 0.40)]
end;

# ╔═╡ 6e8ad944-ce42-11f1-a13b-1faa49395e4c
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

# ╔═╡ 6e8ad8ca-ce42-11f1-a5a9-cb523d13c9c5
verificar(() -> [siguiente_capital(K, s) for (K, s) in CASOS_CAPITAL],
          [siguiente_capital_ref(K, s) for (K, s) in CASOS_CAPITAL];
          pista = md"Devuelve `(1 - 0.05) * K + s * K^0.3`.")

# ╔═╡ 6e8ad8d4-ce42-11f1-aeaa-2fa4d6113313
verificar(() -> [gasto_hoy_optimo(c...) for c in CASOS_DOS_PERIODOS],
          [consumo_hoy_ref(c...) for c in CASOS_DOS_PERIODOS];
          pista = md"La ecuación de Euler da ``c_1 = \beta R c_0``. Sustituye en ``c_1 = y_1 + R(y_0 - c_0)`` y despeja: ``c_0 = (y_0 + y_1/R)/(1 + \beta)``.")

# ╔═╡ 6e8ad8e8-ce42-11f1-9d97-c78138f3c51b
verificar(() -> [mejor_tasa(b) for b in (0.9, 0.95, 0.99)],
          [mejor_tasa_ref(b) for b in (0.9, 0.95, 0.99)];
          pista = md"Con `ss = 0:0.01:0.99`, calcula `w = [bienestar_ref(s, β) for s in ss]` y devuelve `ss[argmax(w)]`.")

# ╔═╡ 6e8ad8f2-ce42-11f1-8df5-c3f15eade298
verificar(() -> [mejor_cambio(c...) for c in CASOS_REGIONES],
          [mejor_cambio_ref(c...) for c in CASOS_REGIONES];
          pista = md"Igual que en el ejercicio 3: evalúa `produccion_final_ref` en cada `tc` de la malla y devuelve el que da el máximo.")

# ╔═╡ Cell order:
# ╟─6e8ad80a-ce42-11f1-8b7e-af8d69536afc
# ╟─6e8ad85c-ce42-11f1-b288-43268b016e41
# ╟─6e8ad85c-ce42-11f1-8520-77a9b76a7bac
# ╟─6e8ad866-ce42-11f1-8630-fbca34454840
# ╟─6e8ad86e-ce42-11f1-9ae0-27800787a36f
# ╟─6e8ad86e-ce42-11f1-8a87-9fff5543890b
# ╟─6e8ad884-ce42-11f1-89af-ff7fcb7e5411
# ╟─6e8ad884-ce42-11f1-8cda-9ba568ce55cc
# ╟─6e8ad88e-ce42-11f1-8b59-77a6954f591f
# ╟─6e8ad88e-ce42-11f1-ab4f-9339f79f0fbd
# ╟─6e8ad898-ce42-11f1-8147-573cfa3d7eeb
# ╟─6e8ad898-ce42-11f1-8b3c-1f860f7fb6c9
# ╟─6e8ad8a2-ce42-11f1-a0fd-6d5cff12333f
# ╟─6e8ad8ac-ce42-11f1-9925-832cbec95187
# ╟─6e8ad8ac-ce42-11f1-90ec-b1245b92bd38
# ╟─6e8ad8b6-ce42-11f1-899c-375703470277
# ╟─6e8ad8c0-ce42-11f1-bc89-1b9924e0d695
# ╟─6e8ad8c0-ce42-11f1-883b-7ba433b89b98
# ╠═6e8ad8ca-ce42-11f1-894f-d191ec34029a
# ╟─6e8ad8ca-ce42-11f1-a5a9-cb523d13c9c5
# ╟─6e8ad8d4-ce42-11f1-a6e0-0fc18241a975
# ╠═6e8ad8d4-ce42-11f1-a9a0-516f583eb6bb
# ╟─6e8ad8d4-ce42-11f1-aeaa-2fa4d6113313
# ╟─6e8ad8e0-ce42-11f1-8473-45017e7315cf
# ╠═6e8ad8e0-ce42-11f1-bf58-83d9a879e5a6
# ╟─6e8ad8e8-ce42-11f1-9d97-c78138f3c51b
# ╟─6e8ad8e8-ce42-11f1-8f94-636b50f938fc
# ╠═6e8ad8f2-ce42-11f1-9a23-1f08951a41dd
# ╟─6e8ad8f2-ce42-11f1-8df5-c3f15eade298
# ╟─6e8ad8fc-ce42-11f1-adde-bfd5bca96c19
# ╟─6e8ad8fc-ce42-11f1-a474-27b2dfa50aab
# ╠═6e8ad906-ce42-11f1-af7e-df6f12b6102d
# ╠═6e8ad906-ce42-11f1-a522-fd6b90ad0374
# ╠═6e8ad912-ce42-11f1-8fe1-b9579217f61f
# ╠═6e8ad912-ce42-11f1-a2f5-a54beac6bdd8
# ╠═6e8ad912-ce42-11f1-90c1-33b28f52309d
# ╠═6e8ad91a-ce42-11f1-b7f1-d3761dc12642
# ╠═6e8ad91a-ce42-11f1-821f-81ea8d4c5ea6
# ╠═6e8ad924-ce42-11f1-a2dc-59a881084eef
# ╠═6e8ad924-ce42-11f1-b739-2f402656e3d6
# ╠═6e8ad924-ce42-11f1-94e1-1b995626e052
# ╠═6e8ad92e-ce42-11f1-b0e8-6db137c557c8
# ╠═6e8ad92e-ce42-11f1-9bcc-992567cce947
# ╠═6e8ad938-ce42-11f1-839b-c75aaeae7aa5
# ╠═6e8ad938-ce42-11f1-8208-db8d187df92a
# ╠═6e8ad938-ce42-11f1-8341-f5a0047bb074
# ╠═6e8ad944-ce42-11f1-9d95-6592689fe229
# ╠═6e8ad944-ce42-11f1-b1a3-83a3791661ec
# ╠═6e8ad944-ce42-11f1-a13b-1faa49395e4c
