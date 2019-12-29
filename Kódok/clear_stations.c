#include <stdio.h>
#include <string.h>

int main(){
    FILE *fin, *fout;
    fin = fopen("hu\\6247548043235\\6247548043235stn.txt","r");
    fout = fopen("hu\\6247548043235\\stn.csv","w");
    if(fin == NULL || fout == NULL)
        return 1;
    char line[155];
    char delim[] = " +";
    char country[] = "HUNGARY";
    char *ptr;
    int pos, row = 1, word, count;
    while(fscanf(fin,"%[^\n]\n",line) != EOF){
        if(row == 2){
            ++row;
            continue;
        }
        else if(row == 1){
            ptr = strchr(line,'-');
            while(ptr != NULL){
                pos = ptr - line;
                line[pos] = ' ';
                ptr = strchr(line+1,'-');
            }
        }
        word = 0;
        count = 0;
        ptr = strtok(line,delim);
        fprintf(fout,"%s",ptr);
        ++word;
        while(1){
            ptr = strtok(NULL,delim);
            if(ptr == NULL)
                break;
            if(row == 1 && (word == 5 || word == 4)){
                ++word;
                continue;
            }
            if(word == 2){
                if(row == 1){
                    while(strcmp(ptr,"COUNTRY") != 0){
                        if(count == 0)
                            fprintf(fout,",%s",ptr);
                        else
                            fprintf(fout," %s",ptr);
                        ++count;
                        if(count > 5)
                            return 2;
                        ptr = strtok(NULL,delim);
                        ++word;
                    }
                }
                else{
                    while(strcmp(ptr,country) != 0){
                        if(count == 0)
                            fprintf(fout,",%s",ptr);
                        else
                            fprintf(fout," %s",ptr);
                        ++count;
                        if(count > 5)
                            return 2;
                        ptr = strtok(NULL,delim);
                        ++word;
                    }
                }
                fprintf(fout,",%s",ptr);
            }
            else{
                fprintf(fout,",%s",ptr);
                ++word;
            }
        }
        ++row;
        fprintf(fout,"\n");
    }
    fclose(fin);
    fclose(fout);
    return 0;
}