#include <stdio.h>
#include <string.h>

int main(){
    FILE* fin;
    FILE* fout;
    fin = fopen("ro\\9812808043220\\9812808043220dat.txt","r");
    fout = fopen("ro\\9812808043220\\98.csv","w");
    if(fin == NULL){
        printf("No input file!");
        return 1;
    }
    if(fout == NULL){
        printf("No output file!");
        return 1;
    }
    char line[150];
    char delim[] = " ";
    char search[] = "0.00T";
    int size = strlen(search);
    int pos;
    char* ptr;
    while(fscanf(fin,"%[^\n]\n",line) != EOF){
        ptr = strstr(line,search);
        while(ptr != NULL){
            pos = ptr - line;
            for(int i = pos ; i < pos+size ; ++i){
                line[i-1] = line[i];
            }
            line[pos+size-1] = ' ';
            ptr = strstr(line+pos+size,search);
        }
        ptr = strtok(line,delim);
        if(ptr[0] != '*')
            fprintf(fout,"%s",ptr);
        while(1){
            ptr = strtok(NULL,delim);
            if(ptr == NULL)
                break;
            if(ptr[0] == '*')
                fprintf(fout,",");
            else
                fprintf(fout,",%s",ptr);
        }
        fprintf(fout,"\n");
    }
    fclose(fin);
    fclose(fout);
    return 0;
}