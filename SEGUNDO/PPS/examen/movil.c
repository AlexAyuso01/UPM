#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "movil.h"

/*
 * Crea dato movil_t y copia los argumentos en la nueva estructura
 * Si no hay memoria devuelve NULL
 * En caso contrario, devuelve la dirección del móvil creado
 */
movil_t *new_movil(const char *imei, const char *modelo, const char *ram, int bat, double pvp, int sspec) {
    movil_t *new_movil = NULL;
    strcpy(new_movil->imei,imei);
    strcpy(new_movil->modelo,modelo);
    strcpy(new_movil->ram,ram);
    new_movil->bat = bat;
    new_movil->pvp = pvp;
    new_movil->sspec = sspec;
    return new_movil;
}

/*
 * Elimina el móvil en la dirección pm
 * Libera toda la memoria ocupada el móvil
 */
void del_movil(movil_t *pm) {
    free(pm);
}

/*
 * Esta función convierte el terminal en pmov a un string
 * Requiere como argumentos la dirección del terminal
 * y un array de cadenas de formateo del string resultante
 * https://www.cprogramming.com/tutorial/printf-format-strings.html
 * La función devuelve la dirección de un string acorde
 * con los códigos de formato en el segundo argumento
 * Para hacer la conversión invoca la llamada
 * sprintf() sobre el buffer en la dirección mstr
 * Si la cadena de formateo es NULL el campo se ignora
 * Al terminar la conversión invoca realloc() para reasignar
 * mstr a fin de que ocupe la memoria estrictamente necesaria
 * Devuelve NULL si no hay memoria
 * En caso contrario, devuelve la dirección del string
 */
char *toString(movil_t *pmov, const char *sfmt[], char *mstr)
{
    char *imei = "";
    char *modelo = "";
    char *ram = "";
    int bat;
    int sspec;
    int i;
    double pvp;
    
    strcpy(imei, pmov->imei);
    strcpy(modelo, pmov->modelo);
    strcpy(ram, pmov->ram);
    bat = pmov->bat;
    pvp = pmov->pvp;
    sspec = pmov->sspec;
    i = 0;
    while (i < 6){
        if (sfmt[i] == NULL){

        } else {
            if (i == 0){
                sprintf(mstr, sfmt[0], imei);
            } 
            else if (i == 1){
                sprintf(mstr, sfmt[1], modelo);
            }
            else if (i == 2){
                sprintf(mstr, sfmt[2], ram);
            }
            else if (i == 3){
                sprintf(mstr, sfmt[3], bat);
            }
            else if (i == 4){
                sprintf(mstr, sfmt[4], pvp);
            }
            else {
                sprintf(mstr, sfmt[5], sspec);
            }
        }
        ++i;
    }
    if (strlen(mstr) < 2500){
        mstr = realloc(mstr, strlen(mstr)+1);
    }
    return mstr;
}
