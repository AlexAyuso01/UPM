#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "movil.h"
#include "vect_movil.h"

/*
 * Ejemplo del toString()
 * newMovil() y delMovil() se explican solos
 */
int mov_test(void) {
	movil_t *paux[3];	/* Vector con las direcciones de tres móviles */
	char *mbuf;		/* Buffer para el texto formateado */
	const char *asfmt[6] = {
			"IMEI: %s; ", "Modelo: %s; ", "RAM: %s; ", "Bat: %d mAh; ", "PVP: %.2f€; ", "Info: %d bytes"
	};
	char imei[16];
	char ram[10];
	char smodelo[3][15];
	int i;

	/*
	 * Invocación de newMovil()
	 * Creación de tres móviles para el ejemplo del toString();
	 */
	printf("\nEjemplo newMovil()\n");
	for(i = 0; i < 3; i++) {
		sprintf(imei, "00000000000000%d", i+1);
		memset(smodelo[i], '\0', 15);
		sprintf(smodelo[i], "Mod. #%d", i+1);
		sprintf(ram, "%dGb", i+1);
		paux[i] = new_movil(imei, smodelo[i], ram, (i+1)*1000, (float) (i+1)*1000, (i+1)*1000);
		if(paux[i] != NULL)
			printf("Creado móvil IMEI %s\n", paux[i]->imei);
		else
			return NOMEM;
	}

	/*
	 * Invocación de toString(). Se muestra también la longitud
	 * de la cadena resultante (la estrictamente necesaria)
	 */
	printf("\nEjemplo toString()\n");
	for(i = 0; i < 3; i++) {
		mbuf = calloc(MAXB, sizeof(char));
		if(mbuf != NULL) {
			memset(mbuf, '\0', MAXB);
			mbuf = toString(paux[i], asfmt, mbuf);
			if(mbuf != NULL) {
				printf("Móvil %d: %s; Long: %d bytes\n", i+1, mbuf, (int) strlen(mbuf));
				free(mbuf);
			}
			else
				printf("Móvil %d: sfmt = {null, null, null, null, null, null}\n", i+1);
		}
		else
			return NOMEM;
	};

	/*
	 * Ejemplo delMovil()
	 */
	for(i = 0; i < 3; i++)
		del_movil(paux[i]);

	return OK;
}

/*
 * Ejemplo #1: testMovil 1
 * Ejemplo #2: testMovil 2 n (n tamaño de la ventana)
 */
