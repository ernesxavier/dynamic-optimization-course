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

# ╔═╡ c0144eb6-cf04-11f1-af45-c12aac17679e
begin
    # Usa el entorno del curso (Code/Project.toml) en lugar del gestor de
    # paquetes propio de Pluto: un solo entorno para todo el repositorio.
    import Pkg
    Pkg.activate(@__DIR__)
    Pkg.instantiate()
    using PlutoUI, Plots, Symbolics, LinearAlgebra, Markdown
    gr()
    default(size = (720, 320), legend = false, grid = :y, gridalpha = 0.15,
            framestyle = :axes, titlefontsize = 11, guidefontsize = 9,
            tickfontsize = 8, legendfontsize = 8, foreground_color_legend = nothing,
            background_color_legend = nothing, margin = 3Plots.mm)
end

# ╔═╡ c0144d4e-cf04-11f1-9dd4-a3d6bd695e03
md"""
# Sesión 3: Envolvente y estática comparativa

**Pregunta de la unidad.** Un gobierno tiene un fondo ``B`` para invertir en
dos regiones. ¿Cómo debe repartirlo?

**Cómo usar este cuaderno.** La teoría está en las notas,
`Class_notes/s03_envolvente.md`, y se desarrolla en el pizarrón; el
cuaderno sirve para mover los parámetros, ver qué pasa y comprobar las
fórmulas numéricamente. En clase se proyectan las secciones 0 a 3. Tú lo
abres después del Laboratorio 0 (sesión 4), cuando ya tengas Julia
instalado: entonces repasa todas las secciones y resuelve los ejercicios.
Pluto es reactivo: al mover un deslizador, todo lo que depende de él se
recalcula.

**Cómo abrirlo.** Desde la raíz del repositorio:
`julia --project=Code -e 'using Pluto; Pluto.run()'` y abrir
`Code/s03_envolvente.jl`.
"""

# ╔═╡ c0144d8a-cf04-11f1-af81-93ce6d224958
TableOfContents(title = "Contenido")

# ╔═╡ c0144d94-cf04-11f1-b9dc-479fcc88deb2
md"""
## 0. La pregunta: ¿qué pasa si una región mejora?

*En clase, al inicio.* El problema de la sesión 2: cada peso en la región
``i`` produce ``a_i\ln(1 + x_i)`` y el fondo ``B`` se reparte entre las dos.
La gráfica muestra el reparto óptimo para cada productividad ``a_2`` de la
región 2.

``a_1`` (productividad de la región 1): $(@bind a1 Slider(1.0:0.1:4.0, default = 2.0, show_value = true))

``a_2`` (productividad de la región 2): $(@bind a2 Slider(0.2:0.1:1.0, default = 1.0, show_value = true))

Fondo ``B``: $(@bind B Slider(0.1:0.1:10.0, default = 4.0, show_value = true))
"""

# ╔═╡ c0144db2-cf04-11f1-9b31-93236330e4d8
md"""
**Observa** los dos tramos: mientras ``a_2`` es bajo, la región 2 no recibe
nada; después, cada mejora le da más y la región 1 recibe lo mismo de menos.
¿Cuál es la pendiente de esas curvas, sin resolver el problema? Es la
pregunta de la clase.
"""

# ╔═╡ c0144dbc-cf04-11f1-bffd-89b472cba12f
md"""
## 1. Una región: la función implícita

*En clase, después de la sección 2.3 de las notas.* En
``\max_x a\ln(1 + x) - px``, el óptimo está donde el producto marginal
(azul) cruza el precio (naranja). La curva punteada es el producto marginal
con ``a`` un 20% mayor.

Productividad ``a``: $(@bind a0 Slider(1.0:0.1:3.0, default = 2.0, show_value = true))

Precio ``p``: $(@bind p Slider(0.2:0.05:1.5, default = 0.5, show_value = true))
"""

# ╔═╡ c0144dd0-cf04-11f1-8499-f95940fef354
md"""
Symbolics.jl calcula las derivadas parciales y los cocientes de la función
implícita:
"""

