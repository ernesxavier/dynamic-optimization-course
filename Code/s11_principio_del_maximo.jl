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

# ╔═╡ 5138c7ce-cf06-11f1-b8ff-f9cb4a9915c5
begin
    # Usa el entorno del curso (Code/Project.toml) en lugar del gestor de
    # paquetes propio de Pluto: un solo entorno para todo el repositorio.
    import Pkg
    Pkg.activate(@__DIR__)
    Pkg.instantiate()
    using PlutoUI, Plots, Markdown
    gr()
    default(size = (720, 320), legend = false, grid = :y, gridalpha = 0.15,
            framestyle = :axes, titlefontsize = 11, guidefontsize = 9,
            tickfontsize = 8, legendfontsize = 8, foreground_color_legend = nothing,
            background_color_legend = nothing, margin = 3Plots.mm)
end

# ╔═╡ 5138c682-cf06-11f1-882e-4504db18781d
md"""
# Sesión 11: Principio del máximo

**Pregunta de la unidad.** ¿Conviene invertir primero donde se ahorra más o
donde se produce más?

**Cómo usar este cuaderno.** La teoría está en las notas,
`Class_notes/s11_principio_del_maximo.md`, y se desarrolla en el pizarrón;
el cuaderno sirve para mover los parámetros, ver qué pasa y comprobar
numéricamente. En clase se proyectan las secciones 1 a 4; la sección 5 y
los ejercicios son para después. Pluto es reactivo: al mover un
deslizador, todo lo que depende de él se recalcula.

**Cómo abrirlo.** Desde la raíz del repositorio:
`julia --project=Code -e 'using Pluto; Pluto.run()'` y abrir
`Code/s11_principio_del_maximo.jl`.
"""

# ╔═╡ 5138c6be-cf06-11f1-abb2-4f0dab8b601e
TableOfContents(title = "Contenido")

# ╔═╡ 5138c6d2-cf06-11f1-a252-3ba97960bb62
md"""
## 1. Un recurso no renovable

*Si alcanza (margen de la clase), después de la sección 5.3 de las notas.* El
recurso de la sección 5.1 de las notas, con ``b = 1`` y ``T = 20`` años. El
cuaderno busca por bisección el ``\lambda`` con el que la extracción total
es igual a las reservas.

Reservas iniciales, ``S_0``: $(@bind S0 Slider(10:10:250, default = 100, show_value = true))

Tasa de descuento, ``\rho``: $(@bind ρ Slider(0.01:0.01:0.10, default = 0.05, show_value = true))

Precio de ahogo, ``a``: $(@bind a Slider(5:1:20, default = 10, show_value = true))
"""

# ╔═╡ 5138c6f0-cf06-11f1-87cf-4f1cddd37890
md"""
## 2. ¿Cuánto vale una tonelada más bajo tierra?

*Si alcanza (margen de la clase)* (notas, 4.1). A la izquierda, el precio
sombra para cada nivel de reservas; a la derecha, el valor óptimo
``V(S_0)`` y la recta con pendiente ``\lambda``.
"""

# ╔═╡ 5138c70e-cf06-11f1-aa45-85a4f3b74bea
md"""
## 3. La condición 1: ``q`` maximiza ``H``

*Si alcanza (margen de la clase)* (notas, 2.2 y 5.2). El Hamiltoniano
``H(q) = e^{-\rho t}B(q) - \lambda q`` en el instante elegido, con el
``\lambda`` de la sección 1, y su máximo sobre ``q \ge 0``.

Instante ``t``: $(@bind t_h Slider(0.0:0.5:20.0, default = 5.0, show_value = true))
"""

# ╔═╡ 5138c722-cf06-11f1-be2e-17f1cc2da6d3
md"""
1. Con ``S_0 = 100``, **mueve** ``t``: el máximo siempre es interior.
2. **Pon** ``S_0 = 30`` en la sección 1 y mueve ``t`` después de ``\tau``
   (unos 12 años): ¿dónde está el máximo? ¿Cuánto vale ahí
   ``\partial H/\partial q``? Es la solución de esquina que la ecuación de
   Euler no podía encontrar.
"""

