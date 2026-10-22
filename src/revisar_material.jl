# Revisa la consistencia del material del curso. Uso, desde la raíz:
#   julia src/revisar_material.jl
# Comprueba que:
#   1. cada clave del índice del repaso exista y su etiqueta incluya esa sesión;
#   2. cada clave citada en una sesión (o en una tarea) aparezca en las filas
#      del índice de esa sesión (o de las sesiones de la unidad);
#   3. los enlaces relativos de las notas lleven a archivos y anclas existentes;
#   4. no queden menciones a sesiones inexistentes ni a "semanas" del curso.
# Termina con código 1 si encuentra algún problema.

const REPASO = joinpath("Class_notes", "repaso")
const AREAS = Dict('C' => "calculo.md", 'L' => "algebra_lineal.md",
                   'D' => "ecuaciones_diferenciales.md", 'A' => "analisis.md",
                   'N' => "metodos_numericos.md", 'E' => "estadistica.md")
const NSESIONES = 24                     # sesiones del curso
const NCONTENIDO = 19                    # sesiones con fila propia en el índice
const LABORATORIOS = [4, 9, 17, 19]
# Cada tarea puede citar las claves de las sesiones de su unidad
const UNIDADES = Dict(1 => Set(1:4), 2 => Set(5:9), 3 => Set(10:14), 4 => Set(15:19))

problemas = String[]
reportar(msg) = push!(problemas, msg)

"Sesiones de una etiqueta como \"Sesiones 5, 12, proyecto\" (0 = proyecto final)."
function sesiones_de(etiqueta)
    startswith(etiqueta, "Todas") && return Set(0:NCONTENIDO)
    s = Set(parse(Int, x.match) for x in eachmatch(r"\d+", etiqueta))
    occursin("laboratorios", etiqueta) && union!(s, LABORATORIOS)
    occursin("proyecto", etiqueta) && push!(s, 0)
    s
end

"Expande \"[E.B2–B3](...)\" en las claves E.B2 y E.B3."
function claves_en(texto)
    ks = String[]
    for m in eachmatch(r"\b([CLDANE])\.([BIA])(\d+)(?:–[BIA]?(\d+))?", texto)
        a = parse(Int, m[3])
        b = m[4] === nothing ? a : parse(Int, m[4])
        append!(ks, ["$(m[1]).$(m[2])$n" for n in a:b])
    end
    ks
end

# --- Etiquetas de cada concepto -------------------------------------------
etiquetas = Dict{String,Set{Int}}()
todas = Set{String}()                    # claves que se usan en todas las sesiones
for archivo in values(AREAS)
    texto = read(joinpath(REPASO, archivo), String)
    for m in eachmatch(r"### ([CLDANE]\.[BIA]\d+)[^\n]*\n\*([^*\n]+)\*", texto)
        etiqueta = rstrip(m[2], '.')
        if !(startswith(etiqueta, "Sesi") || startswith(etiqueta, "Todas"))
            reportar("$(m[1]): etiqueta con formato desconocido: $(m[2])")
            continue
        end
        etiquetas[m[1]] = sesiones_de(etiqueta)
        startswith(etiqueta, "Todas") && push!(todas, m[1])
    end
end

# --- 1. Índice del repaso --------------------------------------------------
indice = Dict{Int,Set{String}}()
for linea in eachline(joinpath(REPASO, "README.md"))
    m = match(r"^\| (\d+|—) \|[^|]*\|(.*)\|$", linea)
    m === nothing && continue
    s = m[1] == "—" ? 0 : parse(Int, m[1])
    indice[s] = Set(claves_en(m[2]))
    s == 1 && continue                   # la sesión 1 remite a todo el nivel B
    for k in indice[s]
        if !haskey(etiquetas, k)
            reportar("Índice, sesión $s: la clave $k no existe")
        elseif !(s in etiquetas[k])
            reportar("Índice, sesión $s: la etiqueta de $k no incluye esa sesión")
        end
    end
