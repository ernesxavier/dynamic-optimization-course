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

# ╔═╡ 6b401c54-ce3b-11f1-8067-13150e74671f
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

# ╔═╡ 6b401b78-ce3b-11f1-b8bf-99c22550a961
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

# ╔═╡ 6b401b9e-ce3b-11f1-9bb7-717a3ca944b5
TableOfContents(title = "Contenido")

# ╔═╡ 6b401baa-ce3b-11f1-a1a3-1b3c660eeede
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

# ╔═╡ 6b401bb4-ce3b-11f1-b943-b112897c440c
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

# ╔═╡ 6b401bbe-ce3b-11f1-8f40-5f2a36954ef5
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

# ╔═╡ 6b401bc8-ce3b-11f1-99a9-b550f8a14336
md"""
¿Cuánto se mueve el cruce? Diferenciando ``F(x(a), a, p) = 0``, el
**teorema de la función implícita** da

```math
\frac{dx^\ast}{da} = -\frac{F_a}{F_x}, \qquad \frac{dx^\ast}{dp} = -\frac{F_p}{F_x} .
```

Symbolics.jl calcula las derivadas parciales y los cocientes:
"""

# ╔═╡ 6b401bc8-ce3b-11f1-9249-518526c3da1e
let
    @variables x a p
    F = a / (1 + x) - p
    Fx = Symbolics.derivative(F, x)
    (dx_da = simplify(-Symbolics.derivative(F, a) / Fx),
     dx_dp = simplify(-Symbolics.derivative(F, p) / Fx))
end

# ╔═╡ 6b401bd2-ce3b-11f1-bf96-f1ed33181adb
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

# ╔═╡ 6b401bd2-ce3b-11f1-88b1-9db692fca658
let
    @variables x₁ x₂ λ α₁ α₂ b
    F = [α₁ / (1 + x₁) - λ, α₂ / (1 + x₂) - λ, b - x₁ - x₂]
    (D_z = Symbolics.jacobian(F, [x₁, x₂, λ]),
     D_param = Symbolics.jacobian(F, [α₁, α₂, b]))
end

# ╔═╡ 6b401bdc-ce3b-11f1-888b-5f6eed8505d8
md"""
Con ``h_i = a_i/(1 + x_i)^2``, el determinante de ``D_zF`` es
``h_1 + h_2 > 0``, y la **regla de Cramer** da cada derivada como un cociente
de determinantes (notas, sección 3). La tabla compara esas derivadas con
diferencias finitas de la solución exacta, para los valores de los
deslizadores de la sección 0.
"""

# ╔═╡ 6b401be6-ce3b-11f1-9a8d-2501ef17405e
md"""
### Cuando cambia el régimen

La gráfica muestra el reparto óptimo según el tamaño del fondo. Los
segmentos cortos son las rectas tangentes con la pendiente que da la regla de
Cramer en el ``B`` elegido; la línea punteada marca el umbral
``\bar B = a_1/a_2 - 1``.
"""

# ╔═╡ 6b401be6-ce3b-11f1-88af-e19ee8b58743
md"""
Mueve ``B`` a uno y otro lado del umbral. A la izquierda, cada peso
adicional va completo a la región 1 (pendiente 1); a la derecha, se reparte
en proporción ``a_1/(a_1 + a_2)`` y ``a_2/(a_1 + a_2)``. En ``\bar B`` la
curva de ``x_1`` tiene un **pico**: la función implícita vale dentro de cada
régimen, pero no en la frontera entre ellos.
"""

# ╔═╡ 6b401bf0-ce3b-11f1-ae9d-b1e5727e8bc4
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

# ╔═╡ 6b401bfa-ce3b-11f1-b369-d13c71390263
md"""
La recta naranja es la de la inversión óptima con ``p`` = $(p). Mueve
``p``: la recta tangente cambia, y su pendiente es siempre
``-x^\ast(p)``. Una envolvente superior de rectas es **convexa**; por eso
``V(p)`` lo es (notas, Para profundizar, P.2).
"""

# ╔═╡ 6b401c04-ce3b-11f1-8eea-3de5daa81ab8
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

# ╔═╡ 6b401c10-ce3b-11f1-b8de-31ada17a7ed3
md"""
### La envolvente del reparto

Lo mismo se ve en la gráfica. Para cada reparto fijo
``(\bar x_1, B - \bar x_1)``, el producto
``a_1\ln(1 + \bar x_1) + a_2\ln(1 + \bar x_2)`` es una recta en ``a_2``, de
pendiente ``\ln(1 + \bar x_2)``. ``V(a_2)`` es su envolvente superior. La
recta naranja es la del reparto óptimo con el ``a_2`` elegido.
"""