# ╔═╡ 5138c722-cf06-11f1-a044-573ed5d2b9d0
md"""
## 4. Condiciones terminales

*Si alcanza (margen de la clase), después de la sección 3 de las notas.* El ejemplo
de la sección 3 de las notas con las tres condiciones finales: libre (gris),
``y(2) \ge y_{\min}`` (naranja) y ``y(2) = y_{\min}`` (azul).

Estado mínimo al final, ``y_{\min}``: $(@bind ymin Slider(0.0:0.25:4.0, default = 3.0, show_value = true))
"""

# ╔═╡ 5138c736-cf06-11f1-991b-8ba2b36509cf
md"""
1. **Mueve** ``y_{\min}`` por debajo de 2: ¿coinciden la curva naranja y la
   gris? ¿Cuánto vale ``\lambda(2)``?
2. **Súbelo** por encima de 2: ¿cuándo se activa la restricción?
3. **Observa** la curva azul con ``y_{\min} < 2``: ¿qué signo tiene
   ``\lambda(2)``, y qué significa?
"""

# ╔═╡ 5138c736-cf06-11f1-9882-f52ef223b09d
md"""
## 5. [Avanzado] Hamiltoniano lineal: bang-bang

*Fuera de clase* (notas, ejercicio F5). Chiang (sec. 7.2, ejemplo 2):
``\max \int_0^2 (2y - 3u)\, dt`` con
``y' = y + u``, ``y(0) = 4``, ``y(2)`` libre y ``u \in [0, 2]``. El
Hamiltoniano ``H = (2 + \lambda)y + (\lambda - 3)u`` es **lineal** en ``u``:
el máximo está en un extremo, ``u = 2`` si ``\lambda > 3`` y ``u = 0`` si
``\lambda < 3``. La **función de cambio** es ``\partial H/\partial u = \lambda - 3``.
Con ``\lambda' = -(2 + \lambda)`` y ``\lambda(2) = 0``,
``\lambda(t) = 2e^{2 - t} - 2``.
"""

# ╔═╡ 5138c74a-cf06-11f1-b00d-cb6cb8649848
md"""
**Observa** dónde cruza el cero la función de cambio y qué hace el control
en ese instante. ¿Por qué vale poco una unidad de estado cerca del final?
Es la estructura de las sesiones 13 y 14.
"""

# ╔═╡ 5138c754-cf06-11f1-acc9-9924fcb6ca82
md"""
## Ejercicios

*Después de clase.* Los ejercicios con demostraciones están en las notas
(sección 8).

### Completa el código

**1.** Escribe `extraccion(t, λ)`, la extracción óptima en el instante ``t``
con precio sombra ``\lambda``, para ``a = 10``, ``b = 1`` y ``\rho = 0.05``.
No olvides que ``q \ge 0``.
"""

# ╔═╡ 5138c75e-cf06-11f1-987a-19dd5fd6865f
function extraccion(t, λ)
    missing  # reemplaza esta línea
end

# ╔═╡ 5138c772-cf06-11f1-9c85-339abe773a6e
md"""
**2.** Escribe `lambda_recurso(S0)`, que encuentre por bisección el precio
sombra con ``a = 10``, ``\rho = 0.05`` y ``T = 20``. Usa `extraido(λ)`, que
devuelve la extracción total ``\int_0^T q\, dt`` con ese ``\lambda``. Si
`extraido(0.0) <= S0`, el recurso sobra y ``\lambda = 0``; si no, busca entre
0 y 10.
"""

# ╔═╡ 5138c77c-cf06-11f1-abed-3f29a6d7a985
function lambda_recurso(S0)
    missing  # reemplaza esta línea
end

# ╔═╡ 5138c790-cf06-11f1-8683-437ed8c9d50d
md"""
**3.** Escribe `lambda_final(ymin)`, el valor de ``\lambda(2)`` en el
ejemplo de la sección 4 con la condición ``y(2) \ge y_{\min}``.
"""

