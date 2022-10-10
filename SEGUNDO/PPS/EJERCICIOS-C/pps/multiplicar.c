#include <stdio.h>

#define M 1000

int main(int argc, char** argv){
    int m; //filas M1
    int n; //columnas M1 y filas M2
    int p; //columnas M2    int m1[];
    int ok = 0;
    FILE * f;
    f = fopen("matrices.txt","r");
    fscanf(f, "%d %d %d", &m, &n, &p);
    int matriz1[m][n], matriz2[n][p], resultado[m][p];
    int i = 0;
    while (i < m){
        int j = 0;
        while(j < n){
            fscanf(f, "%d", &matriz1[i][j]);
            printf("%d",matriz1[i][j]);
            j++;
        }
        printf("\n");
        i++;
    }
    i = 0;
    while (i < n){
        int j = 0;
        while(j < p){
            fscanf(f, "%d", &matriz2[i][j]);
            printf("%d",matriz2[i][j]);
            j++;
        }
        printf("\n");
        i++;
    }
    //multiplicacion 
     for (int a = 0; a < p; a++) {
        // Dentro recorremos las filas de la primera (A)
        for (int i = 0; i < m; i++) {
            int suma = 0;
            // Y cada columna de la primera (A)
            for (int j = 0; j < n; j++) {
                // Multiplicamos y sumamos resultado
                suma += matriz1[i][j] * matriz2[j][a];
            }
            // Lo acomodamos dentro del producto
            resultado[i][a] = suma;
        }
    }
    printf("Imprimiendo producto\n");
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < p; j++) {
            printf("%d ", resultado[i][j]);
        }
        printf("\n");
    }


    return 0;
}