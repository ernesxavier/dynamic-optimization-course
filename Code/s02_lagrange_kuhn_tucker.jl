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

# ╔═╡ e78bd536-ce9b-11f1-9446-49ca1155e028
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

# ╔═╡ e78bd43c-ce9b-11f1-b314-71fe6852d880
md"""
# Sesión 2: Lagrange, concavidad y Kuhn-Tucker

**Pregunta de la unidad.** Un gobierno tiene un fondo ``B`` para invertir en
dos regiones. ¿Cómo debe repartirlo? ¿Conviene siempre dar algo a cada
región?

**Cómo usar este cuaderno.** La teoría está en las notas,
`Class_notes/s02_lagrange_kuhn_tucker.md`, y se desarrolla en el pizarrón;
el cuaderno sirve para mover los parámetros y ver qué pasa. En clase se
proyectan las secciones 2 a 5; las secciones 0 y 1 se exploran antes, y los
ejercicios, después. Pluto es reactivo: al mover un deslizador, todo lo que
depende de él se recalcula.

**Cómo abrirlo.** Desde la raíz del repositorio:
`julia --project=Code -e 'using Pluto; Pluto.run()'` y abrir
`Code/s02_lagrange_kuhn_tucker.jl`.
"""

# ╔═╡ e78bd482-ce9b-11f1-b92a-59af3364debb
TableOfContents(title = "Contenido")

# ╔═╡ e78bd482-ce9b-11f1-a6f9-f35e0a070569
md"""
## 0. La pregunta: repartir un fondo entre dos regiones

*Antes de clase.* Cada región produce ``f_i(x_i) = a_i\ln(1 + x_i)`` y el
fondo se reparte por completo: la región 1 recibe ``x_1`` y la 2, ``B - x_1``
(notas, sección 1).

``a_1`` (productividad de la región 1): $(@bind a1 Slider(1.0:0.1:4.0, default = 2.0, show_value = true))

``a_2`` (productividad de la región 2): $(@bind a2 Slider(0.2:0.1:1.0, default = 1.0, show_value = true))

Fondo ``B``: $(@bind B Slider(0.1:0.1:10.0, default = 4.0, show_value = true))

Antes de usar la teoría, el mejor reparto se puede encontrar **por fuerza
bruta**: se prueban 400 repartos y se queda el que da más producto.
"""

# ╔═╡ e78bd496-ce9b-11f1-b734-079aa93622ff
md"""
**Mueve** ``B`` por debajo de 1, y prueba regiones muy distintas
(``a_1 = 4``, ``a_2 = 0.5``). **Observa:** ¿siempre recibe algo la región
menos productiva? La búsqueda por fuerza bruta da la respuesta para cada
caso, pero no dice por qué; las condiciones de Kuhn-Tucker sí (sección 4).
"""

# ╔═╡ e78bd4a0-ce9b-11f1-b39f-6f78cc0524b0
md"""
## 1. Repaso: gradiente, curvas de nivel y hessiana

*Antes de clase.* El gradiente de ``f`` (las flechas) es perpendicular a las
curvas de nivel; sus entradas son los productos marginales. **Observa** que
las flechas se acortan al alejarse del origen: rendimientos decrecientes.
"""

# ╔═╡ e78bd4aa-ce9b-11f1-a496-af87ed01042d
md"""
Symbolics.jl calcula el gradiente y la hessiana; compáralos con los que
obtienes a mano (notas, sección 2):
"""

# ╔═╡ e78bd4aa-ce9b-11f1-95e9-755fe5ebafd6
begin
    @variables x₁ x₂ α₁ α₂
    f_simbolica = α₁ * log(1 + x₁) + α₂ * log(1 + x₂)
    (gradiente = Symbolics.gradient(f_simbolica, [x₁, x₂]),
     hessiana = Symbolics.hessian(f_simbolica, [x₁, x₂]))
end

# ╔═╡ e78bd4aa-ce9b-11f1-8ab0-ed0b8ded6c6d
md"""
## 2. Lagrange: el óptimo es una tangencia

*En clase, después de la sección 3.4 de las notas.* La solución de Lagrange
iguala los productos marginales: la curva de nivel (azul) toca la recta del
presupuesto (naranja, sólida donde es factible).
"""