# ╔═╡ 6b401c18-ce3b-11f1-9679-4fc0c51edb16
md"""
Reduce ``B`` hasta que la región 2 deje de recibir. La recta tangente se
vuelve **horizontal**: si la región 2 no recibe fondos, una pequeña mejora
de su productividad no vale nada al margen, ``\partial V/\partial a_2 = \ln 1 = 0``.
"""

# ╔═╡ 6b401c18-ce3b-11f1-af64-0f898d48ebd0
md"""
## 4. Comparar políticas

La envolvente da un tipo de cambio entre instrumentos. Un peso adicional del
fondo vale ``\lambda``; elevar ``a_2`` en ``\Delta`` vale, al primer orden,
``\Delta \ln(1 + x_2^\ast)``. Dividiendo, se obtiene cuántos pesos del fondo
vale el programa.

Mejora de la productividad de la región 2, ``\Delta``: $(@bind Δ Slider(0.05:0.05:0.5, default = 0.1, show_value = true))
"""

# ╔═╡ 6b401c22-ce3b-11f1-91af-1db0520bd15d
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

# ╔═╡ 6b401c2c-ce3b-11f1-837e-959023625b1f
md"""
## Ejercicios

### Completa el código

**1.** Escribe `efecto_a1(a1, a2, B)`, que devuelva el vector
`[dx1, dx2, dλ]` de derivadas respecto de ``a_1`` en el régimen interior.
Construye la matriz ``D_zF`` y el lado derecho ``-\partial F/\partial a_1``, y
resuelve el sistema con `D \ b` (o con la regla de Cramer). Puedes usar
`reparto_ref(a1, a2, B)` para obtener ``(x_1, x_2, \lambda)``.
"""

# ╔═╡ 6b401c2c-ce3b-11f1-badc-bb40f80307d0
function efecto_a1(a1, a2, B)
    missing  # reemplaza esta línea
end

# ╔═╡ 6b401c36-ce3b-11f1-a20d-a3c1ded4123d
md"""
**2.** Escribe `valor_marginal(a1, a2, B)`, que devuelva el vector
``[\partial V/\partial a_1,\ \partial V/\partial a_2,\ \partial V/\partial B]``
usando el teorema de la envolvente. Debe funcionar en los dos regímenes.
"""

# ╔═╡ 6b401c36-ce3b-11f1-922b-1bd97d5ca7b1
function valor_marginal(a1, a2, B)
    missing  # reemplaza esta línea
end

# ╔═╡ 6b401c42-ce3b-11f1-8344-ada30bfe1311
md"""
**3. [Avanzado]** En el modelo de Ramsey (sesión 12), el capital de estado
estacionario cumple ``f'(k^\ast) = \rho + \delta`` con ``f(k) = k^\theta``.
Escribe `dk_drho(θ, ρ, δ)`, que devuelva ``dk^\ast/d\rho`` con el teorema de
la función implícita (notas, ejercicio F3). Puedes calcular ``k^\ast`` con su
fórmula cerrada, ``k^\ast = \big(\theta/(\rho + \delta)\big)^{1/(1 - \theta)}``.
"""

# ╔═╡ 6b401c4a-ce3b-11f1-bcc8-c3eb3828dd8c
function dk_drho(θ, ρ, δ)
    missing  # reemplaza esta línea
end

# ╔═╡ 6b401c4a-ce3b-11f1-981b-a925ee1f0757
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

# ╔═╡ 6b401c54-ce3b-11f1-b915-49c6150869cb
md"""
---
## Apéndice: paquetes y funciones auxiliares

Estas celdas definen herramientas que usa el cuaderno. No es necesario
leerlas para seguir la sesión.
"""

# ╔═╡ 6b401c5e-ce3b-11f1-a8bd-d1ec8c86da6c
begin
    const AZUL    = "#2a78d6"   # serie principal
    const NARANJA = "#eb6834"   # segunda serie, recta tangente
    const GRIS    = "#52514e"   # referencias
    const TINTA   = "#0b0b0b"   # óptimo
end;

# ╔═╡ 6b401c5e-ce3b-11f1-8b99-4709d597f832
"Inversión óptima de una región con precio p: max a ln(1 + x) − px, con x ≥ 0."
inversion_una(a, p) = max(a / p - 1, 0.0)

# ╔═╡ 6b401bbe-ce3b-11f1-af2c-439cc1e913d0
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

# ╔═╡ 6b401c68-ce3b-11f1-9f96-31f126b64325
"Valor óptimo de una región con precio p."
valor_una(a, p) = (x = inversion_una(a, p); a * log1p(x) - p * x)

