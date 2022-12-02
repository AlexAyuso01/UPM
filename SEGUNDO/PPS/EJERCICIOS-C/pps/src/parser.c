#include "parser.h"

//struct for the linked list

typedef struct node{
    char *info;
    struct node *next;
} node_t;

node_t *create_new_node(char info[]){
    node_t *new_node = malloc(sizeof(node_t));
    new_node->info = info;
    new_node->next = NULL;
    return new_node;
}
int parser (FILE * file){
    int campos = -1;
    char line[MaxLinea];
    char *line2 = "";
    char result[MaxCampos][MaxLinea];
    if (file == NULL){
        printf("Error opening file \n");
        return 1;
    } else {
        file = fopen("file.txt", "r");
        printf("File open \n");
    }
    //fgets reads the first line of the file and stores it in line
    
    fgets(line, MaxLinea, file);
    printf("linea: %s \n", line);
    //separate the line into tokens and store them in line2 
    char *token = strtok(line,",");
    while(token != NULL){
        printf("Token: %s\n", token);
        //concatenate the tokens into line2 
        
        if(line2 == NULL){
            line2 = token;
        } else {
            strcat(line2," "); 
            strcat(line2,token);             
        }
        token = strtok(NULL,",");
        campos++;
        printf("___LINEA: %s \n", line2);
    }
    //print line2
    printf("linea2: %s \n", line2);
    node_t *head = create_new_node(line);
    printf("head: %s \n", head->info);
    while(fgets(line, MaxLinea, file) != NULL){
        campos ++;
    }
}