# ╔═╡ e78bd4be-ce9b-11f1-8ff4-bdf19509cb57
md"""
## 3. El multiplicador como precio sombra

*En clase.* Las gráficas muestran el valor óptimo ``V(B)`` y el
multiplicador ``\lambda(B)`` para cada tamaño del fondo (notas, sección
3.2). La línea punteada es el umbral ``\bar B``; la naranja, el ``B``
elegido.
"""

# ╔═╡ e78bd4d2-ce9b-11f1-9768-95012eb8dca9
md"""
## 4. Kuhn-Tucker: soluciones de esquina

*En clase, después de la sección 4.4 de las notas.* La tabla evalúa las
condiciones de Kuhn-Tucker en la solución óptima: en cada renglón, el
producto de la última columna debe ser cero (holgura complementaria).
"""

# ╔═╡ e78bd4dc-ce9b-11f1-9122-7392f2147a79
md"""
**¿Quién recibe inversión?** La región 2 recibe sólo si ``B > \bar B``. El
mapa muestra los dos regímenes según la brecha de productividad ``a_1/a_2``
y el tamaño del fondo; el punto es la combinación de los deslizadores.
**Mueve** ``a_1`` y ``B`` y **observa** cómo el punto cruza la frontera.
"""

# ╔═╡ e78bd4e6-ce9b-11f1-89a7-a1eff3c842f4
md"""
## 5. Sin concavidad, las condiciones no bastan

*En clase, antes de la sección 5 de las notas.* Con
``f_i = a_i x_i^\gamma``, la gráfica muestra el producto total a lo largo
del presupuesto y marca el punto interior que cumple Kuhn-Tucker.

``\gamma``: $(@bind γ Slider(0.3:0.1:2.0, default = 1.5, show_value = true))
"""

# ╔═╡ e78bd4f0-ce9b-11f1-ad30-41eb3b03fae0
md"""
**Mueve** ``\gamma`` de 0.5 a 1.5. **Observa:** ¿cuándo el punto de
Kuhn-Tucker es el mejor reparto y cuándo el peor? ¿Adónde va el fondo con
rendimientos crecientes?
"""

# ╔═╡ e78bd4fc-ce9b-11f1-b045-d97c7f998cc2
md"""
## 6. [Avanzado] Cuando falla la calificación de las restricciones

*Fuera de clase* (notas, P.4). En el problema de maximizar ``x_1`` con
``x_2 \le (1 - x_1)^3``, el conjunto factible termina en una cúspide en el
óptimo ``(1, 0)``. Los gradientes de las restricciones activas son
paralelos y no pueden igualar al del objetivo: no existe ``\lambda``.
"""

# ╔═╡ e78bd504-ce9b-11f1-8f81-2f81f803e80a
md"""
## Ejercicios

*Fuera de clase.* Los ejercicios con demostraciones están en las notas
(sección 8).

### Completa el código

**1.** Escribe `reparto_optimo(a1, a2, B)`, que devuelva el vector
`[x1, x2, λ]` del reparto óptimo, suponiendo ``a_1 \ge a_2`` (notas,
sección 4.4).
"""

# ╔═╡ e78bd504-ce9b-11f1-bda8-4171ce10c7d7
function reparto_optimo(a1, a2, B)
    missing  # reemplaza esta línea
end

# ╔═╡ e78bd50e-ce9b-11f1-b64f-3f647a14a6b7
md"""
**2.** Escribe `precio_sombra_numerico(a1, a2, B; h = 1e-5)`, que aproxime
``V'(B)`` con una diferencia centrada, ``\big(V(B + h) - V(B - h)\big)/2h``.
Usa la función `valor_ref(a1, a2, B)`, que calcula ``V(B)``. El verificador
compara tu resultado con ``\lambda``.
"""

# ╔═╡ e78bd50e-ce9b-11f1-bc9d-8322b80270e0
function precio_sombra_numerico(a1, a2, B; h = 1e-5)
    missing  # reemplaza esta línea
end

# ╔═╡ e78bd518-ce9b-11f1-9f17-f30fc5a81f35
md"""
**3. [Avanzado]** Con ``n`` regiones, ``f_i = a_i\ln(1 + x_i)``, la solución
es ``x_i = \max\lbrace a_i/\lambda - 1,\ 0\rbrace``, con ``\lambda`` tal que las
inversiones suman ``B`` (notas, ejercicio F5). Escribe
`llenado_de_agua(a, B)`, que reciba el vector `a` y devuelva el vector de
inversiones. Encuentra ``\lambda`` por bisección: la suma de inversiones
decrece con ``\lambda``.
"""

