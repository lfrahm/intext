# makefile

COMP = gfortran

SOURCES = $(wildcard ./*.f90)
FILENAME = $(patsubst %.f90,%,$(SOURCES))

.SUFFIXES: .f90

.PHONY: main $(SOURCES)

all: main

re: clean main

main: $(SOURCES)

$(SOURCES):
	$(COMP) -o $(patsubst %.f90,%,$@) $@

clean:
	rm -f $(FILENAME)
