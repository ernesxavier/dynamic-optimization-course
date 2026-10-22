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

# ╔═╡ 89c86e54-ce42-11f1-a70c-d9a44d2a1362
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

# ╔═╡ 89c86d6e-ce42-11f1-abab-3b7b0b0e0909
md"""
# Sesión 3: Envolvente y estática comparativa

**Pregunta de la unidad.** Un gobierno tiene un fondo ``B`` para invertir en
dos regiones. ¿Cómo debe repartirlo?

**Pregunta de la sesión.** Si cambian los parámetros (la productividad de una
región, el tamaño del fondo), ¿cuánto cambia el reparto? ¿Cuánto cambia el
producto que se logra?

**Objetivos de la sesión**
1. Calcular cómo cambia un óptimo cuando cambia un parámetro, sin resolver el
   problema: teorema de la función implícita y regla de Cramer.
2. Reconocer que la función implícita sólo vale dentro de un régimen, y que la
   solución puede tener picos donde el régimen cambia.
3. Usar el teorema de la envolvente para saber cuánto cambia el valor óptimo,
   y leer ``V'(B) = \lambda``.
4. Comparar el valor de dos políticas con la envolvente.

**Cómo usar este cuaderno.** Pluto es reactivo: al mover un deslizador, todo
lo que depende de él se recalcula. Las secciones marcadas **[Avanzado]** son
opcionales. Las demostraciones están en las notas formales,
`Class_notes/s03_envolvente.md`.

**Cómo abrirlo.** Desde la raíz del repositorio:
`julia --project=Code -e 'using Pluto; Pluto.run()'` y abrir
`Code/s03_envolvente.jl`.

**Repaso recomendado** (en `Class_notes/repaso/`): C.B5 (derivadas
parciales), L.B3 y L.B4 (determinantes y regla de Cramer), C.I3 (diferencial
total), C.I4 (función implícita) y L.I6 (jacobiano). Para los puntos
[Avanzado]: C.A2.
"""

# ╔═╡ 89c86da0-ce42-11f1-a5eb-35e88940f6a9
TableOfContents(title = "Contenido")

# ╔═╡ 89c86da0-ce42-11f1-996f-bfadb6c122c9
md"""
## 0. La pregunta: ¿qué pasa si una región mejora?

Seguimos con el problema de la sesión 2: cada peso invertido en la región
``i`` produce ``a_i \ln(1 + x_i)``, y el fondo ``B`` se reparte entre las dos.
La región 1 es la más productiva.

Ahora supón que un programa eleva la productividad ``a_2`` de la región 2.
La gráfica muestra el reparto óptimo para cada valor de ``a_2``; el punto
marca el valor del deslizador.

``a_1`` (productividad de la región 1): $(@bind a1 Slider(1.0:0.1:4.0, default = 2.0, show_value = true))

``a_2`` (productividad de la región 2): $(@bind a2 Slider(0.2:0.1:1.0, default = 1.0, show_value = true))

Fondo ``B``: $(@bind B Slider(0.1:0.1:10.0, default = 4.0, show_value = true))
"""

# ╔═╡ 89c86db4-ce42-11f1-8f3c-39cbd08d7cfd
md"""
Hay dos tramos. Mientras ``a_2`` es bajo, la región 2 no recibe nada y una
pequeña mejora no cambia el reparto. Después, cada mejora le da más fondos,
y la región 1 recibe exactamente lo mismo de menos.

En este problema hay fórmula cerrada, pero casi nunca es así. Esta sesión
responde dos preguntas **sin resolver el problema**, sólo a partir de las
condiciones de primer orden:
- ¿cuál es la pendiente de esas curvas? (estática comparativa, secciones 1 y 2);
- ¿cuánto cambia el producto total? (envolvente, secciones 3 y 4).
"""

