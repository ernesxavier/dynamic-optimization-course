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

# ╔═╡ ec1fd68a-ce3f-11f1-9ec2-519f546b466f
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

# ╔═╡ ec1fd4f0-ce3f-11f1-8a82-0764d8ae8c90
md"""
# Sesión 4: Laboratorio 0. Julia, Pluto.jl y Symbolics.jl

**Pregunta de la unidad.** Un gobierno tiene un fondo ``B`` para invertir en
dos regiones. ¿Cómo debe repartirlo?

En las sesiones 2 y 3 la respuesta se obtuvo a mano. En este laboratorio la
computadora hace el álgebra y las gráficas: es el primer paso de todo el
trabajo en código del curso.

**Objetivos del laboratorio**
1. Moverse en un cuaderno de Pluto: celdas reactivas y deslizadores.
2. Escribir funciones, vectores y comprensiones en Julia, y graficar con
   Plots.jl.
3. Derivar y despejar las condiciones de primer orden con Symbolics.jl.
4. Resolver el problema de las dos regiones en código y graficar ``V(B)`` y
   ``\lambda(B)``.
5. Comprobar numéricamente que ``V'(B) = \lambda``.

**Cómo usar este cuaderno.** Para editar una celda, haz clic en ella; para
ejecutarla, ``Shift + Enter``. Para ver el código de una celda oculta, haz
clic en el ojo que aparece a su izquierda. Los ejercicios con verificador
dicen **Pendiente** hasta que reemplazas `missing` por tu código. Las
secciones marcadas **[Avanzado]** son opcionales.

**Antes de la sesión.** Instala el entorno siguiendo el `README.md` del
repositorio. Si el cuaderno abrió y la sección 0 muestra la tabla de
versiones, todo funciona.

**Repaso recomendado** (en `Class_notes/repaso/`): N.B1 (Julia), N.B2
(gráficas), N.B3 (Pluto), N.B4 (punto flotante) y N.I2 (Symbolics.jl). Para
los puntos [Avanzado]: N.A4 (diferencias finitas).
"""

# ╔═╡ ec1fd51a-ce3f-11f1-b100-e9b7667aabb9
TableOfContents(title = "Contenido")

# ╔═╡ ec1fd522-ce3f-11f1-a381-0309ca727c8a
md"""
## 0. ¿Funciona el entorno?
"""

# ╔═╡ ec1fd52c-ce3f-11f1-857b-a7097035ebf1
md"""
| Componente | Versión |
|:---|:---|
| Julia | $(string(VERSION)) |
| PlutoUI | $(string(pkgversion(PlutoUI))) |
| Plots | $(string(pkgversion(Plots))) |
| Symbolics | $(string(pkgversion(Symbolics))) |

Si ves esta tabla, el entorno del curso está instalado y los paquetes cargan.
La primera vez tarda varios minutos; las siguientes, mucho menos.
"""

# ╔═╡ ec1fd52c-ce3f-11f1-9600-0b79490ed524
md"""
## 1. Julia en cinco minutos

Una **función de una línea** se define como en papel. Ésta es el producto
marginal de una región con productividad ``a`` cuando ya recibió ``x``:
"""

# ╔═╡ ec1fd536-ce3f-11f1-ae9b-3b0a201b9bf9
producto_marginal(a, x) = a / (1 + x)

# ╔═╡ ec1fd536-ce3f-11f1-bbe2-f552e86332bb
producto_marginal(2.0, 3.0)

# ╔═╡ ec1fd540-ce3f-11f1-a4da-f5b4397578cc
md"""
Un **rango** es una sucesión de números igualmente espaciados, y el **punto**
aplica una función a cada elemento (*broadcasting*):
"""

# ╔═╡ ec1fd540-ce3f-11f1-beaf-89222605f04b
inversiones = 0:0.5:3

# ╔═╡ ec1fd54c-ce3f-11f1-a3ad-574a21dfb95e
producto_marginal.(2.0, inversiones)

# ╔═╡ ec1fd54c-ce3f-11f1-aac1-b73dcc567861
md"""
Sin el punto, `producto_marginal(2.0, inversiones)` da error: dividir entre
un rango no está definido. Una **comprensión** construye un vector con una
regla, y puede filtrar:
"""

# ╔═╡ ec1fd554-ce3f-11f1-874b-51f281f502f0
[producto_marginal(2.0, x) for x in inversiones if x >= 1]

# ╔═╡ ec1fd554-ce3f-11f1-9167-1deb72ff31f1
md"""
Una **matriz** se escribe por filas, separadas con `;`. El operador `\`
resuelve el sistema lineal ``Ax = b``, el mismo que en la sesión 3 se
resolvía con la regla de Cramer:
"""

