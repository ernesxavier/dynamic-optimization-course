#%% hide
md"""
# Sesión 2: Lagrange, concavidad y Kuhn-Tucker

**Pregunta de la unidad.** Un gobierno tiene un fondo ``B`` para invertir en
dos regiones. ¿Cómo debe repartirlo? ¿Conviene siempre dar algo a cada
región?

**Objetivos de la sesión**
1. Plantear el reparto como un problema de optimización con restricciones.
2. Leer la condición de Lagrange como una tangencia, y el multiplicador como
   el valor de un peso adicional del fondo.
3. Usar las condiciones de Kuhn-Tucker para encontrar soluciones de esquina.
4. Entender por qué la concavidad hace suficientes esas condiciones, y qué
   pasa cuando falta.

**Cómo usar este cuaderno.** Pluto es reactivo: al mover un deslizador, todo
lo que depende de él se recalcula. Las secciones marcadas **[Avanzado]** son
opcionales. Las demostraciones están en las notas formales,
`Class_notes/s02_lagrange_kuhn_tucker.md`.

**Cómo abrirlo.** Desde la raíz del repositorio:
`julia --project=Code -e 'using Pluto; Pluto.run()'` y abrir
`Code/s02_lagrange_kuhn_tucker.jl`.

**Repaso recomendado** (en `Class_notes/repaso/`): C.B2 (máximos en una
variable), C.B5 (gradiente), C.I1 y C.I2 (hessiana y concavidad), C.I5
(Lagrange), L.I4 y L.I5 (definitud y hessiana orlada). Para los puntos
[Avanzado]: C.A1 y L.A3.
"""

#%% hide
TableOfContents(title = "Contenido")

#%% hide
md"""
## 0. La pregunta: repartir un fondo entre dos regiones

Cada peso invertido en la región ``i`` produce

```math
f_i(x_i) = a_i \ln(1 + x_i),
```

donde ``x_i \ge 0`` es la inversión y ``a_i`` la productividad de la región.
Más inversión da más producto, pero cada peso rinde menos que el anterior.
La región 1 es la más productiva: ``a_1 \ge a_2``.

Es la versión estática del hilo conductor del curso (sesión 1): se decide
una sola vez y no hay "después". El fondo se reparte por completo: la región
1 recibe ``x_1`` y la región 2, ``B - x_1``. Mueve los deslizadores y observa dónde está el mejor reparto.

``a_1`` (productividad de la región 1): $(@bind a1 Slider(1.0:0.1:4.0, default = 2.0, show_value = true))

``a_2`` (productividad de la región 2): $(@bind a2 Slider(0.2:0.1:1.0, default = 1.0, show_value = true))

Fondo ``B``: $(@bind B Slider(0.1:0.1:10.0, default = 4.0, show_value = true))
"""

#%% hide
let
    x1s = range(0, B, length = 400)
    total = producto.(x1s, B .- x1s, a1, a2)
    i = argmax(total)
    p = plot(x1s, total; color = AZUL, lw = 2,
             xlabel = "inversión en la región 1, x₁ (la región 2 recibe B − x₁)",
             ylabel = "producto total",
             title = "Producto total según el reparto del fondo B = $B")
    scatter!(p, [x1s[i]], [total[i]]; color = NARANJA, ms = 6, msw = 0)
    annotate!(p, x1s[i], total[i], text("  mejor reparto", 8, :left, NARANJA))
end

#%% hide
let
    x1, x2, λ = reparto_ref(a1, a2, B)
    md"""
    Con estos valores, el mejor reparto da ``x_1 = `` $(round(x1, digits = 2))
    a la región 1 y ``x_2 = `` $(round(x2, digits = 2)) a la región 2.

    Prueba con un fondo pequeño (``B < 1``) y con regiones muy distintas
    (``a_1 = 4``, ``a_2 = 0.5``). **¿Siempre recibe algo la región menos
    productiva?** Las condiciones de Kuhn-Tucker (sección 4) dicen exactamente
    cuándo sí y cuándo no.
    """
