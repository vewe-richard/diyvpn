
CC = gcc

objects = diyvpn.o server.o client.o 



all: diyvpn simpletun



diyvpn: $(objects)

	$(CC) -o $@ $+

simpletun:
	$(CC) simpletun.c -o simpletun



%.o:%.c

	$(CC) -c $+

clean:
	$(RM) *.o diyvpn simpletun