# ╔═╡ ec1fd55e-ce3f-11f1-90fc-7f666bae5abb
A = [2 1; 1 3]

# ╔═╡ ec1fd55e-ce3f-11f1-b64b-4555951b617a
A \ [5, 5]

# ╔═╡ ec1fd568-ce3f-11f1-a59a-9f6c09b03ea7
md"""
Una **tupla con nombres** agrupa los parámetros de un modelo. Las letras con
subíndice se escriben como en LaTeX: `a\_1` y Tab da `a₁`.
"""

# ╔═╡ ec1fd568-ce3f-11f1-a299-cf14bf439356
parametros = (a₁ = 2.0, a₂ = 1.0, B = 4.0)

# ╔═╡ ec1fd572-ce3f-11f1-928d-3fca345af9d1
parametros.a₁ / parametros.a₂ - 1

# ╔═╡ ec1fd57e-ce3f-11f1-b8cf-bff87f95c250
md"""
### Tu turno

**1.** Escribe `producto_total(x1, x2, a1, a2)`, el producto de las dos
regiones: ``a_1\ln(1 + x_1) + a_2\ln(1 + x_2)``. En Julia, el logaritmo
natural es `log`.
"""

# ╔═╡ ec1fd57e-ce3f-11f1-a5c8-ad3f7cff2893
producto_total(x1, x2, a1, a2) = missing  # reemplaza missing

# ╔═╡ ec1fd586-ce3f-11f1-b76c-bf1f8b4a4b22
md"""
**2.** Con ``a_1 = 2``, ``a_2 = 1`` y ``B = 4``, la región 1 recibe
``x_1 = 0, 1, 2, 3, 4`` y la región 2 recibe el resto, ``4 - x_1``. Calcula
el producto total de los cinco repartos **en una sola línea**, con
broadcasting o con una comprensión, y guárdalo en `productos`. ¿Cuál es el
mejor de los cinco?
"""

# ╔═╡ ec1fd590-ce3f-11f1-a586-99d160d7099b
productos = missing  # reemplaza missing

# ╔═╡ ec1fd59a-ce3f-11f1-9d3a-b1def4919264
md"""
## 2. Pluto: celdas reactivas

Pluto tiene tres reglas (N.B3):

1. **Cada variable se define en una sola celda.** Si dos celdas definen la
   misma variable, Pluto marca error en las dos.
2. **Una celda es una expresión.** Para varias líneas se usa `begin … end`
   (las variables quedan disponibles para todo el cuaderno) o `let … end`
   (quedan locales a la celda).
3. **El orden de las celdas no importa.** Al cambiar una celda, Pluto
   recalcula todas las que dependen de ella, estén donde estén.

**Pruébalo.**
- Cambia `0:0.5:3` por `0:1:10` en la celda de `inversiones` de la sección 1
  y ejecútala: la celda del broadcasting se recalcula sola.
- Agrega una celda nueva (el **+** que aparece entre celdas) con
  `inversiones = 1`. Las dos celdas marcan error por la regla 1. Borra la
  celda nueva.

Los **deslizadores** conectan un control con una variable. Al moverlos,
todo lo que depende de ella se recalcula:

``a_1`` (productividad de la región 1): $(@bind a1 Slider(1.0:0.1:4.0, default = 2.0, show_value = true))

``a_2`` (productividad de la región 2): $(@bind a2 Slider(0.2:0.1:1.0, default = 1.0, show_value = true))
"""

# ╔═╡ ec1fd5a4-ce3f-11f1-810b-c54b3908bf2b
md"El primer peso invertido en la región 1 rinde $(producto_marginal(a1, 0)); en la región 2, $(producto_marginal(a2, 0))."

# ╔═╡ ec1fd5a4-ce3f-11f1-9a9f-67b7ec180b40
md"""
La celda anterior es Markdown con valores interpolados con `$( … )`. Así se
escriben los textos que cambian con los deslizadores.
"""

# ╔═╡ ec1fd5ac-ce3f-11f1-b0e9-3dfd5001637f
md"""
## 3. Gráficas con Plots.jl

`plot` crea una gráfica y `plot!` agrega otra curva a la misma. Las opciones
van después de `;`. Ésta compara los productos marginales de las dos
regiones, con los deslizadores de la sección 2:
"""