end

#%% hide
md"""
## 1. Repaso: gradiente, curvas de nivel y hessiana

Con ``f(x_1, x_2) = a_1\ln(1 + x_1) + a_2\ln(1 + x_2)``, el **gradiente**

```math
\nabla f = \left(\frac{a_1}{1 + x_1},\ \frac{a_2}{1 + x_2}\right)
```

apunta hacia donde ``f`` crece más rápido y es perpendicular a las **curvas
de nivel**. Sus entradas son los productos marginales de la inversión en cada
región. Las flechas se acortan al alejarse del origen: rendimientos
decrecientes.
"""

#%% hide
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

#%% hide
md"""
La **hessiana** se puede calcular a mano o con Symbolics.jl:
"""

#%%
begin
    @variables x₁ x₂ α₁ α₂
    f_simbolica = α₁ * log(1 + x₁) + α₂ * log(1 + x₂)
    (gradiente = Symbolics.gradient(f_simbolica, [x₁, x₂]),
     hessiana = Symbolics.hessian(f_simbolica, [x₁, x₂]))
end

#%% hide
md"""
La hessiana es diagonal con entradas negativas: es **definida negativa** en
todo punto, así que ``f`` es estrictamente cóncava (C.I2). Esto será clave
en la sección 4: con una función cóncava y restricciones lineales, las
condiciones de primer orden bastan para el máximo global.
"""

#%% hide
md"""
## 2. Lagrange: el óptimo es una tangencia

Si se exige gastar todo el fondo, ``x_1 + x_2 = B``, y se ignora que la
inversión no puede ser negativa, el método de Lagrange pide que la curva de
nivel de ``f`` sea **tangente** a la recta del presupuesto:

```math
\frac{a_1}{1 + x_1} = \frac{a_2}{1 + x_2} = \lambda .
```

El último peso debe rendir lo mismo en las dos regiones. Despejando,

```math
\lambda = \frac{a_1 + a_2}{B + 2}, \qquad
x_i = \frac{a_i\,(B + 2)}{a_1 + a_2} - 1 .
```

En la gráfica, la recta naranja es el presupuesto (sólida donde es factible),
la curva azul es la curva de nivel tangente y el punto es la solución de
Lagrange.
"""

#%% hide
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

#%% hide
let
    xl1, xl2, λl = lagrange_interior(a1, a2, B)
    aviso = xl2 < 0 ?
        md"""
        !!! danger "No es factible"
            Con ``B`` = $(B), Lagrange recomienda ``x_2`` = $(round(xl2, digits = 2)):
            **desinvertir** en la región 2 para invertir más en la 1. La inversión
            no puede ser negativa. Para tratar las restricciones ``x_i \ge 0``
            hacen falta las condiciones de Kuhn-Tucker (sección 4).
        """ :
        md"""
        !!! correct "Factible"
            Con ``B`` = $(B), las dos inversiones son positivas:
            ``x_1`` = $(round(xl1, digits = 2)), ``x_2`` = $(round(xl2, digits = 2)),
            y ``\lambda`` = $(round(λl, digits = 3)).
        """
    md"""
    $(aviso)

    Reduce ``B`` hasta que el punto salga del cuadrante factible. ¿En qué
    valor de ``B`` ocurre? (Respuesta en la sección 4.)
    """
end

#%% hide
md"""
## 3. El multiplicador como precio sombra

¿Qué significa ``\lambda``? Si ``V(B)`` es el producto total con el mejor
reparto del fondo ``B``, entonces

```math
V'(B) = \lambda :
```

el multiplicador es el **valor de un peso adicional del fondo**. La
demostración general es el teorema de la envolvente (sesión 3). Aquí se
comprueba numéricamente. La línea punteada marca el umbral ``\bar B`` a
partir del cual la región 2 recibe inversión, y la naranja, el ``B`` elegido.
"""

