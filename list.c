
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
struct linkedlist{
   struct linkedlist* prev;
   struct linkedlist* next;
   char key[2000];
} ;

void printList(struct linkedlist* head, FILE *out_file){
   if (head == NULL){
	fprintf(out_file, "EMPTY\n");
	return;
   }
   char prev[100];
   if (head->prev == NULL){
	strcpy(prev, "HEAD");
   }
   else{
	strcpy(prev,head->prev->key);
   }
   char next[100];
   if (head->next == NULL){
        strcpy(next, "TAIL");
   }
   else{
        strcpy(next, head->next->key);
   }
   fprintf(out_file, "(%s,%s,%s)",head->key,prev,next);
   if (strcmp(next,"TAIL")!=0){
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
			struct linkedlist *tmp;
                        tmp=*head;
			*head = NULL;
			free(tmp);
			return;
		}
		else if((*head)->prev == NULL){
			struct linkedlist *tmp;
                        tmp=*head;
			*head = (*head)->next;
			(*head)->prev = NULL;
			free(tmp);
			deleteNodes(head,key);
		}
		else if((*head)->next==NULL){
			struct linkedlist *tmp;
                        tmp=*head;
			(*head)->prev->next = NULL;
			free(tmp);
			return;
		}
		else {
			struct linkedlist *tmp;
			tmp=*head;
			(*head)= tmp->next;
			(*head)->prev=tmp->prev;
			free(tmp);
		}
	}

	if ((*head)->next != NULL){
		deleteNodes(&((*head)->next), key);
	}
}

void freeList(struct linkedlist* head)
{
   struct linkedlist* tmp;

   while (head != NULL)
    {
       tmp = head;
       head = head->next;
       free(tmp);
    }

}

int main(int argc, char *argv[])
{
   FILE *in_file  = fopen(argv[1], "r"); // read only
   FILE *out_file = fopen(argv[2], "w"); // write only 
   // test for files not existing
   if (in_file == NULL || out_file == NULL)
   {
     printf("Error! Could not open file\n");

   }
   char empty[]="EMPTY";
   char headc[]="HEAD";
   char tail[]="TAIL";
   struct linkedlist* head = NULL;
   int x=1;
   //fscanf(in_file, "%d",&x);
   //int i =0;
   while (x==1){
	char line[100];
	x=fscanf(in_file, "%100s", line);
	if (x!=1){
		break;
	}
	if (strcmp(line, "addhead")==0){
		char line1[2000];
                fscanf(in_file, " %[^\n]",line1);
		if (strcmp(headc,line1)!=0 && strcmp(tail,line1)!=0 && strcmp(empty, line1)!=0){

			if (head ==NULL){
				struct linkedlist *first= (struct linkedlist*)malloc(sizeof(struct linkedlist));
				strcpy((*first).key, line1);
				first->next= NULL;
				first->prev= NULL;
				head = first;
			}
			else{
				struct linkedlist *second= (struct linkedlist*)malloc(sizeof(struct linkedlist));
				strcpy((*second).key, line1);
				second->next = head;
				second->prev = NULL;
				head->prev = second;
				head = second;
			}
		}
	}
	else if(strcmp(line, "print")==0){
		printList(head, out_file);
	}
	else if(strcmp(line, "addtail")==0){
		char line1[2000];
                fscanf(in_file, " %[^\n]",line1);
		if (strcmp(headc,line1)!=0 && strcmp(tail,line1)!=0 && strcmp(empty, line1)!=0){
			if (head ==NULL){
                        	struct linkedlist *first= (struct linkedlist*)malloc(sizeof(struct linkedlist));
                        	strcpy((*first).key, line1);
                        	first->next= NULL;
                        	first->prev= NULL;
                        	head = first;
                	}
			else{
                        	struct linkedlist *second= (struct linkedlist*)malloc(sizeof(struct linkedlist));
                        	strcpy((*second).key, line1);
                        	second->next = NULL;
                        	second->prev = getTail(&head);
                        	second->prev->next = second;
                	}
		}
	}
	else if(strcmp(line, "del")==0){
		char line2[2000];
                fscanf(in_file,  " %[^\n]",line2);
		if (head != NULL){
                	deleteNodes(&head,line2);
		}
	}
	//i=i+1;
   }
   fclose(in_file);
   fclose(out_file);
   freeList(head);
   return 0;
}
