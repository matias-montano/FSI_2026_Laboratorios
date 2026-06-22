#include <stdio.h>
#include <string.h>

int
main ()
{
  char passwdOK[] = "GSIlab4";
  char password[10];
  while (1)
    {
      printf ("Ingrese password: ");
      scanf ("%9s", password);
      if (strcmp (password, passwdOK) == 0)
      {
        break;
      }
      while (getchar() != '\n'); // limpiar el buffer de entrada
    }
  printf ("\nCongratulations!!!  Access OK... \n");
  return 0;
}
