#%% hide
md"""
# Sesión 9: Laboratorio 1. Diagramas de fase con DifferentialEquations.jl

**Pregunta de la unidad.** ¿Convergen los estados de México? ¿A qué
velocidad?

**Pregunta del laboratorio.** En un modelo de Solow con dos regiones y
movilidad de capital, ¿converge la región rezagada? ¿Qué parámetros lo
deciden?

**Objetivos del laboratorio**
1. Resolver ecuaciones diferenciales con DifferentialEquations.jl:
   `ODEProblem`, `solve` y la solución como función del tiempo.
2. Medir el error de un método numérico y estimar su orden.
3. Programar un sistema de dos regiones y dibujar su diagrama de fase:
   isoclinas, campo de direcciones y trayectorias.
4. Usar el modelo para responder una pregunta regional.

**Cómo usar este cuaderno.** Los ejercicios con verificador dicen
**Pendiente** hasta que reemplazas `missing` por tu código. Las secciones
marcadas **[Avanzado]** son opcionales. La teoría está en las notas de las
sesiones 5 a 8.

**Repaso recomendado** (en `Class_notes/repaso/`): D.B3 (método de Euler),
N.B1 a N.B3 (Julia, gráficas y Pluto), N.I3 (DifferentialEquations.jl) y
N.I6 (error y orden de un método). Para los puntos [Avanzado]: N.A3
(problemas rígidos).
"""

#%% hide
TableOfContents(title = "Contenido")

#%% hide
md"""
## 0. ¿Funciona DifferentialEquations.jl?

La primera vez que se carga, el paquete tarda varios minutos en compilarse.
Si ves la versión, está listo.
"""

#%% hide
md"DifferentialEquations.jl, versión $(string(pkgversion(DifferentialEquations)))."

#%% hide
md"""
## 1. Una región: Solow con DifferentialEquations.jl

El capital por trabajador de una región cumple

```math
\dot k = s A k^\alpha - (n + \delta) k .
```

Resolverlo con DifferentialEquations.jl toma cuatro pasos (N.I3):
1. Escribir la función ``f(k, p, t)`` que da ``\dot k``. `p` agrupa los
   parámetros.
2. Definir el problema: función, condición inicial, intervalo de tiempo y
   parámetros.
3. Resolverlo con un método, por ejemplo `Tsit5()`.
4. Usar la solución: `sol(t)` la evalúa en cualquier ``t``, y `plot(sol)` la
   grafica.

**1.** Escribe `solow(k, p, t)`, que devuelva ``\dot k``. Los parámetros se
leen como `p.s`, `p.A`, `p.α` y `p.nδ` (este último es ``n + \delta``).
"""

#%%
solow(k, p, t) = missing  # reemplaza missing

#%% hide
verificar(() -> [solow(k, P1, 0.0) for k in (0.5, 2.0, 5.0, 10.0)],
          [solow_ref(k, P1, 0.0) for k in (0.5, 2.0, 5.0, 10.0)];
          pista = md"`solow(k, p, t) = p.s * p.A * k^p.α - p.nδ * k`")

#%% hide
md"""
Con tu función, las celdas siguientes definen y resuelven el problema. Los
parámetros son ``s = 0.2``, ``A = 1``, ``\alpha = 0.3`` y ``n + \delta = 0.06``.
"""

#%%
P1 = (s = 0.2, A = 1.0, α = 0.3, nδ = 0.06)

#%%
problema = ODEProblem(completo(() -> solow(1.0, P1, 0.0)) ? solow : solow_ref, 1.0, (0.0, 100.0), P1)

#%%
solucion = solve(problema, Tsit5())

#%%
plot(solucion; color = AZUL, lw = 2, xlabel = "años", ylabel = "capital k(t)",
     title = "Solow con Tsit5", label = "")

#%%
solucion(50.0)

#%%
length(solucion.t)   # cuántos pasos usó el método

#%% hide
md"""
Mientras el ejercicio 1 está pendiente, las celdas usan la función de
referencia. `solucion(50.0)` evalúa la solución en un tiempo que el método
no calculó: DifferentialEquations.jl interpola. `solucion.t` son los
tiempos en que sí calculó, y su longitud es el número de pasos.

**La solución exacta.** Esta ecuación tiene solución cerrada: con
``z = k^{1-\alpha}``, se vuelve lineal (sesión 5), y

```math
k(t)^{1-\alpha} = \frac{sA}{n + \delta} + \left(k_0^{1-\alpha} - \frac{sA}{n + \delta}\right)e^{-(1-\alpha)(n+\delta)t}.
```

Eso permite medir el error de cualquier método.
"""

