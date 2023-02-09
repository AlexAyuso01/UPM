#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.h"

#define MAX_LINE_LENGTH 2048
#define MAX_FIELDS 15

int parser(const char *filepath) {
	FILE *fp;
	char line[MAX_LINE_LENGTH];
	char fields[MAX_FIELDS][MAX_LINE_LENGTH];
	int field_count;
	int line_count = 0;
    char *token;
    int length;
    int len;

	if (filepath) {
    	fp = fopen(filepath, "r");
    	if (!fp) {
        	fprintf(stderr, "Error: unable to open file %s\n", filepath);
        	return -1;
    	}
	} else {
    	fp = stdin;
	}

	if (fgets(line, MAX_LINE_LENGTH, fp)) {
    	field_count = 0;
    	token = strtok(line, ",");
        while (token && field_count < MAX_FIELDS) {
           len = strcspn(token, "\r\n");
            strncpy(fields[field_count], token, len);
            fields[field_count][len] = '\0';
            token = strtok(NULL, ",");
            field_count++;
        } 
	} else {
    	fprintf(stderr, "Error: unable to read first line of file\n");
    	return -1;
	}

	while (fgets(line, MAX_LINE_LENGTH, fp))	{
    	line_count++;
    	if (line[0] == '\n') {
        	continue;
    	}
        length = field_count;
        field_count = 0;
        token = strtok(line, ",");
    	while ((token && field_count < MAX_FIELDS) || field_count < length) {    
            if (field_count == length-1){
                printf("%s: %s", fields[field_count], token);
                token = strtok(NULL, ",");
                field_count++;
            } else {
        	    printf("%s: %s; ", fields[field_count], token);
        	    token = strtok(NULL, ",");
        	    field_count++;
            }
    	}
	}
    printf("\n");
	if (fp != stdin) {
    	fclose(fp);
	}

	return 0;
}
