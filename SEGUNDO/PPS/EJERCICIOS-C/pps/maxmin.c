#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv){
    FILE *f = fopen(argv[1], "r");
    float num;
    float max = 0.00;
    float min = 0.00;
    int var = 0;
    if (argc != 2){
        printf("Error: wrong number of arguments\n");
        var = -1;
    } else if (fopen(argv[1], "r") == NULL){
        printf("Error opening file\n");
        var = -1;
    } else if (fscanf(f, "%f", &num) == EOF){
        printf("%10.2f %10.2f\n", max, min);
        var = 0;
    } else {
        fseek(f, 0, SEEK_SET);
        fscanf(f, "%f", &num);
        max = num;
        min = num;
        while (fscanf(f, "%f", &num) != EOF){
                
            if (num > max){
                max = num;
            }
            if (num < min){
                min = num;
            }

        }      
        var = 0;
        printf("%10.2f %10.2f\n", max, min);
    }
    return var;
}