# ╔═╡ c0144dda-cf04-11f1-abbd-7b2e814cd388
let
    @variables x a p
    F = a / (1 + x) - p
    Fx = Symbolics.derivative(F, x)
    (dx_da = simplify(-Symbolics.derivative(F, a) / Fx),
     dx_dp = simplify(-Symbolics.derivative(F, p) / Fx))
end

# ╔═╡ c0144de4-cf04-11f1-a7ce-e5f87ce17935
md"""
## 2. Dos regiones: un sistema y la regla de Cramer

*En clase, después de la sección 3.3 de las notas.* Symbolics.jl construye
las dos matrices del sistema, ``D_zF`` y ``\partial F/\partial\alpha``, a
partir de las condiciones de primer orden:
"""

# ╔═╡ c0144dee-cf04-11f1-b6ab-79de68175005
let
    @variables x₁ x₂ λ α₁ α₂ b
    F = [α₁ / (1 + x₁) - λ, α₂ / (1 + x₂) - λ, b - x₁ - x₂]
    (D_z = Symbolics.jacobian(F, [x₁, x₂, λ]),
     D_param = Symbolics.jacobian(F, [α₁, α₂, b]))
end

# ╔═╡ c0144e04-cf04-11f1-83fc-f9040f3f338d
md"""
**El cambio de régimen** (notas, 3.4). Reparto óptimo según el fondo; los
segmentos cortos tienen la pendiente que da la regla de Cramer en el ``B``
elegido, y la línea punteada es el umbral ``\bar B``.
"""

# ╔═╡ c0144e16-cf04-11f1-bf81-7b619944e0fe
md"""
**Mueve** ``B`` a uno y otro lado del umbral. **Observa** la pendiente de
``x_1``: 1 a la izquierda, ``a_1/(a_1 + a_2)`` a la derecha, y un pico en
``\bar B``, donde la función implícita no vale.
"""

# ╔═╡ c0144e16-cf04-11f1-aadb-3f9ccde8015e
md"""
## 3. El teorema de la envolvente

*En clase, después de la sección 4.3 de las notas.* En el problema de una
región, cada inversión fija ``\bar x`` da una recta en ``p`` (gris), de
pendiente ``-\bar x``. ``V(p)`` (azul) es su envolvente superior, y la recta
de la inversión óptima (naranja) la toca: ``V'(p) = -x^\ast(p)``.
"""

# ╔═╡ c0144e2a-cf04-11f1-b0db-afe61b8a0f13
md"""
**Mueve** ``p`` en la sección 1. **Observa** que la recta naranja siempre es
tangente a ``V``, y que ``V`` es convexa (notas, P.2).

**La envolvente del reparto.** Lo mismo con dos regiones: cada reparto fijo
da una recta en ``a_2`` de pendiente ``\ln(1 + \bar x_2)``, y ``V(a_2)`` es su
envolvente.
"""

# ╔═╡ c0144e48-cf04-11f1-b2fb-a7c5a3217891
md"""
## 4. Comparar políticas

*Fuera de clase* (notas, 4.5). Cuánto vale un programa que eleva ``a_2`` en
``\Delta``, en pesos del fondo: la aproximación de la envolvente contra el
cambio exacto.

Mejora de la productividad de la región 2, ``\Delta``: $(@bind Δ Slider(0.05:0.05:0.5, default = 0.1, show_value = true))
"""

# ╔═╡ c0144e5c-cf04-11f1-8150-d56b2787d3f0
md"""
## Ejercicios

*Tarea de la semana del Laboratorio 0 (sesión 4).* Los ejercicios con demostraciones
están en las notas (sección 7).

### Completa el código

**1.** Escribe `efecto_a1(a1, a2, B)`, que devuelva el vector
`[dx1, dx2, dλ]` de derivadas respecto de ``a_1`` en el régimen interior.
Construye la matriz ``D_zF`` y el lado derecho ``-\partial F/\partial a_1``, y
resuelve el sistema con `D \ b` (o con la regla de Cramer). Puedes usar
`reparto_ref(a1, a2, B)` para obtener ``(x_1, x_2, \lambda)``.
"""