# ╔═╡ ec1fd5b8-ce3f-11f1-96ff-951feb8c12ad
md"""
**Tu turno** (sin verificador). En la celda anterior:
- agrega una línea horizontal en ``\lambda = 0.5`` con
  `hline!([0.5]; label = "λ", color = GRIS, ls = :dash)`;
- con ``a_1 = 2`` y ``a_2 = 1``, lee en la gráfica cuánto recibe cada región
  si el último peso debe rendir ``\lambda = 0.5`` en las dos. ¿Cuánto suman?
  (Compara con la sesión 2: con ``B = 4``, el reparto es ``(3, 1)``.)
"""

# ╔═╡ ec1fd5b8-ce3f-11f1-9d08-b548375c17bb
md"""
## 4. Punto flotante

La computadora guarda los números con unos 16 dígitos, y casi ningún decimal
es exacto (N.B4):
"""

# ╔═╡ ec1fd5c2-ce3f-11f1-921d-4fc5698d00e5
0.1 + 0.2 == 0.3

# ╔═╡ ec1fd5c2-ce3f-11f1-9dab-8fc01f83860b
0.1 + 0.2 ≈ 0.3

# ╔═╡ ec1fd5cc-ce3f-11f1-ad78-7197b7efe72e
md"""
`≈` (se escribe `\approx` y Tab) compara con una tolerancia. **Nunca**
compares números reales con `==`. Los verificadores de este cuaderno
comparan con tolerancia por esa razón.
"""

# ╔═╡ ec1fd5cc-ce3f-11f1-bd8d-efc6e2527921
md"""
## 5. Symbolics.jl: las condiciones de primer orden

Symbolics.jl hace con letras lo que se hace a mano: derivar, despejar y
sustituir (N.I2). Primero se declaran las variables simbólicas. Las
productividades se llaman ``\alpha_i`` y el fondo ``b`` para no chocar con
los deslizadores `a1`, `a2` y `B` (regla 1 de Pluto).
"""

# ╔═╡ ec1fd5d6-ce3f-11f1-af26-b5ba620a505b
@variables x₁ x₂ λ μ α₁ α₂ b

# ╔═╡ ec1fd5d6-ce3f-11f1-a327-35e9712df97f
lagrangiano = α₁ * log(1 + x₁) + α₂ * log(1 + x₂) + λ * (b - x₁ - x₂)

# ╔═╡ ec1fd5de-ce3f-11f1-9432-43e69d44fb19
md"""
Las condiciones de primer orden son el gradiente del lagrangiano respecto de
``(x_1, x_2, \lambda)``, y la hessiana respecto de ``(x_1, x_2)`` da la
condición de segundo orden:
"""

# ╔═╡ ec1fd5de-ce3f-11f1-8130-0b2072a1fd6b
cpo = Symbolics.gradient(lagrangiano, [x₁, x₂, λ])

# ╔═╡ ec1fd5ea-ce3f-11f1-978a-6b96cf633aa1
Symbolics.hessian(lagrangiano, [x₁, x₂])

# ╔═╡ ec1fd5ea-ce3f-11f1-a732-7dd875defac4
md"""
La hessiana es diagonal con entradas negativas: el producto es estrictamente
cóncavo, como en la sesión 2.

**Despejar.** `symbolic_solve(ecuacion, variable)` despeja una ecuación. El
signo `~` escribe una ecuación simbólica. Las dos primeras condiciones dan
cada inversión en función de ``\lambda``:
"""

# ╔═╡ ec1fd5f4-ce3f-11f1-b0e9-857870e28527
despejes = (symbolic_solve(cpo[1] ~ 0, x₁)[1], symbolic_solve(cpo[2] ~ 0, x₂)[1])

# ╔═╡ ec1fd5f4-ce3f-11f1-ac3d-cbd6d6d6242a
md"""
Al sustituirlas en la tercera condición, el presupuesto, queda una ecuación
sólo en ``\lambda``:
"""

# ╔═╡ ec1fd5f4-ce3f-11f1-ae07-bd792a37d8d2
presupuesto = substitute(cpo[3], Dict(x₁ => despejes[1], x₂ => despejes[2]))

# ╔═╡ ec1fd5fe-ce3f-11f1-992a-111322d0ef15
md"""
`symbolic_solve` no despeja ``\lambda`` de esta ecuación, porque ``\lambda``
aparece en el denominador. Un cambio de variable lo arregla: con
``\mu = 1/\lambda`` la ecuación es **lineal** en ``\mu``, y
`symbolic_linear_solve` la resuelve. Es un truco que se hace igual a mano:
"""

# ╔═╡ ec1fd5fe-ce3f-11f1-a5e9-996d12f2c4fb
λ_interior = simplify(1 / symbolic_linear_solve(substitute(presupuesto, Dict(λ => 1 / μ)) ~ 0, μ))

