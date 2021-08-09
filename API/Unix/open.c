#include "k.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <errno.h>
#include <libgen.h>
#include <sys/utsname.h>
#include <limits.h>


int main(void){

	char path[200];

	fgets(path, 200, stdin);

	printf("%s", path);
	path[strlen(path)-1] = '\0';
	FILE* stream = fopen(path,"r");
	printf("debug 1\n");

	char line[1024];

	while (fgets(line, 1024, stream)){
			printf("debug 2\n");
			if(line!=NULL){
				printf("%s", line);
			}
			
		}
	return 1;
}