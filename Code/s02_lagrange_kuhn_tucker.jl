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

# ╔═╡ a94fed70-cf04-11f1-9de1-e7dd2b16dbe9
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

# ╔═╡ a94fec10-cf04-11f1-a8a1-b3b3d2b00ed8
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

# ╔═╡ a94fec4e-cf04-11f1-b7c7-af9490221fb6
TableOfContents(title = "Contenido")

# ╔═╡ a94fec58-cf04-11f1-8c56-1dd458154df1
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

# ╔═╡ a94fec76-cf04-11f1-8fff-e3efd0038973
md"""
**Mueve** ``B`` por debajo de 1, y prueba regiones muy distintas
(``a_1 = 4``, ``a_2 = 0.5``). **Observa:** ¿siempre recibe algo la región
menos productiva? La búsqueda por fuerza bruta da la respuesta para cada
caso, pero no dice por qué; las condiciones de Kuhn-Tucker sí (sección 4).
"""

# ╔═╡ a94fec82-cf04-11f1-9531-b9341291f83d
md"""
## 1. Repaso: gradiente, curvas de nivel y hessiana

*Antes de clase.* El gradiente de ``f`` (las flechas) es perpendicular a las
curvas de nivel; sus entradas son los productos marginales. **Observa** que
las flechas se acortan al alejarse del origen: rendimientos decrecientes.
"""

# ╔═╡ a94fec94-cf04-11f1-a777-4311a7c3ad00
md"""
Symbolics.jl calcula el gradiente y la hessiana; compáralos con los que
obtienes a mano (notas, sección 2):
"""

# ╔═╡ a94fec9e-cf04-11f1-ad22-f1fead361783
begin
    @variables x₁ x₂ α₁ α₂
    f_simbolica = α₁ * log(1 + x₁) + α₂ * log(1 + x₂)
    (gradiente = Symbolics.gradient(f_simbolica, [x₁, x₂]),
     hessiana = Symbolics.hessian(f_simbolica, [x₁, x₂]))
end

# ╔═╡ a94feca8-cf04-11f1-a034-a39a017c320d
md"""
## 2. Lagrange: el óptimo es una tangencia

*En clase, después de la sección 3.4 de las notas.* La solución de Lagrange
iguala los productos marginales: la curva de nivel (azul) toca la recta del
presupuesto (naranja, sólida donde es factible).
"""

# ╔═╡ a94fecbc-cf04-11f1-ae47-5ded3503d99f
md"""
## 3. El multiplicador como precio sombra

*En clase.* Las gráficas muestran el valor óptimo ``V(B)`` y el
multiplicador ``\lambda(B)`` para cada tamaño del fondo (notas, sección
3.2). La línea punteada es el umbral ``\bar B``; la naranja, el ``B``
elegido.
"""

# ╔═╡ a94fecda-cf04-11f1-99e8-8d4881e186e8
md"""
## 4. Kuhn-Tucker: soluciones de esquina

*En clase, después de la sección 4.4 de las notas.* La tabla evalúa las
condiciones de Kuhn-Tucker en la solución óptima: en cada renglón, el
producto de la última columna debe ser cero (holgura complementaria).
"""

# ╔═╡ a94fece6-cf04-11f1-8d6f-6351e6c0e189
md"""
**¿Quién recibe inversión?** La región 2 recibe sólo si ``B > \bar B``. El
mapa muestra los dos regímenes según la brecha de productividad ``a_1/a_2``
y el tamaño del fondo; el punto es la combinación de los deslizadores.
**Mueve** ``a_1`` y ``B`` y **observa** cómo el punto cruza la frontera.
"""

# ╔═╡ a94fecf8-cf04-11f1-965a-f181616db048
md"""
## 5. Sin concavidad, las condiciones no bastan

*En clase, antes de la sección 5 de las notas.* Con
``f_i = a_i x_i^\gamma``, la gráfica muestra el producto total a lo largo
del presupuesto y marca el punto interior que cumple Kuhn-Tucker.

``\gamma``: $(@bind γ Slider(0.3:0.1:2.0, default = 1.5, show_value = true))
"""

# ╔═╡ a94fed02-cf04-11f1-997a-098ceaa027bb
md"""
**Mueve** ``\gamma`` de 0.5 a 1.5. **Observa:** ¿cuándo el punto de
Kuhn-Tucker es el mejor reparto y cuándo el peor? ¿Adónde va el fondo con
rendimientos crecientes?
"""

