data Microprocesador = UnMicroprocesador {memoria :: [Int], acumuladorA :: Int, acumuladorB :: Int, programCounter :: Int, mensajeError :: String} deriving Show

xt8088 :: Microprocesador
xt8088 = UnMicroprocesador {memoria = replicate 1024 0, acumuladorA=0, acumuladorB=0, programCounter=0, mensajeError= ""} 

at8086 :: Microprocesador
at8086 = UnMicroprocesador {memoria = [1..20], acumuladorA = 0, acumuladorB = 0, programCounter = 0, mensajeError = ""}

fp20 :: Microprocesador
fp20 =UnMicroprocesador {memoria = [], acumuladorA = 7, acumuladorB = 24, programCounter = 0, mensajeError = ""}


aumentoProgramCounter :: Microprocesador -> Int
aumentoProgramCounter micro = programCounter micro + 1

nop :: Microprocesador -> Microprocesador
nop micro = micro {programCounter = aumentoProgramCounter micro}

swap :: Microprocesador -> Microprocesador
swap micro = micro {acumuladorA = acumuladorB micro, acumuladorB = acumuladorA micro, programCounter = aumentoProgramCounter micro}

add :: Microprocesador -> Microprocesador
add micro = micro {acumuladorA = acumuladorA micro + acumuladorB micro, acumuladorB = 0, programCounter = aumentoProgramCounter micro}

divide :: Microprocesador -> Microprocesador
divide micro | acumuladorB micro == 0 = micro {mensajeError = "Error: Division by Zero", programCounter = aumentoProgramCounter micro}
             | otherwise = micro {acumuladorA = div (acumuladorA micro) (acumuladorB micro), acumuladorB = 0, programCounter = aumentoProgramCounter micro}

lod :: Int -> Microprocesador -> Microprocesador
lod direccion micro = micro {acumuladorA = memoria micro !! (direccion-1), programCounter = aumentoProgramCounter micro}

str :: Int -> Int -> Microprocesador -> Microprocesador
str direccion valor micro = micro {memoria = reemplazaPosicionDeMemoria direccion valor (memoria micro), programCounter = aumentoProgramCounter micro}

reemplazaPosicionDeMemoria :: Int -> Int -> [Int] -> [Int]
reemplazaPosicionDeMemoria direccion valor listaMemoria = (take (direccion-1) listaMemoria) ++ [valor] ++ (drop direccion listaMemoria)

lodv :: Int -> Microprocesador -> Microprocesador
lodv valor micro = micro {acumuladorA = valor, programCounter = aumentoProgramCounter micro}


avanza3Posiciones :: Microprocesador -> Microprocesador
avanza3Posiciones micro = (nop.nop.nop) micro

sumar10Y22 :: Microprocesador -> Microprocesador
sumar10Y22 micro = (add.(lodv 22).swap.(lodv 10)) micro

divide2Por0 :: Microprocesador -> Microprocesador
divide2Por0 micro = (divide.(lod 1).swap.(lod 2).(str 2 0).(str 1 2)) micro