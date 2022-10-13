#include <stdio.h>
#include <stdlib.h>

#define M 1000 

int main(int argc, char ** argv){
    FILE *f;
    char espacio = ' ',a;
    int cadena1[M], cadena2[M], result[M];
    int n = 0, ok = 0,cont = 0, i = 0, aux = 0, aux2 = 0, write = 0, wsnum = 1;
    f = fopen("numeros.txt","r");
    if(f == NULL){
        printf("No such file\n");
        exit(0);
    }
    while(!feof(f)){ //leo solo numeros
        ok = fscanf(f,"%d",&cadena1[n]);
        cadena2[n] = cadena1[n];
        if(ok == 1){
            cont++;
            result[i]=cadena2[n];
            //printf("%d\n",result[i]);
            i++;
            if (feof(f)){
                aux = i;
                aux2 = aux;
                while(aux > write){
                    aux--;
                    printf("%d ",result[aux]);
                }
                write = aux2;
                printf("\n");
            }
        } else { //leo algo que no sea un numero
            wsnum = 0;
            if(cont != 0){
                aux = i;
                aux2 = aux;
                while(aux > write){
                    aux--;
                    printf("%d ",result[aux]);
                }
                write = aux2;
                printf("\n");
                cont = 0;
            }  
        }             
        fgetc(f);
        n++;
        
    }
    if (wsnum != 0){
        printf("%d\n",wsnum);
        while(i > 0){
            i--;
            printf("%d ",result[i]);
        }
        printf("\n");
    }
    fclose(f);
    return(0);
}