# ╔═╡ ec1fd608-ce3f-11f1-b096-eb2c70bd8e4e
x_interior = [simplify(substitute(d, Dict(λ => λ_interior))) for d in despejes]

# ╔═╡ ec1fd608-ce3f-11f1-acf8-efe926b4dd79
md"""
Es la solución interior de la sesión 2:
``\lambda = (a_1 + a_2)/(B + 2)`` y ``x_i = a_i(B + 2)/(a_1 + a_2) - 1``.
Sustituida en el producto, da la función de valor del régimen interior, y
su derivada respecto del fondo es… el multiplicador. Es el teorema de la
envolvente de la sesión 3, comprobado por la computadora:
"""

# ╔═╡ ec1fd610-ce3f-11f1-a614-13d5c72e6137
V_interior = substitute(α₁ * log(1 + x₁) + α₂ * log(1 + x₂),
                        Dict(x₁ => x_interior[1], x₂ => x_interior[2]))

# ╔═╡ ec1fd610-ce3f-11f1-8de0-a39f1a0f3001
simplify(Symbolics.derivative(V_interior, b))

# ╔═╡ ec1fd61c-ce3f-11f1-8dac-a156ae6c3ed8
md"""
**De la fórmula al número.** `substitute` evalúa una expresión en valores
concretos, y `build_function` la convierte en una función de Julia, mucho
más rápida para graficar:
"""

# ╔═╡ ec1fd61c-ce3f-11f1-ab73-cd6a37550129
substitute(λ_interior, Dict(α₁ => 2, α₂ => 1, b => 4))

# ╔═╡ ec1fd61c-ce3f-11f1-9008-5f4286afe1e7
λ_numerica = build_function(λ_interior, α₁, α₂, b; expression = Val(false))

# ╔═╡ ec1fd626-ce3f-11f1-b282-438bf82fbe28
λ_numerica(2.0, 1.0, 4.0)

# ╔═╡ ec1fd626-ce3f-11f1-b1da-a96db2338370
md"""
## 6. Laboratorio: el reparto óptimo, ``V(B)`` y ``\lambda(B)``

Symbolics dio el régimen interior. Falta la esquina: con ``a_1 \ge a_2`` y
``\bar B = a_1/a_2 - 1``, si ``B \le \bar B`` todo va a la región 1,
``x = (B, 0)`` y ``\lambda = a_1/(1 + B)`` (sesión 2, sección 4.4).

**3.** Escribe `reparto(a1, a2, B)`, que devuelva el vector `[x1, x2, λ]`
en los dos regímenes, suponiendo ``a_1 \ge a_2``. Para el régimen interior
puedes usar `λ_numerica(a1, a2, B)`. Un `if … else … end` o el operador
`condicion ? si : no` deciden el régimen.
"""

# ╔═╡ ec1fd630-ce3f-11f1-b382-53bc812972a9
function reparto(a1, a2, B)
    missing  # reemplaza esta línea
end

# ╔═╡ ec1fd63a-ce3f-11f1-9760-8f44fb6d986c
md"""
**4.** Escribe `valor(a1, a2, B)`, el producto total con el reparto óptimo.
Usa `reparto` y `producto_total`.
"""

# ╔═╡ ec1fd63a-ce3f-11f1-9e77-27827a15c162
function valor(a1, a2, B)
    missing  # reemplaza esta línea
end

# ╔═╡ ec1fd644-ce3f-11f1-b1a4-6b8ebade5873
md"""
### Las gráficas

Con los ejercicios 3 y 4 resueltos, la celda siguiente grafica ``V(B)`` y
``\lambda(B)`` con **tus** funciones. Lee el código: usa comprensiones, el
operador `&&` para dibujar el umbral sólo si cae en la gráfica, y `layout`
para poner dos gráficas lado a lado.

Fondo ``B``: $(@bind B Slider(0.1:0.1:10.0, default = 4.0, show_value = true))
"""

# ╔═╡ ec1fd64e-ce3f-11f1-b581-9fc7ae8452c9
md"""
La línea punteada es el umbral ``\bar B``; la naranja, el ``B`` del
deslizador. ``V`` es creciente y cóncava, y ``\lambda`` es decreciente y
continua, también en el umbral.

**5.** La pendiente de ``V`` debe ser ``\lambda``. Para comprobarlo hace falta
una derivada numérica. Escribe `derivada_centrada(g, x; h = 1e-5)`, que
aproxime ``g'(x)`` con ``\big(g(x + h) - g(x - h)\big)/2h``.
"""

