#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int autenticar(char *password, char *clave);
void mostrar_menu();

#define TRUE 1

char archivo_temp[50] = "temp.txt";

int main()
{
    char passwdOK[] = "GSIlab4";
    char password[10];
    int opcion;
    
    while (1)
    {
        printf("\n");
        printf("sistema autenticacion\n");
        printf("Ingrese password: ");
        scanf("%9s", password);
        while(getchar() != '\n');
        
        if (strcmp(password, passwdOK) == 0)
        {
            printf("\n Congratulations!!!  Access OK... \n");
            
            while (TRUE)
            {
                printf("\n");
                printf("sistema menu, opcion: \n");
                printf("1. Leer archivo\n");
                printf("2. Crear respaldo tar.gz\n");
                printf("0. Salir\n");
                printf("Ingrese opción: \n");

                scanf("%1d", &opcion);
                while(getchar() != '\n');
                
                switch(opcion)
                {
                    case 1:
                        printf("Ingrese nombre de su archivo a leer: ");
                        char archivo[50];
                        scanf("%s", archivo);
                        while(getchar() != '\n');
                        
                        FILE *fp = fopen(archivo, "r");
                        if (fp != NULL)
                        {
                            char buffer[100];
                            printf("\nContenido del archivo:\n");
                            while (fgets(buffer, sizeof(buffer), fp) != NULL)
                            {
                                printf("%s", buffer);
                            }
                            fclose(fp);
                        }
                        else
                        {
                            printf("No se pudo abrir el archivo.\n");
                        }
                        break;
                    
                    
                    case 2:
                        printf("creando respaldo de los .md del directorio actual...\n");
                        printf("Ingrese nombre del respaldo: ");
                        char nombre_respaldo[100]; 
                        
                        fgets(nombre_respaldo, sizeof(nombre_respaldo), stdin);
                        nombre_respaldo[strcspn(nombre_respaldo, "\n")] = '\0';
                        
                        char comando[200];
                        // El programador quiere crear un respaldo comprimido
                        snprintf(
                                comando, sizeof(comando), 
                                "tar -czf %s.tar.gz *.md",
                                nombre_respaldo
                        ); // que devuelva un string este comando

                        system(comando);  
                        
                        printf("Respaldo creado: %s.tar.gz\n", nombre_respaldo);
                        break;      
                        
                    case 0:
                        printf("Saliendo...\n");
                        return 0;
                    default:
                        printf("Opción inválida.\n");
                }
            }
        }
        else
        {
            printf("Password incorrecta. Intente nuevamente.\n");
        }
    }
    
    return 0;
}