# ╔═╡ e78bd522-ce9b-11f1-aeaf-ff9d841ecc5c
function llenado_de_agua(a, B)
    missing  # reemplaza esta línea
end

# ╔═╡ e78bd522-ce9b-11f1-a365-930ffaea094e
md"""
### Interpretación

4. Con ``a_1 = 2`` y ``a_2 = 1``, ¿a partir de qué fondo recibe inversión la
   región 2? ¿Por qué un planificador que sólo busca eficiencia concentra
   todo en una región cuando el fondo es pequeño?
5. ¿Por qué ``\lambda(B)`` es decreciente? Explica en términos económicos qué
   significa que sea continuo en ``\bar B``.
6. En la sección 5, con ``\gamma > 1``, ¿qué región recibe todo el fondo?
   ¿Qué implica para la política regional que existan economías de
   aglomeración?
7. Un planificador preocupado por la equidad quiere que la región 2 reciba
   algo aunque el fondo sea pequeño. Propón dos formas de modificar el
   problema para lograrlo y explica su costo en producto total.
8. **[Avanzado]** Verifica numéricamente con `llenado_de_agua` que el precio
   sombra del problema con ``n`` regiones también cumple ``V'(B) = \lambda``.

## Para la próxima sesión

- **Sesión 3: envolvente y estática comparativa.** Por qué
  ``V'(B) = \lambda`` siempre, y cómo cambia el reparto cuando cambia la
  productividad de una región.
- Lectura: Chiang y Wainwright (2006), caps. 8 y 13.
- Repaso: C.I3, C.I4 y L.B4.
"""

# ╔═╡ e78bd52e-ce9b-11f1-9c3e-75e62ba17d58
md"""
---
## Apéndice: paquetes y funciones auxiliares

Estas celdas definen herramientas que usa el cuaderno. No es necesario
leerlas para seguir la sesión.
"""

# ╔═╡ e78bd536-ce9b-11f1-8876-4103614824ff
begin
    const AZUL    = "#2a78d6"   # serie principal
    const NARANJA = "#eb6834"   # restricción, punto destacado
    const GRIS    = "#52514e"   # referencias
    const TINTA   = "#0b0b0b"   # óptimo
end;

# ╔═╡ e78bd4e6-ce9b-11f1-bd2a-6de9b912e780
let
    r = range(1, 20, length = 200)
    p = plot(r, r .- 1; fillrange = 0, fillalpha = 0.15, color = NARANJA, lw = 2,
             xlims = (1, 20), ylims = (0, 10), xlabel = "brecha de productividad a₁/a₂",
             ylabel = "fondo B", title = "¿Quién recibe inversión?", size = (620, 360))
    annotate!(p, 14, 3, text("sólo la región 1", 9, NARANJA))
    annotate!(p, 4.5, 8, text("las dos regiones", 9, AZUL))
    scatter!(p, [a1 / a2], [B]; color = TINTA, ms = 6, msw = 0)
end

# ╔═╡ e78bd4f0-ce9b-11f1-973c-275954257fa3
let
    x1s = range(0, B, length = 400)
    φ = a1 .* x1s .^ γ .+ a2 .* (B .- x1s) .^ γ
    p = plot(x1s, φ; color = AZUL, lw = 2, xlabel = "inversión en la región 1, x₁",
             ylabel = "producto total", title = "Rendimientos con γ = $γ")
    if !(γ ≈ 1)
        cociente = (a2 / a1)^(1 / (γ - 1))      # x₁/x₂ en el punto interior
        xi = B * cociente / (1 + cociente)
        scatter!(p, [xi], [a1 * xi^γ + a2 * (B - xi)^γ]; color = NARANJA, ms = 6, msw = 0)
        annotate!(p, xi, a1 * xi^γ + a2 * (B - xi)^γ,
                  text(γ < 1 ? "  máximo" : "  mínimo", 8, :left, NARANJA))
    end
    p
end