# ╔═╡ c0144e5c-cf04-11f1-853a-b7f520271ffe
function efecto_a1(a1, a2, B)
    missing  # reemplaza esta línea
end

# ╔═╡ c0144e70-cf04-11f1-b0ba-e1a0dd5539d3
md"""
**2.** Escribe `valor_marginal(a1, a2, B)`, que devuelva el vector
``[\partial V/\partial a_1,\ \partial V/\partial a_2,\ \partial V/\partial B]``
usando el teorema de la envolvente. Debe funcionar en los dos regímenes.
"""

# ╔═╡ c0144e7a-cf04-11f1-a5f8-1501b10a8051
function valor_marginal(a1, a2, B)
    missing  # reemplaza esta línea
end

# ╔═╡ c0144e84-cf04-11f1-b8db-29aa53a482f7
md"""
**3. [Avanzado]** En el modelo de Ramsey (sesión 12), el capital de estado
estacionario cumple ``f'(k^\ast) = \rho + \delta`` con ``f(k) = k^\alpha``.
Escribe `dk_drho(α, ρ, δ)`, que devuelva ``dk^\ast/d\rho`` con el teorema de
la función implícita (notas, ejercicio F3). Puedes calcular ``k^\ast`` con su
fórmula cerrada, ``k^\ast = \big(\alpha/(\rho + \delta)\big)^{1/(1 - \alpha)}``.
"""

# ╔═╡ c0144e8e-cf04-11f1-8d77-310273479edc
function dk_drho(α, ρ, δ)
    missing  # reemplaza esta línea
end

# ╔═╡ c0144ea2-cf04-11f1-ad13-17cdbb576515
md"""
### Interpretación

4. Con ``a_1 = 2``, ``a_2 = 1`` y ``B = 4``, ¿qué región recibe la mayor parte
   de un peso adicional del fondo? ¿Por qué no lo recibe todo la más
   productiva?
5. ¿Por qué ``\partial x_1^\ast/\partial a_2 = -\partial x_2^\ast/\partial a_2``?
   ¿Seguiría siendo así si el fondo no se agotara?
6. Explica con la gráfica de la sección 3 por qué una mejora pequeña de la
   productividad de una región que no recibe fondos no vale nada al margen.
   ¿Qué implica para una política que sólo mejora la productividad de las
   regiones rezagadas, sin darles fondos?
7. En la sección 4, ¿por qué el cambio exacto es mayor que la aproximación de
   la envolvente? (Pista: ¿de qué forma es ``V(a_2)``?)
8. **[Avanzado]** Con el resultado del ejercicio 3, ¿una región más
   impaciente (``\rho`` mayor) acumula más o menos capital en el estado
   estacionario? ¿Y una con más depreciación?

## Para la próxima sesión

- **Sesión 4: Laboratorio 0.** Julia con Pluto.jl y Symbolics.jl: resolver
  con Symbolics las condiciones de primer orden del problema de las dos
  regiones y graficar ``V(B)`` y ``\lambda(B)``. Trae el entorno instalado
  (ver el `README.md` del repositorio).
- Repaso: N.B1 a N.B4 (Julia, gráficas, Pluto y punto flotante) y N.I2
  (Symbolics.jl).
"""

# ╔═╡ c0144eac-cf04-11f1-86e4-050b51fe8be5
md"""
---
## Apéndice: paquetes y funciones auxiliares

Estas celdas definen herramientas que usa el cuaderno. No es necesario
leerlas para seguir la sesión.
"""

# ╔═╡ c0144ec0-cf04-11f1-8db1-eb59bb4eb16f
begin
    const AZUL    = "#2a78d6"   # serie principal
    const NARANJA = "#eb6834"   # segunda serie, recta tangente
    const GRIS    = "#52514e"   # referencias
    const TINTA   = "#0b0b0b"   # óptimo
