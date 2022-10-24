
object langosta {
	const vidaMax = 50
	var vida = vidaMax
	var property ubicacionActual = [0,0]
		
	method vida() {
		return vida
	}
	
	method cantidadDanio() {
		return 10
	}
	
	method atacar(unBicho) {
		unBicho.recibirAtaqueDe(self)
	}
	
	method recibirAtaqueDe(unBicho) {
		vida = 0.max(vida - unBicho.cantidadDanio())
		self.atacar(unBicho)
	}
	
	method recibioDanio() {
		return vida < vidaMax
	}
}