# ╔═╡ 5138c790-cf06-11f1-af36-d5e4f0273517
lambda_final(ymin) = missing  # reemplaza missing

# ╔═╡ 5138c7a4-cf06-11f1-99c2-51d6e33d0490
md"""
**4. [Avanzado]** Escribe `coestado_bb(t)`, la solución de
``\lambda' = -(2 + \lambda)`` con ``\lambda(2) = 0`` del problema de la
sección 5.
"""

# ╔═╡ 5138c7ae-cf06-11f1-9138-07485776fdfd
coestado_bb(t) = missing  # reemplaza missing

# ╔═╡ 5138c7b8-cf06-11f1-9627-5dce366285c3
md"""
### Interpretación

5. En la sección 1, la demanda no cambia con el tiempo. ¿Por qué entonces
   la extracción óptima baja año con año?
6. Con ``S_0 = 250``, ``\lambda = 0``. ¿Qué significa que una tonelada más
   no valga nada? ¿Le serviría a esa región una política de conservación?
7. Sube ``\rho``. ¿Qué pasa con la extracción inicial y con ``\lambda``?
   Compáralo con el gasto del fondo regional de la sesión 10 cuando el
   gobierno es impaciente.

### Tu tesis

8. En tu problema, ¿cuál es el estado, cuál el control y qué condición
   final tiene? ¿Qué mide el coestado, en palabras, y en qué unidades?

### [Avanzado]

9. En la sección 3, con ``S_0 = 30`` y ``t > \tau``, ``\partial H/\partial q < 0``
   en ``q = 0``. ¿Por qué esto no contradice que ``q = 0`` sea óptimo?
10. En la sección 5, ¿por qué el cambio ocurre antes de ``t = 2``? ¿Qué
    pasaría con el instante de cambio si el horizonte fuera más largo?

## Para la próxima sesión

- **Sesión 12: Horizonte infinito y descuento.** El Hamiltoniano a valor
  presente, la transversalidad en horizonte infinito y el modelo de Ramsey
  calibrado para México.
- Repaso: C.B3 y C.B4 (exponencial e integrales), A.B3 (series y
  descuento), E.B2 (tasas de crecimiento con datos), L.I1 y L.I2
  (eigenvalores), D.I2, D.I6 y D.I7 (diagramas de fase y valor en la
  frontera), N.I1 (bisección y Newton), N.I3 (DifferentialEquations.jl),
  E.I3 (calibración) y N.I7 (datos en Julia). Para los puntos [Avanzado]:
  D.A2, A.A5 y N.A1.
"""

# ╔═╡ 5138c7c2-cf06-11f1-a126-db92f8bf0b2c
md"""
---
## Apéndice: paquetes y funciones auxiliares

Estas celdas definen herramientas que usa el cuaderno. No es necesario
leerlas para seguir la sesión.
"""

# ╔═╡ 5138c7d6-cf06-11f1-a8dd-b99bb689ed6a
begin
    const AZUL    = "#2a78d6"   # reservas, valor óptimo, Hamiltoniano
    const NARANJA = "#eb6834"   # extracción, precio sombra, óptimo
    const GRIS    = "#52514e"   # referencias
    const TINTA   = "#0b0b0b"   # precio de mercado, estado
end;

# ╔═╡ 5138c72a-cf06-11f1-a0cd-6f342fbd8652
let
    ts = range(0, 2, length = 200)
    casos = [("libre", 0.0, GRIS), ("y(2) ≥ y_min", max(0, (ymin - 2) / 2), NARANJA),
             ("y(2) = y_min", (ymin - 2) / 2, AZUL)]
    g1 = plot(; xlabel = "t", ylabel = "y(t)", title = "Estado", legend = :topleft)
    g2 = plot(; xlabel = "t", ylabel = "λ(t)", title = "Coestado")
    for (i, (nombre, k, color)) in enumerate(casos)
        plot!(g1, ts, k .* ts .+ 2ts .- ts .^ 2 ./ 2; color, lw = 4 - i, label = nombre)
        plot!(g2, ts, k .+ 2 .- ts; color, lw = 4 - i)
    end
    hline!(g1, [ymin]; color = GRIS, ls = :dot, lw = 1, label = "")
    hline!(g2, [0]; color = GRIS, lw = 0.5)
    plot(g1, g2; layout = (1, 2), size = (780, 320))
