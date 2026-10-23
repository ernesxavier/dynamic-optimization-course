#%% hide
md"""
# Sesión 14: Caso completo: inversión entre dos regiones

**Pregunta de la unidad.** ¿Conviene invertir primero donde se ahorra más o
donde se produce más?

**Objetivos de la sesión**
1. Resolver el modelo de Rahman, Intriligator y Takayama: precios sombra
   del capital de cada región, función de cambio y solución bang-bang.
2. Calcular el tiempo de cambio de forma analítica y numérica.
3. Comparar el reparto óptimo con repartos fijos.
4. Calibrar el modelo con dos estados de México y medir qué tan sensible es
   el resultado a las tasas de ahorro, que no se publican.
5. Cuantificar el costo de la equidad con pesos regionales.

**Cómo usar este cuaderno.** Pluto es reactivo: al mover un deslizador, todo
lo que depende de él se recalcula. Las secciones marcadas **[Avanzado]** son
opcionales. Las demostraciones están en las notas formales,
`Class_notes/s14_dos_regiones.md`.

**Cómo abrirlo.** Desde la raíz del repositorio:
`julia --project=Code -e 'using Pluto; Pluto.run()'` y abrir
`Code/s14_dos_regiones.jl`.

**Repaso recomendado** (en `Class_notes/repaso/`): C.B2, E.B2 (tasas de
crecimiento con datos), D.I2 (lineales de primer orden), N.I1 (bisección),
E.I3 (calibración) y N.I7 (datos en Julia). Para los puntos [Avanzado]:
E.A2 (sensibilidad de un modelo calibrado).
"""

#%% hide
TableOfContents(title = "Contenido")

#%% hide
md"""
## 1. El modelo

Cada región produce ``Y_i = v_iK_i`` y ahorra ``s_iY_i``. El ahorro nacional,
``S = \gamma_1K_1 + \gamma_2K_2`` con ``\gamma_i = s_iv_i``, se reparte:
``K_1' = \theta S`` y ``K_2' = (1 - \theta)S``, con ``\theta \in [0, 1]``. El
gobierno maximiza el producto nacional al final, ``Y(T) = v_1K_1(T) + v_2K_2(T)``.

El Hamiltoniano es lineal en ``\theta`` y la función de cambio es
``(p_1 - p_2)S``: se invierte donde el capital vale más. Los precios sombra
cumplen ``p_i' = -\gamma_i\max\{p_1, p_2\}`` con ``p_i(T) = v_i``. El cuaderno
los integra **hacia atrás** desde ``T`` y encuentra el cambio donde se
cruzan; después integra el capital hacia adelante. Ambas regiones empiezan
con ``K_i(0) = 1``.

Productividad del capital, región 1, ``v_1``: $(@bind v1 Slider(0.10:0.01:0.40, default = 0.20, show_value = true))

Productividad del capital, región 2, ``v_2``: $(@bind v2 Slider(0.10:0.01:0.40, default = 0.25, show_value = true))

Tasa de ahorro, región 1, ``s_1``: $(@bind s1 Slider(0.05:0.01:0.50, default = 0.30, show_value = true))

Tasa de ahorro, región 2, ``s_2``: $(@bind s2 Slider(0.05:0.01:0.50, default = 0.20, show_value = true))

Horizonte del plan, ``T``: $(@bind T Slider(5:1:50, default = 30, show_value = true))
"""

#%%
plan = resolver_rit(v1, v2, s1, s2, float(T))

#%% hide
graficar_plan(plan)

#%% hide
tabla_plan(plan)

#%% hide
md"""
Con los valores iniciales, la región 1 produce menos (``v_1 < v_2``) pero
ahorra tanto más que genera más ahorro por unidad de capital
(``\gamma_1 > \gamma_2``). El plan invierte primero en ella, para que el
fondo crezca, y cuando faltan ``\tau^\ast`` años cambia a la región 2,
donde el capital produce más. Baja ``s_1`` hasta que ``\gamma_1 < \gamma_2``:
la primera fase desaparece. Acorta ``T`` por debajo de ``\tau^\ast``: también.
"""

