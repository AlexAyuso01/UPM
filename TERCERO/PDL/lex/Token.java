package lex;
public class Token {

    private Tipos tipo;
    private String valor;

    public Tipos getTipos() {
        return tipo;
    }
    public void setTipos(Tipos tipo) {
        this.tipo = tipo;
    }
    public String getValor() {
        return valor;
    }
    public void setValor(String valor) {
        this.valor = valor;
    }
    enum Tipos {
        NUMERO ("[0-9]+"),
        OPERADOR_BINARIO("[+|=|&|>]");
        private final String patron;
        Tipos(String patron) {
            this.patron = patron;
        }
    }
}