# ╔═╡ ec1fd658-ce3f-11f1-ba57-4b521336941b
function derivada_centrada(g, x; h = 1e-5)
    missing  # reemplaza esta línea
end

# ╔═╡ ec1fd66c-ce3f-11f1-b919-0923badef51e
md"""
## 7. [Avanzado] ¿Qué tan pequeño debe ser ``h``?

Una diferencia finita tiene dos errores (N.A4). El de **truncamiento** baja
con ``h``: es del orden de ``h`` en la diferencia hacia adelante,
``\big(g(x + h) - g(x)\big)/h``, y de ``h^2`` en la centrada. El de
**redondeo** sube cuando ``h`` baja, porque se restan dos números casi
iguales (sección 4). La gráfica muestra el error al estimar ``V'(B) = \lambda``
con cada fórmula, en escala logarítmica.
"""

# ╔═╡ ec1fd676-ce3f-11f1-b16c-997daf1740b6
md"""
El mejor ``h`` está cerca de ``10^{-8}`` para la diferencia hacia adelante y
de ``10^{-5}`` para la centrada; por eso el ejercicio 5 usa ``h = 10^{-5}``.
Con ``h`` más pequeño, el error **crece**.
"""

# ╔═╡ ec1fd676-ce3f-11f1-831f-1bc43da19216
md"""
## Resumen

| Herramienta | Para qué | En este laboratorio |
|---|---|---|
| Funciones y broadcasting | Evaluar un modelo en muchos valores | `producto_marginal.(a, x)` |
| Comprensiones | Construir vectores con una regla | `[valor(a1, a2, b) for b in Bs]` |
| Pluto | Cuadernos reactivos, sin estado oculto | Deslizadores de ``a_1``, ``a_2`` y ``B`` |
| Plots.jl | Gráficas | ``V(B)`` y ``\lambda(B)`` |
| Symbolics.jl | Derivar, despejar y sustituir | Condiciones de primer orden y solución interior |
| Diferencias finitas | Derivar numéricamente | ``V'(B) \approx \lambda`` |

## Preguntas

1. ¿Por qué hubo que llamar ``\alpha_i`` y ``b`` a los símbolos de la
   sección 5?
2. En el ejercicio 2, ¿cuál de los cinco repartos es el mejor? ¿Es el
   óptimo exacto? ¿Por qué no hace falta probar más repartos para saberlo?
3. `symbolic_solve` no despejó ``\lambda`` directamente. ¿Qué otros
   problemas del curso crees que no tendrán solución simbólica? (Pista: la
   sesión 14.)
4. ¿Por qué ``0.1 + 0.2 == 0.3`` da `false`? ¿Qué usaste en lugar de `==`?
5. **[Avanzado]** En la sección 7, ¿por qué el error de la diferencia
   centrada vuelve a crecer cuando ``h < 10^{-5}``?

## Para la próxima sesión

- **Sesión 5: ecuaciones diferenciales lineales de primer orden.** Empieza
  la Unidad II: ¿convergen los estados de México? Se usan los datos del
  PIB por entidad (`Data/entidades.csv`).
- **Entrega de la Tarea 1** (Unidad I).
- Repaso: C.B3 (exponencial), D.B1 a D.B4 (ecuaciones diferenciales) y
  N.I7 (datos en Julia).
"""

# ╔═╡ ec1fd682-ce3f-11f1-a5fd-99b21f4ea650
md"""
---
## Apéndice: paquetes y funciones auxiliares

Estas celdas definen herramientas que usa el cuaderno. No es necesario
leerlas para seguir el laboratorio.
"""

# ╔═╡ ec1fd68a-ce3f-11f1-a6a8-1992aebca464
begin
    const AZUL    = "#2a78d6"   # serie principal
    const NARANJA = "#eb6834"   # segunda serie, valor elegido
    const GRIS    = "#52514e"   # referencias
end;

# ╔═╡ ec1fd5ac-ce3f-11f1-a2be-17e72eb491ff
let
    x = range(0, 6, length = 200)
    plot(x, producto_marginal.(a1, x); label = "región 1", lw = 2, color = AZUL,
         xlabel = "inversión x", ylabel = "producto marginal", legend = :topright)
    plot!(x, producto_marginal.(a2, x); label = "región 2", lw = 2, color = NARANJA)
end

# ╔═╡ ec1fd694-ce3f-11f1-9ed0-ad9187b0651b
"Producto total de las dos regiones: a₁ ln(1 + x₁) + a₂ ln(1 + x₂)."
producto_ref(x1, x2, a1, a2) = a1 * log1p(x1) + a2 * log1p(x2)

