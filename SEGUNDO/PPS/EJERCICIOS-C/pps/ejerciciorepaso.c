#include<stdio.h>
#include<stdlib.h>

#define TAM_LINEA 1024

//retorna 1 si la linea es un comentario o esta vacia 0 si es falso 
int es_comentario_o_vacia(char* linea){
    return linea[0] == '#' || linea[0] == '\n' || linea[0] == '\0';
}

int comprobar_linea (char *linea, int nLinea){
    int ok = 1;
    if (strchr(linea,'\n') == NULL){
        ok = 0;
        fprinf(stderr, "Error: Linea %d no terminada con \\n", nLinea);
    } else if (linea[0] == ';'){
        ok = 0;
        fprintf(stderr, "Error: Linea %d no puede empezar con ;", nLinea);
    } else if (linea[0] == '\n'){
        ok = 0;
        fprintf(stderr, "Error: Linea %d no puede estar vacia", nLinea);
    } else if (linea[0] == '#'){
        ok = 0;
        fprintf(stderr, "Error: Linea %d no puede ser un comentario", nLinea);
    } else if (linea[0] == '='){
        ok = 0;
        fprintf(stderr, "Error: Linea %d no puede empezar con =", nLinea);
    } else if (linea[0] == ' '){
        ok = 0;
        fprintf(stderr, "Error: Linea %d no puede empezar con un espacio", nLinea);
    } else if (linea[0] == '\t'){
        ok = 0;
        fprintf(stderr, "Error: Linea %d no puede empezar con un tabulador", nLinea);
    }
    return ok;
}

int comprobar_formato(char *filename){
    int ok = 1;
    FILE *f;
    char linea[TAM_LINEA];
    int nLinea = 0;
    f = fopen(filename, "r");
    if (f == NULL){
        ok = 0;
        fprintf(stderr, "Error: No se pudo abrir el archivo %s", filename);
    } else {
        while (fgets(linea, TAM_LINEA, f) != NULL){
            nLinea++;
            if (comprobar_linea(linea, nLinea) == 0){
                ok = 0;
            }
        }
        fclose(f);
    }
    return ok;
}

int main (int argc, char *argv[] ) {
    return 0;
}
//delete node function
void deleteNode(struct Node** head_ref, int key)
{
    // Store head node
    struct Node* temp = *head_ref, *prev;
 
    // If head node itself holds the key to be deleted
    if (temp != NULL && temp->data == key)
    {
        *head_ref = temp->next;   // Changed head
        free(temp);               // free old head
        return;
    }
 
    // Search for the key to be deleted, keep track of the
    // previous node as we need to change 'prev->next'
    while (temp != NULL && temp->data != key)
    {
        prev = temp;
        temp = temp->next;
    }
 
    // If key was not present in linked list
    if (temp == NULL) return;
 
    // Unlink the node from linked list
    prev->next = temp->next;
 
    free(temp);  // Free memory
}