#%% hide
md"""
## 2. ¿Cuánto se gana con el reparto óptimo?

La alternativa más simple es un reparto fijo: una misma fracción ``\theta``
del fondo a la región 1 durante todo el plan. Con ``\theta`` fijo, el
capital sigue un sistema lineal, ``K' = MK``, y ``Y(T) = v^\top e^{MT}K(0)``
(sesión 7).
"""

#%% hide
let
    p = plan
    θs = range(0, 1, length = 101)
    Ys = [producto_fijo_ref(θ, p.v1, p.v2, p.s1, p.s2, p.T) for θ in θs]
    g = plot(θs, Ys; color = AZUL, lw = 2.5, xlabel = "fracción fija a la región 1, θ",
             ylabel = "Y(T)", title = "Repartos fijos contra el óptimo", size = (640, 320))
    hline!(g, [p.Y[end]]; color = NARANJA, lw = 2)
    i = argmax(Ys)
    scatter!(g, [θs[i]], [Ys[i]]; color = TINTA, ms = 5, msw = 0)
    g
end

#%% hide
let
    p = plan
    θs = range(0, 1, length = 101)
    Ys = [producto_fijo_ref(θ, p.v1, p.v2, p.s1, p.s2, p.T) for θ in θs]
    i = argmax(Ys)
    mitad = producto_fijo_ref(0.5, p.v1, p.v2, p.s1, p.s2, p.T)
    md"""
    El mejor reparto fijo (``\theta = `` $(round(θs[i], digits = 2))) da
    ``Y(T) = `` $(round(Ys[i], digits = 3)); repartir a la mitad da
    $(round(mitad, digits = 3)); el plan óptimo da $(round(p.Y[end], digits = 3))
    (línea naranja), $(round(100 * (p.Y[end] / Ys[i] - 1), digits = 1))% más que
    el mejor reparto fijo. Cuando hay cambio, ningún reparto fijo alcanza al
    óptimo: lo que importa no es cuánto recibe cada región, sino **cuándo**.
    """
end

#%% hide
md"""
## 3. Calibración: dos estados de México

Las productividades salen de los datos (INEGI y OCDE, 2023):
``v_i = \bar v\,(y_i/\bar y)^\phi``, donde ``y_i`` es el PIB sin minería
petrolera por trabajador y ``\bar v = 1/(K/Y) = 1/3.66`` (Penn World Table,
sesión 12). Con ``\phi = 1``, el capital por trabajador es el mismo en todos
los estados; con ``\phi < 1``, los estados ricos tienen más capital por
trabajador y las diferencias de ``v_i`` se reducen (notas, sección 5.1). Las
tasas de ahorro **no se publican por entidad**: se fijan con supuestos
alrededor de la tasa nacional (0.19).

Región 1: $(@bind e1 Select(OPCIONES_ESTADOS; default = 5))

Región 2: $(@bind e2 Select(OPCIONES_ESTADOS; default = 19))

Tasa de ahorro supuesta, región 1: $(@bind σ1 Slider(0.10:0.01:0.40, default = 0.25, show_value = true))

Tasa de ahorro supuesta, región 2: $(@bind σ2 Slider(0.10:0.01:0.40, default = 0.19, show_value = true))

Horizonte del plan: $(@bind Tm Slider(5:1:40, default = 20, show_value = true))

Cuánto de la diferencia de PIB por trabajador se atribuye a ``v_i``, ``\phi``: $(@bind φ Slider(0.0:0.1:1.0, default = 1.0, show_value = true))
"""

#%%
estados = productividades(CSV.read(joinpath(@__DIR__, "..", "Data", "entidades.csv"), DataFrame), 2023; φ)

#%%
mexico = resolver_rit(estados.v[e1], estados.v[e2], σ1, σ2, float(Tm);
                      nombres = (estados.entidad[e1], estados.entidad[e2]))

#%% hide
graficar_plan(mexico)

#%% hide
tabla_plan(mexico)

#%% hide
md"""
**¿Qué tan sensible es a las tasas de ahorro?** La gráfica muestra cuántos
años del plan se invierte en la región 1 según su tasa de ahorro, con la de
la región 2 fija en el valor del deslizador. La línea punteada es el umbral
``s_1 = s_2 v_2/v_1``: por debajo, si la región 1 es la menos productiva,
nunca recibe nada.
"""