end

# ╔═╡ 5138c740-cf06-11f1-ac1a-07e2b305e736
let
    ts = range(0, 2, length = 400)
    ts_c = 2 - log(2.5)
    λ(t) = 2exp(2 - t) - 2
    u(t) = λ(t) > 3 ? 2.0 : 0.0
    y(t) = t <= ts_c ? 6exp(t) - 2 : (6exp(ts_c) - 2) * exp(t - ts_c)
    g1 = plot(ts, λ.(ts) .- 3; color = AZUL, lw = 2.5, xlabel = "t", ylabel = "λ(t) − 3",
              title = "Función de cambio")
    hline!(g1, [0]; color = GRIS, lw = 0.5)
    g2 = plot(ts, u.(ts); color = NARANJA, lw = 2.5, xlabel = "t", ylabel = "u(t)",
              title = "Control", ylims = (-0.2, 2.2), linetype = :steppost)
    g3 = plot(ts, y.(ts); color = TINTA, lw = 2.5, xlabel = "t", ylabel = "y(t)", title = "Estado")
    foreach(g -> vline!(g, [ts_c]; color = GRIS, ls = :dot, lw = 1), (g1, g2, g3))
    plot(g1, g2, g3; layout = (1, 3), size = (860, 290))
end

# ╔═╡ 5138c7e0-cf06-11f1-ae1f-ddb9b22ca646
"Integral de f en [0, T] con la regla de Simpson y n tramos (n par)."
function integral(f, T; n = 2000)
    h = T / n
    h / 3 * (f(0.0) + f(T) + 4sum(f((2i - 1) * h) for i in 1:n ÷ 2) + 2sum(f(2i * h) for i in 1:n ÷ 2 - 1))
end

# ╔═╡ 5138c7e0-cf06-11f1-a59c-5164d622dbf4
"""
Extracción total en [0, T] con precio sombra λ y demanda p = a - bq: la
extracción es positiva hasta τ = min(T, ln(a/λ)/ρ).
"""
function total_extraido(λ; a, b = 1.0, ρ, T)
    λ >= a && return 0.0
    τ = λ <= 0 ? T : min(T, log(a / λ) / ρ)
    (a * τ - λ * (exp(ρ * τ) - 1) / ρ) / b
end

# ╔═╡ 5138c7ea-cf06-11f1-8d6f-6bcf793ecfbe
"""
Solución del recurso no renovable con B(q) = aq - bq²/2: precio sombra λ
(por bisección), fin de la extracción τ, y las funciones q(t), S(t) y el
precio p(t) = a - bq(t).
"""
function hotelling(S0; a, b = 1.0, ρ, T)
    λ = if total_extraido(0.0; a, b, ρ, T) <= S0
        0.0                                  # el recurso sobra
    else
        lo, hi = 0.0, a
        for _ in 1:200
            m = (lo + hi) / 2
            total_extraido(m; a, b, ρ, T) > S0 ? (lo = m) : (hi = m)
        end
        (lo + hi) / 2
    end
    τ = λ <= 0 ? T : min(T, log(a / λ) / ρ)
    q(t) = max(0.0, (a - λ * exp(ρ * t)) / b)
    # Reservas: S0 menos lo extraído hasta t
    S(t) = S0 - (a * min(t, τ) - λ * (exp(ρ * min(t, τ)) - 1) / ρ) / b
    p(t) = a - b * q(t)
    (; S0, a, b, ρ, T, λ, τ, q, S, p)
end

# ╔═╡ 5138c6dc-cf06-11f1-b26a-09f69fc3f6d8
recurso = hotelling(float(S0); a = float(a), ρ, T = 20.0)