#%%
abs(solucion(50.0) - solow_exacta(50.0, P1, 1.0))

#%% hide
md"""
### El error del método de Euler

**2.** Escribe `euler_solow(p, k0, h, T)`, que aproxime ``k(T)`` con el
método de Euler (D.B3) y paso ``h``: ``k_{j+1} = k_j + h\,f(k_j)``, durante
``T/h`` pasos. Puedes usar tu función `solow`.
"""

#%%
function euler_solow(p, k0, h, T)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> [euler_solow(P1, 1.0, h, 50.0) for h in (2.0, 1.0, 0.1)],
          [euler_solow_ref(P1, 1.0, h, 50.0) for h in (2.0, 1.0, 0.1)];
          pista = md"`k = k0`; `for _ in 1:round(Int, T / h)`: `k += h * solow(k, p, 0.0)`; devuelve `k`.")

#%% hide
md"""
La gráfica compara el error de Euler en ``T = 50`` con el tamaño del paso,
en escala log-log. Si el error es proporcional a ``h^p``, la gráfica es una
recta de pendiente ``p``: el **orden** del método (N.I6).
"""

#%% hide
let
    f = completo(() -> euler_solow(P1, 1.0, 1.0, 50.0)) ? euler_solow : euler_solow_ref
    hs = [2.0, 1.0, 0.5, 0.25, 0.125, 0.0625, 0.03125]
    errores = [abs(f(P1, 1.0, h, 50.0) - solow_exacta(50.0, P1, 1.0)) for h in hs]
    orden = log2(errores[end - 1] / errores[end])
    p = plot(hs, errores; xscale = :log10, yscale = :log10, color = AZUL, lw = 2,
             marker = :circle, ms = 4, msw = 0, xlabel = "paso h", ylabel = "error en T = 50",
             title = "Euler: orden estimado ≈ $(round(orden, digits = 2))", label = "Euler")
    plot!(p, hs, errores[end] .* (hs ./ hs[end]); color = GRIS, ls = :dash, label = "pendiente 1",
          legend = :topleft)
end

#%% hide
md"""
Partir el paso a la mitad parte el error a la mitad: Euler es de **orden
1**. Su error en ``T = 50`` es de unos ``0.022\,h``. `Tsit5()` es de orden 5 y
elige el paso solo: con la tolerancia por omisión y apenas unos diez
pasos, su error es de unos ``3 \times 10^{-5}``. Para igualarlo, Euler
necesitaría ``h \approx 0.001``: 50 000 pasos.
"""

#%% hide
md"""
## 2. Dos regiones con movilidad de capital

Dos regiones del mismo tamaño ahorran fracciones distintas, ``s_1`` y
``s_2``, y pueden tener productividades distintas, ``A_1`` y ``A_2``. El
capital es móvil: fluye hacia la región donde rinde más, a una velocidad
proporcional a la diferencia de rendimientos, ``r_i = \alpha A_i k_i^{\alpha - 1}``:

```math
\dot k_1 = s_1 A_1 k_1^\alpha - (n + \delta) k_1 + m (r_1 - r_2), \qquad
\dot k_2 = s_2 A_2 k_2^\alpha - (n + \delta) k_2 - m (r_1 - r_2).
```

``m \ge 0`` mide la **movilidad del capital**: con ``m = 0``, cada región
es una economía de Solow cerrada. Lo que sale de una región entra a la
otra, así que el flujo no crea ni destruye capital.

**3.** Escribe `dos_regiones!(du, u, p, t)`, en la forma "en el lugar":
`u = [k1, k2]`, y la función debe escribir ``\dot k_1`` en `du[1]` y
``\dot k_2`` en `du[2]`. Los parámetros son `p.s1`, `p.s2`, `p.A1`, `p.A2`,
`p.α`, `p.nδ` y `p.m`.
"""

#%%
function dos_regiones!(du, u, p, t)
    du .= missing  # reemplaza esta línea
end

