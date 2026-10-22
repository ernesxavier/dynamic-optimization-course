#%% hide
md"""
# Sesión 8: Estabilidad de sistemas no lineales

**Pregunta de la unidad.** ¿Convergen los estados de México? ¿A qué
velocidad?

**Objetivos de la sesión**
1. Construir el diagrama de fase de un sistema no lineal en el plano:
   isoclinas, direcciones del flujo, equilibrios y su tipo.
2. Reconocer cuencas de atracción y separatrices: cuando el destino depende
   de dónde se empieza.
3. Leer el diagrama de fase de Ramsey: el punto de silla, la rama estable y
   por qué sólo un consumo inicial es óptimo.
4. Calcular la rama estable numéricamente, integrando hacia atrás y por
   disparo.

**Cómo usar este cuaderno.** Pluto es reactivo: al mover un deslizador, todo
lo que depende de él se recalcula. Las secciones marcadas **[Avanzado]** son
opcionales. Las demostraciones están en las notas formales,
`Class_notes/s08_estabilidad_no_lineal.md`.

**Cómo abrirlo.** Desde la raíz del repositorio:
`julia --project=Code -e 'using Pluto; Pluto.run()'` y abrir
`Code/s08_estabilidad_no_lineal.jl`.

**Repaso recomendado** (en `Class_notes/repaso/`): L.I1 y L.I2
(eigenvalores), L.I6 (jacobiano) y D.I6 (diagramas de fase en el plano).
Para los puntos [Avanzado]: D.A2 (variedad estable).
"""

#%% hide
TableOfContents(title = "Contenido")

#%% hide
md"""
## 1. Dos regiones que compiten por la misma actividad

``x`` e ``y`` son el tamaño de una actividad en la región 1 y en la región 2,
como fracción de lo que cada una podría sostener sola. La actividad en una
región le quita mercado a la otra:

```math
\dot x = x(1 - x - a y), \qquad \dot y = y(1 - y - b x).
```

En la gráfica, las rectas azul y naranja son las isoclinas ``\dot x = 0`` y
``\dot y = 0``; los puntos llenos son equilibrios estables y los vacíos,
inestables o puntos de silla. Si el equilibrio interior es un punto de
silla, la curva negra es la **separatriz**: sus ramas estables.

Cuánto le quita la región 2 a la 1, ``a``: $(@bind a_c Slider(0.2:0.1:2.5, default = 2.0, show_value = true))

Cuánto le quita la región 1 a la 2, ``b``: $(@bind b_c Slider(0.2:0.1:2.5, default = 2.0, show_value = true))
"""

#%% hide
let
    F(z) = [z[1] * (1 - z[1] - a_c * z[2]), z[2] * (1 - z[2] - b_c * z[1])]
    p = plot(; xlims = (0, 1.3), ylims = (0, 1.3), aspect_ratio = :equal, xlabel = "región 1, x",
             ylabel = "región 2, y", title = "Competencia con a = $a_c, b = $b_c", size = (560, 520))
    campo!(p, F, (0, 1.3), (0, 1.3))
    xs = range(0, 1.3, length = 100)
    plot!(p, xs, (1 .- xs) ./ a_c; color = AZUL, lw = 2)          # ẋ = 0
    plot!(p, xs, 1 .- b_c .* xs; color = NARANJA, lw = 2)         # ẏ = 0
    for z0 in PUNTOS_INICIALES
        tr = trayectoria(F, z0, 40)
        plot!(p, first.(tr), last.(tr); color = GRIS, lw = 1, alpha = 0.7)
    end
    eqs = equilibrios_competencia(a_c, b_c)
    for e in eqs
        if e.tipo == :silla && e.x > 0 && e.y > 0
            for rama in ramas_estables(F, [e.x, e.y], e.vs; limites = ((0, 1.3), (0, 1.3)))
                plot!(p, first.(rama), last.(rama); color = TINTA, lw = 2.5)
            end
        end
        scatter!(p, [e.x], [e.y]; color = e.tipo == :estable ? TINTA : :white,
                 markerstrokecolor = TINTA, ms = 7, msw = 1.5)
    end
    p