end;

# ╔═╡ c0144ec0-cf04-11f1-8b12-c16db39b0754
"Inversión óptima de una región con precio p: max a ln(1 + x) − px, con x ≥ 0."
inversion_una(a, p) = max(a / p - 1, 0.0)

# ╔═╡ c0144dc6-cf04-11f1-a7b3-731bf955544d
let
    xs = range(0, 12, length = 300)
    x0, x20 = inversion_una(a0, p), inversion_una(1.2a0, p)
    q = plot(xs, a0 ./ (1 .+ xs); color = AZUL, lw = 2, ylims = (0, 2),
             xlabel = "inversión x", ylabel = "producto marginal",
             title = "Condición de primer orden: a/(1 + x) = p")
    plot!(q, xs, 1.2a0 ./ (1 .+ xs); color = AZUL, lw = 1.5, ls = :dash)
    hline!(q, [p]; color = NARANJA, lw = 2)
    scatter!(q, [x0, x20], [p, p]; color = [TINTA, GRIS], ms = 6, msw = 0)
    annotate!(q, x0 + 0.2, p - 0.1, text("x* = $(round(x0, digits = 2))", 8, :left, TINTA))
end

# ╔═╡ c0144ec8-cf04-11f1-9f87-255a0b382d8c
"Valor óptimo de una región con precio p."
valor_una(a, p) = (x = inversion_una(a, p); a * log1p(x) - p * x)

# ╔═╡ c0144e20-cf04-11f1-af9f-d9ace2b39e07
let
    ps = range(0.1, 2.5, length = 400)
    q = plot(ps, valor_una.(a0, ps); color = AZUL, lw = 3, ylims = (-0.5, 3.5),
             xlabel = "precio p", ylabel = "valor", size = (620, 360),
             title = "V(p) es la envolvente de las rectas con x fija")
    for c in range(0.15, 1.8, length = 12)
        x̄ = inversion_una(a0, c)
        plot!(q, ps, a0 * log1p(x̄) .- ps .* x̄; color = GRIS, lw = 0.7, alpha = 0.6)
    end
    x0 = inversion_una(a0, p)
    plot!(q, ps, a0 * log1p(x0) .- ps .* x0; color = NARANJA, lw = 2)
    scatter!(q, [p], [valor_una(a0, p)]; color = TINTA, ms = 6, msw = 0)
end

# ╔═╡ c0144ed4-cf04-11f1-bfdf-b15a327b9c2d
"Producto total de las dos regiones: a₁ ln(1 + x₁) + a₂ ln(1 + x₂)."
producto(x1, x2, a1, a2) = a1 * log1p(x1) + a2 * log1p(x2)

# ╔═╡ c0144ede-cf04-11f1-a00c-8fcb07edb331
"Umbral del fondo a partir del cual la región menos productiva recibe inversión."
umbral(a1, a2) = max(a1, a2) / min(a1, a2) - 1

# ╔═╡ c0144ede-cf04-11f1-9e0a-c9f43e5d087a
"Reparto óptimo con Kuhn-Tucker: (x₁, x₂, λ). Funciona con cualquier orden de a₁ y a₂."
function reparto_ref(a1, a2, B)
    if a1 < a2
        r = reparto_ref(a2, a1, B)
        return (r[2], r[1], r[3])
    end
    B <= umbral(a1, a2) && return (B, 0.0, a1 / (1 + B))
    λ = (a1 + a2) / (B + 2)
    (a1 / λ - 1, a2 / λ - 1, λ)
end

# ╔═╡ c0144d9e-cf04-11f1-a013-c119638ffee4
let
    a2s = range(0.2, a1, length = 300)
    reps = [reparto_ref(a1, b, B) for b in a2s]
    p = plot(a2s, first.(reps); color = AZUL, lw = 2, label = "región 1, x₁",
             legend = :left, xlabel = "productividad de la región 2, a₂",
             ylabel = "inversión", title = "Reparto óptimo del fondo B = $B")
    plot!(p, a2s, getindex.(reps, 2); color = NARANJA, lw = 2, label = "región 2, x₂")
    x1, x2, _ = reparto_ref(a1, a2, B)
    scatter!(p, [a2, a2], [x1, x2]; color = TINTA, ms = 5, msw = 0, label = "")
