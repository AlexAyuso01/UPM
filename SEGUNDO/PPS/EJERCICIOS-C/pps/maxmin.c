#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv){
    FILE *f = fopen(argv[1], "r");
    float num;
    float max = 0.00;
    float min = 0.00;
    if (argc != 2){
        return -1;
    } 
    if (fopen(argv[1], "r") == NULL){
        return -1;
    }    
        fseek(f,0,SEEK_SET);
        fscanf(f,"%f",&num);
        max = num;
        min = num;
        while (fscanf(f,"%f", &num) != EOF){
                
            if (num > max){
                max = num;
            }
            if (num < min){
                min = num;
            }

        }
        fclose(f);
        printf("%10.2f %10.2f\n",max, min);
        return 0;
}     