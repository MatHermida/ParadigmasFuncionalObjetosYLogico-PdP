object burns {
	var varillasUranio
	
	method varillasUranio(unasVarillasUranio){
		varillasUranio = unasVarillasUranio
	}
	
	method produccionEnergetica(riquezaSuelo, velocidadViento){
		return 0.1 * varillasUranio
	}
	
	method esContaminante(){
		return varillasUranio > 20
	}
}

object exBosque {
	var capacidad
	
	method capacidad(unaCapacidad){
		capacidad = unaCapacidad
	}
	
	method produccionEnergetica(riquezaSuelo, velocidadViento){
		return 0.5 + capacidad * riquezaSuelo
	}
	
	method esContaminante(){
		return true
	}
}

object elSuspiro {
	var turbinas = 1
	
	method construirTurbina(cantidad){
		turbinas += cantidad
	}
	
	method produccionEnergetica(riquezaSuelo, velocidadViento){
		return 0.2 * velocidadViento * turbinas
	}
	
	method esContaminante(){
		return false
	}
}

object centralHidroelectrica {
	method produccionEnergetica(caudal){
		return 2 * caudal
	}
}
