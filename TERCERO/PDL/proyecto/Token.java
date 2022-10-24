package proyecto;


public class Token {
    
	String valor;
	int estado;
	String tipo;
	boolean generado;
	int desplazamientoExtra;
	boolean esComentario;
	
	public Token() {
		this.valor = "";
		this.estado = 0;
		this.tipo = "";
		this.generado = false;
		this.desplazamientoExtra = 0;
		this.esComentario = false;
		
	}

	public String getValor() {
		return valor;
	}

	public void setValor(String valor) {
		this.valor = valor;
	}
	
	

	public int getEstado() {
		return estado;
	}

	public void setEstado(int estado) {
		this.estado = estado;
	}
	
	public String getTipo() {
		return tipo;
	}

	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	
	public boolean getGenerado() {
		return generado;
	}

	public void setGenerado(boolean generado) {
		this.generado = generado;
	}
	
	public int getDesplazamientoExtra() {
		return desplazamientoExtra;
	}

	public void setDesplazamientoExtra(int desplazamientoExtra) {
		this.desplazamientoExtra = desplazamientoExtra;
	}
	
	public boolean getEsComentario() {
		return esComentario;
	}

	public void setEsComentario(boolean esComentario) {
		this.esComentario = esComentario;
	}
	
	 public boolean esTerminal() {
    	if(estado >= 9 && estado <= 23){
    		 return true;
    	 }
    	 return false;
    	 
     }
	
	public boolean esPalReservada() {
		String[] reservadas = {"boolean","function","if","input","int","let","print","return","string","while"};
		for(int i = 0; i < reservadas.length; i++) {
			if(reservadas[i].equals(valor)) {
				return true;
			}
		}
		return false;
	}
	
}
