
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
struct linkedlist{
   struct linkedlist* prev;
   struct linkedlist* next;
   char key[100];
} ;

void printList(struct linkedlist* head, FILE *out_file){
   if (head == NULL){
	fprintf(out_file, "EMPTY\n");
	return;
   }
   char prev[100];
   if (head->prev == NULL){
	strcpy(prev, "Head");
   }
   else{
	strcpy(prev,head->prev->key);
   }
   char next[100];
   if (head->next == NULL){
        strcpy(next, "Tail");
   }
   else{
        strcpy(next, head->next->key);
   }
   fprintf(out_file, "(%s,%s,%s)",head->key,prev,next);
   if (strcmp(next,"Tail")!=0){
	fprintf(out_file, ",");
	printList(head->next, out_file);
   }
   else{
	fprintf(out_file, "\n");
   }
}

struct linkedlist* getTail(struct linkedlist** head){
	if((*head)->next==NULL){
		return *head;
	}
	getTail(&((*head)->next));
}

void deleteNodes(struct linkedlist** head, char key[]){
	if(strcmp((*head)->key, key)==0){
		if((*head)->prev == NULL && (*head)->next == NULL){
			*head = NULL;
			return;
		}
		else if((*head)->prev == NULL){
			*head = (*head)->next;
			(*head)->prev = NULL;
			deleteNodes(head,key);
		}
		else if((*head)->next==NULL){
			(*head)->prev->next = NULL;
			return;
		}
		else {
			(*head)->prev->next = (*head)->next;
			(*head)->next->prev = (*head)->prev;
		}
	}
	if ((*head)->next != NULL){
		deleteNodes(&((*head)->next), key);
	}
}

int main()
{
   FILE *in_file  = fopen("test1.input", "r"); // read only
   FILE *out_file = fopen("test1.output", "w"); // write only 
   // test for files not existing
   if (in_file == NULL || out_file == NULL)
   {
     printf("Error! Could not open file\n");

   }
   struct linkedlist* head = NULL;
   int x;
   fscanf(in_file, "%d",&x);
   int i =0;
   while (i<x){
	char line[100];
	fscanf(in_file, "%100s", line);
	if (strcmp(line, "addhead")==0){
		if (head ==NULL){
			char line1[100];
			fscanf(in_file, "%s",line1);
			struct linkedlist *first= (struct linkedlist*)malloc(sizeof(struct linkedlist));
			strcpy((*first).key, line1);
			first->next= NULL;
			first->prev= NULL;
			head = first;
		}
		else{
			char line2[100];
			fscanf(in_file, "%s",line2);
			struct linkedlist *second= (struct linkedlist*)malloc(sizeof(struct linkedlist));
			strcpy((*second).key, line2);
			second->next = head;
			second->prev = NULL;
			head->prev = second;
			head = second;
		}
	}
	else if(strcmp(line, "print")==0){
		printList(head, out_file);
	}
	else if(strcmp(line, "addtail")==0){
		if (head ==NULL){
                        char line1[100];
                        fscanf(in_file, "%s",line1);
                        struct linkedlist *first= (struct linkedlist*)malloc(sizeof(struct linkedlist));
                        strcpy((*first).key, line1);
                        first->next= NULL;
                        first->prev= NULL;
                        head = first;
                }
		else{
                        char line2[100];
                        fscanf(in_file, "%s",line2);
                        struct linkedlist *second= (struct linkedlist*)malloc(sizeof(struct linkedlist));
                        strcpy((*second).key, line2);
                        second->next = NULL;
                        second->prev = getTail(&head);
                        second->prev->next = second;
                }
	}
	else if(strcmp(line, "del")==0){
		char line2[100];
                fscanf(in_file, "%s",line2);
		if (head != NULL){
                	deleteNodes(&head,line2);
		}
	}
	i=i+1;
   }
   return 0;
}
