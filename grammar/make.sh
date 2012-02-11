mkdir -p bin
greg grammatikh.leg > bin/grammatikh.c
gcc -std=c99 -DUSE_GC bin/grammatikh.c -c -o bin/grammatikh.o