# ╔═╡ 89c86db4-ce42-11f1-a966-a972d02d9b88
md"""
## 1. Una región: la función implícita

Empecemos con una sola región que paga un precio ``p`` por peso invertido:
``\max_x a\ln(1 + x) - px``. La condición de primer orden iguala el producto
marginal con el precio:

```math
F(x, a, p) = \frac{a}{1 + x} - p = 0 .
```

En la gráfica, el óptimo está donde la curva del producto marginal cruza la
recta del precio. La curva punteada es el producto marginal con ``a`` un 20%
mayor: el cruce se mueve a la derecha.

Productividad ``a``: $(@bind a0 Slider(1.0:0.1:3.0, default = 2.0, show_value = true))

Precio ``p``: $(@bind p Slider(0.2:0.05:1.5, default = 0.5, show_value = true))
"""

# ╔═╡ 89c86dbe-ce42-11f1-859a-c70c3ec264ea
md"""
¿Cuánto se mueve el cruce? Diferenciando ``F(x(a), a, p) = 0``, el
**teorema de la función implícita** da

```math
\frac{dx^\ast}{da} = -\frac{F_a}{F_x}, \qquad \frac{dx^\ast}{dp} = -\frac{F_p}{F_x} .
```

Symbolics.jl calcula las derivadas parciales y los cocientes:
"""

# ╔═╡ 89c86dbe-ce42-11f1-83f3-f3ac7bdcba19
let
    @variables x a p
    F = a / (1 + x) - p
    Fx = Symbolics.derivative(F, x)
    (dx_da = simplify(-Symbolics.derivative(F, a) / Fx),
     dx_dp = simplify(-Symbolics.derivative(F, p) / Fx))
end

# ╔═╡ 89c86dc8-ce42-11f1-9cd0-c954f1893e69
md"""
## 2. Dos regiones: un sistema y la regla de Cramer

Con dos regiones y el fondo agotado, las condiciones de primer orden son
tres ecuaciones en tres incógnitas, ``z = (x_1, x_2, \lambda)``:

```math
\frac{a_1}{1 + x_1} - \lambda = 0, \qquad
\frac{a_2}{1 + x_2} - \lambda = 0, \qquad
B - x_1 - x_2 = 0 .
```

Al diferenciarlas respecto de un parámetro ``\alpha`` se obtiene un sistema
lineal en las derivadas,

```math
D_zF \, \frac{\partial z}{\partial \alpha} = -\frac{\partial F}{\partial \alpha},
```

donde ``D_zF`` es el **jacobiano** de las condiciones de primer orden. Las
dos matrices, con Symbolics.jl:
"""

# ╔═╡ 89c86dd2-ce42-11f1-9744-05e94c01b943
let
    @variables x₁ x₂ λ α₁ α₂ b
    F = [α₁ / (1 + x₁) - λ, α₂ / (1 + x₂) - λ, b - x₁ - x₂]
    (D_z = Symbolics.jacobian(F, [x₁, x₂, λ]),
     D_param = Symbolics.jacobian(F, [α₁, α₂, b]))
end

# ╔═╡ 89c86dd2-ce42-11f1-b47a-8d168e421796
md"""
Con ``h_i = a_i/(1 + x_i)^2``, el determinante de ``D_zF`` es
``h_1 + h_2 > 0``, y la **regla de Cramer** da cada derivada como un cociente
de determinantes (notas, sección 3). La tabla compara esas derivadas con
diferencias finitas de la solución exacta, para los valores de los
deslizadores de la sección 0.
"""

# ╔═╡ 89c86ddc-ce42-11f1-87d0-dfa349debced
md"""
### Cuando cambia el régimen

La gráfica muestra el reparto óptimo según el tamaño del fondo. Los
segmentos cortos son las rectas tangentes con la pendiente que da la regla de
Cramer en el ``B`` elegido; la línea punteada marca el umbral
``\bar B = a_1/a_2 - 1``.
"""

