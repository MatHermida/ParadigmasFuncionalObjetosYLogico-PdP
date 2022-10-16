object cansada {
	method cantidadMaximaDeAlimento() {
		return normal.cantidadMaximaDeAlimento()
	}
	
	method obtenerAlimentoDe(hormiga, alimento) {}
}

object normal {
	method cantidadMaximaDeAlimento() {
		return 10
	}
	method obtenerAlimentoDe(hormiga, alimento) {
		hormiga.desplazarseA(alimento.posicion())
		hormiga.extraerAlimentoDe(alimento)
	}
}

object exaltada {
	method cantidadMaximaDeAlimento() {
		return normal.cantidadMaximaDeAlimento() * 2
	}
	method obtenerAlimentoDe(hormiga, alimento) {
		normal.obtenerAlimentoDe(hormiga, alimento)
	}
}