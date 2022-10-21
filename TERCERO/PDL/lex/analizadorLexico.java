package lex;
import lex.Estado;
public class analizadorLexico<E>{
    private static Par <String,Boolean> estadoActual;
    private static String lexema;
    private static String entrada;
    private static int indice;
    private static Character caracter;
    private  Par<String,E> token;

    public Par<String, E> analisisLexico() {
        token = new Par<>("",null);
        estadoActual = Estado.e1;
        String K = "";
        caracter = getCurrentChar();
        if (caracter == null)
            caracter = readIndexFile();
        while(estadoActual != null && !estadoActual.value){
            Par<Par<String,Boolean>,String> trans = getTransicion(estadoActual,indice);
            estadoActual = trans.key;
            accionSemantica(trans.value);
        }
        if (token != null){
            System.out.println("Token: " + token.key + " Valor: " + token.value);
        }
        return token;
    }

    //function that opens a file reads the file and returns the next character to be read
    private Character getCurrentChar() {
        return null;
    }
    //function that reads a file and returns the character read in the file 
    private Character readIndexFile() {
        return null;
    }
    //function that returns the transition of the current state and the index of the character read
    private Par<Par<String, Boolean>, String> getTransicion(Par<String, Boolean> estadoActual2, int indice2) {
        return null;
    }
    //function that performs the semantic action of the transition and generates the token. 
    private void accionSemantica(String value) {
    }
}