# ╔═╡ 89c86de6-ce42-11f1-ac92-5399cf65ad48
md"""
Mueve ``B`` a uno y otro lado del umbral. A la izquierda, cada peso
adicional va completo a la región 1 (pendiente 1); a la derecha, se reparte
en proporción ``a_1/(a_1 + a_2)`` y ``a_2/(a_1 + a_2)``. En ``\bar B`` la
curva de ``x_1`` tiene un **pico**: la función implícita vale dentro de cada
régimen, pero no en la frontera entre ellos.
"""

# ╔═╡ 89c86df0-ce42-11f1-8d8c-11ec770b8e09
md"""
## 3. El teorema de la envolvente

Ahora la segunda pregunta: ¿cuánto cambia el **valor** óptimo? Con
``V(\alpha) = \max_x f(x, \alpha)``, un cambio en ``\alpha`` cambia ``V`` por
dos vías: directamente, y a través del cambio en ``x^\ast``. En el óptimo la
segunda vía no cuenta, porque ``f_x = 0``:

```math
V'(\alpha) = \frac{\partial f}{\partial \alpha}\bigg|_{x = x^\ast(\alpha)} .
```

### Por qué se llama envolvente

En el problema de una región, ``V(p) = \max_x a\ln(1 + x) - px``. Para cada
inversión fija ``\bar x``, el valor ``a\ln(1 + \bar x) - p\bar x`` es una
**recta** en ``p``, de pendiente ``-\bar x``. Ninguna recta supera a
``V(p)``, y cada una la toca en el precio para el que ``\bar x`` es óptima:
``V`` es la **envolvente superior** de las rectas (gris). En el punto de
contacto son tangentes, así que ``V'(p) = -x^\ast(p)``.
"""

# ╔═╡ 89c86dfc-ce42-11f1-a002-19c0e126ec80
md"""
La recta naranja es la de la inversión óptima con ``p`` = $(p). Mueve
``p``: la recta tangente cambia, y su pendiente es siempre
``-x^\ast(p)``. Una envolvente superior de rectas es **convexa**; por eso
``V(p)`` lo es (notas, Para profundizar, P.2).
"""

# ╔═╡ 89c86e04-ce42-11f1-8a30-e773a6d117c8
md"""
### Con restricciones: el precio sombra

Con restricciones, se deriva el **lagrangiano** respecto del parámetro. En el
problema de las dos regiones,
``\mathcal{L} = a_1\ln(1 + x_1) + a_2\ln(1 + x_2) + \lambda (B - x_1 - x_2)``,
así que

```math
\frac{\partial V}{\partial B} = \lambda, \qquad
\frac{\partial V}{\partial a_1} = \ln(1 + x_1^\ast), \qquad
\frac{\partial V}{\partial a_2} = \ln(1 + x_2^\ast) .
```

La primera es la que la sesión 2 dejó pendiente: el multiplicador es el valor
de un peso adicional del fondo. La tabla compara las tres fórmulas con
diferencias finitas de ``V``.
"""

# ╔═╡ 89c86e04-ce42-11f1-9375-7d2550d09e75
md"""
### La envolvente del reparto

Lo mismo se ve en la gráfica. Para cada reparto fijo
``(\bar x_1, B - \bar x_1)``, el producto
``a_1\ln(1 + \bar x_1) + a_2\ln(1 + \bar x_2)`` es una recta en ``a_2``, de
pendiente ``\ln(1 + \bar x_2)``. ``V(a_2)`` es su envolvente superior. La
recta naranja es la del reparto óptimo con el ``a_2`` elegido.
"""

# ╔═╡ 89c86e0e-ce42-11f1-867d-3f04261161a6
md"""
Reduce ``B`` hasta que la región 2 deje de recibir. La recta tangente se
vuelve **horizontal**: si la región 2 no recibe fondos, una pequeña mejora
de su productividad no vale nada al margen, ``\partial V/\partial a_2 = \ln 1 = 0``.
"""

