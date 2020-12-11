class Mensaje {
	// De los mensajes es importante saber qué usuario lo envió
	var usuarioEmisor
	
	method usuarioEmisor() = usuarioEmisor
	
	// y cuántos KB pesa. El peso de un mensaje siempre se calcula como:
		// 5 (datos fijos de transferencia) + peso del contenido * 1,3 (factor de la red)
		
	method pesoTotal() = 5 + self.pesoDelContenido() * 1.3
	
	method pesoDelContenido()
	
	method superaPeso(pesoMaximo) = self.pesoTotal() > pesoMaximo
	
	// Punto 3
	// Un mensaje contiene un texto si es parte del nombre de quien lo envía, 
	// si es parte del texto del mensaje
	// o del nombre del contacto enviado
	
	method contiene(texto) = usuarioEmisor.contains(texto)
}

// Un mensaje puede tener varios tipos de contenido (cada mensaje tiene uno), describimos algunos de ellos:

class Texto inherits Mensaje {
	// Texto: Sirven para enviar texto
	var textoAEnviar
	
	//su peso es de 1KB por caracter.
	override method pesoDelContenido() = textoAEnviar.size() * 1
	
	// Punto 3
	// contiene el texto si es parte del texto del mensaje
	
	override method contiene(texto) = super(texto) or textoAEnviar.contains(texto)
}

class Audio inherits Mensaje {
	// Audio: Su peso depende de la duración del mismo. 1 segundo de audio pesa 1.2 KB.
	var duracion
	
	override method pesoDelContenido() = duracion * 1.2
}


class Contacto inherits Mensaje {
	// 	Contacto: Se debe saber qué usuario se envía y el peso de estos contenidos es siempre 3 KB.
	var contactoEnviado 
	
	override method pesoDelContenido() = 3
	
	// Punto 3
	// Contiene el texto si es parte del nombre del contacto enviado
	override method contiene(texto) = super(texto) or contactoEnviado.contains(texto) 
}

class Imagen inherits Mensaje {
	// De las imágenes conocemos su alto y ancho, medido en pixeles (entonces la cantidad total de píxeles es ancho x alto)
	var alto 
	var ancho 
	
	// El peso de estos mensajes depende del modo de compresión:
	
	var modoCompresion
	
	override method pesoDelContenido() = modoCompresion.realizarCompresion(alto * ancho) * 2  // se considera que un pixel pesa 2KB.
	
}

class Gif inherits Imagen {
	// También se pueden enviar GIFs, que son como cualquier imagen pero además se conoce la cantidad de cuadros que tiene. 
	var cantCuadros
	
	// El peso de estas imágenes es como una imagen normal de las mismas características multiplicada por la cantidad de cuadros del GIF.
	override method pesoDelContenido() = super() * cantCuadros
}

///// MODOS DE COMPRESION /// 

object original {
	// Compresión original: no tiene compresión, se envían todos los pixeles.
	method realizarCompresion(cantPixeles) = cantPixeles
}

class Variable {
	// Compresión variable: se elige un porcentaje de compresión distinto para cada imagen que determina la cantidad de pixeles del mensaje original que se van a enviar.
	var porcentaje
	
	method realizarCompresion(cantPixeles) = (porcentaje/100) * cantPixeles
}

object maxima{
	// Compresión máxima: se envía hasta un máximo de 10.000 píxeles. Si la imagen ocupa menos que eso se envían todos, sino se reduce hasta dicho máximo.
	method realizarCompresion(cantPixeles) = cantPixeles.min(10000)
}