end

#%% hide
let
    eqs = equilibrios_competencia(a_c, b_c)
    nombres = Dict(:estable => "estable", :silla => "punto de silla", :inestable => "inestable")
    filas = join(["| ($(round(e.x, digits = 3)), $(round(e.y, digits = 3))) | $(join(round.(e.λ, digits = 3), ", ")) | $(nombres[e.tipo]) |" for e in eqs], "\n")
    caso = a_c < 1 && b_c < 1 ? "**Competencia débil**: las dos regiones coexisten en el equilibrio interior, empiecen donde empiecen." :
           a_c > 1 && b_c > 1 ? "**Competencia fuerte**: una sola región se queda con la actividad. Cuál, depende de qué lado de la separatriz se empiece." :
           "**Una región domina**: el equilibrio interior no existe en el cuadrante positivo, y la misma región gana desde cualquier punto de partida."
    Markdown.parse("""
    | Equilibrio | Eigenvalores del jacobiano | Tipo |
    |:---|:---|:---|
    $filas

    $caso
    """)
end

#%% hide
md"""
Con ``a = b = 2``, dos regiones casi idénticas terminan en destinos
opuestos según de qué lado de la separatriz empiecen: es la versión en el
plano del umbral de aglomeración de la sesión 6. Baja ``a`` y ``b`` por
debajo de 1: el equilibrio interior se vuelve estable y las regiones
coexisten. La política que busque la coexistencia tiene que cambiar ``a`` y
``b`` (menos competencia, más especialización), no sólo las condiciones
iniciales.
"""

#%% hide
md"""
## 2. El diagrama de fase de Ramsey

El capital ``k`` y el consumo ``c`` óptimos de una economía cumplen (sesión
12)

```math
\dot k = k^\alpha - \delta k - c, \qquad \dot c = \frac{c}{\theta}\big(\alpha k^{\alpha-1} - \delta - \rho\big),
```

con ``\alpha = 0.3`` y ``\delta = 0.05``. La curva azul es la isoclina
``\dot k = 0``, la recta punteada es ``\dot c = 0`` y la curva naranja es la
**rama estable**: el único camino al estado estacionario.

Tasa de descuento ``\rho``: $(@bind ρ Slider(0.01:0.005:0.08, default = 0.03, show_value = true))

Parámetro de aversión ``\theta``: $(@bind θ Slider(0.5:0.5:5.0, default = 2.0, show_value = true))

Capital inicial, como fracción de ``k^\ast``: $(@bind k0_frac Slider(0.2:0.1:2.0, default = 0.5, show_value = true))

Consumo inicial, como fracción del de la rama estable: $(@bind c0_frac Slider(0.85:0.01:1.15, default = 0.97, show_value = true))
"""

#%%
ramsey = modelo_ramsey(0.3, 0.05, ρ, θ)

#%% hide
let
    r = ramsey
    k0 = k0_frac * r.kstar
    c0 = c0_frac * politica(r, k0)
    kmax = 2.4r.kstar
    p = plot(; xlims = (0, kmax), ylims = (0, 2r.cstar), xlabel = "capital k", ylabel = "consumo c",
             title = "Ramsey: ρ = $ρ, θ = $θ", size = (700, 440))
    campo!(p, r.F, (0.02kmax, kmax), (0.02r.cstar, 2r.cstar); n = 13)
    ks = range(0.01, kmax, length = 300)
    plot!(p, ks, ks .^ r.α .- r.δ .* ks; color = AZUL, lw = 2)
    vline!(p, [r.kstar]; color = AZUL, lw = 1.5, ls = :dash)
    plot!(p, r.rama_k, r.rama_c; color = NARANJA, lw = 3)
    tr = trayectoria(r.F, [k0, c0], 300; parar = z -> z[1] < 0.02 || z[1] > kmax || z[2] > 2r.cstar)
    plot!(p, first.(tr), last.(tr); color = TINTA, lw = 2)
    scatter!(p, [k0], [c0]; color = TINTA, ms = 5, msw = 0)
    scatter!(p, [r.kstar], [r.cstar]; color = :white, markerstrokecolor = TINTA, ms = 7, msw = 1.5)