#%% hide
let
    m = mexico
    ss = range(0.10, 0.45, length = 141)
    años = [años_region1(m.v1, m.v2, s, m.s2, m.T) for s in ss]
    g = plot(ss, años; color = AZUL, lw = 2.5, xlabel = "tasa de ahorro de $(m.nombres[1])",
             ylabel = "años", title = "Años de inversión en $(m.nombres[1])", size = (640, 320),
             ylims = (-0.5, m.T + 0.5))
    vline!(g, [m.s2 * m.v2 / m.v1]; color = GRIS, ls = :dot, lw = 1)
    scatter!(g, [m.s1], [años_region1(m.v1, m.v2, m.s1, m.s2, m.T)]; color = NARANJA, ms = 6, msw = 0)
    g
end

#%% hide
md"""
Con Coahuila y Nuevo León y ``\phi = 1``, Nuevo León produce 15% más por
unidad de capital. Coahuila sólo recibe inversión si ahorra más de 1.15
veces lo que ahorra
Nuevo León, y cerca de ese umbral la política salta de "nada" a "más de una
década". **La respuesta depende de un parámetro que no se mide.** Prueba
Chiapas y la Ciudad de México: Chiapas tendría que ahorrar más de cuatro
veces lo que ahorra la capital para recibir algo. El supuesto de capital
por trabajador igual exagera las diferencias de ``v_i`` (notas, sección
5.1).
"""

#%% hide
md"""
## 4. Equidad frente a eficiencia

El objetivo ``Y(T)`` sólo mira el total. Para incluir la equidad, se pesa el
producto de la región **menos productiva** con ``\omega \ge 1``:
``\max\ \omega Y_{\text{pobre}}(T) + Y_{\text{rica}}(T)``. El único cambio es
la transversalidad: ``p_i(T) = \omega_iv_i``. Con los estados y supuestos
de la sección 3:

Peso de la región menos productiva, ``\omega``: $(@bind ω Slider(1.0:0.05:3.0, default = 1.0, show_value = true))
"""

#%% hide
let
    m = mexico
    pobre = m.v1 <= m.v2 ? 1 : 2
    pesos(w) = pobre == 1 ? (w, 1.0) : (1.0, w)
    ws = range(1, 3, length = 81)
    planes = [resolver_rit(m.v1, m.v2, m.s1, m.s2, m.T; ω = pesos(w)) for w in ws]
    Ymax = m.Y[end]
    costo = [100 * (1 - p.Y[end] / Ymax) for p in planes]
    brecha = [p.Yi[end][pobre] / p.Yi[end][3 - pobre] for p in planes]
    g1 = plot(ws, costo; color = NARANJA, lw = 2.5, xlabel = "peso ω", ylabel = "% de Y(T)",
              title = "Costo de la equidad")
    vline!(g1, [ω]; color = GRIS, ls = :dot, lw = 1)
    g2 = plot(ws, brecha; color = AZUL, lw = 2.5, xlabel = "peso ω",
              ylabel = "Y pobre / Y rica en T", title = "Brecha al final del plan")
    vline!(g2, [ω]; color = GRIS, ls = :dot, lw = 1)
    plot(g1, g2; layout = (1, 2), size = (780, 320))
end

#%% hide
let
    m = mexico
    pobre = m.v1 <= m.v2 ? 1 : 2
    p = resolver_rit(m.v1, m.v2, m.s1, m.s2, m.T; ω = pobre == 1 ? (ω, 1.0) : (1.0, ω),
                     nombres = m.nombres)
    md"""
    Con ``\omega = `` $ω: $(describir_politica(p)) El producto nacional al
    final es $(round(100 * (1 - p.Y[end] / m.Y[end]), digits = 1))% menor que
    con el plan de eficiencia, y la región menos productiva produce
    $(round(100 * p.Yi[end][pobre] / p.Yi[end][3 - pobre], digits = 1))% de lo
    que produce la otra (con eficiencia:
    $(round(100 * m.Yi[end][pobre] / m.Yi[end][3 - pobre], digits = 1))%).

    Un peso mayor sube el precio sombra final del capital de la región menos
    productiva y mueve el tiempo de cambio a su favor. Cuando
    ``\omega v_{\text{pobre}} > v_{\text{rica}}``, también la última fase pasa
    a ella y la política salta. Elegir ``\omega`` es un juicio de valor; el
    modelo lo hace explícito y le pone precio.
    """