end

# ╔═╡ c0144ee8-cf04-11f1-9e58-c328190f6e83
"Valor óptimo V(a₁, a₂, B): el producto total con el reparto óptimo."
function valor_ref(a1, a2, B)
    x1, x2, _ = reparto_ref(a1, a2, B)
    producto(x1, x2, a1, a2)
end

# ╔═╡ c0144e36-cf04-11f1-8031-a382e6ca6a82
let
    a2s = range(0.2, 2.5, length = 400)
    q = plot(a2s, [valor_ref(a1, b, B) for b in a2s]; color = AZUL, lw = 3,
             xlabel = "productividad de la región 2, a₂", ylabel = "producto total",
             size = (620, 360), title = "V(a₂) es la envolvente de los repartos fijos")
    for x̄1 in range(0, B, length = 12)
        plot!(q, a2s, a1 * log1p(x̄1) .+ a2s .* log1p(B - x̄1); color = GRIS, lw = 0.7, alpha = 0.6)
    end
    x1, x2, _ = reparto_ref(a1, a2, B)
    plot!(q, a2s, a1 * log1p(x1) .+ a2s .* log1p(x2); color = NARANJA, lw = 2)
    scatter!(q, [a2], [valor_ref(a1, a2, B)]; color = TINTA, ms = 6, msw = 0)
end

# ╔═╡ c0144e52-cf04-11f1-825f-6d44faea02b1
let
    x1, x2, λ = reparto_ref(a1, a2, B)
    aprox = Δ * log1p(x2)
    exacto = valor_ref(a1, a2 + Δ, B) - valor_ref(a1, a2, B)
    r(v) = round(v, digits = 4) + 0.0
    md"""
    | | Valor |
    |:---|---:|
    | Un peso más en el fondo, ``\lambda`` | $(r(λ)) |
    | Programa, aproximación de la envolvente, ``\Delta\ln(1 + x_2^\ast)`` | $(r(aprox)) |
    | Programa, cambio exacto ``V(a_2 + \Delta) - V(a_2)`` | $(r(exacto)) |
    | Equivalente del programa en pesos del fondo, ``\Delta\ln(1 + x_2^\ast)/\lambda`` | $(r(aprox / λ)) |

    **Mueve** ``\Delta`` y ``B``. **Observa:** ¿cuándo se separan la
    aproximación y el cambio exacto? ¿Qué pasa cuando la región 2 está en la
    esquina?
    """
end

# ╔═╡ c0144ef2-cf04-11f1-a7eb-effbf2c1c5bf
"""
Derivadas de (x₁, x₂, λ) (filas) respecto de (a₁, a₂, B) (columnas), por la
función implícita aplicada a las condiciones activas del régimen.
"""
function estatica_ref(a1, a2, B)
    x1, x2, _ = reparto_ref(a1, a2, B)
    J, Fα = zeros(3, 3), zeros(3, 3)
    for (i, x, a) in ((1, x1, a1), (2, x2, a2))
        if x > 0                 # condición de primer orden: a/(1 + x) − λ = 0
            J[i, i], J[i, 3], Fα[i, i] = -a / (1 + x)^2, -1.0, 1 / (1 + x)
        else                     # la región no recibe: x = 0
            J[i, i] = 1.0
        end
    end
    J[3, 1], J[3, 2], Fα[3, 3] = -1.0, -1.0, 1.0   # B − x₁ − x₂ = 0
    -(J \ Fα)
end

