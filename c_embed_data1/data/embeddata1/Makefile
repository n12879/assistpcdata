build: main.o data.txt
	cc -o main main.o
	lua concatcode.lua

run: build
	./main_out

main.o: main.c

clean:
	-@ rm -f ./main main.o ./main_out

distclean: clean
	-@ rm -f *~
	-@ rm -f *.o