# ╔═╡ 5138c6e6-cf06-11f1-a22b-bdabc73a1b7c
let
    r = recurso
    ts = range(0, r.T, length = 400)
    g1 = plot(ts, r.q.(ts); color = NARANJA, lw = 2.5, xlabel = "años", ylabel = "q(t)",
              title = "Extracción", ylims = (0, 1.1r.a))
    g2 = plot(ts, r.S.(ts); color = AZUL, lw = 2.5, xlabel = "años", ylabel = "S(t)",
              title = "Reservas", ylims = (0, 1.1max(r.S0, 1)))
    g3 = plot(ts, r.p.(ts); color = TINTA, lw = 2.5, xlabel = "años", ylabel = "p(t)",
              title = "Precio del recurso", ylims = (0, 1.15r.a))
    plot!(g3, ts, r.λ .* exp.(r.ρ .* ts); color = TINTA, lw = 1, ls = :dash)
    hline!(g3, [r.a]; color = GRIS, ls = :dot, lw = 1)
    r.τ < r.T && foreach(g -> vline!(g, [r.τ]; color = GRIS, ls = :dot, lw = 1), (g1, g2, g3))
    plot(g1, g2, g3; layout = (1, 3), size = (860, 300))
end

# ╔═╡ 5138c6f0-cf06-11f1-b8bf-755d16137652
let
    r = recurso
    rd(v) = round(v, digits = 3)
    caso = r.λ == 0 ? md"**Recurso abundante.** Extraer hasta el precio cero no agota las reservas: sobra recurso al final y una tonelada más en el subsuelo **no vale nada**, ``\lambda = 0``." :
           r.τ < r.T ? md"**Recurso muy escaso.** El precio llega al de ahogo antes de ``T``: la extracción se detiene en ``\tau`` y desde ahí ``q = 0``. Es una **solución de esquina**: ``\partial H/\partial q = 0`` ya no vale, pero ``q = 0`` sigue maximizando ``H`` (sección 3)." :
           md"**Recurso escaso.** Las reservas se agotan exactamente en ``T``: ``\lambda > 0`` y ``S(T) = 0``. El precio sube a la tasa ``\rho`` y la extracción baja."
    md"""
    | | Valor |
    |:---|---:|
    | Precio sombra, ``\lambda`` (valor de ``t = 0``) | $(rd(r.λ)) |
    | Extracción inicial y final, ``q(0)`` y ``q(T)`` | $(rd(r.q(0.0))) y $(rd(r.q(r.T))) |
    | Fin de la extracción, ``\tau`` | $(r.τ < r.T ? rd(r.τ) : "no antes de T") |
    | Reservas al final, ``S(T)`` | $(rd(r.S(r.T))) |

    $caso

    La línea punteada de la derecha es ``\lambda e^{\rho t}``.

    1. Con ``S_0 = 100``, **observa** que el precio sigue la línea punteada:
       la regla de Hotelling.
    2. **Baja** ``S_0`` a 30: ¿cuándo se detiene la extracción? ¿Qué precio
       tiene el recurso en ese momento?
    3. **Sube** ``S_0`` a 200 o más: ¿qué pasa con ``\lambda`` y con las
       reservas al final?
    4. **Sube** ``\rho``: ¿se extrae más al principio o al final?
    """
end

# ╔═╡ 5138c718-cf06-11f1-9c31-6f5efdfc2f41
let
    r = recurso
    qs = range(0, 1.2r.a, length = 300)
    H(q) = exp(-r.ρ * t_h) * (r.a * q - q^2 / 2) - r.λ * q
    qopt = r.q(t_h)
    p = plot(qs, H.(qs); color = AZUL, lw = 2.5, xlabel = "extracción q", ylabel = "H(q)",
             title = "Hamiltoniano en t = $t_h", size = (640, 320))
    hline!(p, [0]; color = GRIS, lw = 0.5)
    scatter!(p, [qopt], [H(qopt)]; color = NARANJA, ms = 7, msw = 0)
    p
end

