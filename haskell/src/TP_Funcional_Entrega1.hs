data Microprocesador = UnMicroprocesador {
    memoria :: [Int],
    acumuladorA :: Int,
    acumuladorB :: Int,
    programCounter :: Int,
    mensajeError :: String
} deriving Show

xt8088 :: Microprocesador
xt8088 = UnMicroprocesador {memoria = replicate 1024 0, acumuladorA=0, acumuladorB=0, programCounter=0, mensajeError= ""} 

at8086 :: Microprocesador
at8086 = UnMicroprocesador {memoria = [1..20], acumuladorA = 0, acumuladorB = 0, programCounter = 0, mensajeError = ""}

fp20 :: Microprocesador
fp20 = UnMicroprocesador {memoria = [], acumuladorA = 7, acumuladorB = 24, programCounter = 0, mensajeError = ""}

mapMemoria :: ([Int]->[Int]) -> Microprocesador -> Microprocesador
mapMemoria func micro = micro {memoria = func.memoria $ micro}
mapAcumA :: (Int->Int) -> Microprocesador -> Microprocesador
mapAcumA func micro = micro {acumuladorA = func.acumuladorA $ micro}
mapAcumB :: (Int->Int) -> Microprocesador -> Microprocesador
mapAcumB func micro = micro {acumuladorB = func.acumuladorB $ micro}
mapProgramCounter :: (Int->Int) -> Microprocesador -> Microprocesador
mapProgramCounter func micro = micro {programCounter = func.programCounter $ micro}
mapMsjError :: (String->String) -> Microprocesador -> Microprocesador
mapMsjError func micro = micro {mensajeError = func.mensajeError $ micro}

aumentarProgramCounter :: Microprocesador -> Microprocesador
aumentarProgramCounter micro = mapProgramCounter (+1) micro

nop :: Microprocesador -> Microprocesador
nop = aumentarProgramCounter

swap :: Microprocesador -> Microprocesador
swap = aumentarProgramCounter.invertirAcumuladores

invertirAcumuladores :: Microprocesador -> Microprocesador
invertirAcumuladores micro = micro {acumuladorA = acumuladorB micro, acumuladorB = acumuladorA micro}

add :: Microprocesador -> Microprocesador
add micro = aumentarProgramCounter . mapAcumB (const 0) . mapAcumA (+ acumuladorB micro) $ micro

divide :: Microprocesador -> Microprocesador
divide micro = aumentarProgramCounter.divisionDeAcum $ micro

divisionDeAcum :: Microprocesador -> Microprocesador
divisionDeAcum micro
    | acumuladorB micro == 0 = mapMsjError (const "Error: Division by Zero") micro
    | otherwise = mapAcumB (const 0) . mapAcumA (flip div (acumuladorB micro)) $ micro

lod :: Int -> Microprocesador -> Microprocesador
lod direccion micro = aumentarProgramCounter.mapAcumA (const (memoria micro !! (direccion-1))) $ micro

str :: Int -> Int -> Microprocesador -> Microprocesador
str direccion valor = aumentarProgramCounter.mapMemoria (transformarValorDePosicionDeLista direccion valor)

transformarValorDePosicionDeLista :: Int -> Int -> [Int] -> [Int]
transformarValorDePosicionDeLista posicion valor lista = (take (posicion-1) lista) ++ [valor] ++ (drop posicion lista)

lodv :: Int -> Microprocesador -> Microprocesador
lodv valor = aumentarProgramCounter.mapAcumA (const valor)


avanza3Posiciones :: Microprocesador -> Microprocesador
avanza3Posiciones = nop.nop.nop

sumar10Y22 :: Microprocesador -> Microprocesador
sumar10Y22 = add.(lodv 22).swap.(lodv 10)

divide2Por0 :: Microprocesador -> Microprocesador
divide2Por0 = divide.(lod 1).swap.(lod 2).(str 2 0).(str 1 2)