end

#%% hide
let
    r = ramsey
    k0 = k0_frac * r.kstar
    destino = destino_ref(r, k0, c0_frac * politica(r, k0))
    lectura = abs(c0_frac - 1) < 0.005 ?
        md"Con el consumo de la **rama estable**, la economía llega al estado estacionario. Cualquier error, por pequeño que sea, la saca de ahí con el tiempo: es un punto de silla." :
        destino == :agota ?
        md"Con un consumo inicial **mayor** que el de la rama estable, el consumo sigue subiendo, cruza la isoclina ``\dot k = 0`` y el capital se **agota** en tiempo finito. No es factible." :
        md"Con un consumo inicial **menor** que el de la rama estable, el capital pasa de ``k^\ast``, el consumo se desploma y el capital se **acumula** sin consumirse nunca. La condición de transversalidad la descarta (sesión 12)."
    lectura
end

#%% hide
let
    r = ramsey
    rd(v) = round(v, digits = 3)
    md"""
    | | Valor |
    |:---|---:|
    | Estado estacionario ``(k^\ast, c^\ast)`` | ($(rd(r.kstar)), $(rd(r.cstar))) |
    | Regla de oro, ``k_{RO}`` (``f'(k) = \delta``) | $(rd(r.kro)) |
    | Tasa de ahorro en el estado estacionario, ``\alpha\delta/(\delta + \rho)`` | $(rd(r.α * r.δ / (r.δ + ρ))) |
    | Consumo óptimo con ``k_0`` = $(rd(k0_frac * r.kstar)) | $(rd(politica(r, k0_frac * r.kstar))) |

    Mueve ``c_0`` arriba y abajo de 1: sólo el consumo de la rama estable es
    óptimo. Baja ``\rho``: la recta ``\dot c = 0`` se mueve a la derecha y
    ``k^\ast`` se acerca a la regla de oro.
    """
end

#%% hide
md"""
## 3. La función de política: cuánto ahorra una región pobre

La rama estable es la gráfica de una función ``c = \sigma(k)``: el consumo
óptimo para cada nivel de capital. A la derecha, la tasa de ahorro que
implica, ``1 - \sigma(k)/k^\alpha``.
"""

#%% hide
let
    r = ramsey
    ks = range(0.15r.kstar, 2r.kstar, length = 200)
    cs = politica.(Ref(r), ks)
    g1 = plot(ks, cs; color = NARANJA, lw = 2.5, xlabel = "capital k", ylabel = "consumo σ(k)",
              title = "Función de política")
    vline!(g1, [r.kstar]; color = GRIS, ls = :dash, lw = 1)
    g2 = plot(ks, 100 .* (1 .- cs ./ ks .^ r.α); color = AZUL, lw = 2.5, xlabel = "capital k",
              ylabel = "tasa de ahorro (%)", title = "Ahorro óptimo")
    vline!(g2, [r.kstar]; color = GRIS, ls = :dash, lw = 1)
    hline!(g2, [100r.α]; color = GRIS, ls = :dot, lw = 1)
    plot(g1, g2; layout = (1, 2), size = (780, 320))
end

#%% hide
md"""
Una región pobre **ahorra una fracción mayor** de su producto, porque ahí el
capital rinde más; la tasa baja a medida que el capital se acerca a
``k^\ast``. La línea punteada es la tasa de la regla de oro, ``\alpha``:
el ahorro óptimo de largo plazo queda por debajo, por la impaciencia. Sube
``\theta``: el ahorro de la región pobre baja, porque con más aversión a la
variación del consumo conviene suavizarlo más.
"""

#%% hide
md"""
## 4. [Avanzado] Un cambio inesperado en la paciencia

La economía está en su estado estacionario con ``\rho = 0.04`` y, en el
año 10, la tasa de descuento baja de manera permanente e inesperada al
valor ``\rho`` del deslizador de la sección 2. El capital no puede saltar;
el consumo sí. ¿Qué hace cada uno?
"""