# ╔═╡ e78bd4fc-ce9b-11f1-bdf0-0915ed216841
let
    x = range(0, 1, length = 300)
    p = plot(x, (1 .- x) .^ 3; fillrange = 0, fillalpha = 0.2, color = AZUL, lw = 2,
             xlims = (-0.1, 1.5), ylims = (-0.6, 1.1), aspect_ratio = :equal,
             xlabel = "x₁", ylabel = "x₂", size = (520, 420), grid = false,
             title = "Conjunto factible con una cúspide")
    hline!(p, [0]; color = GRIS, lw = 1)
    scatter!(p, [1], [0]; color = TINTA, ms = 6, msw = 0)
    plot!(p, [1, 1.4], [0, 0]; arrow = true, color = NARANJA, lw = 2)
    plot!(p, [1, 1], [0, 0.4]; arrow = true, color = GRIS, lw = 2)
    plot!(p, [1, 1], [0, -0.4]; arrow = true, color = GRIS, lw = 2)
    annotate!(p, 1.42, 0.07, text("∇ objetivo", 8, :left, NARANJA))
    annotate!(p, 1.05, 0.42, text("∇g₁ = (0, 1)", 8, :left, GRIS))
    annotate!(p, 1.05, -0.42, text("∇g₂ = (0, −1)", 8, :left, GRIS))
end

# ╔═╡ e78bd540-ce9b-11f1-8ce9-6bfbdc2a9ff2
"Producto total de las dos regiones: a₁ ln(1 + x₁) + a₂ ln(1 + x₂)."
producto(x1, x2, a1, a2) = a1 * log1p(x1) + a2 * log1p(x2)

# ╔═╡ e78bd48c-ce9b-11f1-95b8-e75574eb195c
mejor = let
    x1s = range(0, B, length = 400)                  # repartos posibles
    total = producto.(x1s, B .- x1s, a1, a2)         # producto de cada uno
    i = argmax(total)
    (x1 = x1s[i], x2 = B - x1s[i], producto = total[i])
end

# ╔═╡ e78bd496-ce9b-11f1-931f-f166ed23034e
let
    x1s = range(0, B, length = 400)
    total = producto.(x1s, B .- x1s, a1, a2)
    p = plot(x1s, total; color = AZUL, lw = 2,
             xlabel = "inversión en la región 1, x₁ (la región 2 recibe B − x₁)",
             ylabel = "producto total",
             title = "Producto total según el reparto del fondo B = $B")
    scatter!(p, [mejor.x1], [mejor.producto]; color = NARANJA, ms = 6, msw = 0)
    annotate!(p, mejor.x1, mejor.producto, text("  mejor reparto", 8, :left, NARANJA))
end

# ╔═╡ e78bd540-ce9b-11f1-9026-07a5f90961e5
"Gradiente del producto total (productos marginales de cada región)."
gradiente(x1, x2, a1, a2) = (a1 / (1 + x1), a2 / (1 + x2))

# ╔═╡ e78bd4a0-ce9b-11f1-b91d-217692321e46
let
    xs = range(0, 10, length = 200)
    p = contour(xs, xs, (u, v) -> producto(u, v, a1, a2); levels = 8, color = :blues,
                colorbar = false, xlabel = "x₁", ylabel = "x₂", aspect_ratio = :equal,
                xlims = (0, 10), ylims = (0, 10), size = (480, 440), grid = false,
                title = "Curvas de nivel de f y su gradiente")
    puntos = [(u, v) for u in 1:2:9 for v in 1:2:9]
    g = [gradiente(u, v, a1, a2) for (u, v) in puntos]
    escala = 1.4 / maximum(hypot(gi...) for gi in g)
    quiver!(p, first.(puntos), last.(puntos);
            quiver = (escala .* first.(g), escala .* last.(g)), color = NARANJA, lw = 1.5)
end

# ╔═╡ e78bd540-ce9b-11f1-a6b8-01e714750015
"Umbral del fondo a partir del cual la región menos productiva recibe inversión."
umbral(a1, a2) = max(a1, a2) / min(a1, a2) - 1

# ╔═╡ e78bd54a-ce9b-11f1-b710-2374643d867e
"Solución de Lagrange con el presupuesto agotado, sin imponer xᵢ ≥ 0: (x₁, x₂, λ)."
function lagrange_interior(a1, a2, B)
    λ = (a1 + a2) / (B + 2)
    (a1 / λ - 1, a2 / λ - 1, λ)
end