# ╔═╡ 89c86e18-ce42-11f1-bfa3-7f20ca1134a5
md"""
## 4. Comparar políticas

La envolvente da un tipo de cambio entre instrumentos. Un peso adicional del
fondo vale ``\lambda``; elevar ``a_2`` en ``\Delta`` vale, al primer orden,
``\Delta \ln(1 + x_2^\ast)``. Dividiendo, se obtiene cuántos pesos del fondo
vale el programa.

Mejora de la productividad de la región 2, ``\Delta``: $(@bind Δ Slider(0.05:0.05:0.5, default = 0.1, show_value = true))
"""

# ╔═╡ 89c86e22-ce42-11f1-8efb-a130316a4d52
md"""
## Resumen

| Herramienta | Qué dice | En el problema de las regiones |
|---|---|---|
| Función implícita | ``dx^\ast/d\alpha = -F_\alpha/F_x`` sin despejar ``x^\ast`` | Signo de ``dx^\ast/d\alpha`` = signo del efecto sobre el rendimiento marginal |
| Regla de Cramer | Resuelve el sistema ``D_zF\,\partial z/\partial\alpha = -\partial F/\partial\alpha`` | Una mejora en ``a_2`` mueve fondos de la región 1 a la 2 |
| Cambio de régimen | La función implícita vale dentro de cada régimen | ``x^\ast(B)`` tiene un pico en ``\bar B`` |
| Envolvente | ``V'(\alpha) = \partial\mathcal{L}/\partial\alpha`` en el óptimo | ``V'(B) = \lambda``, ``\partial V/\partial a_i = \ln(1 + x_i^\ast)`` |
| Envolvente geométrica | ``V`` es la envolvente superior de las curvas con ``x`` fija | Si la región 2 no recibe, mejorar ``a_2`` no vale nada al margen |
"""

# ╔═╡ 89c86e22-ce42-11f1-86e2-5994c8284912
md"""
## Ejercicios

### Completa el código

**1.** Escribe `efecto_a1(a1, a2, B)`, que devuelva el vector
`[dx1, dx2, dλ]` de derivadas respecto de ``a_1`` en el régimen interior.
Construye la matriz ``D_zF`` y el lado derecho ``-\partial F/\partial a_1``, y
resuelve el sistema con `D \ b` (o con la regla de Cramer). Puedes usar
`reparto_ref(a1, a2, B)` para obtener ``(x_1, x_2, \lambda)``.
"""

# ╔═╡ 89c86e2e-ce42-11f1-9f20-2d18bdeca06f
function efecto_a1(a1, a2, B)
    missing  # reemplaza esta línea
end

# ╔═╡ 89c86e2e-ce42-11f1-86f0-e52a8921e421
md"""
**2.** Escribe `valor_marginal(a1, a2, B)`, que devuelva el vector
``[\partial V/\partial a_1,\ \partial V/\partial a_2,\ \partial V/\partial B]``
usando el teorema de la envolvente. Debe funcionar en los dos regímenes.
"""

# ╔═╡ 89c86e36-ce42-11f1-aa31-bba50dd92a09
function valor_marginal(a1, a2, B)
    missing  # reemplaza esta línea
end

# ╔═╡ 89c86e40-ce42-11f1-b360-8d2adb3fdd85
md"""
**3. [Avanzado]** En el modelo de Ramsey (sesión 12), el capital de estado
estacionario cumple ``f'(k^\ast) = \rho + \kappa`` con ``f(k) = k^\theta``.
Escribe `dk_drho(θ, ρ, κ)`, que devuelva ``dk^\ast/d\rho`` con el teorema de
la función implícita (notas, ejercicio F3). Puedes calcular ``k^\ast`` con su
fórmula cerrada, ``k^\ast = \big(\theta/(\rho + \kappa)\big)^{1/(1 - \theta)}``.
"""