# ╔═╡ ec1fd694-ce3f-11f1-a979-6de561cf16e2
"Reparto óptimo con Kuhn-Tucker: (x₁, x₂, λ). Funciona con cualquier orden de a₁ y a₂."
function reparto_ref(a1, a2, B)
    if a1 < a2
        r = reparto_ref(a2, a1, B)
        return (r[2], r[1], r[3])
    end
    B <= a1 / a2 - 1 && return (B, 0.0, a1 / (1 + B))
    λ = (a1 + a2) / (B + 2)
    (a1 / λ - 1, a2 / λ - 1, λ)
end

# ╔═╡ ec1fd69e-ce3f-11f1-9a56-bfcead1c47e6
"Valor óptimo V(a₁, a₂, B): el producto total con el reparto óptimo."
function valor_ref(a1, a2, B)
    x1, x2, _ = reparto_ref(a1, a2, B)
    producto_ref(x1, x2, a1, a2)
end

# ╔═╡ ec1fd66c-ce3f-11f1-a84b-8fe606810ff6
let
    hs = 10.0 .^ (-1:-0.25:-13)
    V(b) = valor_ref(a1, a2, b)
    λ = reparto_ref(a1, a2, B)[3]
    adelante = [abs((V(B + h) - V(B)) / h - λ) for h in hs]
    centrada = [abs((V(B + h) - V(B - h)) / 2h - λ) for h in hs]
    plot(hs, max.(adelante, 1e-17); xscale = :log10, yscale = :log10, lw = 2,
         color = AZUL, label = "hacia adelante", legend = :bottomleft,
         xlabel = "h", ylabel = "error", title = "Error de la derivada numérica de V en B = $B")
    plot!(hs, max.(centrada, 1e-17); lw = 2, color = NARANJA, label = "centrada")
end

# ╔═╡ ec1fd69e-ce3f-11f1-b458-a59fb563a09c
begin
    # Casos de prueba: (x₁, x₂, a₁, a₂) para el producto; (a₁, a₂, B) con
    # esquina, umbral e interior para el reparto.
    const CASOS_PRODUCTO = [(0.0, 0.0, 2.0, 1.0), (3.0, 1.0, 2.0, 1.0), (0.5, 2.5, 1.5, 0.7)]
    const CASOS = [(2.0, 1.0, 0.5), (2.0, 1.0, 1.0), (2.0, 1.0, 4.0), (3.0, 0.5, 2.0), (1.0, 1.0, 3.0)]
end;

# ╔═╡ ec1fd6a8-ce3f-11f1-8847-6be4701ed9cc
"¿La función ya está escrita? Verdadero si corre sin error y no devuelve missing."
function completo(f)
    r = try
        f()
    catch
        return false
    end
    !(r === missing || (r isa AbstractArray && any(ismissing, r)))
end

# ╔═╡ ec1fd64e-ce3f-11f1-a7a5-67c1a59b9690
if completo(() -> valor(2.0, 1.0, 4.0)) && completo(() -> reparto(2.0, 1.0, 4.0))
    let
        Bs = range(0.01, 10, length = 300)
        g1 = plot(Bs, [valor(a1, a2, b) for b in Bs]; color = AZUL, lw = 2,
                  xlabel = "fondo B", ylabel = "V(B)", title = "Valor óptimo")
        g2 = plot(Bs, [reparto(a1, a2, b)[3] for b in Bs]; color = AZUL, lw = 2,
                  xlabel = "fondo B", ylabel = "λ(B)", title = "Precio sombra del fondo")
        B̄ = a1 / a2 - 1
        for g in (g1, g2)
            B̄ <= 10 && vline!(g, [B̄]; color = GRIS, ls = :dash, lw = 1)
            vline!(g, [B]; color = NARANJA, lw = 1.5)
        end
        plot(g1, g2; layout = (1, 2), size = (760, 320))
    end
else
    md"Completa los ejercicios 3 y 4 para ver las gráficas."
end

# ╔═╡ ec1fd662-ce3f-11f1-af2a-8b73194f99b1
if completo(() -> derivada_centrada(exp, 1.0)) && completo(() -> valor(2.0, 1.0, 4.0))
    md"""
    Con ``B`` = $(B): la derivada numérica de ``V`` es
    $(round(derivada_centrada(v -> valor(a1, a2, v), B), digits = 6)) y el
    multiplicador vale $(round(reparto(a1, a2, B)[3], digits = 6)).
    """