# ╔═╡ a94fed0c-cf04-11f1-82d6-c7b0c02d1c57
md"""
## 6. [Avanzado] Cuando falla la calificación de las restricciones

*Fuera de clase* (notas, P.4). En el problema de maximizar ``x_1`` con
``x_2 \le (1 - x_1)^3``, el conjunto factible termina en una cúspide en el
óptimo ``(1, 0)``. Los gradientes de las restricciones activas son
paralelos y no pueden igualar al del objetivo: no existe ``\lambda``.
"""

# ╔═╡ a94fed14-cf04-11f1-a4f4-7d0b1cb71e4a
md"""
## Ejercicios

*Tarea de la semana del Laboratorio 0 (sesión 4).* Los ejercicios con
demostraciones están en las notas (sección 8).

### Completa el código

**1.** Escribe `reparto_optimo(a1, a2, B)`, que devuelva el vector
`[x1, x2, λ]` del reparto óptimo, suponiendo ``a_1 \ge a_2`` (notas,
sección 4.4).
"""

# ╔═╡ a94fed20-cf04-11f1-bf12-f7811bdfa22b
function reparto_optimo(a1, a2, B)
    missing  # reemplaza esta línea
end

# ╔═╡ a94fed34-cf04-11f1-bf2a-f7721b9badc8
md"""
**2.** Escribe `precio_sombra_numerico(a1, a2, B; h = 1e-5)`, que aproxime
``V'(B)`` con una diferencia centrada, ``\big(V(B + h) - V(B - h)\big)/2h``.
Usa la función `valor_ref(a1, a2, B)`, que calcula ``V(B)``. El verificador
compara tu resultado con ``\lambda``.
"""

# ╔═╡ a94fed3e-cf04-11f1-9736-6d25e159f5e3
function precio_sombra_numerico(a1, a2, B; h = 1e-5)
    missing  # reemplaza esta línea
end

# ╔═╡ a94fed46-cf04-11f1-958f-a1ce7a10016f
md"""
**3. [Avanzado]** Con ``n`` regiones, ``f_i = a_i\ln(1 + x_i)``, la solución
es ``x_i = \max\lbrace a_i/\lambda - 1,\ 0\rbrace``, con ``\lambda`` tal que las
inversiones suman ``B`` (notas, ejercicio F5). Escribe
`llenado_de_agua(a, B)`, que reciba el vector `a` y devuelva el vector de
inversiones. Encuentra ``\lambda`` por bisección: la suma de inversiones
decrece con ``\lambda``.
"""

# ╔═╡ a94fed52-cf04-11f1-88ae-b7c09c236e46
function llenado_de_agua(a, B)
    missing  # reemplaza esta línea
end

# ╔═╡ a94fed66-cf04-11f1-a700-bbd9fb42ea2a
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

# ╔═╡ a94fed70-cf04-11f1-a05d-6d31a5f22407
md"""
---
## Apéndice: paquetes y funciones auxiliares

Estas celdas definen herramientas que usa el cuaderno. No es necesario
leerlas para seguir la sesión.
"""

# ╔═╡ a94fed78-cf04-11f1-943a-e7ad4b836098
begin
    const AZUL    = "#2a78d6"   # serie principal
    const NARANJA = "#eb6834"   # restricción, punto destacado
    const GRIS    = "#52514e"   # referencias
    const TINTA   = "#0b0b0b"   # óptimo
end;

# ╔═╡ a94fecee-cf04-11f1-b675-a1209a06f419
let
    r = range(1, 20, length = 200)
    p = plot(r, r .- 1; fillrange = 0, fillalpha = 0.15, color = NARANJA, lw = 2,
             xlims = (1, 20), ylims = (0, 10), xlabel = "brecha de productividad a₁/a₂",
             ylabel = "fondo B", title = "¿Quién recibe inversión?", size = (620, 360))
    annotate!(p, 14, 3, text("sólo la región 1", 9, NARANJA))
    annotate!(p, 4.5, 8, text("las dos regiones", 9, AZUL))
    scatter!(p, [a1 / a2], [B]; color = TINTA, ms = 6, msw = 0)
end

# ╔═╡ a94fecf8-cf04-11f1-b6a7-eff00cdd1eb5
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

# ╔═╡ a94fed0c-cf04-11f1-9f50-978a0bdff4e3
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