# ╔═╡ c0144e0c-cf04-11f1-ba95-afc4b8ecef09
let
    Bs = range(0.01, 10, length = 400)
    reps = [reparto_ref(a1, a2, b) for b in Bs]
    q = plot(Bs, first.(reps); color = AZUL, lw = 2, label = "región 1, x₁",
             legend = :topleft, xlabel = "fondo B", ylabel = "inversión",
             title = "Reparto óptimo según el fondo")
    plot!(q, Bs, getindex.(reps, 2); color = NARANJA, lw = 2, label = "región 2, x₂")
    B̄ = umbral(a1, a2)
    B̄ <= 10 && vline!(q, [B̄]; color = GRIS, ls = :dash, lw = 1, label = "")
    x1, x2, _ = reparto_ref(a1, a2, B)
    D = estatica_ref(a1, a2, B)
    for (x, d) in ((x1, D[1, 3]), (x2, D[2, 3]))
        plot!(q, [B - 0.8, B + 0.8], [x - 0.8d, x + 0.8d]; color = TINTA, lw = 2.5, label = "")
    end
    q
end

# ╔═╡ c0144efc-cf04-11f1-92dc-291ff0933461
"Derivada numérica de g en v, por diferencia centrada."
derivada_numerica(g, v; h = 1e-6) = (g(v + h) - g(v - h)) / 2h

# ╔═╡ c0144de4-cf04-11f1-8eda-b56bc06dadc7
let
    x0 = inversion_una(a0, p)
    ift_a, ift_p = (1 + x0) / a0, -(1 + x0)^2 / a0
    num_a = derivada_numerica(b -> inversion_una(b, p), a0)
    num_p = derivada_numerica(q -> inversion_una(a0, q), p)
    r(v) = round(v, digits = 4)
    nota = x0 > 0 ? md"" :
        md"""
        !!! warning "Solución de esquina"
            Con ``p \ge a`` no conviene invertir: ``x^\ast = 0`` y las derivadas
            son cero. La fórmula de la función implícita sólo vale en el óptimo
            interior.
        """
    md"""
    **Comprobación numérica**, con ``a`` = $(a0) y ``p`` = $(p)
    (``x^\ast`` = $(r(x0))):

    | Derivada | Función implícita | Diferencia finita |
    |:---|---:|---:|
    | ``dx^\ast/da`` | $(x0 > 0 ? r(ift_a) : 0.0) | $(r(num_a)) |
    | ``dx^\ast/dp`` | $(x0 > 0 ? r(ift_p) : 0.0) | $(r(num_p)) |

    $(nota)

    **Mueve** ``p`` hasta que supere ``a``. **Observa** qué pasa con el óptimo
    y con las derivadas.
    """
end

# ╔═╡ c0144df8-cf04-11f1-ac0e-19dc826ccae1
let
    x1, x2, λ = reparto_ref(a1, a2, B)
    D = estatica_ref(a1, a2, B)
    num(i, j) = derivada_numerica(v -> collect(reparto_ref(
        (j == 1 ? v : a1), (j == 2 ? v : a2), (j == 3 ? v : B)))[i],
        (a1, a2, B)[j])
    r(v) = round(v, digits = 4) + 0.0
    regimen = x2 > 0 ?
        md"Régimen **interior**: las dos regiones reciben." :
        md"Régimen de **esquina**: la región 2 no recibe, y las condiciones activas son otras (``x_2 = 0``)."
    md"""
    **Comprobación numérica**, con los deslizadores de la sección 0
    (``x_1`` = $(r(x1)), ``x_2`` = $(r(x2)), ``\lambda`` = $(r(λ))):

    | | ``\partial/\partial a_2`` (Cramer) | ``\partial/\partial a_2`` (numérica) | ``\partial/\partial B`` (Cramer) | ``\partial/\partial B`` (numérica) |
    |:---|---:|---:|---:|---:|
    | ``x_1`` | $(r(D[1, 2])) | $(r(num(1, 2))) | $(r(D[1, 3])) | $(r(num(1, 3))) |
    | ``x_2`` | $(r(D[2, 2])) | $(r(num(2, 2))) | $(r(D[2, 3])) | $(r(num(2, 3))) |
    | ``\lambda`` | $(r(D[3, 2])) | $(r(num(3, 2))) | $(r(D[3, 3])) | $(r(num(3, 3))) |

    $(regimen)
    """
