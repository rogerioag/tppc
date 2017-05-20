LEX := $(patsubst %.l,%.c,$(wildcard *.l))
YACC := $(patsubst %.y,%.tab.c,$(wildcard *.y))

all : $(YACC) $(LEX) build

parser.tab.c : parser.y
	bison -y -d -t $^ -o parser.tab.c

scanner.c : scanner.l
	flex -d -T $^
	
build :
	# gcc parser.tab.c lex.yy.c -o $@ -lfl
	gcc -c parser.tab.c lex.yy.c
	gcc parser.tab.o lex.yy.o -o tppc.exe

clean : 
	rm -f $(LEX)
	rm -f *.yy.c
	rm *.exe
	rm *.tab.[cho]
	rm *.o