end

#%% hide
md"""
## 5. [Avanzado] El mapa de sensibilidad

Años de inversión en la región 1 para cada combinación de tasas de ahorro,
con las productividades y el horizonte de la sección 3. El punto es el
supuesto actual. La frontera entre "nada" y "algo" es la recta
``s_1/s_2 = v_2/v_1``, pero el número de años cambia rápido cerca de ella.
"""

#%% hide
let
    m = mexico
    ss = range(0.10, 0.40, length = 61)
    años = [años_region1(m.v1, m.v2, a, b, m.T) for b in ss, a in ss]
    g = heatmap(ss, ss, años; color = cgrad([:white, AZUL]), xlabel = "ahorro de $(m.nombres[1])",
                ylabel = "ahorro de $(m.nombres[2])", title = "Años de inversión en $(m.nombres[1])",
                colorbar = true, size = (600, 480), aspect_ratio = :equal, xlims = (0.1, 0.4),
                ylims = (0.1, 0.4))
    plot!(g, ss, ss .* m.v1 ./ m.v2; color = GRIS, ls = :dot, lw = 1)
    scatter!(g, [m.s1], [m.s2]; color = NARANJA, ms = 6, msw = 0)
    g
end

#%% hide
md"""
## Resumen

| Herramienta | Qué dice | En este cuaderno |
|---|---|---|
| Tasa interna de crecimiento | ``\gamma_i = s_iv_i``: ahorro por unidad de capital | Tablas |
| Precios sombra | ``p_i' = -\gamma_i\max\{p_1, p_2\}``, ``p_i(T) = v_i`` | Gráfica de la izquierda |
| Función de cambio | Se invierte donde el capital vale más | Reparto ``\theta(t)`` |
| Tiempo de cambio | ``\tau^\ast = \gamma_2^{-1}\ln\big(v_1(s_1 - s_2)/(\gamma_1 - \gamma_2)\big)`` | Analítico contra numérico |
| Repartos fijos | Ninguno alcanza al óptimo cuando hay cambio | Sección 2 |
| Calibración | ``v_i`` de los datos; ``s_i`` supuestos | Sección 3 |
| Equidad | Pesos ``\omega_i`` cambian la transversalidad | Sección 4 |

## Ejercicios

### Completa el código

**1.** Escribe `tau_cambio(v1, v2, s1, s2)`, los años antes del final en que
ocurre el cambio, suponiendo ``v_2 > v_1`` y ``\gamma_1 > \gamma_2``.
"""

#%%
tau_cambio(v1, v2, s1, s2) = missing  # reemplaza missing

#%% hide
verificar(() -> [tau_cambio(0.20, 0.25, 0.30, 0.20), tau_cambio(0.40, 0.461, 0.25, 0.19)],
          [20log(2), log(0.40 * 0.06 / (0.25 * 0.40 - 0.19 * 0.461)) / (0.19 * 0.461)];
          pista = md"Con `γ1 = s1 * v1` y `γ2 = s2 * v2`: `log(v1 * (s1 - s2) / (γ1 - γ2)) / γ2`.")

#%% hide
md"""
**2.** Escribe `s_umbral(v1, v2, s2)`, la tasa de ahorro mínima de la región
1 para que, siendo menos productiva, reciba inversión en algún momento.
"""

#%%
s_umbral(v1, v2, s2) = missing  # reemplaza missing

#%% hide
verificar(() -> [s_umbral(0.40, 0.461, 0.19), s_umbral(0.114, 0.530, 0.19)],
          [0.19 * 0.461 / 0.40, 0.19 * 0.530 / 0.114];
          pista = md"Hace falta ``\gamma_1 > \gamma_2``, es decir, ``s_1v_1 > s_2v_2``: `s2 * v2 / v1`.")

#%% hide
md"""
**3.** Escribe `producto_fijo(θ, v1, v2, s1, s2, T)`, el producto nacional
al final con un reparto fijo ``\theta`` y ``K_1(0) = K_2(0) = 1``. Usa la
exponencial de una matriz, `exp(M * T)`.
"""

