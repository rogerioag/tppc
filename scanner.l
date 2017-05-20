%{
// #include "parser.h"

void yyerror(char *);

/* Token type, será gerado depois pelo yacc. */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
enum yytokentype
{
    END_OF_FILE = 258,
    T_NUM_INTEIRO = 259,
	T_NUM_PONTO_FLUTUANTE = 260,
    T_NUM_NOTACAO_CIENTIFICA = 261,
    T_ID = 262,
    T_PR = 263,
    T_IGUAL = 264,
    T_DOIS_PONTOS = 265,
    T_ATRIBUICAO = 266,
    T_MENOR = 267,
    T_MENOR_IGUAL = 268,
    T_MAIOR = 269,
    T_MAIOR_IGUAL = 270,
    T_DIFERENTE = 271,
    T_ABRE_PARENTESES = 272, 
    T_FECHA_PARENTESES = 273,
    T_ABRE_COLCHETE = 274,
    T_FECHA_COLCHETE = 275,
    T_ABRE_CHAVE = 276,
    T_FECHA_CHAVE = 277,
    T_VIRGULA = 278, 
    T_MAIS = 279, 
    T_MENOS = 280,
    T_MULTIPLICACAO = 281,
    T_DIVISAO = 282,
    COMENTARIO_NAO_FINALIZADO = 283
};
#endif

int yylval;

/* Número da linha. */
int line_num = 1;
%}
 
/* Definições */
DIGITO			[0-9]+
LETRA			[a-zA-Z]+
ID 				{LETRA}({LETRA}|{DIGITO})*
NUM_NATURAL		{DIGITO}+
NUM_INTEIRO		([-+]?{NUM_NATURAL})
NUM_PONTO_FLUTUANTE	({NUM_INTEIRO}"."{NUM_INTEIRO})

NUM_NOTACAO_CIENTIFICA ({NUM_PONTO_FLUTUANTE}[eE]{NUM_INTEIRO})

PALAVRA_RESERVADA	(leia|escreva|principal|se|então|senão|repita|até|fim|retorna|inteiro|flutuante)

ESPACO_EM_BRANCO [ \n\r\t]+

%x 		COMENTARIO

%option case-sensitive
 
%% /* Regras com padrões e ações. */

{PALAVRA_RESERVADA}	{
	printf("<PR, %s>\n", yytext);
	return T_PR; 
}

{ID}	{   
	// ECHO;
	// yylval = T_ID;
	// printf("%d: %s -> %d", line_num, yytext, yylval); 
	printf("<ID, %s>\n", yytext);
	return T_ID;
}

"="             { printf("<SB, %s>\n", yytext); return T_IGUAL; }
":"             { printf("<SB, %s>\n", yytext); return T_DOIS_PONTOS; }
":="            { printf("<SB, %s>\n", yytext); return T_ATRIBUICAO; }
"<"             { printf("<SB, %s>\n", yytext); return T_MENOR; }
"<="            { printf("<SB, %s>\n", yytext); return T_MENOR_IGUAL; }
">"             { printf("<SB, %s>\n", yytext); return T_MAIOR; }
">="            { printf("<SB, %s>\n", yytext); return T_MAIOR_IGUAL; }
"<>"            { printf("<SB, %s>\n", yytext); return T_DIFERENTE; }
"("             { printf("<SB, %s>\n", yytext); return T_ABRE_PARENTESES; }
")"             { printf("<SB, %s>\n", yytext); return T_FECHA_PARENTESES; }
"["             { printf("<SB, %s>\n", yytext); return T_ABRE_COLCHETE; }
"]"             { printf("<SB, %s>\n", yytext); return T_FECHA_COLCHETE; }
","             { printf("<SB, %s>\n", yytext); return T_VIRGULA; }
"+"             { printf("<SB, %s>\n", yytext); return T_MAIS; }
"-"             { printf("<SB, %s>\n", yytext); return T_MENOS; }
"*"             { printf("<SB, %s>\n", yytext); return T_MULTIPLICACAO; }
"/"             { printf("<SB, %s>\n", yytext); return T_DIVISAO; }

{NUM_INTEIRO}	{
	printf("<NUM, %s>\n", yytext);
	return T_NUM_INTEIRO;
}

{NUM_PONTO_FLUTUANTE}	{
	printf("<NUM, %s>\n", yytext);
	return T_NUM_PONTO_FLUTUANTE;
}

{NUM_NOTACAO_CIENTIFICA}    {
    printf("<NUM, %s>\n", yytext);
    return T_NUM_NOTACAO_CIENTIFICA;
}

{ESPACO_EM_BRANCO} {
	/* Não faz nada, Consome. */
}


\{(.*?)\}	{
	/*Comentário, ignorado. */
}

"{" { BEGIN(COMENTARIO); }
<COMENTARIO>{
    "}" { BEGIN(INITIAL); }
    <<EOF>> { printf("EOF in comment\n"); }
    . {}
}

<<EOF>>     return END_OF_FILE;


%% /* Código do Usuário */
/* A função yywrap */
int yywrap(void){
	return 1;
}

extern int yy_flex_debug;
int main(int argc, char *argv[]){
	yyin = fopen(argv[1], "r");
	int token = 0;
	yy_flex_debug = 1;
	while((token = yylex()) != END_OF_FILE){
		// printf("Token: %d\n", token);
	}
	
	fclose(yyin);

	return 0;
}
