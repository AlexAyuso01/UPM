#include "parser.c"

// uses main to call parser.c and parser.h
int main(int argc, char *argv[]){
    FILE *file = fopen("file.txt", "r");
    parser(file);
    return 0;
}