# ╔═╡ 6b401bf0-ce3b-11f1-a0f5-2ffc806857f7
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

# ╔═╡ 6b401c68-ce3b-11f1-b9f6-fb9d746520d1
"Producto total de las dos regiones: a₁ ln(1 + x₁) + a₂ ln(1 + x₂)."
producto(x1, x2, a1, a2) = a1 * log1p(x1) + a2 * log1p(x2)

# ╔═╡ 6b401c74-ce3b-11f1-a68b-7f324d9f2f91
"Umbral del fondo a partir del cual la región menos productiva recibe inversión."
umbral(a1, a2) = max(a1, a2) / min(a1, a2) - 1

# ╔═╡ 6b401c74-ce3b-11f1-b1ba-45132372ed8f
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

# ╔═╡ 6b401bb4-ce3b-11f1-8ca7-0da9b0de7c15
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

# ╔═╡ 6b401c74-ce3b-11f1-8a3b-1fafffcbed06
"Valor óptimo V(a₁, a₂, B): el producto total con el reparto óptimo."
function valor_ref(a1, a2, B)
    x1, x2, _ = reparto_ref(a1, a2, B)
    producto(x1, x2, a1, a2)
end

# ╔═╡ 6b401c10-ce3b-11f1-9ac9-9395570f8c3c
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

# ╔═╡ 6b401c18-ce3b-11f1-b883-81f87ef720d5
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

# ╔═╡ 6b401c7c-ce3b-11f1-afda-01b1020c82ea
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

# ╔═╡ 6b401be6-ce3b-11f1-9976-df4f01ab2c15
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

# ╔═╡ 6b401c7c-ce3b-11f1-877c-7f5574b44969
"Derivada numérica de g en v, por diferencia centrada."
derivada_numerica(g, v; h = 1e-6) = (g(v + h) - g(v - h)) / 2h

# ╔═╡ 6b401bc8-ce3b-11f1-b569-5bb2ad128a31
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

# ╔═╡ 6b401bdc-ce3b-11f1-9b57-49343a3322dc
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

# ╔═╡ 6b401c04-ce3b-11f1-b35b-6d45ec9afba1
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

# ╔═╡ 6b401c86-ce3b-11f1-82bb-e74fa7cfd4c7
"dk*/dρ en el estado estacionario de Ramsey con f(k) = k^θ."
function dk_drho_ref(θ, ρ, δ)
    k = (θ / (ρ + δ))^(1 / (1 - θ))
    -k / ((1 - θ) * (ρ + δ))
end

# ╔═╡ 6b401c86-ce3b-11f1-b737-b3566c0e7092
begin
    # Casos de prueba (a₁, a₂, B): esquina, umbral e interior; sólo interior;
    # y (θ, ρ, δ) de Ramsey.
    const CASOS = [(2.0, 1.0, 0.5), (2.0, 1.0, 1.0), (2.0, 1.0, 4.0), (3.0, 0.5, 2.0), (1.0, 1.0, 3.0)]
    const CASOS_INTERIOR = [(2.0, 1.0, 4.0), (3.0, 0.5, 8.0), (1.0, 1.0, 3.0), (1.5, 1.2, 2.0)]
    const CASOS_RAMSEY = [(0.3, 0.03, 0.05), (0.4, 0.02, 0.06), (0.35, 0.05, 0.1)]
end;

# ╔═╡ 6b401c86-ce3b-11f1-9387-f9b4210753f2
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

# ╔═╡ 6b401c2c-ce3b-11f1-a8f0-dfdd62c7f9d9
verificar(() -> [efecto_a1(c...) for c in CASOS_INTERIOR],
          [estatica_ref(c...)[:, 1] for c in CASOS_INTERIOR];
          pista = md"Con `h1 = a1 / (1 + x1)^2` y `h2 = a2 / (1 + x2)^2`, la matriz es `[-h1 0 -1; 0 -h2 -1; -1 -1 0]` y el lado derecho, `[-1 / (1 + x1), 0, 0]`.")

# ╔═╡ 6b401c42-ce3b-11f1-aa43-c5fa0742e18e
verificar(() -> [valor_marginal(c...) for c in CASOS],
          [(r = reparto_ref(c...); [log1p(r[1]), log1p(r[2]), r[3]]) for c in CASOS];
          pista = md"Obtén `x1, x2, λ = reparto_ref(a1, a2, B)` y deriva el lagrangiano respecto de cada parámetro: `[log1p(x1), log1p(x2), λ]`.")

