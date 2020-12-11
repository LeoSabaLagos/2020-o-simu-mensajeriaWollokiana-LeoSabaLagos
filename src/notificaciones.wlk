class Notificacion {
	var chatCorrespondiente
	
	var property estaLeida = false
	
	method marcarComoLeida(){
		self.estaLeida(true)
	} 	
	
	method correspondeAlChat(chat){
		if(chat == chatCorrespondiente)
			self.estaLeida(true)
	}
}
