%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <stdarg.h>
  // #include "syntax-tree.h"

  /* Protótipos */
  // nodeType *opr(int oper, int nops, ...);
  // nodeType *id(int i);
  // nodeType *con(int value);
  // void freeNode(nodeType *p);
  // int ex(nodeType *p);

  int yylex(void);
  void yyerror(char *s);
  // int sym[26];	/* Tabela de Símbolos. */

  extern FILE *yyin;
  extern FILE *yyout;
%}

%union {
    int intValue;
    float floatValue;
    char *stringValue;
    int id;
}

%token DOIS_PONTOS VIRGULA ABRE_COLCHETE FECHA_COLCHETE ABRE_PARENTESES FECHA_PARENTESES ATRIBUICAO 
%token ID SE ENTAO SENAO REPITA ATE FIM 
%token INTEIRO FLUTUANTE // Tipos
%token NUM_INTEIRO NUM_PONTO_FLUTUANTE NUM_NOTACAO_CIENTIFICA
%token LEIA ESCREVA RETORNA
%token MAIS MENOS MULTIPLICACAO DIVISAO
%token MENOR MAIOR IGUAL MENOR_IGUAL MAIOR_IGUAL DIFERENTE
%token END_OF_FILE

%nonassoc IFX
%nonassoc ELSE

%left MAIOR_IGUAL MENOR_IGUAL IGUAL DIFERENTE MAIOR MENOR
%left MAIS MENOS 
%left MULTIPLICACAO DIVISAO
%nonassoc UMINUS

%%
programa :
		lista_declaracoes					{ printf(""); }
		;

lista_declaracoes : 
				lista_declaracoes declaracao { printf(""); }
				| declaracao  				 { printf(""); }
				;

declaracao :
			declaracao_variaveis			 { printf(""); }
			| inicializacao_variaveis		 { printf(""); }
			| declaracao_funcao				 { printf(""); }
			;

declaracao_variaveis :
					tipo DOIS_PONTOS lista_variaveis	{ printf(""); }
					;

inicializacao_variaveis :
						atribuicao				{ printf(""); }
						;

lista_variaveis :
				lista_variaveis VIRGULA var		{ printf(""); }
				| var 							{ printf(""); }
				;

var :
	ID 											{ printf(""); }
	| ID indice 								{ printf(""); }
	;

indice :
		indice ABRE_COLCHETE expressao FECHA_COLCHETE		{ printf(""); }
		| ABRE_COLCHETE expressao FECHA_COLCHETE 			{ printf(""); }
		;

tipo :
	INTEIRO  					{ printf(""); }
	| FLUTUANTE 				{ printf(""); }
	;

declaracao_funcao :
				tipo cabecalho  				{ printf(""); }
				| cabecalho  					{ printf(""); }
				;

cabecalho :
			ID ABRE_PARENTESES lista_parametros FECHA_PARENTESES corpo FIM  		{ printf(""); }
			;

lista_parametros :
				lista_parametros VIRGULA parametro  		{ printf(""); }
				| parametro  							{ printf(""); }
				| /*vazio*/
				;

parametro :
			tipo DOIS_PONTOS ID 						{ printf(""); }
			|  parametro ABRE_COLCHETE FECHA_COLCHETE  				{ printf(""); }
			;

corpo :
	corpo acao  				{ printf(""); }
	| /*vazio*/
	;

acao :
	expressao 						{ printf(""); }
	| declaracao_variaveis 			{ printf(""); }
	| se 							{ printf(""); }
	| repita 						{ printf(""); }
	| leia 							{ printf(""); }
	| escreva 						{ printf(""); }
	| retorna 						{ printf(""); }
	| /*erro*/ 						{ printf("Erro!"); }
	;

se :
	SE expressao ENTAO corpo FIM  					{ printf(""); }
	| SE expressao ENTAO corpo SENAO corpo FIM		{ printf(""); }
	;

repita :
		REPITA corpo ATE expressao  				{ printf(""); }
		;

atribuicao :
			var ATRIBUICAO expressao  					{ printf(""); }
			;

leia :
		LEIA ABRE_PARENTESES ID FECHA_PARENTESES  						{ printf(""); }
		;

escreva :
		ESCREVA ABRE_PARENTESES expressao FECHA_PARENTESES  			{ printf(""); }
		;

retorna :
		RETORNA ABRE_PARENTESES expressao FECHA_PARENTESES  			{ printf(""); }
		;

expressao :
			expressao_simples  				{ printf(""); }
			| atribuicao  					{ printf(""); }
			;

expressao_simples :
					expressao_aditiva  														{ printf(""); }
					| expressao_simples operador_relacional expressao_aditiva  				{ printf(""); }
					;

expressao_aditiva :
					expressao_multiplicativa  												{ printf(""); }
					| expressao_aditiva operador_soma expressao_multiplicativa 				{ printf(""); }
					;

expressao_multiplicativa :
					expressao_unaria  														{ printf(""); }
					| expressao_multiplicativa operador_multiplicacao expressao_unaria 		{ printf(""); }
					;

expressao_unaria :
				fator							 	{ printf(""); }
				| operador_soma expressao 			{ printf(""); }
				;

operador_relacional :
					MENOR /*"<"*/					{ printf(""); }
					| MAIOR /*">"*/  				{ printf(""); }
					| IGUAL /*="*/ 					{ printf(""); }
					| DIFERENTE /*"<>"*/  			{ printf(""); }
					| MENOR_IGUAL /*"<="*/  		{ printf(""); }
					| MAIOR_IGUAL /*">="*/ 			{ printf(""); }
					; 				
operador_soma :
				MAIS /*"+"*/				{ printf(""); }
				| MENOS /*"-"*/ 			{ printf(""); }
				;

operador_multiplicacao :
						MULTIPLICACAO /*"*"*/			{ printf(""); }
						| DIVISAO /*"/"*/ 				{ printf(""); }
						;

fator :
		ABRE_PARENTESES expressao FECHA_PARENTESES 			{ printf(""); }
		| var 						{ printf(""); }
		| chamada_funcao 			{ printf(""); }
		| numero 					{ printf(""); }
		;

numero :
		NUM_INTEIRO 				{ printf(""); }
		| NUM_PONTO_FLUTUANTE 		{ printf(""); }
		| NUM_NOTACAO_CIENTIFICA 	{ printf(""); }
		;

chamada_funcao :
				ID ABRE_PARENTESES lista_argumentos FECHA_PARENTESES  	{ printf(""); }
				;

lista_argumentos :
					lista_argumentos VIRGULA expressao  	{ printf(""); }
					| expressao 						{ printf(""); }
					| /*vazio*/
					;

%%


void yyerror(char *s) {
	fprintf(stdout, "%s\n", s);
}

/*int main(void) {
	yyparse();
	return 0;
}*/

int main(int argc, char *argv[]){
	yyin = fopen(argv[1], "r");
	
	yyparse();
	
	fclose(yyin);

	return 0;
}
