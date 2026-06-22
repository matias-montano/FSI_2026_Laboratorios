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
      scanf ("%s", password);
      if (strcmp (password, passwdOK) == 0)
	{
	  break;
	}
    }
  printf ("\nCongratulations!!!  Access OK... \n");
  return 0;
}
