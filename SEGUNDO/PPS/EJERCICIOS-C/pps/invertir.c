#include <stdio.h>
#include <stdlib.h>

#define M 1000 

int main(int argc, char ** argv){
    FILE *f;
    char espacio = ' ',a;
    int cadena1[M], cadena2[M],err[M] ;
    f = fopen("numeros.txt","r");
    if(f == NULL){
        printf("No such file\n");
        exit(0);
    }
    int n = 0;
    int ok = 0;
    //printf("%d\n",n);
    while(!feof(f)){
        ok = fscanf(f,"%d",&cadena1[n]);
        cadena2[n] = cadena1[n];   
        fgetc(f);
        n++;
    }
    //printf("%d",cadena2[0]);
    int m = n-1;
    int j = 0;
    int nzeros = 0;
    while(m >= j){
        if (cadena2[j] == 0 && nzeros == 0){
            printf("\n");
            j++; 
            nzeros++;
        }
        else if (nzeros == 1 && cadena1[j+1] != 0){
            nzeros = 0;   
        } else if(cadena2[j] == 0){
            j++;
        } else {
            printf("%d ",cadena2[j]);
            j++;
        }
    }
    fclose(f);
    return(0);
}