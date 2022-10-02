class Alimento {
	var property peso
	var posicion
	
	method posicion() {
		return posicion
	}
	method cantMaxPosibleDeExtraer() {
		return (peso - 1).max(0)
	}
	method extraerAlimento(cantAExtraer) {
		peso -= (cantAExtraer + 1)	
	}
	
}
