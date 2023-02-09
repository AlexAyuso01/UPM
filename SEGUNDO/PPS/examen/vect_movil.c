#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "movil.h"
#include "vect_movil.h"

/*
 * Partiendo de las especificaciones de terminales en el
 * argumento vmov la función crea terminales manteniendo
 * en memoria, simultáneamente, un máximo de n
 * Si no hubo error, invoca la función toString() para
 * mostrar en la salida estándar los n últimos terminales
 * Antes de terminar, libera toda la memoria reservada
 * Devuelve NOMEM si no hay suficiente memoria
 * En caso contrario, devuelve OK
 */
int vect_movil(int n, const char *sfmt[], const char *vmov[NM][NC]) {
    int i, j;
    char *mstr;
    movil_t *pmov;
    i = 0;
    j = 0;
    pmov = malloc(sizeof(movil_t)*n);
    while (i < n){
        while (j < NC){
        if (vmov[i][j] == NULL){
            j++;
            }
            else{
                pmov = new_movil(vmov[i][j], vmov[i][j+1], vmov[i][j+2], atoi(vmov[i][j+3]), atof(vmov[i][j+4]), atoi(vmov[i][j+5]));
                if (pmov == NULL){
                    return NOMEM;
                }
                else{
                    mstr = toString(pmov, sfmt, mstr);
                    if (mstr == NULL){
                        return NOMEM;
                    }
                    else{
                        printf("%s", mstr);
                        free(mstr);
                    }
                }
                j = j + 6;
            }
        }
        i++;
    }
    free(pmov);
    return OK;
}