#%%
producto_fijo(θ, v1, v2, s1, s2, T) = missing  # reemplaza missing

#%% hide
verificar(() -> [producto_fijo(0.5, 0.20, 0.25, 0.30, 0.20, 30.0), producto_fijo(1.0, 0.40, 0.461, 0.25, 0.19, 20.0)],
          [producto_fijo_ref(0.5, 0.20, 0.25, 0.30, 0.20, 30.0), producto_fijo_ref(1.0, 0.40, 0.461, 0.25, 0.19, 20.0)];
          rtol = 1e-6,
          pista = md"`M = [θ*s1*v1  θ*s2*v2; (1-θ)*s1*v1  (1-θ)*s2*v2]`; después `[v1 v2] * exp(M * T) * [1.0, 1.0]`, y toma el único elemento con `only` o `[1]`.")

#%% hide
md"""
**4. [Avanzado]** Escribe `tau_ponderado(v1, v2, s1, s2, ω1, ω2)`, el tiempo
de cambio con pesos (notas, ejercicio F4), suponiendo que la última fase es
en la región 2 (``\omega_2v_2 > \omega_1v_1``) y ``\gamma_1 > \gamma_2``.
"""

#%%
tau_ponderado(v1, v2, s1, s2, ω1, ω2) = missing  # reemplaza missing

#%% hide
verificar(() -> [tau_ponderado(0.20, 0.25, 0.30, 0.20, 1.0, 1.0), tau_ponderado(0.20, 0.25, 0.30, 0.20, 1.1, 1.0)],
          [resolver_rit(0.20, 0.25, 0.30, 0.20, 60.0).τ, resolver_rit(0.20, 0.25, 0.30, 0.20, 60.0; ω = (1.1, 1.0)).τ];
          rtol = 1e-3,
          pista = md"Igualando ``p_1 = p_2`` en la última fase: ``e^{\gamma_2\tau} = (\gamma_1\omega_2v_2 - \gamma_2\omega_1v_1)/(\omega_2v_2(\gamma_1 - \gamma_2))``.")

