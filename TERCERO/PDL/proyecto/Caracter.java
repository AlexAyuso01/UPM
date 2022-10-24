package proyecto;

public class Caracter {
     char a;
	
	
     public Caracter(char a) {
    	 this.a = a;
     }
     
     public char getCaracter() {
    	 return (char)this.a;
     }
     
     
     public boolean esDigito() {
    	 if((int)a >= 48 && (int)a <= 57) {
    		 return true;
    	 }
    	 return false;
     }
     
     public boolean esLetra() {
    	 if((int)a >= 97 && (int)a <= 122) {
    		 return true;
    	 }
    	 return false;
     }
     
     public boolean esAnd() {
    	 if((int)a == 38) {
    		 return true;
    	 }
    	 return false;
     }
     
     public boolean esComilla() {
    	 if((int)a == 39) {
    		 return true;
    	 }
    	 return false;
     }
     
     public boolean esParI() {
    	 if((int)a == 40) {
    		 return true;
    	 }
    	 return false;
     }
     
     public boolean esParD() {
    	 if((int)a == 41) {
    		 return true;
    	 }
    	 return false;
     }
     
     public boolean esSuma() {
    	 if((int)a == 43) {
    		 return true;
    	 }
    	 return false;
     }
     
     public boolean esComa() {
    	 if((int)a == 44) {
    		 return true;
    	 }
    	 return false;
     }
     
     public boolean esBarra() {
    	 if((int)a == 47) {
    		 return true;
    	 }
    	 return false;
     }
     
     public boolean esPtoComa() {
    	 if((int)a == 59) {
    		 return true;
    	 }
    	 return false;
     }
     
     
     public boolean esMayor() {
    	 if((int)a == 62) {
    		 return true;
    	 }
    	 return false;
     }
     
     public boolean esIgual() {
    	 if((int)a == 61) {
    		 return true;
    	 }
    	 return false;
     }
     
     public boolean esCorchI() {
    	 if((int)a == 123) {
    		 return true;
    	 }
    	 return false;
     }
     
     public boolean esCorchD() {
    	 if((int)a == 125) {
    		 return true;
    	 }
    	 return false;
     }
     
     
     
     
     
     
     
     
}