# ╔═╡ 5138c7f4-cf06-11f1-98ca-0f0923dc794d
"Bienestar óptimo del recurso: ∫ e^{-ρt} B(q(t)) dt."
valor(r) = integral(t -> exp(-r.ρ * t) * (r.a * r.q(t) - r.b * r.q(t)^2 / 2), r.T; n = 4000)

# ╔═╡ 5138c6f8-cf06-11f1-840b-636a5c8b1a85
let
    r = recurso
    Ss = range(5, 250, length = 120)
    λs = [hotelling(s; r.a, r.ρ, r.T).λ for s in Ss]
    g1 = plot(Ss, λs; color = NARANJA, lw = 2.5, xlabel = "reservas S₀", ylabel = "λ",
              title = "Precio sombra del recurso")
    scatter!(g1, [r.S0], [r.λ]; color = TINTA, ms = 5, msw = 0)
    vline!(g1, [r.a * r.T]; color = GRIS, ls = :dot, lw = 1)
    Vs = [valor(hotelling(s; r.a, r.ρ, r.T)) for s in Ss]
    g2 = plot(Ss, Vs; color = AZUL, lw = 2.5, xlabel = "reservas S₀", ylabel = "V(S₀)",
              title = "Valor óptimo y su pendiente")
    cerca = abs.(Ss .- r.S0) .< 60
    plot!(g2, Ss[cerca], valor(r) .+ r.λ .* (Ss[cerca] .- r.S0); color = NARANJA, lw = 1.5, ls = :dash)
    scatter!(g2, [r.S0], [valor(r)]; color = TINTA, ms = 5, msw = 0)
    plot(g1, g2; layout = (1, 2), size = (780, 320))
end

# ╔═╡ 5138c704-cf06-11f1-b18b-db2a6ad35258
let
    r = recurso
    vmas = valor(hotelling(r.S0 + 1; r.a, r.ρ, r.T))
    vmenos = valor(hotelling(r.S0 - 1; r.a, r.ρ, r.T))
    md"""
    | | Valor |
    |:---|---:|
    | Coestado, ``\lambda`` | $(round(r.λ, sigdigits = 5)) |
    | ``(V(S_0 + 1) - V(S_0 - 1))/2`` | $(round((vmas - vmenos) / 2, sigdigits = 5)) |

    **Observa:** ¿desde qué nivel de reservas una tonelada más ya no vale
    nada (línea punteada)? ¿Por qué ``V(S_0)`` se aplana a partir de ahí?
    """
end

# ╔═╡ 5138c800-cf06-11f1-a922-efc52d4fb3dd
"Extracción total con precio sombra λ y los parámetros del ejercicio 2."
extraido(λ) = total_extraido(λ; a = 10.0, ρ = 0.05, T = 20.0)

# ╔═╡ 5138c800-cf06-11f1-9b0a-cd5943388a33
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

# ╔═╡ 5138c768-cf06-11f1-8d85-17e59e563018
verificar(() -> [extraccion(0.0, 2.0), extraccion(10.0, 2.0), extraccion(15.0, 5.0)],
          [8.0, 10 - 2exp(0.5), 0.0];
          pista = md"De ``e^{-\rho t}(a - q) = \lambda``: `max(0.0, 10 - λ * exp(0.05t))`.")

# ╔═╡ 5138c786-cf06-11f1-a303-9d0ecdae9335
verificar(() -> lambda_recurso.([30.0, 100.0, 150.0, 250.0]),
          [hotelling(s; a = 10.0, ρ = 0.05, T = 20.0).λ for s in (30.0, 100.0, 150.0, 250.0)];
          rtol = 1e-6,
          pista = md"`extraido(0.0) <= S0 && return 0.0`; después, con `lo, hi = 0.0, 10.0`, repite unas 60 veces: `m = (lo + hi) / 2`; si `extraido(m) > S0`, el precio es demasiado bajo (se extrae de más) y `lo = m`; si no, `hi = m`.")