#%% hide
md"""
### Interpretación

5. En la sección 1, ¿por qué el plan invierte primero en la región que
   produce menos? ¿Qué pasaría si el objetivo fuera el producto en el año 1
   en lugar del año ``T``?
6. En la sección 3, ¿qué tasa de ahorro supondrías para cada estado y cómo
   la defenderías? ¿Con qué datos podrías acotarla?
7. En la sección 4, ¿a partir de qué peso cambia la política? ¿Qué le dirías
   a un gobierno que pregunta cuánto cuesta la equidad?

### Tu tesis

8. ¿Cuál es, en tu problema, el análogo del tiempo de cambio? ¿Qué
   parámetro de tu modelo no se mide directamente, y cómo mostrarías qué tan
   sensible es tu resultado a él?

### [Avanzado]

9. ¿Por qué no hay un segundo cambio? (Notas, sección 3.1.)
10. Si los estados ricos tienen más capital por trabajador, la diferencia
    real de ``v_i`` es menor que la calibrada. ¿Cómo cambiaría el umbral de
    ahorro y la política en la sección 3?

## Para la próxima sesión

- **Sesión 15: Ecuación de Bellman en horizonte finito.** Empieza la
  Unidad IV: la función valor, la inducción hacia atrás y el problema de la
  torta en tiempo discreto.
- Repaso: C.B3 (exponencial y logaritmo), A.B3 (series y descuento), A.I1
  a A.I3 (supremo, conjuntos compactos y teorema de Weierstrass) y N.I5
  (maximizar en una variable). Para los puntos [Avanzado]: L.A4 (cadenas de
  Markov).
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
    using PlutoUI, Plots, CSV, DataFrames, LinearAlgebra, Markdown
    gr()
    default(size = (720, 320), legend = false, grid = :y, gridalpha = 0.15,
            framestyle = :axes, titlefontsize = 11, guidefontsize = 9,
            tickfontsize = 8, legendfontsize = 8, foreground_color_legend = nothing,
            background_color_legend = nothing, margin = 3Plots.mm)
end

#%%
begin
    const AZUL    = "#2a78d6"   # región 1
    const NARANJA = "#eb6834"   # región 2
    const GRIS    = "#52514e"   # referencias
    const TINTA   = "#0b0b0b"   # reparto, producto total
end;

#%%
"""
Productividad del capital por entidad en el año dado: v_i = v̄ (y_i/ȳ)^φ,
con y_i el PIB sin minería petrolera por trabajador y v̄ = 1/(K/Y) de la PWT
(promedio 1990–2019, sesión 12). Con φ = 1, el capital por trabajador es el
mismo en todos los estados.
"""
function productividades(datos, año; KY = 3.66, φ = 1.0)
    d = sort(filter(r -> r.año == año, datos), :clave)
    y = (d.pib .- d.pib_petrolero) ./ d.empleo
    ybar = sum(d.pib .- d.pib_petrolero) / sum(d.empleo)
    (; entidad = String.(d.entidad), v = (y ./ ybar) .^ φ ./ KY)
end

#%%
"Opciones del selector de estados: clave => nombre, en el orden de las claves del INEGI."
const OPCIONES_ESTADOS = let
    d = CSV.read(joinpath(@__DIR__, "..", "Data", "entidades.csv"), DataFrame)
    u = unique(select(d, :clave, :entidad), :clave)
    sort!(u, :clave)
    [c => String(e) for (c, e) in zip(u.clave, u.entidad)]
end

#%%
"""
Resuelve el modelo de dos regiones. Los precios sombra se integran hacia
atrás desde p_i(T) = ω_i v_i con p_i' = -γ_i max(p₁, p₂) (RK4 por tramos); los
cambios se localizan donde p₁ - p₂ cambia de signo (interpolación lineal),
y el capital se integra hacia adelante con el reparto resultante.
"""
function resolver_rit(v1, v2, s1, s2, T; ω = (1.0, 1.0), n = 4000, nombres = ("Región 1", "Región 2"))
    γ = (s1 * v1, s2 * v2)
    dt = T / n
    t = collect(range(0, T, length = n + 1))
    P(p) = max(p[1], p[2])
    F(p) = [-γ[1] * P(p), -γ[2] * P(p)]
    p = Vector{Vector{Float64}}(undef, n + 1)
    p[end] = [ω[1] * v1, ω[2] * v2]
    for k in n:-1:1                       # hacia atrás: paso -dt
        z = p[k + 1]
        a = F(z); b = F(z .- dt / 2 .* a); c = F(z .- dt / 2 .* b); d = F(z .- dt .* c)
        p[k] = z .- dt / 6 .* (a .+ 2b .+ 2c .+ d)
    end
    dif = [q[1] - q[2] for q in p]
    θ = [d > 0 ? 1.0 : 0.0 for d in dif]
    cambios = Float64[]
    for k in 1:n
        if dif[k] * dif[k + 1] < 0          # cambio de signo estricto
            push!(cambios, t[k] + dt * dif[k] / (dif[k] - dif[k + 1]))
        end
    end
    # Capital hacia adelante: exacto en cada paso, con el reparto del inicio del paso
    K = Vector{Vector{Float64}}(undef, n + 1)
    K[1] = [1.0, 1.0]
    for k in 1:n
        M = [θ[k] * γ[1] θ[k] * γ[2]; (1 - θ[k]) * γ[1] (1 - θ[k]) * γ[2]]
        K[k + 1] = exp(M * dt) * K[k]
    end
    Yi = [[v1 * k[1], v2 * k[2]] for k in K]
    # Tiempo de cambio analítico (sin pesos, caso v2 > v1 y γ1 > γ2, o el simétrico)
    τ = if γ[1] > γ[2] && ω[2] * v2 > ω[1] * v1
        log((γ[1] * ω[2] * v2 - γ[2] * ω[1] * v1) / (ω[2] * v2 * (γ[1] - γ[2]))) / γ[2]
    elseif γ[2] > γ[1] && ω[1] * v1 > ω[2] * v2
        log((γ[2] * ω[1] * v1 - γ[1] * ω[2] * v2) / (ω[1] * v1 * (γ[2] - γ[1]))) / γ[1]
    else
        Inf
    end
    (; v1, v2, s1, s2, T, γ, ω, nombres, t, p, θ, cambios, τ, K, Yi, Y = sum.(Yi))
end

#%%
"""
Años del plan en que se invierte en la región 1, con la solución analítica
(notas, sección 3): la última fase es en la región con mayor v; antes, en la
de mayor γ, si el horizonte alcanza.
"""
function años_region1(v1, v2, s1, s2, T)
    γ1, γ2 = s1 * v1, s2 * v2
    if v2 > v1                           # al final, región 2
        γ1 > γ2 || return 0.0
        τ = log(v1 * (s1 - s2) / (γ1 - γ2)) / γ2
        max(0.0, T - τ)
    else                                 # al final, región 1
        γ2 > γ1 || return float(T)
        τ = log(v2 * (s2 - s1) / (γ2 - γ1)) / γ1
        min(float(T), τ)
    end
end

#%%
"Descripción en palabras de la política óptima."
function describir_politica(r)
    a, b = r.nombres
    primero = r.θ[1] == 1 ? a : b
    if isempty(r.cambios)
        "toda la inversión va a $primero durante todo el plan."
    else
        segundo = primero == a ? b : a
        "toda la inversión va a $primero hasta el año $(round(r.cambios[1], digits = 1)) y después a $segundo."
    end
end

#%%
"Gráficas de un plan: precios sombra, reparto y capital."
function graficar_plan(r)
    a, b = r.nombres
    g1 = plot(r.t, first.(r.p); color = AZUL, lw = 2.5, xlabel = "años", ylabel = "precio sombra",
              title = "Precios sombra del capital", label = a, legend = :topright)
    plot!(g1, r.t, last.(r.p); color = NARANJA, lw = 2.5, label = b)
    g2 = plot(r.t, r.θ; color = TINTA, lw = 2.5, xlabel = "años", ylabel = "θ(t)",
              title = "Fracción a $(a)", ylims = (-0.1, 1.1), linetype = :steppost)
    g3 = plot(r.t, first.(r.K); color = AZUL, lw = 2.5, xlabel = "años", ylabel = "capital",
              title = "Capital", label = a, legend = :topleft)
    plot!(g3, r.t, last.(r.K); color = NARANJA, lw = 2.5, label = b)
    for g in (g1, g2, g3), c in r.cambios
        vline!(g, [c]; color = GRIS, ls = :dot, lw = 1, label = "")
    end
    plot(g1, g2, g3; layout = (1, 3), size = (880, 310))
end

#%%
"Tabla de resultados de un plan."
function tabla_plan(r)
    a, b = r.nombres
    rd(x, d = 3) = round(x, digits = d)
    analitico = isfinite(r.τ) ? (r.τ < r.T ? string(rd(r.T - r.τ, 2)) : "ninguno (τ* = $(rd(r.τ, 1)) ≥ T)") : "ninguno"
    numerico = isempty(r.cambios) ? "ninguno" : string(rd(r.cambios[1], 2))
    Markdown.parse("""
    | | $a | $b |
    |:---|---:|---:|
    | Productividad del capital, ``v_i`` | $(rd(r.v1)) | $(rd(r.v2)) |
    | Tasa de ahorro, ``s_i`` | $(rd(r.s1, 2)) | $(rd(r.s2, 2)) |
    | Tasa interna de crecimiento, ``\\gamma_i = s_iv_i`` | $(rd(r.γ[1], 4)) | $(rd(r.γ[2], 4)) |
    | Producto al final, ``Y_i(T)`` | $(rd(r.Yi[end][1])) | $(rd(r.Yi[end][2])) |

    **Política óptima:** $(describir_politica(r))

    Tiempo de cambio ``t^\\ast``: analítico, $analitico; numérico, $numerico.
    Producto nacional al final: ``Y(T) = `` $(rd(r.Y[end])).
    """)
end

#%%
"Producto nacional al final con un reparto fijo θ y K(0) = (1, 1)."
function producto_fijo_ref(θ, v1, v2, s1, s2, T)
    M = [θ * s1 * v1 θ * s2 * v2; (1 - θ) * s1 * v1 (1 - θ) * s2 * v2]
    dot([v1, v2], exp(M * T) * [1.0, 1.0])
end

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
