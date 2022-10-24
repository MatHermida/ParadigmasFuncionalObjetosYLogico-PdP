class Colonia {

	const hormiguerosYColonias = []

	method aniadirHormigueroOColonia(asentamiento) {
		hormiguerosYColonias.add(asentamiento)
	}

	method reclamarAlimento() {
		hormiguerosYColonias.forEach({ asentamiento => asentamiento.reclamarAlimento()})
	}
	
	method cantidadDeAlimentoTotal() {
		return hormiguerosYColonias.sum({ asentamiento => asentamiento.cantidadDeAlimentoTotal()})
	}

	method poblacionTotal() {
		return hormiguerosYColonias.sum({ asentamiento => asentamiento.poblacionTotal() })
	}

	method defenderseDe(unBicho) {
		hormiguerosYColonias.forEach({ asentamiento => asentamiento.defenderseDe(unBicho)})
	}

}