#%% hide
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

#%% hide
let
    h = 0.01
    λ = reparto_ref(a1, a2, B)[3]
    dif = (valor_ref(a1, a2, B + h) - valor_ref(a1, a2, B)) / h
    md"""
    Con ``B`` = $(B): aumentar el fondo en ``h = 0.01`` aumenta el producto en
    ``\Delta V / h`` = $(round(dif, digits = 4)), y el multiplicador vale
    ``\lambda`` = $(round(λ, digits = 4)).

    Observa dos cosas en las gráficas: ``V`` es **cóncava** (cada peso adicional
    vale menos que el anterior) y ``\lambda`` es **continuo** en el umbral,
    aunque la fórmula del reparto cambia ahí.
    """
end

#%% hide
md"""
## 4. Kuhn-Tucker: soluciones de esquina

Con las restricciones completas, ``x_1 + x_2 \le B`` y ``x_1, x_2 \ge 0``, y
el lagrangiano ``\mathcal{L} = f(x) + \lambda (B - x_1 - x_2)``, las
condiciones de Kuhn-Tucker son:

```math
\frac{a_i}{1 + x_i} - \lambda \le 0, \qquad x_i \ge 0, \qquad
x_i \left(\frac{a_i}{1 + x_i} - \lambda\right) = 0,
```

```math
B - x_1 - x_2 \ge 0, \qquad \lambda \ge 0, \qquad \lambda\,(B - x_1 - x_2) = 0 .
```

En cada par, **al menos una de las dos desigualdades se cumple con
igualdad** (holgura complementaria). La tabla las evalúa en la solución
óptima para los valores de los deslizadores.
"""

#%% hide
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
    """
end

#%% hide
md"""
Resolviendo los casos (notas, sección 4.4), la región 2 recibe inversión si
y sólo si el fondo supera el umbral

```math
\bar B = \frac{a_1}{a_2} - 1 .
```

Con un fondo pequeño, todo va a la región más productiva. El mapa muestra los
dos regímenes según la brecha de productividad ``a_1/a_2`` y el tamaño del
fondo. El punto es la combinación elegida con los deslizadores.
"""

#%% hide
let
    r = range(1, 20, length = 200)
    p = plot(r, r .- 1; fillrange = 0, fillalpha = 0.15, color = NARANJA, lw = 2,
             xlims = (1, 20), ylims = (0, 10), xlabel = "brecha de productividad a₁/a₂",
             ylabel = "fondo B", title = "¿Quién recibe inversión?", size = (620, 360))
    annotate!(p, 14, 3, text("sólo la región 1", 9, NARANJA))
    annotate!(p, 4.5, 8, text("las dos regiones", 9, AZUL))
    scatter!(p, [a1 / a2], [B]; color = TINTA, ms = 6, msw = 0)
end

#%% hide
md"""
## 5. Sin concavidad, las condiciones no bastan

Supón **rendimientos crecientes**, ``f_i = a_i x_i^\gamma`` con
``\gamma > 1``, por ejemplo por economías de aglomeración. La gráfica
muestra el producto total a lo largo del presupuesto, ``x_2 = B - x_1``, y
marca el punto interior donde los productos marginales se igualan, que
cumple las condiciones de Kuhn-Tucker.

``\gamma``: $(@bind γ Slider(0.3:0.1:2.0, default = 1.5, show_value = true))
"""

#%% hide
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

#%% hide
md"""
- Con ``\gamma < 1``, ``f`` es cóncava y el punto interior es el **máximo**:
  conviene repartir.
- Con ``\gamma > 1``, ``f`` es convexa a lo largo del presupuesto y el punto
  interior es el **mínimo**. El óptimo está en una esquina: todo el fondo a
  una sola región.

Las condiciones de Kuhn-Tucker son **necesarias**; sólo con concavidad son
también **suficientes** (notas, sección 4.3). Para la política regional, la
lección es que la forma de los rendimientos decide entre repartir y
concentrar.
"""

#%% hide
md"""
## 6. [Avanzado] Cuando falla la calificación de las restricciones

