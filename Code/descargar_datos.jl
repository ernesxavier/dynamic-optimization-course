# Descarga los datos del curso y genera:
#
#   Data/entidades.csv   PIB, PIB petrolero, población y empleo de las 32
#                        entidades federativas, por año (sesiones 5 y 14)
#   Data/pwt_mexico.csv  Penn World Table 11.0, serie de México (sesión 12)
#
# Uso (desde la raíz del repositorio):
#     julia --project=Code Code/descargar_datos.jl
#
# Fuentes:
#   - PIB por entidad: INEGI, PIBE, año base 2018, datos abiertos. Millones de
#     pesos a precios de 2018. El PIB petrolero es el valor agregado de la
#     minería petrolera (21-1), para poder excluirlo en Campeche y Tabasco.
#   - Población y empleo: OCDE, base de datos regional (regiones TL2 = las 32
#     entidades). El empleo es el de 15 a 64 años. Se usa la OCDE porque el
#     servidor de datos abiertos de CONAPO rechaza las descargas automáticas.
#   - Penn World Table 11.0 (Feenstra, Inklaar y Timmer, 2015), Dataverse,
#     https://doi.org/10.34894/FABVLR, licencia CC BY 4.0.
#
# Las claves de entidad son las del INEGI (1 = Aguascalientes, …, 32 =
# Zacatecas), que coinciden con las de la OCDE (ME01, …, ME32).

using CSV, DataFrames, Downloads, XLSX, p7zip_jll, Unicode

const DATA = joinpath(@__DIR__, "..", "Data")
const URL_PIBE = "https://www.inegi.org.mx/contenidos/programas/pibent/2018/datosabiertos/pibe_datos_abiertos_csv.zip"
const URL_OCDE = "https://sdmx.oecd.org/public/rest/data/OECD.CFE.EDS,"
const URL_PWT = "https://dataverse.nl/api/access/datafile/554105"   # pwt110.xlsx
const DESDE = 2003

descargar(url, destino) = Downloads.download(url, destino; headers = ["User-Agent" => "Mozilla/5.0"])
sin_acentos(s) = lowercase(Unicode.normalize(s; stripmark = true))

# --- PIB por entidad (INEGI) ------------------------------------------------
"Lee un archivo del PIBE y devuelve (clave, entidad, año, valor) en millones de pesos de 2018."
function leer_pibe(ruta)
    t = CSV.read(ruta, DataFrame; missingstring = "NA")
    t = filter(r -> startswith(r[1], "Millones de pesos a precios de 2018|"), t)
    entidad = [replace(last(split(d, '|')), "<C1>" => "") for d in t[:, 1]]
    t = t[entidad .!= "Estados Unidos Mexicanos", :]
    nrow(t) == 32 || error("Se esperaban 32 entidades en $(basename(ruta)), hay $(nrow(t))")
    t[!, 1] = [replace(last(split(d, '|')), "<C1>" => "") for d in t[:, 1]]
    t.clave = 1:32                        # el PIBE lista las entidades en el orden de sus claves
    largo = stack(t, Not(1, :clave); variable_name = :año, value_name = :valor)
    largo.año = [parse(Int, match(r"\d{4}", a).match) for a in largo.año]
    rename!(largo, 1 => :entidad)
    select(largo, :clave, :entidad, :año, :valor)
end

println("Descargando el PIB por entidad (INEGI)...")
tmp = mktempdir()
descargar(URL_PIBE, joinpath(tmp, "pibe.zip"))
run(pipeline(`$(p7zip()) x $(joinpath(tmp, "pibe.zip")) -o$tmp -y`; stdout = devnull))
archivo(patron) = only([joinpath(d, f) for (d, _, fs) in walkdir(tmp) for f in fs if occursin(patron, f) && endswith(f, ".csv")])
pib = rename(leer_pibe(archivo(r"actividad_pibe\d{4}")), :valor => :pib)
petro = rename(leer_pibe(archivo(r"actividad_21p\d{4}")), :valor => :pib_petrolero)
pib = innerjoin(pib, select(petro, :clave, :año, :pib_petrolero), on = [:clave, :año])