# ╔═╡ 6b401c4a-ce3b-11f1-bdd8-37b350ae2258
verificar(() -> [dk_drho(c...) for c in CASOS_RAMSEY],
          [dk_drho_ref(c...) for c in CASOS_RAMSEY];
          pista = md"Con ``F(k, \rho) = \theta k^{\theta - 1} - \rho - \delta``, ``dk^\ast/d\rho = -F_\rho/F_k = 1/\big(\theta(\theta - 1)k^{\theta - 2}\big)``.")

# ╔═╡ Cell order:
# ╟─6b401b78-ce3b-11f1-b8bf-99c22550a961
# ╟─6b401b9e-ce3b-11f1-9bb7-717a3ca944b5
# ╟─6b401baa-ce3b-11f1-a1a3-1b3c660eeede
# ╟─6b401bb4-ce3b-11f1-8ca7-0da9b0de7c15
# ╟─6b401bb4-ce3b-11f1-b943-b112897c440c
# ╟─6b401bbe-ce3b-11f1-8f40-5f2a36954ef5
# ╟─6b401bbe-ce3b-11f1-af2c-439cc1e913d0
# ╟─6b401bc8-ce3b-11f1-99a9-b550f8a14336
# ╠═6b401bc8-ce3b-11f1-9249-518526c3da1e
# ╟─6b401bc8-ce3b-11f1-b569-5bb2ad128a31
# ╟─6b401bd2-ce3b-11f1-bf96-f1ed33181adb
# ╠═6b401bd2-ce3b-11f1-88b1-9db692fca658
# ╟─6b401bdc-ce3b-11f1-888b-5f6eed8505d8
# ╟─6b401bdc-ce3b-11f1-9b57-49343a3322dc
# ╟─6b401be6-ce3b-11f1-9a8d-2501ef17405e
# ╟─6b401be6-ce3b-11f1-9976-df4f01ab2c15
# ╟─6b401be6-ce3b-11f1-88af-e19ee8b58743
# ╟─6b401bf0-ce3b-11f1-ae9d-b1e5727e8bc4
# ╟─6b401bf0-ce3b-11f1-a0f5-2ffc806857f7
# ╟─6b401bfa-ce3b-11f1-b369-d13c71390263
# ╟─6b401c04-ce3b-11f1-8eea-3de5daa81ab8
# ╟─6b401c04-ce3b-11f1-b35b-6d45ec9afba1
# ╟─6b401c10-ce3b-11f1-b8de-31ada17a7ed3
# ╟─6b401c10-ce3b-11f1-9ac9-9395570f8c3c
# ╟─6b401c18-ce3b-11f1-9679-4fc0c51edb16
# ╟─6b401c18-ce3b-11f1-af64-0f898d48ebd0
# ╟─6b401c18-ce3b-11f1-b883-81f87ef720d5
# ╟─6b401c22-ce3b-11f1-91af-1db0520bd15d
# ╟─6b401c2c-ce3b-11f1-837e-959023625b1f
# ╠═6b401c2c-ce3b-11f1-badc-bb40f80307d0
# ╟─6b401c2c-ce3b-11f1-a8f0-dfdd62c7f9d9
# ╟─6b401c36-ce3b-11f1-a20d-a3c1ded4123d
# ╠═6b401c36-ce3b-11f1-922b-1bd97d5ca7b1
# ╟─6b401c42-ce3b-11f1-aa43-c5fa0742e18e
# ╟─6b401c42-ce3b-11f1-8344-ada30bfe1311
# ╠═6b401c4a-ce3b-11f1-bcc8-c3eb3828dd8c
# ╟─6b401c4a-ce3b-11f1-bdd8-37b350ae2258
# ╟─6b401c4a-ce3b-11f1-981b-a925ee1f0757
# ╟─6b401c54-ce3b-11f1-b915-49c6150869cb
# ╠═6b401c54-ce3b-11f1-8067-13150e74671f
# ╠═6b401c5e-ce3b-11f1-a8bd-d1ec8c86da6c
# ╠═6b401c5e-ce3b-11f1-8b99-4709d597f832
# ╠═6b401c68-ce3b-11f1-9f96-31f126b64325
# ╠═6b401c68-ce3b-11f1-b9f6-fb9d746520d1
# ╠═6b401c74-ce3b-11f1-a68b-7f324d9f2f91
# ╠═6b401c74-ce3b-11f1-b1ba-45132372ed8f
# ╠═6b401c74-ce3b-11f1-8a3b-1fafffcbed06
# ╠═6b401c7c-ce3b-11f1-afda-01b1020c82ea
# ╠═6b401c7c-ce3b-11f1-877c-7f5574b44969
# ╠═6b401c86-ce3b-11f1-82bb-e74fa7cfd4c7
# ╠═6b401c86-ce3b-11f1-b737-b3566c0e7092
# ╠═6b401c86-ce3b-11f1-9387-f9b4210753f2
