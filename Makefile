PROGRAM = nanotts
TARGETS = svoxpico/.libs/libttspico.a
#OPT_FLAG = -O2
OPT_FLAG = 
SHELL := /bin/bash

$(PROGRAM): $(TARGETS) 
pico: $(TARGETS)
all: $(PROGRAM)

svoxpico/.libs/libttspico.a:
	cd svoxpico; ./autogen.sh && ./configure && make

nanotts:
	g++ -I. -I./svoxpico -Wall -g ${OPT_FLAG} -c -o nanotts.o src/nanotts.cpp
	g++ -I. -I./svoxpico -Wall -g ${OPT_FLAG} -c -o mmfile.o src/mmfile.cpp
	g++ -L./svoxpico/.libs mmfile.o nanotts.o svoxpico/.libs/libttspico.a -g ${OPT_FLAG} -o nanotts -lao -ldl -lm

clean:
	for file in mmfile.o nanotts.o nanotts pico2wave pico2wave.o ; do if [ -f $${file} ]; then rm $${file}; echo rm $${file}; fi; done
	cd svoxpico; make clean ; ./clean.sh

pico:
	gcc -I. -I./svoxpico -Wall -g ${OPT_FLAG} -c -o pico2wave.o src/pico2wave.c
	gcc -I./svoxpico -Wall -g ${OPT_FLAG} pico2wave.o svoxpico/.libs/libttspico.a -o pico2wave -lm -lpopt