end

# ╔═╡ c0144e3e-cf04-11f1-b565-37fa87fc2256
let
    x1, x2, λ = reparto_ref(a1, a2, B)
    n1 = derivada_numerica(v -> valor_ref(v, a2, B), a1)
    n2 = derivada_numerica(v -> valor_ref(a1, v, B), a2)
    nB = derivada_numerica(v -> valor_ref(a1, a2, v), B)
    r(v) = round(v, digits = 4) + 0.0
    md"""
    **Comprobación numérica** de las fórmulas de la sección 4.4 de las notas:

    | | Envolvente | Diferencia finita |
    |:---|---:|---:|
    | ``\partial V/\partial a_1`` | ``\ln(1 + x_1^\ast)`` = $(r(log1p(x1))) | $(r(n1)) |
    | ``\partial V/\partial a_2`` | ``\ln(1 + x_2^\ast)`` = $(r(log1p(x2))) | $(r(n2)) |
    | ``\partial V/\partial B`` | ``\lambda`` = $(r(λ)) | $(r(nB)) |

    **Mueve** ``B`` hasta que la región 2 deje de recibir. **Observa** que la
    recta naranja se vuelve horizontal y que ``\partial V/\partial a_2 = 0``.
    """
end

# ╔═╡ c0144f06-cf04-11f1-80d0-6d941b323229
"dk*/dρ en el estado estacionario de Ramsey con f(k) = k^α."
function dk_drho_ref(α, ρ, δ)
    k = (α / (ρ + δ))^(1 / (1 - α))
    -k / ((1 - α) * (ρ + δ))
end

# ╔═╡ c0144f10-cf04-11f1-a397-d946343caab3
begin
    # Casos de prueba (a₁, a₂, B): esquina, umbral e interior; sólo interior;
    # y (α, ρ, δ) de Ramsey.
    const CASOS = [(2.0, 1.0, 0.5), (2.0, 1.0, 1.0), (2.0, 1.0, 4.0), (3.0, 0.5, 2.0), (1.0, 1.0, 3.0)]
    const CASOS_INTERIOR = [(2.0, 1.0, 4.0), (3.0, 0.5, 8.0), (1.0, 1.0, 3.0), (1.5, 1.2, 2.0)]
    const CASOS_RAMSEY = [(0.3, 0.03, 0.05), (0.4, 0.02, 0.06), (0.35, 0.05, 0.1)]
end;

# ╔═╡ c0144f10-cf04-11f1-a5b1-175d9aa8f156
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

# ╔═╡ c0144e64-cf04-11f1-90b9-a32c4af3640a
verificar(() -> [efecto_a1(c...) for c in CASOS_INTERIOR],
          [estatica_ref(c...)[:, 1] for c in CASOS_INTERIOR];
          pista = md"Con `h1 = a1 / (1 + x1)^2` y `h2 = a2 / (1 + x2)^2`, la matriz es `[-h1 0 -1; 0 -h2 -1; -1 -1 0]` y el lado derecho, `[-1 / (1 + x1), 0, 0]`.")

# ╔═╡ c0144e84-cf04-11f1-a888-3f8be7d0b0f0
verificar(() -> [valor_marginal(c...) for c in CASOS],
          [(r = reparto_ref(c...); [log1p(r[1]), log1p(r[2]), r[3]]) for c in CASOS];
          pista = md"Obtén `x1, x2, λ = reparto_ref(a1, a2, B)` y deriva el lagrangiano respecto de cada parámetro: `[log1p(x1), log1p(x2), λ]`.")

# ╔═╡ c0144e96-cf04-11f1-8ecc-2b91a0716bd7
verificar(() -> [dk_drho(c...) for c in CASOS_RAMSEY],
          [dk_drho_ref(c...) for c in CASOS_RAMSEY];
          pista = md"Con ``F(k, \rho) = \alpha k^{\alpha - 1} - \rho - \delta``, ``dk^\ast/d\rho = -F_\rho/F_k = 1/\big(\alpha(\alpha - 1)k^{\alpha - 2}\big)``.")