#%% hide
let
    viejo = modelo_ramsey(0.3, 0.05, 0.04, θ)
    nuevo = ramsey
    t, k, c = respuesta_a_cambio(viejo, nuevo; t_cambio = 10.0, horizonte = 120.0)
    g1 = plot(t, k; color = AZUL, lw = 2, xlabel = "años", ylabel = "capital k", title = "Capital")
    g2 = plot(t, c; color = NARANJA, lw = 2, xlabel = "años", ylabel = "consumo c", title = "Consumo")
    for g in (g1, g2)
        vline!(g, [10]; color = GRIS, ls = :dot, lw = 1)
    end
    plot(g1, g2; layout = (1, 2), size = (780, 300))
end

#%% hide
md"""
Si el nuevo ``\rho`` es menor que 0.04, en el año 10 el consumo **cae de
golpe** hasta la nueva rama estable y después crece, mientras el capital se
acumula poco a poco hacia el nuevo ``k^\ast``. El estado (``k``) se mueve
despacio; el control (``c``) salta. Es la lectura típica de un diagrama de
fase de optimización (notas, sección 3.6). Prueba un ``\rho`` mayor que
0.04: el consumo salta hacia arriba.
"""

#%% hide
md"""
## Resumen

| Herramienta | Qué dice | En este cuaderno |
|---|---|---|
| Isoclinas | Dónde una variable no cambia; sus cruces son equilibrios | Rectas de competencia; joroba y vertical de Ramsey |
| Flechas | El signo de cada ecuación entre isoclinas | Campo de direcciones |
| Jacobiano | El tipo de cada equilibrio | Tabla de la competencia |
| Separatriz | Divide el plano en cuencas de atracción | Competencia fuerte |
| Rama estable | El único camino al punto de silla; es la función de política | Ramsey |
| Disparo e integración hacia atrás | Dos formas de calcular la rama estable | Ejercicio 3; curva naranja |

## Ejercicios

### Completa el código

**1.** Escribe `jacobiano_competencia(x, y, a, b)`, el jacobiano del modelo
de competencia en el punto ``(x, y)``.
"""

#%%
function jacobiano_competencia(x, y, a, b)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> [jacobiano_competencia(1.0, 0.0, 2.0, 2.0), jacobiano_competencia(0.3, 0.6, 0.5, 1.5)],
          [jacobiano_competencia_ref(1.0, 0.0, 2.0, 2.0), jacobiano_competencia_ref(0.3, 0.6, 0.5, 1.5)];
          pista = md"`[1 - 2x - a*y  -a*x; -b*y  1 - 2y - b*x]`")

#%% hide
md"""
**2.** Escribe `equilibrio_interior(a, b)`, que devuelva el vector
``[x^\ast, y^\ast]`` del equilibrio interior, suponiendo ``ab \ne 1``.
"""

#%%
function equilibrio_interior(a, b)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> [equilibrio_interior(0.5, 0.5), equilibrio_interior(2.0, 2.0), equilibrio_interior(0.3, 0.8)],
          [[2 / 3, 2 / 3], [1 / 3, 1 / 3], [0.7 / 0.76, 0.2 / 0.76]];
          pista = md"Resuelve el sistema lineal ``x + ay = 1``, ``bx + y = 1``: ``x^\ast = (1 - a)/(1 - ab)``, ``y^\ast = (1 - b)/(1 - ab)``.")

#%% hide
md"""
**3.** Escribe `consumo_inicial(k0)`, que encuentre por **disparo** el
consumo de la rama estable para el capital ``k_0``, con los parámetros
``\alpha = 0.3``, ``\delta = 0.05``, ``\rho = 0.03`` y ``\theta = 2``. Usa
`destino(k0, c0)`, que simula la trayectoria y devuelve `:agota` si el
capital se agota o `:acumula` si se acumula de más. Haz bisección sobre
``c_0`` entre ``10^{-6}`` y ``k_0^{0.3}``, unas 50 veces.
"""