# ╔═╡ a94fed84-cf04-11f1-86e5-afe1c0006567
"Producto total de las dos regiones: a₁ ln(1 + x₁) + a₂ ln(1 + x₂)."
producto(x1, x2, a1, a2) = a1 * log1p(x1) + a2 * log1p(x2)

# ╔═╡ a94fec62-cf04-11f1-8a2f-8d7408f7edbc
mejor = let
    x1s = range(0, B, length = 400)                  # repartos posibles
    total = producto.(x1s, B .- x1s, a1, a2)         # producto de cada uno
    i = argmax(total)
    (x1 = x1s[i], x2 = B - x1s[i], producto = total[i])
end

# ╔═╡ a94fec6c-cf04-11f1-bf34-39c6e935d3f3
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

# ╔═╡ a94fed84-cf04-11f1-bd41-e30983a9c93a
"Gradiente del producto total (productos marginales de cada región)."
gradiente(x1, x2, a1, a2) = (a1 / (1 + x1), a2 / (1 + x2))

# ╔═╡ a94fec8a-cf04-11f1-b22e-61e4d2b97787
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

# ╔═╡ a94fed8e-cf04-11f1-974c-bdfcf57ca213
"Umbral del fondo a partir del cual la región menos productiva recibe inversión."
umbral(a1, a2) = max(a1, a2) / min(a1, a2) - 1

# ╔═╡ a94fed98-cf04-11f1-b69e-9713fd17de23
"Solución de Lagrange con el presupuesto agotado, sin imponer xᵢ ≥ 0: (x₁, x₂, λ)."
function lagrange_interior(a1, a2, B)
    λ = (a1 + a2) / (B + 2)
    (a1 / λ - 1, a2 / λ - 1, λ)
end

# ╔═╡ a94fecb4-cf04-11f1-bcad-c9363afff3f6
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

# ╔═╡ a94fecb4-cf04-11f1-af20-b51c1e3b0b3f
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

# ╔═╡ a94feda2-cf04-11f1-81c2-6932afbf8875
"Reparto óptimo con Kuhn-Tucker: (x₁, x₂, λ). Funciona con cualquier orden de a₁ y a₂."
function reparto_ref(a1, a2, B)
    if a1 < a2
        r = reparto_ref(a2, a1, B)
        return (r[2], r[1], r[3])
    end
    B <= umbral(a1, a2) ? (B, 0.0, a1 / (1 + B)) : lagrange_interior(a1, a2, B)
end

# ╔═╡ a94fecda-cf04-11f1-8208-1f8900ade9f1
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

# ╔═╡ a94fedac-cf04-11f1-923e-2bf0d99b373c
"Valor óptimo V(B): el producto total con el reparto óptimo."
function valor_ref(a1, a2, B)
    x1, x2, _ = reparto_ref(a1, a2, B)
    producto(x1, x2, a1, a2)
end

# ╔═╡ a94fecc6-cf04-11f1-9428-a1916f5067e1
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

# ╔═╡ a94fecd0-cf04-11f1-b7a4-b1428ade8356
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

# ╔═╡ a94fedac-cf04-11f1-8a74-cf473efb2132
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

# ╔═╡ a94fedb6-cf04-11f1-95e5-038dc275095b
"Casos de prueba (a₁, a₂, B) para los ejercicios: esquina, umbral e interior."
const CASOS = [(2.0, 1.0, 0.5), (2.0, 1.0, 1.0), (2.0, 1.0, 4.0), (3.0, 0.5, 2.0), (1.0, 1.0, 3.0)]

# ╔═╡ a94fedc0-cf04-11f1-a3ca-8bf734ef6e12
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

# ╔═╡ a94fed2a-cf04-11f1-b2d9-19ad9201c499
verificar(() -> [reparto_optimo(c...) for c in CASOS],
          [collect(reparto_ref(c...)) for c in CASOS];
          pista = md"Calcula `B̄ = a1 / a2 - 1`. Si `B <= B̄`, devuelve `[B, 0.0, a1 / (1 + B)]`. Si no, `λ = (a1 + a2) / (B + 2)`, `x1 = a1 / λ - 1` y `x2 = B - x1`.")

# ╔═╡ a94fed3e-cf04-11f1-b11d-abb12e0167b6
verificar(() -> [precio_sombra_numerico(c...) for c in CASOS],
          [reparto_ref(c...)[3] for c in CASOS];
          rtol = 1e-5,
          pista = md"Devuelve `(valor_ref(a1, a2, B + h) - valor_ref(a1, a2, B - h)) / (2h)`.")