end
sort(collect(keys(indice))) == 0:NCONTENIDO ||
    reportar("El índice del repaso no tiene una fila por sesión 1–$NCONTENIDO (más el proyecto final)")

# Al revés: cada sesión de una etiqueta debe tener la clave en su fila
for (k, ss) in etiquetas, s in ss
    k in todas && continue
    s in keys(indice) || continue
    s == 1 && continue
    k in indice[s] || reportar("$k: su etiqueta dice sesión $s, pero no está en esa fila del índice")
end

# --- 2. Claves citadas en cada sesión ---------------------------------------
"Sesiones que cubre un archivo, según su título (\"# Sesión 3:\" o \"# Sesiones 1 y 2:\")."
function sesiones_del_archivo(ruta)
    titulo = first(filter(l -> occursin(r"^#\s+Sesi", l), readlines(ruta)))
    Set(parse(Int, x.match) for x in eachmatch(r"\d+", split(titulo, ':')[1]))
end

for ruta in [readdir("src"; join = true); readdir("Class_notes"; join = true)]
    tarea = match(r"/tarea(\d)_[a-z_]+\.(jl|md)$", ruta)
    (tarea !== nothing || occursin(r"/s\d\d_[a-z_]+\.(jl|md)$", ruta)) || continue
    cubre = tarea === nothing ? sesiones_del_archivo(ruta) : UNIDADES[parse(Int, tarea[1])]
    # Una sesión puede anunciar el repaso de la siguiente ("Para la próxima sesión")
    alcance = tarea === nothing ? union(cubre, Set(maximum(cubre) + 1)) : cubre
    permitidas = union((get(indice, s, Set{String}()) for s in alcance)...)
    # La sesión 1 (diagnóstico) remite a todo el nivel básico
    1 in alcance && union!(permitidas, filter(k -> occursin(".B", k), keys(etiquetas)))
    for k in unique(claves_en(read(ruta, String)))
        haskey(etiquetas, k) || (reportar("$ruta: cita la clave inexistente $k"); continue)
        k in permitidas || reportar("$ruta: cita $k, que no está en el índice de las sesiones $(sort(collect(cubre)))")
    end
end

# --- 3. Enlaces relativos ---------------------------------------------------
anclas(ruta) = Set(m[1] for m in eachmatch(r"<a id=\"([^\"]+)\"></a>", read(ruta, String)))
for dir in ("Class_notes", REPASO, "docs", "programa", ".")
    for nombre in readdir(dir)
        endswith(nombre, ".md") || continue
        ruta = joinpath(dir, nombre)
        texto = read(ruta, String)
        for m in eachmatch(r"\]\(([^)#\s]*\.md)?(?:#([^)\s]+))?\)", texto)
            m[1] === nothing && m[2] === nothing && continue
            destino = m[1] === nothing ? ruta : normpath(joinpath(dir, m[1]))
            if !isfile(destino)
                reportar("$ruta: enlace roto a $(m[1])")
            elseif m[2] !== nothing && !(m[2] in anclas(destino))
                reportar("$ruta: el ancla #$(m[2]) no existe en $(something(m[1], "el mismo archivo"))")
            end
        end
    end
end

# --- 4. Menciones a sesiones y semanas --------------------------------------
for dir in ("src", "Class_notes", REPASO)
    for nombre in readdir(dir)
        (endswith(nombre, ".jl") || endswith(nombre, ".md")) || continue
        ruta = joinpath(dir, nombre)
        for (i, linea) in enumerate(eachline(ruta))
            for m in eachmatch(r"\b[Ss]esi(?:ón|ones)\]?\s+(\d+)", linea)
                parse(Int, m[1]) <= NSESIONES || reportar("$ruta:$i: sesión inexistente: $(m.match)")
            end
            occursin(r"\b[Ss]emanas?\s+\d", linea) && reportar("$ruta:$i: menciona semanas del curso: $(strip(linea))")
        end
    end
end

if isempty(problemas)
    println("Sin problemas.")
else
    foreach(println, problemas)
    println("\n$(length(problemas)) problema(s).")
    exit(1)
end
