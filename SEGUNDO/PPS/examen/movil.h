#define OK 0
#define KO -1
#define NOMEM -11

typedef struct movil_s {
	char imei[16];
	char ram[16];
	char *modelo;
	int bat;
	float pvp;
	int sspec;
} movil_t;

typedef movil_t *pMovil;

movil_t *new_movil (const char *imei, const char *modelo, const char *ram, int bat, double pvp, int sspec);
void del_movil(movil_t *pm);
char *toString(movil_t *pmov, const char *sfmt[], char *mstr);