# ╔═╡ e78bd4b4-ce9b-11f1-9cc2-03275f158a23
let
    xl1, xl2, _ = lagrange_interior(a1, a2, B)
    xs = range(-0.95, 11, length = 300)
    p = contour(xs, xs, (u, v) -> producto(u, v, a1, a2);
                levels = [producto(xl1, xl2, a1, a2)], color = AZUL, lw = 2,
                colorbar = false, xlims = (-1, 11), ylims = (-1, 11),
                aspect_ratio = :equal, size = (480, 440), grid = false,
                xlabel = "x₁", ylabel = "x₂", title = "Solución de Lagrange")
    hline!(p, [0]; color = GRIS, lw = 1)
    vline!(p, [0]; color = GRIS, lw = 1)
    plot!(p, [-1, B + 1], [B + 1, -1]; color = NARANJA, lw = 1, ls = :dash)
    plot!(p, [0, B], [B, 0]; color = NARANJA, lw = 2.5)
    scatter!(p, [xl1], [xl2]; color = xl2 < 0 ? :red : TINTA, ms = 6, msw = 0)
end

# ╔═╡ e78bd4be-ce9b-11f1-b6df-6fee3f0fcc44
let
    xl1, xl2, λl = lagrange_interior(a1, a2, B)
    aviso = xl2 < 0 ?
        md"""
        !!! danger "No es factible"
            Con ``B`` = $(B), Lagrange recomienda ``x_2`` = $(round(xl2, digits = 2)):
            **desinvertir** en la región 2. Hacen falta las condiciones de
            Kuhn-Tucker (sección 4).
        """ :
        md"""
        !!! correct "Factible"
            Con ``B`` = $(B): ``x_1`` = $(round(xl1, digits = 2)),
            ``x_2`` = $(round(xl2, digits = 2)) y ``\lambda`` = $(round(λl, digits = 3)).
        """
    md"""
    $(aviso)

    **Mueve** ``B`` hacia abajo. **Observa** en qué valor el punto sale del
    cuadrante factible: es el umbral ``\bar B = a_1/a_2 - 1`` de las notas.
    """
end

# ╔═╡ e78bd54a-ce9b-11f1-a93d-5bede1039696
"Reparto óptimo con Kuhn-Tucker: (x₁, x₂, λ). Funciona con cualquier orden de a₁ y a₂."
function reparto_ref(a1, a2, B)
    if a1 < a2
        r = reparto_ref(a2, a1, B)
        return (r[2], r[1], r[3])
    end
    B <= umbral(a1, a2) ? (B, 0.0, a1 / (1 + B)) : lagrange_interior(a1, a2, B)
end

# ╔═╡ e78bd4dc-ce9b-11f1-9c6a-fba7cfb47592
let
    x1, x2, λ = reparto_ref(a1, a2, B)
    d1, d2 = a1 / (1 + x1) - λ, a2 / (1 + x2) - λ
    holgura = B - x1 - x2
    r(v) = round(v, digits = 4) + 0.0
    mensaje = x2 == 0 ?
        md"""
        La región 2 no recibe nada: su derivada es **negativa**, $(r(d2)). El
        primer peso invertido en ella rendiría ``a_2`` = $(a2), menos que el
        valor de un peso del fondo, ``\lambda`` = $(r(λ)).
        """ :
        md"""
        Las dos regiones reciben inversión: en ambas, el producto marginal
        iguala el precio sombra del fondo, ``\lambda`` = $(r(λ)).
        """
    md"""
    | | Variable | ``\partial\mathcal{L}/\partial x_i`` o holgura | Producto (debe ser 0) |
    |:---|---:|---:|---:|
    | Región 1 | ``x_1`` = $(r(x1)) | $(r(d1)) | $(r(x1 * d1)) |
    | Región 2 | ``x_2`` = $(r(x2)) | $(r(d2)) | $(r(x2 * d2)) |
    | Fondo | ``\lambda`` = $(r(λ)) | ``B - x_1 - x_2`` = $(r(holgura)) | $(r(λ * holgura)) |

    $(mensaje)

    La fórmula de Kuhn-Tucker da ``x_1`` = $(r(x1)); la búsqueda por fuerza
    bruta de la sección 0 dio $(r(mejor.x1)).
    """
end

