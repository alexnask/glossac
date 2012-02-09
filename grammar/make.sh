mkdir -p bin
greg grammatikh.leg > bin/grammatikh.c
gcc -std=c99 bin/grammatikh.c -c -o bin/grammatikh.o
