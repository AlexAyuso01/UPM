/*-
 * main.c
 * Minishell C source
 * Shows how to use "obtain_order" input interface function.
 *
 * Copyright (c) 1993-2002-2019, Francisco Rosales <frosal@fi.upm.es>
 * Todos los derechos reservados.
 *
 * Publicado bajo Licencia de Proyecto Educativo Práctico
 * <http://laurel.datsi.fi.upm.es/~ssoo/LICENCIA/LPEP>
 *
 * Queda prohibida la difusión total o parcial por cualquier
 * medio del material entregado al alumno para la realización
 * de este proyecto o de cualquier material derivado de este,
 * incluyendo la solución particular que desarrolle el alumno.
 *
 * DO NOT MODIFY ANYTHING OVER THIS LINE
 * THIS FILE IS TO BE MODIFIED
 */

#include <stddef.h>			/* NULL */
#include <stdio.h>			/* setbuf, printf */
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <string.h>
#include <limits.h>

extern int obtain_order();		/* See parser.y for description */
int esmandatointerno(int argc, char **argv);
void getCurrentDirectory(int argc, char **argv);

int main(void)
{
	char ***argvv = NULL;
	int argvc;
	char **argv = NULL;
	int argc;
	char *filev[3] = { NULL, NULL, NULL };
	int bg;
	int ret;

	setbuf(stdout, NULL);			/* Unbuffered */
	setbuf(stdin, NULL);

	while (1) {
		fprintf(stderr, "%s", "msh> ");	/* Prompt */
		ret = obtain_order(&argvv, filev, &bg);
		if (ret == 0) break;		/* EOF */
		if (ret == -1) continue;	/* Syntax error */
		argvc = ret - 1;		/* Line */
		if (argvc == 0) continue;	/* Empty line */
		
#if 1
/*
 * LAS LINEAS QUE A CONTINUACION SE PRESENTAN SON SOLO
 * PARA DAR UNA IDEA DE COMO UTILIZAR LAS ESTRUCTURAS
 * argvv Y filev. ESTAS LINEAS DEBERAN SER ELIMINADAS.
 */
		for (argvc = 0; (argv = argvv[argvc]); argvc++) {
			for (argc = 0; argv[argc]; argc++){
			// mirar si argumento[0] es mandato interno == 0 -> mandato entero  
			// si no es: 
			// como es el 
			if (argv[argc] != NULL){
				if (esmandatointerno(argc, argv) != 0){
					wait(NULL);
				} else {
					int pid = fork();
					if (pid == 0){
						execvp(argv[0], argv);
					} else{
						wait(NULL);
					}
				}
			}
			}
		}
		if (filev[0]) printf("< %s\n", filev[0]);/* IN */
		if (filev[1]) printf("> %s\n", filev[1]);/* OUT */
		if (filev[2]) printf(">& %s\n", filev[2]);/* ERR */
		if (bg) printf("&\n");
/*
 * FIN DE LA PARTE A ELIMINAR
 */
#endif
	}
	exit(0);
	return 0;
}
// check if the command is an internal command
int esmandatointerno(int argc, char **argv){ // NO FUNCIONA AUN PERO PORQUE NO SE ACTUALIZA EL CURRENT DIRECTORY
	//checks if it is the cd unix command, if it is, it changes the directory
	if (strcmp(argv[0], "cd") == 0){
		if (argc == 0){ // if there is no argument, it changes to the home directory
			chdir(getenv("HOME"));
		} else if (argc == 1){ // if there is one argument, it changes to the directory specified
			getCurrentDirectory(argc, argv);
		} else { // if there are more than one argument, it prints an error
			printf("cd: too many arguments\n");
		}
		return 1;
	} else if (strcmp(argv[0], "exit") == 0){
		exit(0);
	} else if (strcmp(argv[0], "umask") == 0){
		printf("umask: not implemented\n");
		return 1;
	} else if (strcmp(argv[0], "limit") == 0){
		return 1;
	}
	return 0;
}
//function that gets the current directory and changes it to the specified directory
void getCurrentDirectory(int argc, char **argv){
	//get the current directory and store it in dir 
	//char dir[PATH_MAX];
	//getcwd(dir,sizeof(dir));
	char *cwd = getcwd(NULL,0);
	//concatenate the current directory with the argument
	printf("%s\n", cwd);
	strcat(cwd, "/");
	strcat(cwd, argv[1]);
	//change the directory to dir
	chdir(cwd);
	printf("%s\n", cwd);
	printf("%d\n", argc);
	//free(dir);
}

