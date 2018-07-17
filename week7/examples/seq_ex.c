/*
Filename: "sequence_examples.c"
Return a vectors of sequentially summed values
Arguments:
start -- value to start the sum at
size -- the number of elements to return
sumVect -- the vector of summed output values
*/

void sumSeq(int *start, int *size, int *sumVect){
    /*
    This function provides a simple sequential sum
    where F[n] = F[n-1] + n
    */
    int i, j ;
    j = 0 ;
    for(i = *start; i < (*start + *size); i++){
        if(i == *start){
            sumVect[j] = i ;
        }
        else{
            sumVect[j] = sumVect[j-1] + i ;
        }
        j ++ ;
    }
}

void fiboSeq(int *size, int *sumVect){
    /*
    This function returns the Fibonacci sequence
    where F[n] = F[n-1] + F[n-2]
    */
    int i ;
    sumVect[0] = 0 ;
    sumVect[1] = 1 ;
    for(i = 2; i < *size; i++){
        sumVect[i] = sumVect[i-1] + sumVect[i-2] ;
    }
}