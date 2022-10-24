package proyecto;

import java.util.ArrayList;

public class AnalizadorLexico {
	// lista de tokens
	static ArrayList<Token> tokens = new ArrayList<Token>();
	static ArrayList<String> lineas = new ArrayList<String>();
	LectorFichero lector = new LectorFichero();
	
	

	public AnalizadorLexico(String fileName) {
		lineas = lector.readFile("prueba.txt");
		tokens = identificarTokens();
	}
	
	//ArrayList<String> lineas, int punteroPrograma
	public static ArrayList<Token> identificarTokens() {
		ArrayList<Token> listaTokens = new ArrayList<>();
		Token token = new Token();
		boolean esblanco = false;
		int j = 0; //para leer linea a linea
		//lineas.size()
		while(j < lineas.size()) {
			int punteroLinea = 0;
			String linea = lineas.get(j);
			while(punteroLinea < linea.length()) {
				//si es un espacio en blanco
				    if((int)linea.charAt(punteroLinea) ==32) {
				    	esblanco = true;
				    }
				    else {
				    	esblanco = false;
				    }
					Caracter a = new Caracter(linea.charAt(punteroLinea));
				    token = transicionar(token,a);
				    if(token.getGenerado() == true) {
				    	Token aux = new Token();
				    	aux.setEstado(token.getEstado());
				    	aux.setGenerado(token.getGenerado());
				    	aux.setTipo(token.getTipo());
				    	aux.setValor(token.getValor());
				    	if(token.getDesplazamientoExtra() == 1) {
				    		punteroLinea++;
				    	}
				    	if(!token.esPalReservada()) {
					    	listaTokens.add(aux);
				    	}
				    	token.setEstado(0);
				    	token.setGenerado(false);
				    	token.setTipo("");
				    	token.setValor("");
				    	token.setDesplazamientoExtra(0);
				    	token.setEsComentario(false);
				    	if(aux.getEsComentario()) {
				    		break;
				    	}
				    	if(esblanco == false) {
				    		punteroLinea--;
				    	}
				    	
				    }
				punteroLinea++;
			}
			j++;
			
			
		}
		
		
		return listaTokens;

	}

	private static Token transicionar(Token token, Caracter a) {
		String valor = token.valor;
		if (token.estado == 0) {
			if (a.esDigito()) {
				token.setEstado(1);
				token.setValor(valor + a.getCaracter());
			} else if (a.esLetra()) {
				token.setEstado(2);
				token.setValor(valor + a.getCaracter());
			} else if (a.esComilla()) {
				token.setEstado(3);
				token.setValor(valor + '"');
			} else if (a.esSuma()) {
				token.setEstado(4);
				token.setValor(valor + a.getCaracter());
			} else if (a.esIgual()) {
				token.setEstado(5);
				token.setValor(valor + a.getCaracter());
			} else if (a.esAnd()) {
				token.setEstado(6);
				token.setValor(valor + a.getCaracter());
			} else if (a.esBarra()) {
				token.setEstado(7);
				token.setValor(valor + a.getCaracter());
			} else if (a.esParI()) {                
				token.setEstado(17);
				token.setValor(valor + a.getCaracter());
				token.setTipo("partI");
			} else if (a.esParD()) {
				token.setEstado(18);
				token.setValor(valor + a.getCaracter());
				token.setTipo("partD");
			} else if (a.esCorchI()) {
				token.setEstado(19);
				token.setValor(valor + a.getCaracter());
				token.setTipo("corchI");
			} else if (a.esCorchD()) {
				token.setEstado(20);
				token.setValor(valor + a.getCaracter());
				token.setTipo("corchD");
			} else if (a.esComa()) {
				token.setEstado(21);
				token.setValor(valor + a.getCaracter());
				token.setTipo("coma");
			} else if (a.esPtoComa()) {
				token.setEstado(22);
				token.setValor(valor + a.getCaracter());
				token.setTipo("PtoComa");
			} else if (a.esMayor()) {
				token.setEstado(23);
				token.setValor(valor + a.getCaracter());
				token.setTipo("mayor");
			} 
		} else if (token.esTerminal()) {
			token.setGenerado(true);
		} else {
			int state = token.estado;
			switch (state) {
			case 1:
				if (a.esDigito()) {
					token.setValor(valor + a.getCaracter());
				} else {
					token.setEstado(9);
					token.setTipo("cteEntera");
					token.setGenerado(true);
				}
				break;

			case 2:
				if (a.esLetra() || a.esDigito()) {
					token.setValor(valor + a.getCaracter());
				} else {
					token.setEstado(10);
					token.setTipo("identificador");
					token.setGenerado(true);
				}
				break;

			case 3:
				if(!a.esComilla()){
					token.setValor(valor + a.getCaracter());
				}
				else{
					token.setEstado(11);
					token.setTipo("cadena");
					token.setValor(valor + '"');
					token.setGenerado(true);
				}
				break;
			
			case 4:
				if(a.esIgual()){
					token.setEstado(12);
					token.setValor(valor + a.getCaracter());
					token.setTipo("asigSuma");
					token.setGenerado(true);
					token.setDesplazamientoExtra(1);
					//ASIGSUMA
				}
				else{
					token.setEstado(13);
					token.setTipo("suma");
					token.setGenerado(true);
					//SUMA
				}
				break;

			case 5:
				if(a.esIgual()){
					token.setEstado(14);
					token.setValor(valor + a.getCaracter());
					token.setTipo("equals");
					token.setGenerado(true);
					token.setDesplazamientoExtra(1);
					//EQUALS
				}
				else{
					token.setEstado(15);
					token.setTipo("igual");
					token.setGenerado(true);
					 //IGUAL
				}
				break;
			
			case 6:
				if(a.esAnd()){
					token.setEstado(16);
					token.setValor(valor + a.getCaracter());
					token.setTipo("and");
					token.setGenerado(true);
					token.setDesplazamientoExtra(1);
					//AND
				}
				break;
			
			case 7:
				if(a.esBarra()){
					token.setEstado(0);
					token.setValor(valor + a.getCaracter());
					token.setTipo("Comentario");
					token.setGenerado(true);
					token.setEsComentario(true);
				}
				break;
			}
		}
		return token;
	}
	
}