# ╔═╡ a94fed5c-cf04-11f1-a1f8-a1c080004cb3
verificar(() -> llenado_de_agua([3.0, 2.0, 1.0, 0.5], 2.0),
          llenado_de_agua_ref([3.0, 2.0, 1.0, 0.5], 2.0);
          rtol = 1e-6,
          pista = md"Busca ``\lambda`` entre `sum(a) / (B + length(a))` (ahí la suma es al menos `B`) y `maximum(a)` (ahí es 0). En cada paso, calcula `x = max.(a ./ λ .- 1, 0)` y compara `sum(x)` con `B`.")

# ╔═╡ Cell order:
# ╟─a94fec10-cf04-11f1-a8a1-b3b3d2b00ed8
# ╟─a94fec4e-cf04-11f1-b7c7-af9490221fb6
# ╟─a94fec58-cf04-11f1-8c56-1dd458154df1
# ╠═a94fec62-cf04-11f1-8a2f-8d7408f7edbc
# ╟─a94fec6c-cf04-11f1-bf34-39c6e935d3f3
# ╟─a94fec76-cf04-11f1-8fff-e3efd0038973
# ╟─a94fec82-cf04-11f1-9531-b9341291f83d
# ╟─a94fec8a-cf04-11f1-b22e-61e4d2b97787
# ╟─a94fec94-cf04-11f1-a777-4311a7c3ad00
# ╠═a94fec9e-cf04-11f1-ad22-f1fead361783
# ╟─a94feca8-cf04-11f1-a034-a39a017c320d
# ╟─a94fecb4-cf04-11f1-bcad-c9363afff3f6
# ╟─a94fecb4-cf04-11f1-af20-b51c1e3b0b3f
# ╟─a94fecbc-cf04-11f1-ae47-5ded3503d99f
# ╟─a94fecc6-cf04-11f1-9428-a1916f5067e1
# ╟─a94fecd0-cf04-11f1-b7a4-b1428ade8356
# ╟─a94fecda-cf04-11f1-99e8-8d4881e186e8
# ╟─a94fecda-cf04-11f1-8208-1f8900ade9f1
# ╟─a94fece6-cf04-11f1-8d6f-6351e6c0e189
# ╟─a94fecee-cf04-11f1-b675-a1209a06f419
# ╟─a94fecf8-cf04-11f1-965a-f181616db048
# ╟─a94fecf8-cf04-11f1-b6a7-eff00cdd1eb5
# ╟─a94fed02-cf04-11f1-997a-098ceaa027bb
# ╟─a94fed0c-cf04-11f1-82d6-c7b0c02d1c57
# ╟─a94fed0c-cf04-11f1-9f50-978a0bdff4e3
# ╟─a94fed14-cf04-11f1-a4f4-7d0b1cb71e4a
# ╠═a94fed20-cf04-11f1-bf12-f7811bdfa22b
# ╟─a94fed2a-cf04-11f1-b2d9-19ad9201c499
# ╟─a94fed34-cf04-11f1-bf2a-f7721b9badc8
# ╠═a94fed3e-cf04-11f1-9736-6d25e159f5e3
# ╟─a94fed3e-cf04-11f1-b11d-abb12e0167b6
# ╟─a94fed46-cf04-11f1-958f-a1ce7a10016f
# ╠═a94fed52-cf04-11f1-88ae-b7c09c236e46
# ╟─a94fed5c-cf04-11f1-a1f8-a1c080004cb3
# ╟─a94fed66-cf04-11f1-a700-bbd9fb42ea2a
# ╟─a94fed70-cf04-11f1-a05d-6d31a5f22407
# ╠═a94fed70-cf04-11f1-9de1-e7dd2b16dbe9
# ╠═a94fed78-cf04-11f1-943a-e7ad4b836098
# ╠═a94fed84-cf04-11f1-86e5-afe1c0006567
# ╠═a94fed84-cf04-11f1-bd41-e30983a9c93a
# ╠═a94fed8e-cf04-11f1-974c-bdfcf57ca213
# ╠═a94fed98-cf04-11f1-b69e-9713fd17de23
# ╠═a94feda2-cf04-11f1-81c2-6932afbf8875
# ╠═a94fedac-cf04-11f1-923e-2bf0d99b373c
# ╠═a94fedac-cf04-11f1-8a74-cf473efb2132
# ╠═a94fedb6-cf04-11f1-95e5-038dc275095b
# ╠═a94fedc0-cf04-11f1-a3ca-8bf734ef6e12
