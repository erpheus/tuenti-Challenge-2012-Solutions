/* 
 * File:   main.c
 * Author: Guillermo
 *
 * Created on April 30, 2012, 2:52 AM
 */

#include <stdio.h>
#include <stdlib.h>

/*
 * 
 */
int main(int argc, char** argv) {
    
    unsigned long int numCasos;
    unsigned long int k, R, G;
    unsigned long int i, j;
    unsigned long int *grupos;
    unsigned long int *primero,*limite,*inicioP;
    long long int litros;
    long int libres;
    
    scanf("%ld",&numCasos);
    for(i=0;i<numCasos;i++){
        
        litros=0;
        
        scanf("%ld %ld %ld",&R,&k,&G);
        grupos=(unsigned long int*)malloc(G*sizeof(unsigned long int));
        
        if (!grupos){
           return 1; 
        }
        
        for(j=0,primero=grupos;j<G;j++,primero=&primero[1]){
            scanf("%ld",primero);
        } 
        
        primero=grupos;
        
        inicioP=primero;
        
        for(j=0;j<R;j++){
            
            limite=primero;
            
            libres = k;
            
            while(((signed int)(libres - (*primero)) >= 0)){
                
                libres -= (*primero);
                primero=&primero[1];
                if (primero == &grupos[G])
                    primero = &grupos[0];
                if (primero==limite)
                    break;
            }
            
            litros += k-libres;
            
            if (inicioP==primero && (R/(j+1)) > 1){
                //Han transcurrido j+1
                litros*=R/(j+1);
                j=((R/(j+1))*(j+1))-1;
            }
            
        }
        
        printf("%lld\n",litros);
        
        free((void *)grupos);
        
    }
    

    return (EXIT_SUCCESS);
}