# ╔═╡ e78bd554-ce9b-11f1-9f8b-ebc5706fe0e8
"Valor óptimo V(B): el producto total con el reparto óptimo."
function valor_ref(a1, a2, B)
    x1, x2, _ = reparto_ref(a1, a2, B)
    producto(x1, x2, a1, a2)
end

# ╔═╡ e78bd4ca-ce9b-11f1-8039-c77a5351bd64
let
    Bs = range(0.01, 10, length = 400)
    V = [valor_ref(a1, a2, b) for b in Bs]
    λs = [reparto_ref(a1, a2, b)[3] for b in Bs]
    B̄ = umbral(a1, a2)
    p1 = plot(Bs, V; color = AZUL, lw = 2, xlabel = "fondo B", ylabel = "V(B)",
              title = "Valor óptimo")
    p2 = plot(Bs, λs; color = AZUL, lw = 2, xlabel = "fondo B", ylabel = "λ(B)",
              title = "Precio sombra del fondo")
    for p in (p1, p2)
        B̄ <= 10 && vline!(p, [B̄]; color = GRIS, ls = :dash, lw = 1)
        vline!(p, [B]; color = NARANJA, lw = 1.5)
    end
    plot(p1, p2; layout = (1, 2), size = (760, 320))
end

# ╔═╡ e78bd4ca-ce9b-11f1-8410-f5f751df21a1
let
    h = 0.01
    λ = reparto_ref(a1, a2, B)[3]
    dif = (valor_ref(a1, a2, B + h) - valor_ref(a1, a2, B)) / h
    md"""
    **Comprobación numérica:** con ``B`` = $(B), aumentar el fondo en
    ``h = 0.01`` aumenta el producto en ``\Delta V/h`` = $(round(dif, digits = 4));
    el multiplicador vale ``\lambda`` = $(round(λ, digits = 4)).

    **Observa** que ``V`` es cóncava y que ``\lambda`` es continuo en el umbral,
    aunque la fórmula del reparto cambia ahí.
    """
end

# ╔═╡ e78bd55c-ce9b-11f1-b0c8-a7b535fe6d93
"Reparto óptimo entre n regiones con aᵢ ln(1 + xᵢ), por bisección en λ."
function llenado_de_agua_ref(a, B)
    total(λ) = sum(max.(a ./ λ .- 1, 0))
    bajo, alto = sum(a) / (B + length(a)), maximum(a)
    for _ in 1:200
        medio = (bajo + alto) / 2
        total(medio) > B ? (bajo = medio) : (alto = medio)
    end
    λ = (bajo + alto) / 2
    max.(a ./ λ .- 1, 0)
end

# ╔═╡ e78bd55c-ce9b-11f1-a8d2-211fbfbd8886
"Casos de prueba (a₁, a₂, B) para los ejercicios: esquina, umbral e interior."
const CASOS = [(2.0, 1.0, 0.5), (2.0, 1.0, 1.0), (2.0, 1.0, 4.0), (3.0, 0.5, 2.0), (1.0, 1.0, 3.0)]

# ╔═╡ e78bd55c-ce9b-11f1-a1cb-b3abcb3f756b
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

# ╔═╡ e78bd504-ce9b-11f1-ad0c-97074d3c8621
verificar(() -> [reparto_optimo(c...) for c in CASOS],
          [collect(reparto_ref(c...)) for c in CASOS];
          pista = md"Calcula `B̄ = a1 / a2 - 1`. Si `B <= B̄`, devuelve `[B, 0.0, a1 / (1 + B)]`. Si no, `λ = (a1 + a2) / (B + 2)`, `x1 = a1 / λ - 1` y `x2 = B - x1`.")

# ╔═╡ e78bd518-ce9b-11f1-9828-61e507a50535
verificar(() -> [precio_sombra_numerico(c...) for c in CASOS],
          [reparto_ref(c...)[3] for c in CASOS];
          rtol = 1e-5,
          pista = md"Devuelve `(valor_ref(a1, a2, B + h) - valor_ref(a1, a2, B - h)) / (2h)`.")

# ╔═╡ e78bd522-ce9b-11f1-bb83-6f737ae12cfd
verificar(() -> llenado_de_agua([3.0, 2.0, 1.0, 0.5], 2.0),
          llenado_de_agua_ref([3.0, 2.0, 1.0, 0.5], 2.0);
          rtol = 1e-6,
          pista = md"Busca ``\lambda`` entre `sum(a) / (B + length(a))` (ahí la suma es al menos `B`) y `maximum(a)` (ahí es 0). En cada paso, calcula `x = max.(a ./ λ .- 1, 0)` y compara `sum(x)` con `B`.")

