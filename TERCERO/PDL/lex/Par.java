package lex;

public class Par<K,V>{
    K key;
    V value;

    public Par(K key, V value) {
        this.key = key;
        this.value = value;
    }

    @Override
    public String toString() {
        return "{" + key + ", " + value + "}";
    }
}
