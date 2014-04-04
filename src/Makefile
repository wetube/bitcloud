CC=gcc
CFLAGS=-Wall
LDLIBS=-lsqlite3

bitcloud: main.o bitcloud.a
	$(CC) -o $@ $^ $(LDLIBS)

tests: bitcloud.a
	cd tests && $(MAKE)

bitcloud.a: nodepool.o
	ar -cvq $@ $^

main.o: main.c bitcloud.h
	$(CC) $(CFLAGS) -c $<

nodepool.o: nodepool.c nodepool_sql.h bitcloud.h
	$(CC) $(CFLAGS) -c $<

# careful, everytime nodepool.sql is modified the nodepool is deleted:
nodepool_sql.h: nodepool.sql
	rm -f nodepool
	xxd -i $< > nodepool_sql.h

clean:
	rm -f *.o *.a nodepool nodepool_sql.h bitcloud
	cd tests && $(MAKE) clean
