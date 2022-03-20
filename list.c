#include <stdio.h>
#include <stdlib.h>
struct linkedlist{
   char key[];
   char pre_k[];
   char nex_k[];
} linkedlists;


int main()
{
   FILE *in_file  = fopen("test1.input", "r"); // read only
   FILE *out_file = fopen("test1.output", "w"); // write only
   // test for files not existing
   if (in_file == NULL || out_file == NULL)
   {
       printf("Error! Could not open file\n");

   }
   char line[100];
   fgets(line, 100, in_file);
   fprintf(out_file, "The line is: %s\n", line);
   // write to file
   fprintf(out_file, "this is a test %d\n", 55);
   return 0;
}
