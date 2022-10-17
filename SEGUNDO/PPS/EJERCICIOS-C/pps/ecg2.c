
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int resolver (double a, double b, double c, double *px1, double *px2);

int main (int argc, char** argv){
    double a,b,c,PX1,PX2;
    FILE* F; 
    double *px1 = &PX1, *px2 = &PX2;
    F = fopen ("ecuaciones.txt", "r");
    if (F == NULL) {
        printf ("No se encontró el archivo ecuaciones.txt\n");
        exit (0);
    }
    else{
        int n = 1;
        while (scanf("%lf %lf %lf",&a, &b, &c) != EOF){
            resolver (a, b, c, px1, px2);
            printf ("caso %d\n",n);
            n++;
            printf ("solucion 1: %lf \n",*px1);
            printf ("solucion 2: %lf \n\n",*px2);
        }
    }
    return 0;
}

int resolver(double a, double b, double c, double *px1, double *px2){
    double result1 = (-b + sqrt(b*b-(4*a*c)))/(2*a), result2 = (-b - sqrt(b*b-(4*a*c)))/(2*a);
    printf("resolver a: %f b: %f c: %f \n", a,b,c);  
    if(a == 0 && b != 0){
            *px1 = -c/b;
            *px2 = -NAN;
            return 0;
    } 

    if ((b*b)-(4*a*c) >= 0){     
        *px1 = (((-1*b)) + sqrt(b*b-(4*a*c)))/(2*a);
        *px2 = (((-1*b)) - sqrt(b*b-(4*a*c)))/(2*a);
    } else if ((b*b)-(4*a*c) < 0){ //para solucion no real o una solucion no real
        double D = b*b-(4*a*c);
        if(D < 0 ){
            *px1 = -(1*b)/(2*a); //Parte real
            *px2 = fabs(-sqrt(-(b*b-(4*a*c)))/(2*a)); //Parte imaginaria
            return 1;
        } 
    } else {
        *px1 = NAN;
        *px2 = NAN;
        return 0;
    }
}