# ╔═╡ 5138c79c-cf06-11f1-aaa5-35c1d4275107
verificar(() -> lambda_final.([1.0, 2.0, 3.0, 4.0]), [0.0, 0.0, 0.5, 1.0];
          pista = md"Con ``\lambda(2) = k``, ``y(2) = 2k + 2``. Si la solución libre (``k = 0``) cumple ``y(2) \ge y_{\min}``, ``k = 0``; si no, ``2k + 2 = y_{\min}``: `max(0.0, (ymin - 2) / 2)`.")

# ╔═╡ 5138c7b8-cf06-11f1-8d39-3b3af65060e4
verificar(() -> coestado_bb.([0.0, 1.0, 2.0]), [2exp(2) - 2, 2exp(1) - 2, 0.0];
          pista = md"Con ``z = 2 + \lambda``, ``z' = -z``, así que ``z(t) = z(2)e^{2-t} = 2e^{2-t}``: `2exp(2 - t) - 2`.")

# ╔═╡ Cell order:
# ╟─5138c682-cf06-11f1-882e-4504db18781d
# ╟─5138c6be-cf06-11f1-abb2-4f0dab8b601e
# ╟─5138c6d2-cf06-11f1-a252-3ba97960bb62
# ╠═5138c6dc-cf06-11f1-b26a-09f69fc3f6d8
# ╟─5138c6e6-cf06-11f1-a22b-bdabc73a1b7c
# ╟─5138c6f0-cf06-11f1-b8bf-755d16137652
# ╟─5138c6f0-cf06-11f1-87cf-4f1cddd37890
# ╟─5138c6f8-cf06-11f1-840b-636a5c8b1a85
# ╟─5138c704-cf06-11f1-b18b-db2a6ad35258
# ╟─5138c70e-cf06-11f1-aa45-85a4f3b74bea
# ╟─5138c718-cf06-11f1-9c31-6f5efdfc2f41
# ╟─5138c722-cf06-11f1-be2e-17f1cc2da6d3
# ╟─5138c722-cf06-11f1-a044-573ed5d2b9d0
# ╟─5138c72a-cf06-11f1-a0cd-6f342fbd8652
# ╟─5138c736-cf06-11f1-991b-8ba2b36509cf
# ╟─5138c736-cf06-11f1-9882-f52ef223b09d
# ╟─5138c740-cf06-11f1-ac1a-07e2b305e736
# ╟─5138c74a-cf06-11f1-b00d-cb6cb8649848
# ╟─5138c754-cf06-11f1-acc9-9924fcb6ca82
# ╠═5138c75e-cf06-11f1-987a-19dd5fd6865f
# ╟─5138c768-cf06-11f1-8d85-17e59e563018
# ╟─5138c772-cf06-11f1-9c85-339abe773a6e
# ╠═5138c77c-cf06-11f1-abed-3f29a6d7a985
# ╟─5138c786-cf06-11f1-a303-9d0ecdae9335
# ╟─5138c790-cf06-11f1-8683-437ed8c9d50d
# ╠═5138c790-cf06-11f1-af36-d5e4f0273517
# ╟─5138c79c-cf06-11f1-aaa5-35c1d4275107
# ╟─5138c7a4-cf06-11f1-99c2-51d6e33d0490
# ╠═5138c7ae-cf06-11f1-9138-07485776fdfd
# ╟─5138c7b8-cf06-11f1-8d39-3b3af65060e4
# ╟─5138c7b8-cf06-11f1-9627-5dce366285c3
# ╟─5138c7c2-cf06-11f1-a126-db92f8bf0b2c
# ╠═5138c7ce-cf06-11f1-b8ff-f9cb4a9915c5
# ╠═5138c7d6-cf06-11f1-a8dd-b99bb689ed6a
# ╠═5138c7e0-cf06-11f1-ae1f-ddb9b22ca646
# ╠═5138c7e0-cf06-11f1-a59c-5164d622dbf4
# ╠═5138c7ea-cf06-11f1-8d6f-6bcf793ecfbe
# ╠═5138c7f4-cf06-11f1-98ca-0f0923dc794d
# ╠═5138c800-cf06-11f1-a922-efc52d4fb3dd
# ╠═5138c800-cf06-11f1-9b0a-cd5943388a33
