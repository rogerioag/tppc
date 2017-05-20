/*
  Scanner of tppc
*/
%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h> // toupper

// #include "syntax-tree.h"
#include "parser.tab.h"

void yyerror(char *);
extern int yy_flex_debug;

// extern char * _strupr(char *);

char *strlwr(char *);

char *strupr(char *);

int resWord(char *);

int symLookup(char *);

/* Número da linha. */
int line_num = 1;
%}

/* Definições */
DIGITO          [0-9]+
LETRA           [a-zA-Z]+
ID              {LETRA}({LETRA}|{DIGITO})*
NUM_NATURAL     {DIGITO}+
NUM_INTEIRO     ([-+]?{NUM_NATURAL})

NUM_PONTO_FLUTUANTE ({NUM_INTEIRO}"."{NUM_INTEIRO})

NUM_NOTACAO_CIENTIFICA ({NUM_PONTO_FLUTUANTE}[eE]{NUM_INTEIRO})

ESPACO_EM_BRANCO [ \n\r\t]+

%x      COMENTARIO

%option case-sensitive
 
%% /* Regras com padrões e ações. */

{ID}    {   
    // ECHO;
    // yylval = ID;
    // printf("%d: %s -> %d", line_num, yytext, yylval);
    // yylval.sIndex = *yytext - 'a';
    printf("<ID, %s>\n", yytext);
    // yylval.stringValue = (char*)realloc(v, yyleng *sizeof(char));
    // strcpy(yylval.stringValue,yytext);
    // return ID;
    int i;
    if((i = isPalavraReservada(yytext)) != 0)
        return i;
    yylval.id = simboloLookup(yytext);
    return ID;
}

"="             { printf("<SB, %s>\n", yytext); return IGUAL; }
":"             { printf("<SB, %s>\n", yytext); return DOIS_PONTOS; }
":="            { printf("<SB, %s>\n", yytext); return ATRIBUICAO; }
"<"             { printf("<SB, %s>\n", yytext); return MENOR; }
"<="            { printf("<SB, %s>\n", yytext); return MENOR_IGUAL; }
">"             { printf("<SB, %s>\n", yytext); return MAIOR; }
">="            { printf("<SB, %s>\n", yytext); return MAIOR_IGUAL; }
"<>"            { printf("<SB, %s>\n", yytext); return DIFERENTE; }
"("             { printf("<SB, %s>\n", yytext); return ABRE_PARENTESES; }
")"             { printf("<SB, %s>\n", yytext); return FECHA_PARENTESES; }
"["             { printf("<SB, %s>\n", yytext); return ABRE_COLCHETE; }
"]"             { printf("<SB, %s>\n", yytext); return FECHA_COLCHETE; }
","             { printf("<SB, %s>\n", yytext); return VIRGULA; }
"+"             { printf("<SB, %s>\n", yytext); return MAIS; }
"-"             { printf("<SB, %s>\n", yytext); return MENOS; }
"*"             { printf("<SB, %s>\n", yytext); return MULTIPLICACAO; }
"/"             { printf("<SB, %s>\n", yytext); return DIVISAO; }

{NUM_INTEIRO}   {
    printf("<NUM, %s>\n", yytext);
    // yylval.intValue = atoi(yytext);
    return NUM_INTEIRO;
}

{NUM_PONTO_FLUTUANTE}   {
    printf("<NUM, %s>\n", yytext);
    // yylval.floatValue = atof(yytext);
    return NUM_PONTO_FLUTUANTE;
}

{NUM_NOTACAO_CIENTIFICA}    {
    printf("<NUM, %s>\n", yytext);
    return NUM_NOTACAO_CIENTIFICA;
}

{ESPACO_EM_BRANCO} {
    /* Não faz nada, Consome. */
}


\{(.*?)\}   {
    /*Comentário, ignorado. */
}

"{" { BEGIN(COMENTARIO); }
<COMENTARIO>{
    "}" { BEGIN(INITIAL); }
    <<EOF>> { printf("EOF in comment\n"); }
    . {}
}

<<EOF>>     return END_OF_FILE;

.		/* anything else is an error */
		yyerror("Caracter Inválido");

%% /* Código do Usuário */
/* A função yywrap */
int yywrap(void){
    return 1;
}

char *strlwr(char *str)
{
  unsigned char *p = (unsigned char *)str;

  while (*p) {
     *p = tolower((unsigned char)*p);
      p++;
  }

  return str;
}

char *strupr(char *str)
{
  unsigned char *p = (unsigned char *)str;

  while (*p) {
     *p = toupper((unsigned char)*p);
      p++;
  }

  return str;
}

int resWord(char *lexema){
    return 272;
}

int symLookup(char *lexema){
    return 1000;
}


/*int main(int argc, char *argv[]){
    yyin = fopen(argv[1], "r");
    int token = 0;
    yy_flex_debug = 1;
    while((token = yylex()) != END_OF_FILE){
        // printf("Token: %d\n", token);
    }
    
    fclose(yyin);

    return 0;
}*/