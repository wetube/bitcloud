CFLAGS=-Wall
LDLIBS=-lsqlite3 -luv

bitcloud: main.o nodepool.o
	$(CC) -o $@ $^ $(LDLIBS)
main.o: main.c bitcloud.h
	$(CC) $(CFLAGS) -c $<
nodepool.o: nodepool.c nodepool_sql.h
	$(CC) $(CFLAGS) -c $<

nodepool_sql.h: nodepool.sql
	xxd -i $< > nodepool_sql.h
clean:
	rm *.o nodepool nodepool_sql.h bitcloud