Maximizar ``x_1`` sujeto a ``x_2 \le (1 - x_1)^3`` y ``x_1, x_2 \ge 0``. El
conjunto factible (sombreado) termina en una **cúspide** en ``(1, 0)``, que
es el óptimo. Ahí los gradientes de las dos restricciones activas, ``(0, 1)``
y ``(0, -1)``, son paralelos: no pueden combinarse para igualar el gradiente
del objetivo, ``(1, 0)``. Las condiciones de Kuhn-Tucker fallan aunque el
óptimo existe.
"""

#%% hide
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

#%% hide
md"""
## Resumen

| Herramienta | Qué dice | En el problema de las regiones |
|---|---|---|
| Primer orden | En un máximo interior, ``\nabla f = 0`` | — |
| Concavidad | Hessiana semidefinida negativa: el óptimo local es global | ``f`` es estrictamente cóncava |
| Lagrange | Tangencia: ``\nabla f = \lambda \nabla g`` | Igualar productos marginales |
| Precio sombra | ``V'(B) = \lambda`` | Valor de un peso adicional del fondo |
| Kuhn-Tucker | Signos y holgura complementaria | La región 2 recibe sólo si ``B > a_1/a_2 - 1`` |
| Suficiencia | ``f`` cóncava y restricciones convexas: Kuhn-Tucker basta | Sí; con rendimientos crecientes, no |
"""

#%% hide
md"""
## Ejercicios

### Completa el código