int main(int argc, char *argv[])
{
	/*
	 * Array con datos de móviles
	 */
	const char *vmov[NM][NC] = {
			{ "80069edad0a9e28", "Samsung Galaxy J2 Core (2020)", "1 GB RAM ", "2600", "39.160000", "1353" },
			{ "173ababaa3c165d", "Apple iPhone SE (2020)", "3 GB RAM ", "1821", "460.130000", "2169" },
			{ "a63ff8b2342fa58", "ZTE nubia Play", "6/8 GB RAM ", "5100", "606.980000", "1654" },
			{ "5c131f27e9bebf6", "OnePlus 8", "8/12 GB RAM ", "4300", "930.050000", "2423" },
			{ "4c70ce8b52420b7", "Honor 30 Pro", "8 GB RAM ", "4000", "704.880000", "2033" },
			{ "94028646f07d210", "OnePlus 8 Pro", "8/12 GB RAM ", "4510", "930.050000", "2590" },
			{ "9fefba73f16338f", "Honor 30 Pro+", "8/12 GB RAM ", "4000", "704.880000", "2354" },
			{ "10a760343842b4a", "Honor 30", "6/8 GB RAM ", "4000", "704.880000", "1915" },
			{ "f62a5c7618ddf82", "Oppo Ace2", "8/12 GB RAM ", "4000", "802.780000", "2050" },
			{ "aee9f694f46d876", "Huawei Watch GT 2e", "16 MB RAM ", "455", "558.030000", "873" },
			{ "9f05b51836141c5", "Oppo A12", "3/4 GB RAM ", "4230", "802.780000", "1538" },
			{ "24f92f8aa317579", "Oppo A52", "4-8 GB RAM ", "5000", "802.780000", "1806" },
			{ "3c1789f2212ee5c", "Motorola Moto G Power", "4 GB RAM ", "5000", "58.740000", "1625" },
			{ "cf896e3c4e5a7e2", "LG Folder 2", "1 GB RAM ", "1470", "186.010000", "1044" },
			{ "eeaca9875b6c5b4", "Motorola Moto G8 Power", "4 GB RAM ", "5000", "58.740000", "2066" },
			{ "8b9036455356681", "Motorola Moto G Stylus", "4 GB RAM ", "4000", "58.740000", "1712" },
			{ "8339c94a5af0338", "Oppo A12e", "3 GB RAM ", "4230", "802.780000", "1356" },
			{ "c335486f5f318e3", "Honor 8A 2020", "3 GB RAM ", "3020", "704.880000", "1293" },
			{ "c5194fdd9dbee8c", "Honor Play 4T", "6 GB RAM ", "4000", "704.880000", "1434" },
			{ "6e7d6a1050a43a0", "Tecno Camon 15 Air", "3 GB RAM ", "5000", "1116.060000", "1428" },
			{ "b5eb4fe99f341d1", "Tecno Camon 15 Premier", "6 GB RAM ", "4000", "1116.060000", "1496" },
			{ "306374a6a1bc24f", "vivo S6 5G", "6/8 GB RAM ", "4500", "959.420000", "1611" },
			{ "5823e15f3699c72", "vivo Y50", "8 GB RAM ", "5000", "959.420000", "1596" },
			{ "d851e9f1f467b1f", "Honor Play 4T Pro", "6/8 GB RAM ", "4000", "704.880000", "1543" },
			{ "7ceee50ca6ad88f", "Infinix Hot 9 Play", "2/3 GB RAM ", "6000", "1106.270000", "1752" },
			{ "4b0a922f3659d17", "Huawei P40 Pro", "8 GB RAM ", "4200", "558.030000", "2608" },
			{ "e9a98c8dfe17bf0", "Huawei P40", "6/8 GB RAM ", "3800", "558.030000", "2427" },
			{ "739b9d7d6e5961c", "Honor 30S", "6/8 GB RAM ", "4000", "704.880000", "1882" },
			{ "358d1a05a0d79f1", "Samsung Galaxy Xcover FieldPro", "4 GB RAM ", "4500", "39.160000", "1585" },
			{ "d13480b3b68592e", "Xiaomi Redmi K30 Pro Zoom", "8/12 GB RAM ", "4700", "783.200000", "1931" },
			{ "0f978296d22dbc4", "Motorola Moto G8 Power Lite", "4 GB RAM ", "5000", "58.740000", "1542" },
			{ "c5d03ff51c19344", "Honor Play 9A", "4 GB RAM ", "5000", "704.880000", "1524" },
			{ "4aea5fee01bf586", "Nokia 5.3", "3-6 GB RAM ", "4000", "9.790000", "1905" },
			{ "73f2142accae05c", "Nokia 1.3", "1 GB RAM ", "3000", "9.790000", "1602" },
			{ "d31aafbf939dfea", "Nokia 5310 (2020)", "8 MB RAM ", "1200", "9.790000", "1163" },
			{ "d767fb6d6f0785f", "Xiaomi Redmi 8A Pro", "2/3 GB RAM ", "5000", "783.200000", "1577" },
			{ "9b6f37e7b5d104e", "LG V60 ThinQ 5G UW", "8 GB RAM ", "5000", "186.010000", "2112" },
			{ "7694442765a10ca", "BLU View Mega", "2 GB RAM ", "3000", "646.140000", "1066" },
			{ "6b55167432845f5", "Infinix S5 Pro (48+40)", "4/6 GB RAM ", "4000", "1106.270000", "1558" },
			{ "d2395529fe754a7", "Infinix S5 Pro (16+32)", "4/6 GB RAM ", "4000", "1106.270000", "1536" },
			{ "45f1255e6ca8960", "Infinix Hot 9", "2-4 GB RAM ", "5000", "1106.270000", "1750" },
			{ "c47128ae542f7c2", "Allview Viva 803G", "1 GB RAM ", "3600", "871.310000", "987" },
			{ "928ff1fd2c1d60e", "Wiko Y61", "1/2 GB RAM ", "3000", "939.840000", "1151" },
			{ "093444e6e9fccd6", "Wiko View4 Lite", "2 GB RAM ", "4000", "939.840000", "1227" },
			{ "5a7605f8f48ef72", "Wiko Sunny4", "1 GB RAM ", "2200", "939.840000", "971" },
			{ "26f414eb753b4dd", "Wiko View3 Lite", "2 GB RAM ", "4000", "939.840000", "1222" },
			{ "1240858d963066d", "Wiko Y60", "1 GB RAM ", "2500", "939.840000", "1139" },
			{ "e0c7d410defede6", "Infinix Note 8i", "4/6 GB RAM ", "5200", "1106.270000", "1475" },
			{ "b20bea72321a420", "TCL NxtPaper", "4 GB RAM ", "5500", "1125.850000", "1198" },
			{ "639e121dd700405", "Energizer U680S", "2 GB RAM ", "7000", "1027.950000", "1040" }
	};
	/*
	 * La cadena de formateo para el toString()
	 */
	const char *sfmt[6] = { "IMEI: %s; ", "Modelo: %s; ", "RAM: %s; ", "Bat: %d mAh; ", "PVP: %.2f€; ", NULL };
	int code = KO;

	if(argc == 1 || argc > 3)
		fprintf(stderr, "Parámetros incorrectos. No hace nada\n");
	else {
		switch(argv[1][0]) {
		/*
		 * Ejemplo newMovil(), delMovil() y toString()
		 */
		case '1':
			code = mov_test();
			break;
		/*
		 * Ejemplo de invocación de vectMovil()
		 * El tamaño de la ventana se suministra a través de la línea de orden
		 * sfmt es el array con las cadenas de formateo
		 */
		case '2':
			if(argv[2] != NULL) {
				code = vect_movil((int) strtol(argv[2], NULL, 10), sfmt, vmov);
			}
			else
				fprintf(stderr, "Falta parámetro #2. No hace nada\n");
			break;
		default:
			fprintf(stderr, "Parámetros incorrectos. No hace nada\n");
		}
	}

	return code;
}