# ╔═╡ 89c86e40-ce42-11f1-894c-471e05c8771f
function dk_drho(θ, ρ, κ)
    missing  # reemplaza esta línea
end

# ╔═╡ 89c86e4a-ce42-11f1-b8fb-b3041dcce53b
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

### [Avanzado]

8. Muestra que ``x_1^\ast(B)`` no es diferenciable en ``\bar B`` y que
   ``V(B)`` sí lo es (notas, ejercicio F6).
9. Con el resultado del ejercicio 3, ¿una región más impaciente (``\rho``
   mayor) acumula más o menos capital en el estado estacionario? ¿Y una con
   más depreciación?

## Para la próxima sesión

- **Sesión 4: Laboratorio 0.** Julia con Pluto.jl y Symbolics.jl: resolver
  con Symbolics las condiciones de primer orden del problema de las dos
  regiones y graficar ``V(B)`` y ``\lambda(B)``. Trae el entorno instalado
  (ver el `README.md` del repositorio).
- Repaso: N.B1 a N.B4 (Julia, gráficas, Pluto y punto flotante) y N.I2
  (Symbolics.jl).
"""

# ╔═╡ 89c86e4a-ce42-11f1-809a-75eef892be39
md"""
---
## Apéndice: paquetes y funciones auxiliares

Estas celdas definen herramientas que usa el cuaderno. No es necesario
leerlas para seguir la sesión.
"""

# ╔═╡ 89c86e54-ce42-11f1-8cb8-6d8a8ebc144c
begin
    const AZUL    = "#2a78d6"   # serie principal
    const NARANJA = "#eb6834"   # segunda serie, recta tangente
    const GRIS    = "#52514e"   # referencias
    const TINTA   = "#0b0b0b"   # óptimo
end;

# ╔═╡ 89c86e60-ce42-11f1-bae0-1121b7a3ac7d
"Inversión óptima de una región con precio p: max a ln(1 + x) − px, con x ≥ 0."
inversion_una(a, p) = max(a / p - 1, 0.0)

# ╔═╡ 89c86dbe-ce42-11f1-9cb2-a54ed187417d
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

# ╔═╡ 89c86e60-ce42-11f1-8b2d-cbc009703d1d
"Valor óptimo de una región con precio p."
valor_una(a, p) = (x = inversion_una(a, p); a * log1p(x) - p * x)

# ╔═╡ 89c86df0-ce42-11f1-9e2d-1b8f7604063c
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

# ╔═╡ 89c86e60-ce42-11f1-9053-79f6c7e4e75a
"Producto total de las dos regiones: a₁ ln(1 + x₁) + a₂ ln(1 + x₂)."
producto(x1, x2, a1, a2) = a1 * log1p(x1) + a2 * log1p(x2)

# ╔═╡ 89c86e68-ce42-11f1-a246-cdf04e79a9b3
"Umbral del fondo a partir del cual la región menos productiva recibe inversión."
umbral(a1, a2) = max(a1, a2) / min(a1, a2) - 1

# ╔═╡ 89c86e68-ce42-11f1-b984-cfea1e618ba6
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

# ╔═╡ 89c86daa-ce42-11f1-a216-ff0c46b48e56
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

# ╔═╡ 89c86e72-ce42-11f1-bde4-0d6f2dc5e8a6
"Valor óptimo V(a₁, a₂, B): el producto total con el reparto óptimo."
function valor_ref(a1, a2, B)
    x1, x2, _ = reparto_ref(a1, a2, B)
    producto(x1, x2, a1, a2)
end

# ╔═╡ 89c86e0e-ce42-11f1-a8e7-5b5d56e26075
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

# ╔═╡ 89c86e18-ce42-11f1-90e5-6b95edd36385
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

    Si el programa cuesta menos que su equivalente en pesos, conviene más que
    agregar esos pesos al fondo. La aproximación es buena para ``\Delta``
    pequeño; la diferencia con el cambio exacto es de segundo orden. Cuando la
    región 2 está en la esquina, la aproximación da cero, pero un programa
    grande puede llevarla al régimen interior y tener un valor exacto
    positivo.
    """