# ╔═╡ Cell order:
# ╟─c0144d4e-cf04-11f1-9dd4-a3d6bd695e03
# ╟─c0144d8a-cf04-11f1-af81-93ce6d224958
# ╟─c0144d94-cf04-11f1-b9dc-479fcc88deb2
# ╟─c0144d9e-cf04-11f1-a013-c119638ffee4
# ╟─c0144db2-cf04-11f1-9b31-93236330e4d8
# ╟─c0144dbc-cf04-11f1-bffd-89b472cba12f
# ╟─c0144dc6-cf04-11f1-a7b3-731bf955544d
# ╟─c0144dd0-cf04-11f1-8499-f95940fef354
# ╠═c0144dda-cf04-11f1-abbd-7b2e814cd388
# ╟─c0144de4-cf04-11f1-8eda-b56bc06dadc7
# ╟─c0144de4-cf04-11f1-a7ce-e5f87ce17935
# ╠═c0144dee-cf04-11f1-b6ab-79de68175005
# ╟─c0144df8-cf04-11f1-ac0e-19dc826ccae1
# ╟─c0144e04-cf04-11f1-83fc-f9040f3f338d
# ╟─c0144e0c-cf04-11f1-ba95-afc4b8ecef09
# ╟─c0144e16-cf04-11f1-bf81-7b619944e0fe
# ╟─c0144e16-cf04-11f1-aadb-3f9ccde8015e
# ╟─c0144e20-cf04-11f1-af9f-d9ace2b39e07
# ╟─c0144e2a-cf04-11f1-b0db-afe61b8a0f13
# ╟─c0144e36-cf04-11f1-8031-a382e6ca6a82
# ╟─c0144e3e-cf04-11f1-b565-37fa87fc2256
# ╟─c0144e48-cf04-11f1-b2fb-a7c5a3217891
# ╟─c0144e52-cf04-11f1-825f-6d44faea02b1
# ╟─c0144e5c-cf04-11f1-8150-d56b2787d3f0
# ╠═c0144e5c-cf04-11f1-853a-b7f520271ffe
# ╟─c0144e64-cf04-11f1-90b9-a32c4af3640a
# ╟─c0144e70-cf04-11f1-b0ba-e1a0dd5539d3
# ╠═c0144e7a-cf04-11f1-a5f8-1501b10a8051
# ╟─c0144e84-cf04-11f1-a888-3f8be7d0b0f0
# ╟─c0144e84-cf04-11f1-b8db-29aa53a482f7
# ╠═c0144e8e-cf04-11f1-8d77-310273479edc
# ╟─c0144e96-cf04-11f1-8ecc-2b91a0716bd7
# ╟─c0144ea2-cf04-11f1-ad13-17cdbb576515
# ╟─c0144eac-cf04-11f1-86e4-050b51fe8be5
# ╠═c0144eb6-cf04-11f1-af45-c12aac17679e
# ╠═c0144ec0-cf04-11f1-8db1-eb59bb4eb16f
# ╠═c0144ec0-cf04-11f1-8b12-c16db39b0754
# ╠═c0144ec8-cf04-11f1-9f87-255a0b382d8c
# ╠═c0144ed4-cf04-11f1-bfdf-b15a327b9c2d
# ╠═c0144ede-cf04-11f1-a00c-8fcb07edb331
# ╠═c0144ede-cf04-11f1-9e0a-c9f43e5d087a
# ╠═c0144ee8-cf04-11f1-9e58-c328190f6e83
# ╠═c0144ef2-cf04-11f1-a7eb-effbf2c1c5bf
# ╠═c0144efc-cf04-11f1-92dc-291ff0933461
# ╠═c0144f06-cf04-11f1-80d0-6d941b323229
# ╠═c0144f10-cf04-11f1-a397-d946343caab3
# ╠═c0144f10-cf04-11f1-a5b1-175d9aa8f156
