CFLAGS=-Wall
LDLIBS=-lsqlite3

bitcloud: main.o
	$(CC) -o $@ $^ $(LDLIBS)
main.o: main.c bitcloud.h
	$(CC) $(CFLAGS) -c $<