**1.** Escribe `reparto_optimo(a1, a2, B)`, que devuelva el vector
`[x1, x2, λ]` del reparto óptimo, suponiendo ``a_1 \ge a_2``. Usa el umbral
``\bar B = a_1/a_2 - 1`` y las dos fórmulas de las secciones 2 y 4.
"""

#%%
function reparto_optimo(a1, a2, B)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> [reparto_optimo(c...) for c in CASOS],
          [collect(reparto_ref(c...)) for c in CASOS];
          pista = md"Calcula `B̄ = a1 / a2 - 1`. Si `B <= B̄`, devuelve `[B, 0.0, a1 / (1 + B)]`. Si no, `λ = (a1 + a2) / (B + 2)`, `x1 = a1 / λ - 1` y `x2 = B - x1`.")

#%% hide
md"""
**2.** Escribe `precio_sombra_numerico(a1, a2, B; h = 1e-5)`, que aproxime
``V'(B)`` con una diferencia centrada, ``\big(V(B + h) - V(B - h)\big)/2h``.
Usa la función `valor_ref(a1, a2, B)`, que calcula ``V(B)``. El verificador
compara tu resultado con ``\lambda``.
"""

#%%
function precio_sombra_numerico(a1, a2, B; h = 1e-5)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> [precio_sombra_numerico(c...) for c in CASOS],
          [reparto_ref(c...)[3] for c in CASOS];
          rtol = 1e-5,
          pista = md"Devuelve `(valor_ref(a1, a2, B + h) - valor_ref(a1, a2, B - h)) / (2h)`.")

#%% hide
md"""
**3. [Avanzado]** Con ``n`` regiones, ``f_i = a_i\ln(1 + x_i)``, la solución
es ``x_i = \max\lbrace a_i/\lambda - 1,\ 0\rbrace``, con ``\lambda`` tal que las
inversiones suman ``B`` (notas, ejercicio F5). Escribe
`llenado_de_agua(a, B)`, que reciba el vector `a` y devuelva el vector de
inversiones. Encuentra ``\lambda`` por bisección: la suma de inversiones
decrece con ``\lambda``.
"""

#%%
function llenado_de_agua(a, B)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> llenado_de_agua([3.0, 2.0, 1.0, 0.5], 2.0),
          llenado_de_agua_ref([3.0, 2.0, 1.0, 0.5], 2.0);
          rtol = 1e-6,
          pista = md"Busca ``\lambda`` entre `sum(a) / (B + length(a))` (ahí la suma es al menos `B`) y `maximum(a)` (ahí es 0). En cada paso, calcula `x = max.(a ./ λ .- 1, 0)` y compara `sum(x)` con `B`.")

#%% hide
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

### [Avanzado]

8. Demuestra directamente, sin el teorema general, que el reparto de la
   sección 4 es el máximo global (usa la concavidad de ``f``).
9. Verifica numéricamente con `llenado_de_agua` que el precio sombra del
   problema con ``n`` regiones también cumple ``V'(B) = \lambda``.
10. En la sección 6, reemplaza ``(1 - x_1)^3`` por ``1 - x_1``. ¿Se cumple
    ahora la calificación de las restricciones? ¿Existe ``\lambda``?

## Para la próxima sesión

- **Sesión 3: envolvente y estática comparativa.** Veremos por qué
  ``V'(B) = \lambda`` siempre (teorema de la envolvente) y cómo cambia el
  reparto cuando cambia la productividad de una región (estática
  comparativa con el teorema de la función implícita y la regla de Cramer).
- Lectura: Chiang y Wainwright (2006), caps. 8 y 13.
- Repaso: C.I3, C.I4 y L.B4.
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
    using PlutoUI, Plots, Symbolics, LinearAlgebra, Markdown
    gr()
    default(size = (720, 320), legend = false, grid = :y, gridalpha = 0.15,
            framestyle = :axes, titlefontsize = 11, guidefontsize = 9,
            tickfontsize = 8, legendfontsize = 8, foreground_color_legend = nothing,
            background_color_legend = nothing, margin = 3Plots.mm)
end

#%%
begin
    const AZUL    = "#2a78d6"   # serie principal
    const NARANJA = "#eb6834"   # restricción, punto destacado
    const GRIS    = "#52514e"   # referencias
    const TINTA   = "#0b0b0b"   # óptimo
end;

#%%
"Producto total de las dos regiones: a₁ ln(1 + x₁) + a₂ ln(1 + x₂)."
producto(x1, x2, a1, a2) = a1 * log1p(x1) + a2 * log1p(x2)

#%%
"Gradiente del producto total (productos marginales de cada región)."
gradiente(x1, x2, a1, a2) = (a1 / (1 + x1), a2 / (1 + x2))

#%%
"Umbral del fondo a partir del cual la región menos productiva recibe inversión."
umbral(a1, a2) = max(a1, a2) / min(a1, a2) - 1

#%%
"Solución de Lagrange con el presupuesto agotado, sin imponer xᵢ ≥ 0: (x₁, x₂, λ)."
function lagrange_interior(a1, a2, B)
    λ = (a1 + a2) / (B + 2)
    (a1 / λ - 1, a2 / λ - 1, λ)
end

#%%
"Reparto óptimo con Kuhn-Tucker: (x₁, x₂, λ). Funciona con cualquier orden de a₁ y a₂."
function reparto_ref(a1, a2, B)
    if a1 < a2
        r = reparto_ref(a2, a1, B)
        return (r[2], r[1], r[3])
    end
    B <= umbral(a1, a2) ? (B, 0.0, a1 / (1 + B)) : lagrange_interior(a1, a2, B)
end

#%%
"Valor óptimo V(B): el producto total con el reparto óptimo."
function valor_ref(a1, a2, B)
    x1, x2, _ = reparto_ref(a1, a2, B)
    producto(x1, x2, a1, a2)
end

#%%
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

#%%
"Casos de prueba (a₁, a₂, B) para los ejercicios: esquina, umbral e interior."
const CASOS = [(2.0, 1.0, 0.5), (2.0, 1.0, 1.0), (2.0, 1.0, 4.0), (3.0, 0.5, 2.0), (1.0, 1.0, 3.0)]

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