# --- Población y empleo (OCDE) ----------------------------------------------
"Descarga una serie regional de la OCDE para las entidades de México."
function leer_ocde(flujo, clave_sdmx, nombre)
    ruta = joinpath(tmp, "$nombre.csv")
    descargar(URL_OCDE * flujo * ",/" * clave_sdmx * "?startPeriod=$DESDE&format=csvfilewithlabels", ruta)
    t = CSV.read(ruta, DataFrame)
    filter!(r -> r.COUNTRY == "MEX" && occursin(r"^ME\d\d$", r.REF_AREA) && r.UNIT_MEASURE == "PS", t)
    DataFrame(clave = parse.(Int, SubString.(t.REF_AREA, 3)), nombre_ocde = t[!, "Reference area"],
              año = t.TIME_PERIOD, valor = t.OBS_VALUE)
end

println("Descargando población y empleo por entidad (OCDE)...")
pob = leer_ocde("DSD_REG_DEMO@DF_POP_BROAD", "A.TL2...POP._T._T.", "poblacion")
emp = leer_ocde("DSD_REG_LAB@DF_LEVELS", "A.TL2...EMP.Y15T64._T.", "empleo")

# Comprobar que las claves de la OCDE y del INEGI son las mismas entidades
nombres = unique(innerjoin(unique(select(pib, :clave, :entidad)), unique(select(pob, :clave, :nombre_ocde)), on = :clave))
for r in eachrow(nombres)
    r.clave == 9 && continue                       # "Ciudad de México" y "México D.C."
    first(sin_acentos(r.entidad), 4) == first(sin_acentos(r.nombre_ocde), 4) ||
        error("La clave $(r.clave) no coincide: $(r.entidad) / $(r.nombre_ocde)")
end

entidades = leftjoin(pib, select(rename(pob, :valor => :poblacion), :clave, :año, :poblacion), on = [:clave, :año])
entidades = leftjoin(entidades, select(rename(emp, :valor => :empleo), :clave, :año, :empleo), on = [:clave, :año])
entidades.poblacion = passmissing(x -> round(Int, x)).(entidades.poblacion)
entidades.empleo = passmissing(x -> round(Int, x)).(entidades.empleo)
sort!(entidades, [:clave, :año])
CSV.write(joinpath(DATA, "entidades.csv"), entidades)
println("Guardado Data/entidades.csv: ", nrow(entidades), " filas, años ",
        minimum(entidades.año), "–", maximum(entidades.año), "; empleo desde ",
        minimum(entidades.año[.!ismissing.(entidades.empleo)]))

# --- Penn World Table 11.0 --------------------------------------------------
println("Descargando la Penn World Table 11.0...")
descargar(URL_PWT, joinpath(tmp, "pwt110.xlsx"))
pwt = DataFrame(XLSX.readtable(joinpath(tmp, "pwt110.xlsx"), "Data"))
pwt = filter(:countrycode => ==("MEX"), pwt)
# PIB real (rgdpna) y capital real (rnna) a precios nacionales constantes de 2021,
# en millones de dólares; emp y pop en millones; labsh: participación del
# trabajo; delta: depreciación; csh_i: participación de la inversión en el PIB
cols = [:year, :rgdpna, :rnna, :emp, :pop, :hc, :labsh, :delta, :csh_i, :rtfpna]
pwt = select(pwt, cols)
for c in cols[2:end]
    pwt[!, c] = [x isa Number ? Float64(x) : missing for x in pwt[!, c]]
end
pwt.year = Int.(pwt.year)
rename!(pwt, :year => :año)
CSV.write(joinpath(DATA, "pwt_mexico.csv"), pwt)
println("Guardado Data/pwt_mexico.csv: ", nrow(pwt), " años, ", minimum(pwt.año), "–", maximum(pwt.año))