else
    md"Completa los ejercicios 4 y 5 para comparar ``V'(B)`` con ``\lambda``."
end

# ╔═╡ ec1fd6a8-ce3f-11f1-9785-2751f9915f3e
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

# ╔═╡ ec1fd586-ce3f-11f1-b118-f7a496885122
verificar(() -> [producto_total(c...) for c in CASOS_PRODUCTO],
          [producto_ref(c...) for c in CASOS_PRODUCTO];
          pista = md"`producto_total(x1, x2, a1, a2) = a1 * log(1 + x1) + a2 * log(1 + x2)`")

# ╔═╡ ec1fd59a-ce3f-11f1-8935-17660ddedbbd
verificar(() -> productos, producto_ref.(0:4, 4 .- (0:4), 2.0, 1.0);
          pista = md"Con broadcasting: `producto_total.(0:4, 4 .- (0:4), 2.0, 1.0)`. Con una comprensión: `[producto_total(x, 4 - x, 2.0, 1.0) for x in 0:4]`.")

# ╔═╡ ec1fd630-ce3f-11f1-a40e-831dd9376568
verificar(() -> [reparto(c...) for c in CASOS],
          [collect(reparto_ref(c...)) for c in CASOS];
          pista = md"Calcula `B̄ = a1 / a2 - 1`. Si `B <= B̄`, devuelve `[B, 0.0, a1 / (1 + B)]`. Si no, `λ = λ_numerica(a1, a2, B)` y devuelve `[a1 / λ - 1, a2 / λ - 1, λ]`.")

# ╔═╡ ec1fd644-ce3f-11f1-bf16-0dd3ce85d075
verificar(() -> [valor(c...) for c in CASOS], [valor_ref(c...) for c in CASOS];
          pista = md"`x1, x2, _ = reparto(a1, a2, B)` y después `producto_total(x1, x2, a1, a2)`.")

# ╔═╡ ec1fd658-ce3f-11f1-811e-c9b9c0e369a2
verificar(() -> [derivada_centrada(exp, 1.0), derivada_centrada(sin, 0.0), derivada_centrada(x -> x^3, 2.0)],
          [exp(1.0), 1.0, 12.0];
          rtol = 1e-8,
          pista = md"`(g(x + h) - g(x - h)) / (2h)`")