#%% hide
verificar(() -> [(du = zeros(Union{Missing, Float64}, 2); dos_regiones!(du, u, P2_PRUEBA, 0.0); copy(du)) for u in ([2.0, 1.0], [5.0, 4.0], [1.0, 6.0])],
          [(du = zeros(2); dos_regiones_ref!(du, u, P2_PRUEBA, 0.0); du) for u in ([2.0, 1.0], [5.0, 4.0], [1.0, 6.0])];
          pista = md"Con `k1, k2 = u`, calcula `r1 = p.α * p.A1 * k1^(p.α - 1)`, `r2` igual, y `flujo = p.m * (r1 - r2)`. Después `du[1] = p.s1 * p.A1 * k1^p.α - p.nδ * k1 + flujo` y `du[2]` con el signo contrario del flujo.")

#%% hide
md"""
### El diagrama de fase

La región 1 es el norte, que ahorra más; la región 2, el sur. Las curvas
azul y naranja son las isoclinas ``\dot k_1 = 0`` y ``\dot k_2 = 0``; su
cruce es el estado estacionario. Las curvas grises son trayectorias desde
varios puntos de partida, calculadas con `solve`.

Ahorro del norte ``s_1``: $(@bind s1 Slider(0.05:0.01:0.4, default = 0.25, show_value = true))
Ahorro del sur ``s_2``: $(@bind s2 Slider(0.05:0.01:0.4, default = 0.15, show_value = true))

Productividad del norte ``A_1``: $(@bind A1 Slider(0.5:0.05:1.5, default = 1.0, show_value = true))
Productividad del sur ``A_2``: $(@bind A2 Slider(0.5:0.05:1.5, default = 0.8, show_value = true))

Movilidad del capital ``m``: $(@bind m Slider([0.0, 0.1, 0.3, 1.0, 3.0, 10.0, 30.0], default = 1.0, show_value = true))
"""

#%%
P2 = (s1 = s1, s2 = s2, A1 = A1, A2 = A2, α = 0.3, nδ = 0.06, m = m)

#%% hide
let
    f! = completo_sistema() ? dos_regiones! : dos_regiones_ref!
    kss = estado_estacionario(f!, P2)
    lim = 1.6maximum(kss)
    k1s, k2s = range(0.05, lim, length = 120), range(0.05, lim, length = 120)
    du = zeros(2)
    comp(i) = (a, b) -> (f!(du, [a, b], P2, 0.0); du[i])
    p = contour(k1s, k2s, comp(1); levels = [0.0], color = AZUL, lw = 2, colorbar = false,
                xlabel = "capital del norte, k₁", ylabel = "capital del sur, k₂",
                title = "Dos regiones con m = $m", size = (560, 520), aspect_ratio = :equal,
                xlims = (0, lim), ylims = (0, lim))
    contour!(p, k1s, k2s, comp(2); levels = [0.0], color = NARANJA, lw = 2, colorbar = false)
    campo!(p, f!, P2, (0.05lim, lim), (0.05lim, lim))
    for u0 in ([0.1, 0.1], [0.1, 0.9], [0.9, 0.1], [0.9, 0.9], [0.5, 0.05], [0.05, 0.5]) .* lim
        sol = solve(ODEProblem(f!, u0, (0.0, 300.0), P2), Tsit5())
        plot!(p, first.(sol.u), last.(sol.u); color = GRIS, lw = 1.2)
    end
    scatter!(p, [kss[1]], [kss[2]]; color = TINTA, ms = 7, msw = 0)
end

#%% hide
md"""
### ¿Converge el sur?

La gráfica sigue a las dos regiones desde el mismo punto de partida, con
poco capital, y compara el ingreso por trabajador ``y_i = A_i k_i^\alpha``
del norte y del sur con y sin movilidad.
"""

#%% hide
let
    f! = completo_sistema() ? dos_regiones! : dos_regiones_ref!
    ts = 0:1:150
    p = plot(; xlabel = "años", ylabel = "y₁ / y₂", title = "Ingreso del norte entre el del sur",
             legend = :topright)
    for (mm, color, nombre) in ((0.0, GRIS, "sin movilidad"), (m, AZUL, "con m = $m"))
        sol = solve(ODEProblem(f!, [1.0, 1.0], (0.0, 150.0), merge(P2, (m = mm,))), Tsit5())
        y = [ingresos(P2, sol(t)) for t in ts]
        plot!(p, ts, first.(y) ./ last.(y); color, lw = 2, label = nombre)
    end
    hline!(p, [(A1 / A2)^(1 / (1 - 0.3))]; color = NARANJA, ls = :dash, lw = 1.5,
           label = "límite con movilidad perfecta")
end