end

# ╔═╡ 89c86e72-ce42-11f1-8c9c-c14fa393eca4
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

# ╔═╡ 89c86de6-ce42-11f1-a760-e90f959c7ccf
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

# ╔═╡ 89c86e72-ce42-11f1-aba0-376d424cc7c7
"Derivada numérica de g en v, por diferencia centrada."
derivada_numerica(g, v; h = 1e-6) = (g(v + h) - g(v - h)) / 2h

# ╔═╡ 89c86dc8-ce42-11f1-8dd5-af3b92145b29
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
    Con ``a`` = $(a0) y ``p`` = $(p), el óptimo es ``x^\ast`` = $(r(x0)).

    | Derivada | Función implícita | Diferencia finita |
    |:---|---:|---:|
    | ``dx^\ast/da`` | $(x0 > 0 ? r(ift_a) : 0.0) | $(r(num_a)) |
    | ``dx^\ast/dp`` | $(x0 > 0 ? r(ift_p) : 0.0) | $(r(num_p)) |

    $(nota)

    Los signos se leen sin calcular nada: en un máximo, ``F_x < 0``, así que el
    signo de ``dx^\ast/da`` es el de ``F_a = 1/(1 + x) > 0``. **El óptimo se
    mueve hacia donde el parámetro aumenta el rendimiento marginal.**
    """
end

# ╔═╡ 89c86ddc-ce42-11f1-b172-394ba5376156
let
    x1, x2, λ = reparto_ref(a1, a2, B)
    D = estatica_ref(a1, a2, B)
    num(i, j) = derivada_numerica(v -> collect(reparto_ref(
        (j == 1 ? v : a1), (j == 2 ? v : a2), (j == 3 ? v : B)))[i],
        (a1, a2, B)[j])
    r(v) = round(v, digits = 4) + 0.0
    regimen = x2 > 0 ?
        md"""
        Régimen **interior**: las dos regiones reciben. Un aumento de ``a_2``
        mueve fondos de la región 1 a la 2 (las dos primeras derivadas de la
        columna ``a_2`` suman cero) y eleva el precio sombra.
        """ :
        md"""
        Régimen de **esquina**: la región 2 no recibe. Las condiciones activas
        son otras (``x_2 = 0``), y una pequeña mejora de ``a_2`` no cambia nada.
        """
    md"""
    Reparto: ``x_1`` = $(r(x1)), ``x_2`` = $(r(x2)), ``\lambda`` = $(r(λ)).

    | | ``\partial/\partial a_2`` (Cramer) | ``\partial/\partial a_2`` (numérica) | ``\partial/\partial B`` (Cramer) | ``\partial/\partial B`` (numérica) |
    |:---|---:|---:|---:|---:|
    | ``x_1`` | $(r(D[1, 2])) | $(r(num(1, 2))) | $(r(D[1, 3])) | $(r(num(1, 3))) |
    | ``x_2`` | $(r(D[2, 2])) | $(r(num(2, 2))) | $(r(D[2, 3])) | $(r(num(2, 3))) |
    | ``\lambda`` | $(r(D[3, 2])) | $(r(num(3, 2))) | $(r(D[3, 3])) | $(r(num(3, 3))) |

    $(regimen)
    """
end

# ╔═╡ 89c86e04-ce42-11f1-b225-d704995bb3d2
let
    x1, x2, λ = reparto_ref(a1, a2, B)
    n1 = derivada_numerica(v -> valor_ref(v, a2, B), a1)
    n2 = derivada_numerica(v -> valor_ref(a1, v, B), a2)
    nB = derivada_numerica(v -> valor_ref(a1, a2, v), B)
    r(v) = round(v, digits = 4) + 0.0
    md"""
    | | Envolvente | Diferencia finita |
    |:---|---:|---:|
    | ``\partial V/\partial a_1`` | ``\ln(1 + x_1^\ast)`` = $(r(log1p(x1))) | $(r(n1)) |
    | ``\partial V/\partial a_2`` | ``\ln(1 + x_2^\ast)`` = $(r(log1p(x2))) | $(r(n2)) |
    | ``\partial V/\partial B`` | ``\lambda`` = $(r(λ)) | $(r(nB)) |

    Ninguna de las tres fórmulas necesita ``\partial x^\ast/\partial \alpha``:
    el reajuste del reparto no agrega nada al primer orden.
    """
end

# ╔═╡ 89c86e7c-ce42-11f1-9f51-71767bf0d280
"dk*/dρ en el estado estacionario de Ramsey con f(k) = k^θ."
function dk_drho_ref(θ, ρ, κ)
    k = (θ / (ρ + κ))^(1 / (1 - θ))
    -k / ((1 - θ) * (ρ + κ))
end

# ╔═╡ 89c86e7c-ce42-11f1-82c9-37f7f5521279
begin
    # Casos de prueba (a₁, a₂, B): esquina, umbral e interior; sólo interior;
    # y (θ, ρ, κ) de Ramsey.
    const CASOS = [(2.0, 1.0, 0.5), (2.0, 1.0, 1.0), (2.0, 1.0, 4.0), (3.0, 0.5, 2.0), (1.0, 1.0, 3.0)]
    const CASOS_INTERIOR = [(2.0, 1.0, 4.0), (3.0, 0.5, 8.0), (1.0, 1.0, 3.0), (1.5, 1.2, 2.0)]
    const CASOS_RAMSEY = [(0.3, 0.03, 0.05), (0.4, 0.02, 0.06), (0.35, 0.05, 0.1)]
end;

# ╔═╡ 89c86e86-ce42-11f1-9f8b-9b06dbbc822f
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

# ╔═╡ 89c86e2e-ce42-11f1-94d1-2f8298bd379f
verificar(() -> [efecto_a1(c...) for c in CASOS_INTERIOR],
          [estatica_ref(c...)[:, 1] for c in CASOS_INTERIOR];
          pista = md"Con `h1 = a1 / (1 + x1)^2` y `h2 = a2 / (1 + x2)^2`, la matriz es `[-h1 0 -1; 0 -h2 -1; -1 -1 0]` y el lado derecho, `[-1 / (1 + x1), 0, 0]`.")

# ╔═╡ 89c86e36-ce42-11f1-836e-6131cacc4d3c
verificar(() -> [valor_marginal(c...) for c in CASOS],
          [(r = reparto_ref(c...); [log1p(r[1]), log1p(r[2]), r[3]]) for c in CASOS];
          pista = md"Obtén `x1, x2, λ = reparto_ref(a1, a2, B)` y deriva el lagrangiano respecto de cada parámetro: `[log1p(x1), log1p(x2), λ]`.")

# ╔═╡ 89c86e40-ce42-11f1-8681-e72f9743aadc
verificar(() -> [dk_drho(c...) for c in CASOS_RAMSEY],
          [dk_drho_ref(c...) for c in CASOS_RAMSEY];
          pista = md"Con ``F(k, \rho) = \theta k^{\theta - 1} - \rho - \kappa``, ``dk^\ast/d\rho = -F_\rho/F_k = 1/\big(\theta(\theta - 1)k^{\theta - 2}\big)``.")

# ╔═╡ Cell order:
# ╟─89c86d6e-ce42-11f1-abab-3b7b0b0e0909
# ╟─89c86da0-ce42-11f1-a5eb-35e88940f6a9
# ╟─89c86da0-ce42-11f1-996f-bfadb6c122c9
# ╟─89c86daa-ce42-11f1-a216-ff0c46b48e56
# ╟─89c86db4-ce42-11f1-8f3c-39cbd08d7cfd
# ╟─89c86db4-ce42-11f1-a966-a972d02d9b88
# ╟─89c86dbe-ce42-11f1-9cb2-a54ed187417d
# ╟─89c86dbe-ce42-11f1-859a-c70c3ec264ea
# ╠═89c86dbe-ce42-11f1-83f3-f3ac7bdcba19
# ╟─89c86dc8-ce42-11f1-8dd5-af3b92145b29
# ╟─89c86dc8-ce42-11f1-9cd0-c954f1893e69
# ╠═89c86dd2-ce42-11f1-9744-05e94c01b943
# ╟─89c86dd2-ce42-11f1-b47a-8d168e421796
# ╟─89c86ddc-ce42-11f1-b172-394ba5376156
# ╟─89c86ddc-ce42-11f1-87d0-dfa349debced
# ╟─89c86de6-ce42-11f1-a760-e90f959c7ccf
# ╟─89c86de6-ce42-11f1-ac92-5399cf65ad48
# ╟─89c86df0-ce42-11f1-8d8c-11ec770b8e09
# ╟─89c86df0-ce42-11f1-9e2d-1b8f7604063c
# ╟─89c86dfc-ce42-11f1-a002-19c0e126ec80
# ╟─89c86e04-ce42-11f1-8a30-e773a6d117c8
# ╟─89c86e04-ce42-11f1-b225-d704995bb3d2
# ╟─89c86e04-ce42-11f1-9375-7d2550d09e75
# ╟─89c86e0e-ce42-11f1-a8e7-5b5d56e26075
# ╟─89c86e0e-ce42-11f1-867d-3f04261161a6
# ╟─89c86e18-ce42-11f1-bfa3-7f20ca1134a5
# ╟─89c86e18-ce42-11f1-90e5-6b95edd36385
# ╟─89c86e22-ce42-11f1-8efb-a130316a4d52
# ╟─89c86e22-ce42-11f1-86e2-5994c8284912
# ╠═89c86e2e-ce42-11f1-9f20-2d18bdeca06f
# ╟─89c86e2e-ce42-11f1-94d1-2f8298bd379f
# ╟─89c86e2e-ce42-11f1-86f0-e52a8921e421
# ╠═89c86e36-ce42-11f1-aa31-bba50dd92a09
# ╟─89c86e36-ce42-11f1-836e-6131cacc4d3c
# ╟─89c86e40-ce42-11f1-b360-8d2adb3fdd85
# ╠═89c86e40-ce42-11f1-894c-471e05c8771f
# ╟─89c86e40-ce42-11f1-8681-e72f9743aadc
# ╟─89c86e4a-ce42-11f1-b8fb-b3041dcce53b
# ╟─89c86e4a-ce42-11f1-809a-75eef892be39
# ╠═89c86e54-ce42-11f1-a70c-d9a44d2a1362
# ╠═89c86e54-ce42-11f1-8cb8-6d8a8ebc144c
# ╠═89c86e60-ce42-11f1-bae0-1121b7a3ac7d
# ╠═89c86e60-ce42-11f1-8b2d-cbc009703d1d
# ╠═89c86e60-ce42-11f1-9053-79f6c7e4e75a
# ╠═89c86e68-ce42-11f1-a246-cdf04e79a9b3
# ╠═89c86e68-ce42-11f1-b984-cfea1e618ba6
# ╠═89c86e72-ce42-11f1-bde4-0d6f2dc5e8a6
# ╠═89c86e72-ce42-11f1-8c9c-c14fa393eca4
# ╠═89c86e72-ce42-11f1-aba0-376d424cc7c7
# ╠═89c86e7c-ce42-11f1-9f51-71767bf0d280
# ╠═89c86e7c-ce42-11f1-82c9-37f7f5521279
# ╠═89c86e86-ce42-11f1-9f8b-9b06dbbc822f
