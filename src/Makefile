CC=gcc
CFLAGS=-Wall
LDLIBS=-lsqlite3

bitcloud: main.o nodepool.o
	$(CC) -o $@ $^ $(LDLIBS)

main.o: main.c bitcloud.h
	$(CC) $(CFLAGS) -c $<

nodepool.o: nodepool.c nodepool_sql.h bitcloud.h
	$(CC) $(CFLAGS) -c $<

# careful, everytime nodepool.sql is modified the nodepool is deleted:
nodepool_sql.h: nodepool.sql
	rm -f nodepool
	xxd -i $< > nodepool_sql.h

clean:
	rm -f *.o nodepool nodepool_sql.h bitcloud