#%% hide
let
    f! = completo_sistema() ? dos_regiones! : dos_regiones_ref!
    r0 = razon_largo_plazo_ref(merge(P2, (m = 0.0,)))
    rm = razon_largo_plazo_ref(P2)
    rlim = (A1 / A2)^(1 / (1 - 0.3))
    rd(v) = round(v, digits = 3)
    md"""
    | | ``y_1/y_2`` de largo plazo |
    |:---|---:|
    | Sin movilidad (``m = 0``) | $(rd(r0)) |
    | Con la movilidad elegida (``m`` = $(m)) | $(rd(rm)) |
    | Con movilidad perfecta (``m \to \infty``): ``(A_1/A_2)^{1/(1-\alpha)}`` | $(rd(rlim)) |

    Con movilidad perfecta, el capital se mueve hasta igualar los
    rendimientos, ``r_1 = r_2``, y la razón de ingresos depende **sólo de las
    productividades**, no del ahorro.
    """
end

#%% hide
md"""
## 3. ¿Qué parámetros lo deciden?

**4.** Escribe `razon_largo_plazo(p)`, que resuelva el sistema con **tu**
función `dos_regiones!` desde ``k_1 = k_2 = 1`` hasta ``t = 600`` y
devuelva la razón de ingresos ``y_1/y_2`` al final. Usa `ODEProblem`,
`solve(...; reltol = 1e-8, abstol = 1e-8)` y `ingresos(p, k)`, que devuelve
``(y_1, y_2)``.
"""

#%%
function razon_largo_plazo(p)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> [razon_largo_plazo(merge(P2_PRUEBA, c)) for c in ESCENARIOS],
          [razon_largo_plazo_ref(merge(P2_PRUEBA, c)) for c in ESCENARIOS];
          rtol = 1e-4,
          pista = md"`sol = solve(ODEProblem(dos_regiones!, [1.0, 1.0], (0.0, 600.0), p), Tsit5(); reltol = 1e-8, abstol = 1e-8)`; después `y1, y2 = ingresos(p, sol.u[end])` y devuelve `y1 / y2`.")

#%% hide
md"""
Con tu función (o la de referencia, si el ejercicio 4 está pendiente), la
tabla compara tres situaciones: las regiones difieren sólo en el ahorro,
sólo en la productividad, o en las dos cosas.
"""

#%% hide
let
    f = completo(() -> razon_largo_plazo(P2_PRUEBA)) ? razon_largo_plazo : razon_largo_plazo_ref
    casos = [("Sólo ahorro: s = (0.25, 0.15), A = (1, 1)", (s1 = 0.25, s2 = 0.15, A1 = 1.0, A2 = 1.0)),
             ("Sólo productividad: s = (0.2, 0.2), A = (1, 0.8)", (s1 = 0.2, s2 = 0.2, A1 = 1.0, A2 = 0.8)),
             ("Las dos: s = (0.25, 0.15), A = (1, 0.8)", (s1 = 0.25, s2 = 0.15, A1 = 1.0, A2 = 0.8))]
    filas = map(casos) do (nombre, c)
        r = [round(f(merge(P2_PRUEBA, c, (m = mm,))), digits = 3) for mm in (0.0, 1.0, 10.0)]
        "| $nombre | $(r[1]) | $(r[2]) | $(r[3]) |"
    end
    Markdown.parse("""
    | Diferencia entre las regiones | ``m = 0`` | ``m = 1`` | ``m = 10`` |
    |:---|---:|---:|---:|
    $(join(filas, "\n"))
    """)
end

#%% hide
md"""
**Lectura.**
- Si las regiones difieren **sólo en el ahorro**, la movilidad cierra la
  brecha: el capital que el norte ahorra de más se va al sur, donde rinde
  más. Con movilidad alta, los ingresos casi se igualan.
- Si difieren **sólo en la productividad**, la movilidad no cambia nada: sin
  movilidad, los rendimientos ya son iguales en el estado estacionario
  (``r_i = \alpha(n + \delta)/s``), y no hay razón para que el capital se
  mueva.
- Si difieren en las dos cosas, la movilidad cierra la parte de la brecha
  que viene del ahorro y deja la que viene de la productividad.

Para la pregunta del laboratorio: **la región rezagada converge si su
rezago viene de que ahorra poco y el capital es móvil; no converge si viene
de que es menos productiva.** Según este modelo, y si el capital se mueve
entre los estados de México, la falta de convergencia de la sesión 5 apunta
más a diferencias de productividad persistentes que a diferencias de
ahorro.
"""

