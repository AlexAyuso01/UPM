#include <stddef.h>     /* NULL */
#include <stdio.h>      /* setbuf, printf */
#include <stdlib.h>
#include <sys/wait.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>

#define MAX_LINE 80 /* The maximum length of a command */

extern int obtain_order();     /* See parser.y for description */
void execute_pipeline(char ***argvv);
void handle_redirections(char *filev[], char **in_file, char **out_file);

int main(void)
{
    char ***argvv = NULL;
    int argvc;
    //char **argv = NULL;
    char *filev[3] = {NULL, NULL, NULL};
    int bg;
    int ret;
	char *in_file = NULL;
	char *out_file = NULL;
	
    setbuf(stdout, NULL); /* Unbuffered */
    setbuf(stdin, NULL);

    while (1)
    {
        fprintf(stderr, "%s", "msh> "); /* Prompt */
        ret = obtain_order(&argvv, filev, &bg);
        if (ret == 0)
            break;     /* EOF */
        if (ret == -1)
            continue; /* Syntax error */
        argvc = ret - 1; /* Line */
        if (argvc == 0)
            continue; /* Empty line */
		handle_redirections(filev, &in_file, &out_file);
		execute_pipeline(argvv);
	}
	return 0;
}

void execute_pipeline(char ***argvv)
{
    int num_commands = 0;
    for (int i = 0; argvv[i] != NULL; i++) {
        num_commands++;
    }

    int pipes[num_commands - 1][2];
    for (int i = 0; i < num_commands - 1; i++) {
        if (pipe(pipes[i]) == -1) {
            perror("pipe");
            exit(EXIT_FAILURE);
        }
    }

    for (int i = 0; i < num_commands; i++) {
        pid_t pid = fork();
        if (pid == -1) {
            perror("fork");
            exit(EXIT_FAILURE);
        } else if (pid == 0) {
            if (i == 0 && num_commands > 1) {
                // First command in pipeline
                dup2(pipes[i][1], STDOUT_FILENO);
                close(pipes[i][0]);
                close(pipes[i][1]);
            } else if (i == num_commands - 1 && num_commands > 1) {
                // Last command in pipeline
                dup2(pipes[i - 1][0], STDIN_FILENO);
                close(pipes[i - 1][0]);
                close(pipes[i - 1][1]);
            } else if (num_commands > 1) {
                // Command in the middle of the pipeline
                dup2(pipes[i - 1][0], STDIN_FILENO);
                close(pipes[i - 1][0]);
                close(pipes[i - 1][1]);
                dup2(pipes[i][1], STDOUT_FILENO);
                close(pipes[i][0]);
                close(pipes[i][1]);
            }

            if (execvp(argvv[i][0], argvv[i]) == -1) {
                perror("execvp");
                exit(EXIT_FAILURE);
            }
        } else {
            if (i == 0 && num_commands > 1) {
                close(pipes[i][1]);
            } else if (i == num_commands - 1 && num_commands > 1) {
                close(pipes[i - 1][0]);
            } else if (num_commands > 1) {
                close(pipes[i - 1][0]);
                close(pipes[i][1]);
            }
		}
	}

	for (int i = 0; i < num_commands; i++) {
    	wait(NULL);
	}
}

void handle_redirections(char *filev[], char **in_file, char **out_file) {
    if (filev[0] != NULL) {
        *in_file = filev[0];
    }
    if (filev[1] != NULL) {
        *out_file = filev[1];
    }
    
    if (*in_file != NULL) {
        int fd = open(*in_file, O_RDONLY);
        if (fd == -1) {
            perror("open");
            exit(EXIT_FAILURE);
        }
        dup2(fd, STDIN_FILENO);
        close(fd);
    }
    
    if (*out_file != NULL) {
        int fd = open(*out_file, O_WRONLY | O_CREAT | O_TRUNC, 0666);
        if (fd == -1) {
            perror("open");
            exit(EXIT_FAILURE);
        }
        dup2(fd, STDOUT_FILENO);
        close(fd);
    }
}


