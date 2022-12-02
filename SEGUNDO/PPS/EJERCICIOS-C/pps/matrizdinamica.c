#include <stdio.h>
#include <stdlib.h>

int main(int argc,  char *argv[]){
    long int n,m,nfilas,ncolumnas,**matriz;
    char *one,*two;
    one=argv[1];
    two=argv[2];
    nfilas=atoi(one);
    ncolumnas=atoi(two);
    matriz=(long int **)malloc(nfilas*sizeof(long int *));

    if(matriz==NULL){
        exit(71);
    } 
    if(argc != 3){
        exit(71);
    }

    for(n=0;n<nfilas;n++){
        matriz[n]=(long int*)malloc(ncolumnas*sizeof(long int));
    }
    for(n=0;n<nfilas;n++){
        for(m=0;m<ncolumnas;m++){
            if(n==0 || m==0){
                matriz[n][m]=1;
            }
            else{
                matriz[n][m]=matriz[n-1][m]+matriz[n][m-1];
            }
        }
    }

    for(n=0;n<nfilas;n++){
        for(m=0;m<ncolumnas;m++){
            if(m==ncolumnas-1){
                printf("%li\n",matriz[n][m]);
            }
            else{
                printf("%li\t",matriz[n][m]);
            }
        }
    }

    for(n=0;n<nfilas;n++){
        free(matriz[n]);
    }
    free(matriz);
    return 0;
}