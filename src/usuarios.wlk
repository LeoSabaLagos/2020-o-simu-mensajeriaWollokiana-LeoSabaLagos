import mensajes.*
import chats.*
import notificaciones.*

class Usuario {
	// los usuarios tienen una memoria que se va llenando con cada mensaje
	var espacio
	
	var chatsEnLosQueParticipa = #{}
	
	// Punto 5
	var notificaciones = []
	
	method tieneEspacioPara(mensaje) = espacio >= mensaje.pesoTotal()
	
	method guardarMensaje(mensaje,chat){
		self.reducirEspacio(mensaje)
		chatsEnLosQueParticipa.add(chat)
	}
	
	method reducirEspacio(mensaje){
		espacio = (espacio - mensaje.pesoTotal()).max(0)
	}
	
	// Lo hago para el test
	method espacio() = espacio
	
	// Punto 2
	// Enviar un mensaje a un chat considerando los tipos de chats y las restricciones que tienen.
	method enviar(mensaje,chat){
		chat.validarEnvio(mensaje)
	}
	
	// Punto 3
	// Hacer una búsqueda de un texto en los chats de un usuario. 
	method buscarTexto(texto) = chatsEnLosQueParticipa.filter({ chat => chat.algunMensajeContiene(texto) })
	// La búsqueda obtiene como resultado los chats que tengan algún mensaje con ese texto. 
	
	
	// Punto 4
	// Dado un usuario, conocer sus mensajes más pesados. Que es el conjunto formado por el mensaje más pesado de cada uno de sus chat.
	method mensajesMasPesados() = chatsEnLosQueParticipa.map({ chat => chat.mensajeMasPesado() })
	
	// Punto 5a
	method recibirNotificacion(chat){
		notificaciones.add( new Notificacion(chatCorrespondiente = chat) )
	}
	
	// Punto 5b
	method leerUnChat(chat){
		notificaciones.forEach({ notificacion => notificacion.correspondeAlChat(chat) })
	}
	
	// Punto 5c
	method notificacionesSinLeer() = notificaciones.filter({ notificacion => notificacion.estaLeida() })
}
