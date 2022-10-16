import centrales.*

object springfield {
	const velocidadViento = 10
	const riquezaSuelo = 0.9
	var necesidadEnergetica = 0
	var centrales = #{}

	method necesidadEnergetica(unaNecesidadEnergetica){
		necesidadEnergetica = unaNecesidadEnergetica
	}
	method centrales(unasCentrales){
		centrales = unasCentrales
	}

	method produccionEnergDeCentral(central) {
		if (centrales.contains(central)) {
			return central.produccionEnergetica(riquezaSuelo, velocidadViento)
		} else {
			return 0
		}
	}

	method centralesContaminantes() {
		return centrales.filter({ central => central.esContaminante() })
	}

	method cubrioNecesidadEnergetica() {
		return centrales.sum({central => self.produccionEnergDeCentral(central)}) >= necesidadEnergetica
	}

	method estaAlHorno() {
		return self.centralesContaminantes().sum({central => self.produccionEnergDeCentral(central)}) >= necesidadEnergetica * 0.5 or centrales.all({central => central.esContaminante()})
	}
	
	method centralMasProductora(){
		return centrales.max({central => self.produccionEnergDeCentral(central)})
	}
}

object albuquerque {
	const caudalRio = 150
	var central = centralHidroelectrica
	
	method centralMasProductora(){
		return central
	}
	
	method produccionEnergDeCentral() {
		return central.produccionEnergetica(caudalRio)
	}
}


object region {
	var ciudades = #{}
	
	method agregarCiudad(unaCiudad){
	  ciudades.add(unaCiudad)
    }
    
	method centralesMasProductoras(){
		return ciudades.map({ciudad => ciudad.centralMasProductora()}).asSet()
	}
}