# ╔═╡ Cell order:
# ╟─e78bd43c-ce9b-11f1-b314-71fe6852d880
# ╟─e78bd482-ce9b-11f1-b92a-59af3364debb
# ╟─e78bd482-ce9b-11f1-a6f9-f35e0a070569
# ╠═e78bd48c-ce9b-11f1-95b8-e75574eb195c
# ╟─e78bd496-ce9b-11f1-931f-f166ed23034e
# ╟─e78bd496-ce9b-11f1-b734-079aa93622ff
# ╟─e78bd4a0-ce9b-11f1-b39f-6f78cc0524b0
# ╟─e78bd4a0-ce9b-11f1-b91d-217692321e46
# ╟─e78bd4aa-ce9b-11f1-a496-af87ed01042d
# ╠═e78bd4aa-ce9b-11f1-95e9-755fe5ebafd6
# ╟─e78bd4aa-ce9b-11f1-8ab0-ed0b8ded6c6d
# ╟─e78bd4b4-ce9b-11f1-9cc2-03275f158a23
# ╟─e78bd4be-ce9b-11f1-b6df-6fee3f0fcc44
# ╟─e78bd4be-ce9b-11f1-8ff4-bdf19509cb57
# ╟─e78bd4ca-ce9b-11f1-8039-c77a5351bd64
# ╟─e78bd4ca-ce9b-11f1-8410-f5f751df21a1
# ╟─e78bd4d2-ce9b-11f1-9768-95012eb8dca9
# ╟─e78bd4dc-ce9b-11f1-9c6a-fba7cfb47592
# ╟─e78bd4dc-ce9b-11f1-9122-7392f2147a79
# ╟─e78bd4e6-ce9b-11f1-bd2a-6de9b912e780
# ╟─e78bd4e6-ce9b-11f1-89a7-a1eff3c842f4
# ╟─e78bd4f0-ce9b-11f1-973c-275954257fa3
# ╟─e78bd4f0-ce9b-11f1-ad30-41eb3b03fae0
# ╟─e78bd4fc-ce9b-11f1-b045-d97c7f998cc2
# ╟─e78bd4fc-ce9b-11f1-bdf0-0915ed216841
# ╟─e78bd504-ce9b-11f1-8f81-2f81f803e80a
# ╠═e78bd504-ce9b-11f1-bda8-4171ce10c7d7
# ╟─e78bd504-ce9b-11f1-ad0c-97074d3c8621
# ╟─e78bd50e-ce9b-11f1-b64f-3f647a14a6b7
# ╠═e78bd50e-ce9b-11f1-bc9d-8322b80270e0
# ╟─e78bd518-ce9b-11f1-9828-61e507a50535
# ╟─e78bd518-ce9b-11f1-9f17-f30fc5a81f35
# ╠═e78bd522-ce9b-11f1-aeaf-ff9d841ecc5c
# ╟─e78bd522-ce9b-11f1-bb83-6f737ae12cfd
# ╟─e78bd522-ce9b-11f1-a365-930ffaea094e
# ╟─e78bd52e-ce9b-11f1-9c3e-75e62ba17d58
# ╠═e78bd536-ce9b-11f1-9446-49ca1155e028
# ╠═e78bd536-ce9b-11f1-8876-4103614824ff
# ╠═e78bd540-ce9b-11f1-8ce9-6bfbdc2a9ff2
# ╠═e78bd540-ce9b-11f1-9026-07a5f90961e5
# ╠═e78bd540-ce9b-11f1-a6b8-01e714750015
# ╠═e78bd54a-ce9b-11f1-b710-2374643d867e
# ╠═e78bd54a-ce9b-11f1-a93d-5bede1039696
# ╠═e78bd554-ce9b-11f1-9f8b-ebc5706fe0e8
# ╠═e78bd55c-ce9b-11f1-b0c8-a7b535fe6d93
# ╠═e78bd55c-ce9b-11f1-a8d2-211fbfbd8886
# ╠═e78bd55c-ce9b-11f1-a1cb-b3abcb3f756b