#%%
function consumo_inicial(k0)
    missing  # reemplaza esta línea
end

#%% hide
verificar(() -> consumo_inicial.([1.65, 3.3, 9.9]),
          politica.(Ref(RAMSEY_BASE), [1.65, 3.3, 9.9]);
          rtol = 1e-3,
          pista = md"Con `lo, hi = 1e-6, k0^0.3`, repite: `m = (lo + hi) / 2`; si `destino(k0, m) == :agota`, el consumo es demasiado alto y `hi = m`; si no, `lo = m`. Devuelve `(lo + hi) / 2`.")

#%% hide
md"""
**4. [Avanzado]** Escribe `tasa_ahorro_ss(α, δ, ρ)`, la tasa de ahorro del
estado estacionario de Ramsey (notas, ejercicio F4).
"""

#%%
tasa_ahorro_ss(α, δ, ρ) = missing  # reemplaza missing

#%% hide
verificar(() -> [tasa_ahorro_ss(0.3, 0.05, 0.03), tasa_ahorro_ss(0.35, 0.06, 0.02)],
          [0.3 * 0.05 / 0.08, 0.35 * 0.06 / 0.08];
          pista = md"En el estado estacionario, el ahorro repone la depreciación: ``s = \delta k^\ast/(k^\ast)^\alpha = \delta (k^\ast)^{1-\alpha}``, y ``(k^\ast)^{1-\alpha} = \alpha/(\delta + \rho)``.")