#%% hide
md"""
## 4. [Avanzado] Movilidad muy alta: un problema rígido

Con ``m`` muy grande, el flujo de capital iguala los rendimientos casi al
instante, mientras la acumulación sigue tardando décadas: dos escalas de
tiempo muy distintas. El problema es **rígido** (N.A3). Un método explícito
como `Tsit5()` necesita pasos del tamaño de la escala rápida; uno implícito
como `Rodas5P()`, no.

Movilidad ``m``: $(@bind m_rigido Slider([1.0, 10.0, 100.0, 1000.0, 10000.0], default = 1000.0, show_value = true))
"""

#%% hide
let
    p = merge(P2_PRUEBA, (m = m_rigido,))
    prob = ODEProblem(dos_regiones_ref!, [1.0, 1.0], (0.0, 300.0), p)
    solve(prob, Tsit5()); solve(prob, Rodas5P())         # compilar antes de medir
    t1 = @elapsed s1_ = solve(prob, Tsit5())
    t2 = @elapsed s2_ = solve(prob, Rodas5P())
    md"""
    | Método | Pasos | Tiempo (ms) | ``k(300)`` |
    |:---|---:|---:|---:|
    | `Tsit5()` (explícito) | $(length(s1_.t)) | $(round(1000t1, digits = 1)) | $(join(round.(s1_.u[end], digits = 3), ", ")) |
    | `Rodas5P()` (implícito) | $(length(s2_.t)) | $(round(1000t2, digits = 1)) | $(join(round.(s2_.u[end], digits = 3), ", ")) |

    Las dos soluciones coinciden (con la tolerancia por omisión), pero con ``m`` grande el método explícito
    necesita muchos más pasos. Si un `solve` tarda mucho o advierte que el
    paso se volvió demasiado pequeño, hay que sospechar rigidez.
    """
end

#%% hide
md"""
## Preguntas

1. En la sección 1, ¿cuántos pasos usó `Tsit5()` y qué error tuvo en
   ``t = 50``? ¿Qué paso necesitaría Euler para el mismo error?
2. En el diagrama de fase, ¿cómo cambian las isoclinas al subir ``m``? ¿Por
   qué el estado estacionario se mueve hacia la diagonal cuando las
   productividades son iguales?
3. Explica por qué la movilidad de capital no cierra una brecha de
   productividad. ¿Qué política sí la cerraría?
4. Con ``A_1 = A_2`` y ``s_1 > s_2``, ¿qué región tiene más capital en el
   estado estacionario con movilidad perfecta? ¿Quién es dueño de ese
   capital? (El modelo no lo distingue: ¿qué cambiaría si lo hiciera?)
5. **[Avanzado]** Con ``m = 10000``, ¿cuántas veces más pasos usa
   `Tsit5()` que `Rodas5P()`?

## Para la próxima sesión

- **Sesión 10: del cálculo de variaciones al Hamiltoniano.** Empieza la
  Unidad III: elegir una trayectoria completa en lugar de un número.
- Repaso: C.B1 a C.B4 (derivadas e integrales), C.I6 (regla de Leibniz),
  C.I7 (Taylor) y D.I3 (lineales de segundo orden). Para los puntos
  [Avanzado]: C.A3 (funcionales y primera variación).
"""

#%% hide
md"""
---
## Apéndice: paquetes y funciones auxiliares

Estas celdas definen herramientas que usa el cuaderno. No es necesario
leerlas para seguir el laboratorio.
"""

#%%
begin
    # Usa el entorno del curso (Code/Project.toml) en lugar del gestor de
    # paquetes propio de Pluto: un solo entorno para todo el repositorio.
    import Pkg
    Pkg.activate(@__DIR__)
    Pkg.instantiate()
    using PlutoUI, Plots, DifferentialEquations, Markdown
    gr()
    default(size = (720, 320), legend = false, grid = :y, gridalpha = 0.15,
            framestyle = :axes, titlefontsize = 11, guidefontsize = 9,
            tickfontsize = 8, legendfontsize = 8, foreground_color_legend = nothing,
            background_color_legend = nothing, margin = 3Plots.mm)
end

#%%
begin
    const AZUL    = "#2a78d6"   # serie principal, isoclina k̇₁ = 0
    const NARANJA = "#eb6834"   # isoclina k̇₂ = 0, límite
    const GRIS    = "#52514e"   # trayectorias y campo
    const TINTA   = "#0b0b0b"   # estado estacionario
end;