# ╔═╡ Cell order:
# ╟─ec1fd4f0-ce3f-11f1-8a82-0764d8ae8c90
# ╟─ec1fd51a-ce3f-11f1-b100-e9b7667aabb9
# ╟─ec1fd522-ce3f-11f1-a381-0309ca727c8a
# ╟─ec1fd52c-ce3f-11f1-857b-a7097035ebf1
# ╟─ec1fd52c-ce3f-11f1-9600-0b79490ed524
# ╠═ec1fd536-ce3f-11f1-ae9b-3b0a201b9bf9
# ╠═ec1fd536-ce3f-11f1-bbe2-f552e86332bb
# ╟─ec1fd540-ce3f-11f1-a4da-f5b4397578cc
# ╠═ec1fd540-ce3f-11f1-beaf-89222605f04b
# ╠═ec1fd54c-ce3f-11f1-a3ad-574a21dfb95e
# ╟─ec1fd54c-ce3f-11f1-aac1-b73dcc567861
# ╠═ec1fd554-ce3f-11f1-874b-51f281f502f0
# ╟─ec1fd554-ce3f-11f1-9167-1deb72ff31f1
# ╠═ec1fd55e-ce3f-11f1-90fc-7f666bae5abb
# ╠═ec1fd55e-ce3f-11f1-b64b-4555951b617a
# ╟─ec1fd568-ce3f-11f1-a59a-9f6c09b03ea7
# ╠═ec1fd568-ce3f-11f1-a299-cf14bf439356
# ╠═ec1fd572-ce3f-11f1-928d-3fca345af9d1
# ╟─ec1fd57e-ce3f-11f1-b8cf-bff87f95c250
# ╠═ec1fd57e-ce3f-11f1-a5c8-ad3f7cff2893
# ╟─ec1fd586-ce3f-11f1-b118-f7a496885122
# ╟─ec1fd586-ce3f-11f1-b76c-bf1f8b4a4b22
# ╠═ec1fd590-ce3f-11f1-a586-99d160d7099b
# ╟─ec1fd59a-ce3f-11f1-8935-17660ddedbbd
# ╟─ec1fd59a-ce3f-11f1-9d3a-b1def4919264
# ╠═ec1fd5a4-ce3f-11f1-810b-c54b3908bf2b
# ╟─ec1fd5a4-ce3f-11f1-9a9f-67b7ec180b40
# ╟─ec1fd5ac-ce3f-11f1-b0e9-3dfd5001637f
# ╠═ec1fd5ac-ce3f-11f1-a2be-17e72eb491ff
# ╟─ec1fd5b8-ce3f-11f1-96ff-951feb8c12ad
# ╟─ec1fd5b8-ce3f-11f1-9d08-b548375c17bb
# ╠═ec1fd5c2-ce3f-11f1-921d-4fc5698d00e5
# ╠═ec1fd5c2-ce3f-11f1-9dab-8fc01f83860b
# ╟─ec1fd5cc-ce3f-11f1-ad78-7197b7efe72e
# ╟─ec1fd5cc-ce3f-11f1-bd8d-efc6e2527921
# ╠═ec1fd5d6-ce3f-11f1-af26-b5ba620a505b
# ╠═ec1fd5d6-ce3f-11f1-a327-35e9712df97f
# ╟─ec1fd5de-ce3f-11f1-9432-43e69d44fb19
# ╠═ec1fd5de-ce3f-11f1-8130-0b2072a1fd6b
# ╠═ec1fd5ea-ce3f-11f1-978a-6b96cf633aa1
# ╟─ec1fd5ea-ce3f-11f1-a732-7dd875defac4
# ╠═ec1fd5f4-ce3f-11f1-b0e9-857870e28527
# ╟─ec1fd5f4-ce3f-11f1-ac3d-cbd6d6d6242a
# ╠═ec1fd5f4-ce3f-11f1-ae07-bd792a37d8d2
# ╟─ec1fd5fe-ce3f-11f1-992a-111322d0ef15
# ╠═ec1fd5fe-ce3f-11f1-a5e9-996d12f2c4fb
# ╠═ec1fd608-ce3f-11f1-b096-eb2c70bd8e4e
# ╟─ec1fd608-ce3f-11f1-acf8-efe926b4dd79
# ╠═ec1fd610-ce3f-11f1-a614-13d5c72e6137
# ╠═ec1fd610-ce3f-11f1-8de0-a39f1a0f3001
# ╟─ec1fd61c-ce3f-11f1-8dac-a156ae6c3ed8
# ╠═ec1fd61c-ce3f-11f1-ab73-cd6a37550129
# ╠═ec1fd61c-ce3f-11f1-9008-5f4286afe1e7
# ╠═ec1fd626-ce3f-11f1-b282-438bf82fbe28
# ╟─ec1fd626-ce3f-11f1-b1da-a96db2338370
# ╠═ec1fd630-ce3f-11f1-b382-53bc812972a9
# ╟─ec1fd630-ce3f-11f1-a40e-831dd9376568
# ╟─ec1fd63a-ce3f-11f1-9760-8f44fb6d986c
# ╠═ec1fd63a-ce3f-11f1-9e77-27827a15c162
# ╟─ec1fd644-ce3f-11f1-bf16-0dd3ce85d075
# ╟─ec1fd644-ce3f-11f1-b1a4-6b8ebade5873
# ╠═ec1fd64e-ce3f-11f1-a7a5-67c1a59b9690
# ╟─ec1fd64e-ce3f-11f1-b581-9fc7ae8452c9
# ╠═ec1fd658-ce3f-11f1-ba57-4b521336941b
# ╟─ec1fd658-ce3f-11f1-811e-c9b9c0e369a2
# ╠═ec1fd662-ce3f-11f1-af2a-8b73194f99b1
# ╟─ec1fd66c-ce3f-11f1-b919-0923badef51e
# ╠═ec1fd66c-ce3f-11f1-a84b-8fe606810ff6
# ╟─ec1fd676-ce3f-11f1-b16c-997daf1740b6
# ╟─ec1fd676-ce3f-11f1-831f-1bc43da19216
# ╟─ec1fd682-ce3f-11f1-a5fd-99b21f4ea650
# ╠═ec1fd68a-ce3f-11f1-9ec2-519f546b466f
# ╠═ec1fd68a-ce3f-11f1-a6a8-1992aebca464
# ╠═ec1fd694-ce3f-11f1-9ed0-ad9187b0651b
# ╠═ec1fd694-ce3f-11f1-a979-6de561cf16e2
# ╠═ec1fd69e-ce3f-11f1-9a56-bfcead1c47e6
# ╠═ec1fd69e-ce3f-11f1-b458-a59fb563a09c
# ╠═ec1fd6a8-ce3f-11f1-8847-6be4701ed9cc
# ╠═ec1fd6a8-ce3f-11f1-9785-2751f9915f3e
