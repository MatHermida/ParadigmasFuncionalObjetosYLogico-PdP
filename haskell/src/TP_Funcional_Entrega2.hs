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
nop micro
    | hayError micro = micro
    | otherwise = aumentarProgramCounter micro

hayError :: Microprocesador -> Bool
hayError = (>0).length.mensajeError

swap :: Instruccion
swap = aumentarProgramCounter.invertirAcumuladores

invertirAcumuladores :: Instruccion
invertirAcumuladores micro = micro {acumuladorA = acumuladorB micro, acumuladorB = acumuladorA micro}

add :: Instruccion
add micro = aumentarProgramCounter . mapAcumB (const 0) . mapAcumA (+ acumuladorB micro) $ micro

divide :: Instruccion
divide micro = aumentarProgramCounter.divisionDeAcum $ micro

divisionDeAcum :: Instruccion
divisionDeAcum micro
    | acumuladorB micro == 0 = mapMsjError (const "Error: Division by Zero") micro
    | otherwise = mapAcumB (const 0) . mapAcumA (flip div (acumuladorB micro)) $ micro

lod :: Int -> Instruccion
lod direccion micro = aumentarProgramCounter.mapAcumA (const (memoria micro !! (direccion-1))) $ micro

str :: Int -> Int -> Instruccion
str direccion valor = aumentarProgramCounter.mapMemoria (transformarValorDePosicionDeLista direccion valor)

transformarValorDePosicionDeLista :: Int -> Int -> [Int] -> [Int]
transformarValorDePosicionDeLista posicion valor lista = (take (posicion-1) lista) ++ [valor] ++ (drop posicion lista)

lodv :: Int -> Instruccion
lodv valor = aumentarProgramCounter.mapAcumA (const valor)


avanza3Posiciones :: Instruccion
avanza3Posiciones = nop.nop.nop

sumar10Y22 :: Instruccion
sumar10Y22 = add.(lodv 22).swap.(lodv 10)

divide2Por0 :: Instruccion
divide2Por0 = divide.(lod 1).swap.(lod 2).(str 2 0).(str 1 2)


cargarPrograma :: Programa -> Instruccion
cargarPrograma listaInstrucciones = mapMemoriaPrograma (const listaInstrucciones)



ejecutarPrograma :: Instruccion
ejecutarPrograma micro = aplicarListaDeInstruccionesAMicro (memoriaPrograma micro) micro 

aplicarListaDeInstruccionesAMicro :: Programa -> Instruccion
aplicarListaDeInstruccionesAMicro listaInstrucciones micro = foldr aplicarValorSiNoHayError micro (reverse listaInstrucciones)
--aplicarListaDeInstruccionesAMicro listaInstrucciones micro = foldl (flip ($)) micro listaInstrucciones

aplicarValorSiNoHayError :: Instruccion -> Instruccion
aplicarValorSiNoHayError func micro 
    | mensajeError micro == "" = func $ micro
    | otherwise = micro

ifnz :: Programa -> Instruccion
ifnz listaInstrucciones micro 
    | acumuladorA micro == 0 = micro
    | otherwise = aplicarListaDeInstruccionesAMicro listaInstrucciones micro
