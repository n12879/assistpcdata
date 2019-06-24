#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

/* etu stroku mozhno otredaktirovat izvne
 * poske kompilyacii programmy */
char c[] = "\n mysizeis 000000 \n";

int main (int argc, char **argv)
{
  unsigned int mysize;
  char buffer[100];
  FILE *fd;
  int i;

  /* chitaem razmer sobstvenno ispolnyaemogo fayla
   * (kotoriy byl skompilirovan vnachale, pered dobavleniem
   * dannyh v ego konec) */
  sscanf(c, " mysizeis %u ", &mysize);
	printf("Hello, my size is %u bytes!\n", mysize);

  /* otkrivayem sebya (ispolnyaemiy fayl */
  fd = fopen(argv[0], "rb");
  if (fd == NULL) {
    fprintf(stderr, "fopen error: %s\n", strerror(errno));
    exit(2);
  }
  
  /* perematyvaem fd do dannyh, kotorie bili vstroeny */
  fseek(fd, mysize, SEEK_SET);

  /* chitaem i ispolzuem vstroenniye danniye v hvoste fayla
   * (prosto pechataem v standartniy vivod) */
  i = 0;
  while (fscanf(fd, " %99[^\r\n] ", buffer) != EOF) {
    i++;
    printf("data line %d: %s\n", i, buffer);
  }

  /* pribiraem za soboy */
  fclose(fd);

	return 0;
}

