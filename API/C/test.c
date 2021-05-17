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

int login(char* host, int port) {
    int h = khp(host, port);

    return h;
}


int validHandle(int handle) {
    if(handle > 0)
		return 1;
	if(handle == 0)
		fprintf(stderr, "ERROR: Authentication error %d\n", handle);
	else if(handle == -1)
		fprintf(stderr, "ERROR: Connection error %d\n", handle);
	else if(handle == -2)
		fprintf(stderr, "ERROR: Time out error %d\n", handle);
	return 0;
}

J castTime(int hour,int min,int sec) {
 return (J)((60 * hour + min) * 60 + sec) * 1000000000;
}

int readQuote(char *csv,int h) {
		printf("debug 1\n");
		FILE* stream = fopen(csv,"r");
		printf("INFO: %s file has been opened and ready to be parsed\n",csv);
		char line[1024];
		struct quoteinfo{
			int timeHH, timeMM, timeSS;
			char sym[9];
			int bidSize,bidPrice,askSize,askPrice;
		}quoteTmp;
		int lineNum = 0;
		char *tmp;
		char *timeTmp;
		K result, rowinfo;
		const char delimiters[] = ":,";
		printf("debug 2\n");
		while (fgets(line, 1024, stream)){
			printf("debug 3\n");
			if(line!=NULL){
				//strtok might be a better choice but this was easier to understand coming from q
				sscanf( line, "%d:%d:%d,%[^,],%d,%d,%d,%d", &quoteTmp.timeHH,&quoteTmp.timeMM,&quoteTmp.timeSS, quoteTmp.sym,&quoteTmp.bidSize,&quoteTmp.askSize,&quoteTmp.bidPrice,&quoteTmp.askPrice);
				printf("%s \n",line);
				if(lineNum!=0){
					rowinfo = knk(6,ktj(-KN,castTime(quoteTmp.timeHH,quoteTmp.timeMM,quoteTmp.timeSS)), ks((S) quoteTmp.sym), kj(quoteTmp.bidSize), kf(quoteTmp.bidPrice), kj(quoteTmp.askSize), kf(quoteTmp.askPrice));
					result = k(h,".u.upd", ks((S) "quote"), rowinfo, (K) 0);
					//printf("%s\n",result->s);
					r0(result);
				}
				
				lineNum++;
			}
			
		}
		fclose(stream);
		printf("INFO: CSV parsed and sent to handle %d \n",h);
		return EXIT_SUCCESS;
}


// int readTrade(char *csv,int h) {
//     //parse CSV, feedhandling is perform between the lines
// 	if (access(csv, F_OK) != -1) {
// 		FILE* stream = fopen(csv,"r");
// 		printf("File has been opened and ready to parse\n",csv);
// 		char line[1024];
// 		struct quoteinfo{
// 			int timeHH, timeMM, timeSS;
// 			char sym[9];
// 			int size;
// 			int price;
// 		}tradeTmp;
// 		int lineNum = 0;
// 		char *tmp;
// 		char *timeTmp;
// 		K result, rowinfo;
// 		const char delimiters[] = ":,";
				
// 		while (fgets(line, 1024, stream)){
			
// 			if(line!=NULL){
// 				//strtok might be a better choice but this was easier to understand coming from q
// 				sscanf( line, "%d:%d:%d,%[^,],%d,%d", &tradeTmp.timeHH,&tradeTmp.timeMM,&tradeTmp.timeSS, tradeTmp.sym,&tradeTmp.size,&tradeTmp.price);
				
				
// 				if(lineNum!=0){
// 					rowinfo = knk(4,ktj(-KN,castTime(tradeTmp.timeHH,tradeTmp.timeMM,tradeTmp.timeSS)), ks((S) tradeTmp.sym), kj(tradeTmp.size), kf(tradeTmp.price));
// 					result = k(h,".u.upd", ks((S) "trade"), rowinfo, (K) 0);
// 					r0(result);
// 				}
				
// 				lineNum++;
// 			}
			
// 		}
// 		fclose(stream);
// 		printf("Csv parsed and sent to %d \n",h);
// 		return EXIT_SUCCESS;
// 	} else {
// 		fprintf(stderr, "File is missing \n");
// 		return EXIT_FAILURE;
// 	}
// }


int main(void) {

    char host[200];
    int port;
    char portpath[200];
    int handle;
    char quotecsvpath[200];
    char tradecsvpath[200];

    printf("Enter host name: ");
    fgets(host,LINE_MAX, stdin);
    printf("Enter port name: ");
    fgets(portpath,LINE_MAX, stdin);
    port = atoi(portpath);

    handle = login(host, port);

    if (!validHandle) {
        return 0;
    }

    printf("Enter Quote CSV Path:");
	fgets(quotecsvpath,LINE_MAX, stdin);

	quotecsvpath[strlen(quotecsvpath)-1]='\0';

    readQuote(quotecsvpath, handle);

    //parseTradeCSV();
    
    return 1;
}