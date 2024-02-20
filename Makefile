CXX=g++
INCLUDES=-I/opt/local/include
IGNORES=-Wno-deprecated-declarations 
CPPFLAGS=-Wall -Werror -O2 -fopenmp  ${INCLUDES} ${IGNORES}

TARGETS=cmos

all: ${TARGETS}


run: cmos
	./cmos
	
	

clean:
	rm -f $(TARGETS) *.o 