#%% hide
md"""
### Interpretación

5. En la competencia fuerte, dos regiones empiezan en ``(0.42, 0.40)`` y
   ``(0.40, 0.42)``. ¿Qué le pasa a cada una? ¿Qué dice esto sobre las
   políticas de "esperar a que el mercado decida"?
6. En Ramsey, ¿por qué una economía que consume demasiado al principio
   termina sin capital, y una que consume demasiado poco no es óptima,
   aunque acumule mucho?
7. Según la sección 3, ¿qué región debería tener la mayor tasa de ahorro,
   una rica o una pobre? ¿Coincide con lo que se observa entre los estados
   de México (sesión 5)? ¿Qué supuesto del modelo podría explicar la
   diferencia?

### Tu tesis

8. Si tu problema tiene un punto de silla, ¿cuál es la variable de estado,
   que no puede saltar, y cuál la de control, que salta a la rama estable?

### [Avanzado]

9. En la sección 4, ¿por qué el consumo cae justo después de que la
   economía se vuelve más paciente, si a largo plazo termina más alto?
10. Compara la rama estable de la sección 2 con la recta del eigenvector
    estable de la sesión 7. ¿Dónde coinciden y dónde se separan?

## Para la próxima sesión

- **Sesión 9: Laboratorio 1.** Diagramas de fase con DifferentialEquations.jl:
  el modelo de Solow con dos regiones y movilidad de capital.
- Repaso: D.B3 (método de Euler), N.B1 a N.B3 (Julia, gráficas y Pluto),
  N.I3 (DifferentialEquations.jl) y N.I6 (error y convergencia).
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
    using PlutoUI, Plots, LinearAlgebra, Markdown
    gr()
    default(size = (720, 320), legend = false, grid = :y, gridalpha = 0.15,
            framestyle = :axes, titlefontsize = 11, guidefontsize = 9,
            tickfontsize = 8, legendfontsize = 8, foreground_color_legend = nothing,
            background_color_legend = nothing, margin = 3Plots.mm)
end

#%%
begin
    const AZUL    = "#2a78d6"   # isoclina ẋ = 0 y k̇ = 0, ahorro
    const NARANJA = "#eb6834"   # isoclina ẏ = 0, rama estable
    const GRIS    = "#52514e"   # campo y trayectorias de referencia
    const TINTA   = "#0b0b0b"   # equilibrios, separatriz, trayectoria elegida
end;

#%%
"Un paso de Runge-Kutta de cuarto orden para ż = F(z) (dt negativo integra hacia atrás)."
function paso_rk4(F, z, dt)
    k1 = F(z); k2 = F(z .+ dt / 2 .* k1); k3 = F(z .+ dt / 2 .* k2); k4 = F(z .+ dt .* k3)
    z .+ dt / 6 .* (k1 .+ 2k2 .+ 2k3 .+ k4)
end

#%%
"Trayectoria de ż = F(z) desde z0 durante T (o hasta que `parar(z)` sea verdadero)."
function trayectoria(F, z0, T; dt = 0.05, parar = z -> false)
    z = float.(z0)
    pts = [z]
    for _ in 1:round(Int, abs(T) / dt)
        z = paso_rk4(F, z, sign(T) * dt)
        (any(isnan, z) || parar(z)) && break
        push!(pts, z)
    end
    pts
end

#%%
"Dibuja el campo de direcciones (flechas de igual largo) de ż = F(z) en el rectángulo."
function campo!(p, F, xr, yr; n = 11)
    xs, ys = range(xr..., length = n), range(yr..., length = n)
    pts = [(u, v) for u in xs for v in ys]
    dirs = [F([u, v]) for (u, v) in pts]
    lx, ly = 0.35 * (xr[2] - xr[1]) / n, 0.35 * (yr[2] - yr[1]) / n
    unit(d) = d ./ max(hypot(d[1] / lx, d[2] / ly), 1e-12)
    quiver!(p, first.(pts), last.(pts); quiver = (first.(unit.(dirs)), last.(unit.(dirs))),
            color = GRIS, alpha = 0.45, lw = 0.8)
end

#%%
"""
Las dos ramas estables de un punto de silla z⋆ con eigenvector estable vs,
integrando hacia atrás desde z⋆ ± ε vs hasta salir de los límites.
"""
function ramas_estables(F, zstar, vs; limites, ε = 1e-4, T = 400.0)
    fuera(z) = !(limites[1][1] <= z[1] <= limites[1][2] && limites[2][1] <= z[2] <= limites[2][2])
    [trayectoria(F, zstar .+ s * ε .* vs, -T; parar = fuera) for s in (1, -1)]
end

#%%
"Equilibrios del modelo de competencia, con eigenvalores, tipo y eigenvector estable."
function equilibrios_competencia(a, b)
    cand = [(0.0, 0.0), (1.0, 0.0), (0.0, 1.0)]
    if abs(1 - a * b) > 1e-9
        xi, yi = (1 - a) / (1 - a * b), (1 - b) / (1 - a * b)
        xi > 0 && yi > 0 && push!(cand, (xi, yi))
    end
    map(cand) do (x, y)
        λ, V = eigen(jacobiano_competencia_ref(x, y, a, b))
        λ = real.(λ)
        tipo = all(λ .< 0) ? :estable : any(λ .< 0) ? :silla : :inestable
        (; x, y, λ, tipo, vs = real.(V[:, argmin(λ)]))
    end
end

#%%
"Jacobiano del modelo de competencia en (x, y)."
jacobiano_competencia_ref(x, y, a, b) = [1 - 2x - a * y  -a * x; -b * y  1 - 2y - b * x]

#%%
"Puntos de partida de las trayectorias de la sección 1, sobre el borde del cuadrado."
const PUNTOS_INICIALES = [[u, v] for (u, v) in vcat([(t, 1.25) for t in 0.05:0.15:1.25],
                                                    [(1.25, t) for t in 0.05:0.15:1.1],
                                                    [(t, 0.02) for t in 0.1:0.3:1.0],
                                                    [(0.02, t) for t in 0.1:0.3:1.0])]

#%%
"""
Modelo de Ramsey con f(k) = k^α: campo, estado estacionario, regla de oro y la
rama estable (calculada hacia atrás), ordenada por k.
"""
function modelo_ramsey(α, δ, ρ, θ)
    F(z) = (k = max(z[1], 1e-9); [k^α - δ * z[1] - z[2], z[2] / θ * (α * k^(α - 1) - δ - ρ)])
    kstar = (α / (δ + ρ))^(1 / (1 - α))
    cstar = kstar^α - δ * kstar
    kro = (α / δ)^(1 / (1 - α))
    J = [ρ -1.0; cstar * α * (α - 1) * kstar^(α - 2) / θ 0.0]
    λ, V = eigen(J)
    vs = V[:, argmin(λ)]
    lim = ((0.01kstar, 3kstar), (0.0, 3cstar))
    ramas = [trayectoria(F, [kstar, cstar] .+ s * 1e-5 .* vs, -2000.0; dt = 0.02,
                         parar = z -> !(lim[1][1] <= z[1] <= lim[1][2] && lim[2][1] <= z[2] <= lim[2][2]))
             for s in (1, -1)]
    # Tiempos hacia atrás de cada punto (para reconstruir la trayectoria hacia adelante)
    pts = vcat(reverse(ramas[2]), ramas[1])
    orden = sortperm(first.(pts))
    (; α, δ, ρ, θ, F, kstar, cstar, kro, λs = minimum(λ), vs, ramas,
     rama_k = first.(pts[orden]), rama_c = last.(pts[orden]))
end

#%%
"Consumo de la rama estable para el capital k (interpolación lineal)."
function politica(r, k)
    i = clamp(searchsortedlast(r.rama_k, k), 1, length(r.rama_k) - 1)
    w = (k - r.rama_k[i]) / (r.rama_k[i + 1] - r.rama_k[i])
    (1 - w) * r.rama_c[i] + w * r.rama_c[i + 1]
end

#%%
"Destino de la trayectoria de Ramsey desde (k0, c0): :agota, :acumula o :llega."
function destino_ref(r, k0, c0; T = 400.0, dt = 0.05)
    z = [k0, c0]
    for _ in 1:round(Int, T / dt)
        z = paso_rk4(r.F, z, dt)
        (z[1] < 0.01r.kstar || any(isnan, z)) && return :agota
        (z[2] < 0.01r.cstar || z[1] > 1.5max(r.kstar, k0)) && return :acumula
    end
    :llega
end

#%%
begin
    # Modelo de Ramsey con los parámetros del ejercicio 3, y el destino de la
    # trayectoria desde (k0, c0) con esos parámetros
    const RAMSEY_BASE = modelo_ramsey(0.3, 0.05, 0.03, 2.0)
    destino(k0, c0) = destino_ref(RAMSEY_BASE, k0, c0)
end

#%%
"""
Capital y consumo cuando ρ cambia en t_cambio: antes, el estado estacionario
viejo; después, la rama estable del modelo nuevo, recorrida hacia adelante.
"""
function respuesta_a_cambio(viejo, nuevo; t_cambio = 10.0, horizonte = 120.0, dt = 0.02)
    k0 = viejo.kstar
    # La rama del lado de k0, recorrida desde lejos hacia el estado estacionario
    izquierda = nuevo.ramas[1][end][1] < nuevo.kstar ? nuevo.ramas[1] : nuevo.ramas[2]
    derecha = izquierda === nuevo.ramas[1] ? nuevo.ramas[2] : nuevo.ramas[1]
    rama = k0 < nuevo.kstar ? izquierda : derecha
    i = findfirst(z -> (k0 < nuevo.kstar ? z[1] <= k0 : z[1] >= k0), rama)
    camino = i === nothing ? [[nuevo.kstar, nuevo.cstar]] : reverse(rama[1:i])
    n_antes = round(Int, t_cambio / dt)
    t = vcat(range(0, t_cambio, length = n_antes), t_cambio .+ dt .* (0:length(camino) - 1))
    k = vcat(fill(viejo.kstar, n_antes), first.(camino))
    c = vcat(fill(viejo.cstar, n_antes), last.(camino))
    dentro = t .<= horizonte
    # Después de recorrer la rama, la economía se queda en el estado estacionario
    if t[end] < horizonte
        extra = range(t[end] + dt, horizonte, step = dt)
        t = vcat(t, extra); k = vcat(k, fill(nuevo.kstar, length(extra))); c = vcat(c, fill(nuevo.cstar, length(extra)))
        dentro = trues(length(t))
    end
    t[dentro], k[dentro], c[dentro]
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
