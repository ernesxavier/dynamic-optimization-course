# Optimización Dinámica

Material del curso de Optimización Dinámica (Doctorado en Economía Regional,
CISE, UAdeC), con cuadernos en Julia.

## Estructura

```
├── programa/
│   └── programa.md            → Programa del curso (24 sesiones)
├── docs/
│   ├── planeacion.md          → Decisiones de diseño y plan B
│   └── guia-de-repaso.md      → Repaso del profesor antes del curso
├── Class_notes/
│   ├── sNN_tema.md            → Notas formales por sesión (ver tabla abajo)
│   └── repaso/                → Repaso de matemáticas por niveles (índice por sesión)
│       └── figuras/           → Figuras de las notas (generadas con Code/figuras_repaso.jl)
├── Data/                      → Datos de los casos aplicados, en CSV
├── Code/                      → Todo el código Julia, un solo entorno
│   ├── sNN_tema.jl            → Cuadernos de Pluto (ver tabla abajo)
│   ├── figuras_repaso.jl      → Regenera las figuras de Class_notes/repaso/figuras/
│   ├── Project.toml
│   └── Manifest.toml
├── src/                       → Fuentes de los cuadernos de Pluto (formato #%%)
│   ├── construir_cuaderno.jl  → Genera y ejecuta un cuaderno a partir de su fuente
│   └── sNN_tema.jl            → Fuente de Code/sNN_tema.jl
└── README.md
```

## Notas y cuadernos previstos

| Ses. | Tema | Notas (`Class_notes/`) | Cuaderno (`Code/`) |
|---|---|---|---|
| 2 | Lagrange y Kuhn-Tucker | `s02_lagrange_kuhn_tucker.md` | `s02_lagrange_kuhn_tucker.jl` |
| 3 | Envolvente y estática comparativa | `s03_envolvente.md` | |
| 4 | Laboratorio 0: Julia, Pluto.jl, Symbolics.jl | | `s04_laboratorio_0.jl` |
| 5 | Ecuaciones lineales | `s05_ecuaciones_lineales.md` | |
| 6 | Equilibrio y diagramas de fase | `s06_diagramas_de_fase.md` | |
| 7 | Sistemas lineales y linealización | `s07_sistemas_lineales.md` | |
| 8 | Estabilidad no lineal | `s08_estabilidad_no_lineal.md` | `s08_estabilidad_no_lineal.jl` |
| 9 | Laboratorio 1: diagramas de fase | | `s09_laboratorio_1.jl` |
| 10 | Cálculo de variaciones | `s10_calculo_de_variaciones.md` | |
| 11 | Principio del máximo | `s11_principio_del_maximo.md` | |
| 12 | Horizonte infinito y Ramsey | `s12_horizonte_infinito.md` | `s12_ramsey.jl` |
| 13 | Varias variables, bang-bang | `s13_varias_variables.md` | |
| 14 | Caso: inversión entre dos regiones | `s14_dos_regiones.md` | `s14_dos_regiones.jl` |
| 15 | Bellman en horizonte finito | `s15_bellman.md` | |
| 16 | Bellman en horizonte infinito | `s16_bellman_infinito.md` | `s16_bellman_infinito.jl` |
| 17 | Laboratorio 2: iteración de función valor | | `s17_laboratorio_2.jl` |
| 18 | Control óptimo frente a programación dinámica | `s18_control_vs_pd.md` | |
| 19 | Laboratorio 3: comparación numérica | | `s19_laboratorio_3.jl` |

## Requisitos

- Julia 1.13

## Entorno de Julia

Todo el repositorio usa **un solo entorno**: `Code/Project.toml` +
`Code/Manifest.toml`. Incluye Pluto, así que no hace falta instalar nada en el
entorno global. Los cuadernos de Pluto activan este entorno en su primera
celda de paquetes (`Pkg.activate(@__DIR__)`).

## Uso

Desde la raíz del repositorio, la primera vez:

```
julia --project=Code -e 'using Pkg; Pkg.instantiate()'
```

**Cuadernos de Pluto:**

```
julia --project=Code -e 'using Pluto; Pluto.run()'
```

y en el navegador abrir el cuaderno de la sesión, por ejemplo
`Code/s02_lagrange_kuhn_tucker.jl`.

**Construir un cuaderno desde su fuente.** Cada cuaderno de Pluto tiene una
fuente en `src/` con marcadores `#%%` (celda visible) y `#%% hide` (código
oculto), más fácil de editar como texto. Este comando genera el cuaderno, lo
ejecuta sin interfaz, reporta las celdas con error y guarda las gráficas en
la carpeta de salidas para revisarlas:

```
julia --project=Code src/construir_cuaderno.jl src/s02_lagrange_kuhn_tucker.jl Code/s02_lagrange_kuhn_tucker.jl /tmp/salidas
```

La fuente y el cuaderno deben coincidir. Los cambios grandes se hacen en la
fuente y se regenera el cuaderno; si se edita el cuaderno en Pluto, hay que
pasar el cambio a la fuente antes de volver a generarlo.

**Regenerar las figuras del repaso:**

```
julia --project=Code Code/figuras_repaso.jl
```

**Actualizar paquetes** (por ejemplo, al cambiar de versión de Julia):

```
julia -e 'using Pkg; Pkg.activate("Code"); Pkg.update()'
```

## Pendientes

- [x] Decidir el lenguaje del curso (Julia con Pluto.jl).
- [x] Verificar los capítulos de Chiang y Wainwright y de Chiang (1992) citados en el temario.
- [x] Programa con el formato del curso de Econofísica.
- [x] Estructura del repositorio y entorno de Julia (`Code/Project.toml`).
- [ ] Repaso del profesor en 5 semanas (14 oct a 17 nov): ver `docs/guia-de-repaso.md`.
- [x] Piloto: notas y cuaderno de la sesión 2 (Lagrange y Kuhn-Tucker).
- [ ] Notas formales y cuadernos del resto de las sesiones (tabla de arriba).
- [x] Notas de repaso por áreas (C, L, D, A, N) con autodiagnósticos; tabla de claves por sesión.
- [x] Orientación aplicada en el programa: preguntas regionales, datos del INEGI en las sesiones 5, 12 y 14, proyecto ligado a la tesis.
- [ ] Script `Code/descargar_inegi.jl` y CSV en `Data/`: PIB por entidad federativa y población, para convergencia y calibraciones.
- [ ] Definir con qué datos se aproximan las tasas de ahorro sᵢ y las productividades vᵢ de dos regiones (sesión 14), y los parámetros de Ramsey para México (sesión 12).
- [ ] Agregar una referencia sobre convergencia regional en México para la sesión 5 (verificar la ficha).
- [ ] Armar el calendario sesión por sesión (requiere las fechas del trimestre y los días sin clase).
- [ ] Redactar el cuestionario diagnóstico y el material de repaso de la semana previa.
- [ ] Preparar el syllabus en el formato institucional de la UAdeC.
- [ ] Redactar las cuatro tareas.
- [ ] Probar la instalación del entorno en una computadora limpia.
- [ ] Corregir en Zotero: la ficha GZK24M8N es el Vol. 5B del Handbook (ISBN 978-0-444-59531-7); agregar a Henderson y Strange como coeditores; indicar 4.ª ed. en Sethi.
- [ ] Agregar a Zotero los artículos de Rahman, Intriligator y Takayama, y la bibliografía del plan que falta. El título correcto de Rahman (1963) dice "An Aggregative Study".
- [ ] En Zotero, el PDF de Chiang y Wainwright (ZL6E3WVS) está como archivo suelto, sin ficha: crear la ficha del libro.
