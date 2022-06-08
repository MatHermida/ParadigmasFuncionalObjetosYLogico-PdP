import Text.Show.Functions()

type Instruccion = Microprocesador -> Microprocesador
type Programa = [Instruccion]

data Microprocesador = UnMicroprocesador {
    acumuladorA :: Int,
    acumuladorB :: Int,
    programCounter :: Int,
    mensajeError :: String,
    memoriaPrograma :: Programa,
    memoria :: [Int]
} deriving Show

xt8088 :: Microprocesador
xt8088 = UnMicroprocesador {
    acumuladorA = 0, 
    acumuladorB = 0, 
    programCounter = 0, 
    mensajeError = "", 
    memoriaPrograma = [swap, nop, lodv 133, lodv 0, str 1 3, str 2 0], 
    memoria = replicate 1024 0} 

at8086 :: Microprocesador
at8086 = UnMicroprocesador {
    acumuladorA = 0, 
    acumuladorB = 0, 
    programCounter = 0, 
    mensajeError = "", 
    memoriaPrograma = [], 
    memoria = [1..20]}

fp20 :: Microprocesador
fp20 = UnMicroprocesador {
    acumuladorA = 7, 
    acumuladorB = 24, 
    programCounter = 0, 
    mensajeError = "", 
    memoriaPrograma = [], 
    memoria = []}

mapMemoria :: ([Int]->[Int]) -> Instruccion
mapMemoria func micro = micro {memoria = func.memoria $ micro}
mapAcumA :: (Int->Int) -> Instruccion
mapAcumA func micro = micro {acumuladorA = func.acumuladorA $ micro}
mapAcumB :: (Int->Int) -> Instruccion
mapAcumB func micro = micro {acumuladorB = func.acumuladorB $ micro}
mapProgramCounter :: (Int->Int) -> Instruccion
mapProgramCounter func micro = micro {programCounter = func.programCounter $ micro}
mapMsjError :: (String->String) -> Instruccion
mapMsjError func micro = micro {mensajeError = func.mensajeError $ micro}
mapMemoriaPrograma :: (Programa->Programa) -> Instruccion
mapMemoriaPrograma func micro = micro {memoriaPrograma = func.memoriaPrograma $ micro}

aumentarProgramCounter :: Instruccion
aumentarProgramCounter micro = mapProgramCounter (+1) micro

nop :: Microprocesador -> Microprocesador
nop = id

hayError :: Microprocesador -> Bool
hayError = (>0).length.mensajeError

swap :: Instruccion
swap = invertirAcumuladores

invertirAcumuladores :: Instruccion
invertirAcumuladores micro = mapAcumA ((const.acumuladorB) micro).mapAcumB ((const.acumuladorA) micro) $ micro

add :: Instruccion
add micro = mapAcumB (const 0) . mapAcumA (+ acumuladorB micro) $ micro

divide :: Instruccion
divide = divisionDeAcum

divisionDeAcum :: Instruccion
divisionDeAcum (UnMicroprocesador acumA 0 pC msjErr memProg mem) = mapMsjError (const "Error: Division by Zero") (UnMicroprocesador acumA 0 pC msjErr memProg mem)
divisionDeAcum micro = mapAcumB (const 0) . mapAcumA (`div` (acumuladorB micro)) $ micro

lod :: Int -> Instruccion
lod direccion micro = mapAcumA ((const.valorDeMemEnDir direccion) micro ) $ micro

valorDeMemEnDir :: Int -> Microprocesador -> Int
valorDeMemEnDir direccion micro = (memoria micro !! (direccion-1))

str :: Int -> Int -> Instruccion
str direccion valor = mapMemoria (transformarValorDePosicionDeLista direccion valor)

transformarValorDePosicionDeLista :: Int -> Int -> [Int] -> [Int]
transformarValorDePosicionDeLista posicion valor lista = (take (posicion-1) lista) ++ [valor] ++ (drop posicion lista)

lodv :: Int -> Instruccion
lodv valor = mapAcumA (const valor)


avanza3Posiciones :: Instruccion
avanza3Posiciones = nop.nop.nop

sumar10Y22 :: Instruccion
sumar10Y22 = add.(lodv 22).swap.(lodv 10)

divide2Por0 :: Instruccion
divide2Por0 = divide.(lod 1).swap.(lod 2).(str 2 0).(str 1 2)


