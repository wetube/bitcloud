CC=gcc
LDLIBS=-lsqlite3 ../bitcloud.a
INCLUDES=-I..
CFLAGS=-Wall

run_tests_and_clean: clean run_tests

run_tests: tests
	@echo -- STARTING TESTS --
	@./tests
	@echo -- ALL TESTS PASSED --
	@echo -- LOGS --
	sqlite3 nodepool "select * from logs"


tests: main.c
	@$(CC) -o $@ $^ $(INCLUDES) $(LDLIBS)

clean:
	@rm -f tests nodepool
