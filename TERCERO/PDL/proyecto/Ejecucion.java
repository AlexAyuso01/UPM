package proyecto;

import java.util.ArrayList;

public class Ejecucion {

	
	public static void main(String[]args) {
		
		AnalizadorLexico AL = new AnalizadorLexico("prueba.txt");
		ArrayList<Token> tokens = AnalizadorLexico.tokens;
		for(int i = 0; i < tokens.size();i++) {
			System.out.println("Token " + i + ": " + tokens.get(i).getValor() + " tipo: " + tokens.get(i).getTipo());
		}
		
		
	}
}