#%%
"Solow de una región: k̇ = sAk^α − (n + δ)k."
solow_ref(k, p, t) = p.s * p.A * max(k, 0.0)^p.α - p.nδ * k

#%%
"Solución exacta de Solow de una región desde k0 (vía z = k^(1−α))."
function solow_exacta(t, p, k0)
    zstar = p.s * p.A / p.nδ
    (zstar + (k0^(1 - p.α) - zstar) * exp(-(1 - p.α) * p.nδ * t))^(1 / (1 - p.α))
end

#%%
"k(T) con el método de Euler y paso h."
function euler_solow_ref(p, k0, h, T)
    k = k0
    for _ in 1:round(Int, T / h)
        k += h * solow_ref(k, p, 0.0)
    end
    k
end

#%%
"Solow con dos regiones y movilidad de capital, en el lugar."
function dos_regiones_ref!(du, u, p, t)
    k1, k2 = max(u[1], 1e-9), max(u[2], 1e-9)
    r1, r2 = p.α * p.A1 * k1^(p.α - 1), p.α * p.A2 * k2^(p.α - 1)
    flujo = p.m * (r1 - r2)
    du[1] = p.s1 * p.A1 * k1^p.α - p.nδ * k1 + flujo
    du[2] = p.s2 * p.A2 * k2^p.α - p.nδ * k2 - flujo
    du
end

#%%
"Ingresos por trabajador (y₁, y₂) con el capital k = (k₁, k₂)."
ingresos(p, k) = (p.A1 * max(k[1], 0.0)^p.α, p.A2 * max(k[2], 0.0)^p.α)

#%%
"Estado estacionario del sistema f!, como el final de una simulación larga."
function estado_estacionario(f!, p)
    solve(ODEProblem(f!, [1.0, 1.0], (0.0, 2000.0), p), Rodas5P(); reltol = 1e-10, abstol = 1e-10).u[end]
end

#%%
"Razón de ingresos y₁/y₂ de largo plazo (t = 600 desde k₁ = k₂ = 1)."
function razon_largo_plazo_ref(p)
    sol = solve(ODEProblem(dos_regiones_ref!, [1.0, 1.0], (0.0, 600.0), p), Tsit5(); reltol = 1e-8, abstol = 1e-8)
    y1, y2 = ingresos(p, sol.u[end])
    y1 / y2
end

#%%
"Dibuja el campo de direcciones (flechas de igual largo) del sistema f! en el rectángulo."
function campo!(plt, f!, p, xr, yr; n = 11)
    xs, ys = range(xr..., length = n), range(yr..., length = n)
    pts = [(u, v) for u in xs for v in ys]
    du = zeros(2)
    dirs = [(f!(du, [u, v], p, 0.0); copy(du)) for (u, v) in pts]
    l = 0.35 * (xr[2] - xr[1]) / n
    unit(d) = l .* d ./ max(hypot(d...), 1e-12)
    quiver!(plt, first.(pts), last.(pts); quiver = (first.(unit.(dirs)), last.(unit.(dirs))),
            color = GRIS, alpha = 0.4, lw = 0.8)
end

#%%
begin
    # Parámetros y escenarios de prueba de los ejercicios 3 y 4
    const P2_PRUEBA = (s1 = 0.25, s2 = 0.15, A1 = 1.0, A2 = 0.8, α = 0.3, nδ = 0.06, m = 1.0)
    const ESCENARIOS = [(m = 0.0,), (m = 1.0,), (s1 = 0.2, s2 = 0.2, m = 3.0), (A2 = 1.0, m = 10.0)]
end;

#%%
"¿La función ya está escrita? Verdadero si corre sin error y no devuelve missing."
function completo(f)
    r = try
        f()
    catch
        return false
    end
    !(r === missing || (r isa AbstractArray && any(ismissing, r)))
end

#%%
"¿Ya está escrito `dos_regiones!`? (Se prueba con un vector que admite missing.)"
completo_sistema() = completo(() -> (du = zeros(Union{Missing, Float64}, 2);
                                     dos_regiones!(du, [2.0, 1.0], P2_PRUEBA, 0.0); du))

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
                  (a isa AbstractArray && b isa AbstractArray && size(a) == size(b) && all(cerca.(a, b)))
    if pendiente(resultado)
        caja("warning", "Pendiente", md"Reemplaza `missing` por tu código.")
    elseif cerca(resultado, esperado)
        caja("correct", "¡Correcto!", md"Bien hecho.")
    else
        caja("danger", "Todavía no", pista)
    end
end
