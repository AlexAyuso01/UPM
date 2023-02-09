#include <stdio.h>
#include <stdlib.h>
#include "parser.h"

int main(int argc, char *argv[]) {
    const char *filepath = NULL;

    if (argc > 2) {
        fprintf(stderr, "Error: Invalid number of arguments\n");
        return -1;
    } else if (argc == 2) {
        filepath = argv[1];
    }

    if (parser(filepath) != 0) {
        fprintf(stderr, "Error: Parsing failed\n");
        return -1;
    }

    return 0;
}
