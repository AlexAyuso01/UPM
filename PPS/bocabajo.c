#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "auxiliar.h"

        void AuxFunct(void){
                fputs("bocabajo: Uso: bocabajo [ fichero... ]\n",stdout);
                fputs("bocabajo: Invierte el orden de las lineas de los ficheros (o de la entrada).\n",stdout);
                exit(EX_OK);
        }
        void increase (int *pint);

int main(int argc, char *argv[]){

        argv0="bocabajo";
        char **rowpointer;
        int n=0;
        char MAXROWS[2049];
        FILE *fil;


        if(argc==2 && (strcmp(argv[1],"-h")==0 || strcmp(argv[1],"--help")==0)){
                AuxFunct();
        }



        else if(argc<2){
                rowpointer=malloc(sizeof(char*));
                while(fgets(MAXROWS, sizeof MAXROWS, stdin)!= NULL){
                        increase(&n);
                        rowpointer=realloc(rowpointer, (sizeof(char *))*(n+1));
                        if (rowpointer==NULL){
                                Error(EX_OSERR, "No se pudo ubicar la memoria dinámica necesaria.");
                        }
                        rowpointer[n]=strdup(MAXROWS);
                }
                while(n>=1){
                        printf("%s",rowpointer[n]);
                        n--;
                }
                free(rowpointer);
                exit(0);
        }


        int i=1;
        rowpointer=malloc(sizeof(char*)*(n+1));
        while(argv[i]!=NULL){
                char MAXROWS[2049];
                fil=fopen(argv[i],"r");
                if(fil!=NULL){
                        while(fgets(MAXROWS,sizeof MAXROWS, fil)!=NULL){
                                increase(&n);
                                rowpointer=realloc(rowpointer,(sizeof(char *))*(n+1));
                                if (rowpointer==NULL){
                                        Error(EX_OSERR, "No se pudo ubicar la memoria dinámica necesaria.");
                                }
                                rowpointer[n]=strdup(MAXROWS);
                        }
                fclose(fil);
                increase(&i);

                }

                else{
                        Error(EX_NOINPUT, "El fichero \%s\" no puede ser leido.",argv[i]);
                }
        }
        while(n>=1){
                printf("%s",rowpointer[n]);
                char *tmp=rowpointer[n];
                if(tmp[strlen(tmp)-1]!='\n'){
                        printf("\n");
                }
                n--;
        }
        free(rowpointer);
        exit(0);
}
        void increase (int *pint){
                (*pint)++;
        }
                                                                                                                                                                                                  83,9          Bot