cargarPrograma :: Programa -> Instruccion
cargarPrograma programa = mapMemoriaPrograma (const programa)

ejecutarPrograma :: Instruccion
ejecutarPrograma micro = aplicarProgramaAMicro (memoriaPrograma micro) micro 

aplicarProgramaAMicro :: Programa -> Instruccion
aplicarProgramaAMicro programa micro = foldl aplicarValorSiNoHayError micro programa

aplicarValorSiNoHayError :: Microprocesador -> Instruccion -> Microprocesador
aplicarValorSiNoHayError micro func 
    | mensajeError micro == "" = aumentarProgramCounter.func $ micro
    | otherwise = micro

ifnz :: Programa -> Instruccion
ifnz programa micro 
    | acumuladorA micro == 0 = micro
    | otherwise = aplicarProgramaAMicro programa micro

depurarPrograma :: Instruccion
depurarPrograma micro = mapMemoriaPrograma (limpiarInstruccionesQueNoModifican micro) micro

limpiarInstruccionesQueNoModifican :: Microprocesador -> Programa -> Programa
limpiarInstruccionesQueNoModifican micro programa
    | null programa = []
    | acumuladoresYMemoriaEnCero.(head programa) $ micro = limpiarInstruccionesQueNoModifican micro (tail programa)
    | otherwise = [head programa] ++ limpiarInstruccionesQueNoModifican micro (tail programa)

acumuladoresYMemoriaEnCero :: Microprocesador -> Bool
acumuladoresYMemoriaEnCero micro = (acumuladorA micro == 0) && (acumuladorB micro == 0) && (all (==0) (memoria micro))

memoriaOrdenada :: Microprocesador -> Bool
memoriaOrdenada micro = listaEstaOrdenada.memoria $ micro

listaEstaOrdenada :: [Int] -> Bool
listaEstaOrdenada [] = True
listaEstaOrdenada [_] = True
listaEstaOrdenada (x:y:xs) = x <= y && listaEstaOrdenada (y:xs)

microDesorden :: Microprocesador
microDesorden = UnMicroprocesador {
    acumuladorA=0, 
    acumuladorB=0, 
    programCounter=0, 
    mensajeError= "", 
    memoriaPrograma = [], 
    memoria = [2,5,1,0,6,9]
}

microMemoriaInf :: Microprocesador
microMemoriaInf = UnMicroprocesador {
    acumuladorA = 0, 
    acumuladorB = 0, 
    programCounter = 0, 
    mensajeError = "", 
    memoriaPrograma = [],
    memoria = [0, 0..]
} 

{-
●	¿Qué sucede al querer cargar y ejecutar el programa que suma 10 y 22 en el procesador con memoria infinita?

    La suma entre 10 y 22 se ejecuta sin problemas y su resultado nos da 32 en el Acumulador A
    Pero al mostrar el micro después de la suma, no terminará de mostrar el micro completo
    ya que su memoria es infinita.

●	¿Y si queremos saber si la memoria está ordenada (punto anterior)?

    No se terminará de ejecutar la función porque estará infinitamente intentando
    comparar si cada elemento de la lista es <= que el siguiente, como en este caso,
    todos los valores son 0, entonces siempre estará cumpliendo el orden.
    Pero si en algún punto la lista no estuviera ordenada, la funcion
    frenaría y devolvería un False, sin seguir comparando los elementos siguientes.

●	Relacione lo que pasa con el concepto y justifique.

    Este funcionamiento especial se debe a que Haskell trabaja en un modo llamado
    Lazy Evaluation. Lo que significa es que no se evalúa una expresion hasta
    que se nesecite su valor. 
    Esto hace que cuando hacemos Sumar 10 y 22, como solo debe trabajar con los acumuladores,
    no se fija si la memoria del micro es finita o infinita, y por eso se puede ejecutar
    normalmente la suma; el problema recién aparece al intentar mostrar al micro por consola
    donde debe mostrar su memoria infinita, lo que nunca terminará de hacer.
    El caso con la funcion memoriaOrdenada es que la funcion compara si se cumple el orden
    entre los elementos de la memoria, hasta que halla 1 caso en el que no se cumpla.
    Es por eso que si la memoria es infinita pero no está ordenada, la funcion devuelve Falso.
    Pero en el caso de que sí esté ordenada, seguirá evaluando el orden
    elementos a elementos infinitamente para los infinitos elementos.
-}
