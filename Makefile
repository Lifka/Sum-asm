###############################################################################
# Makefile
###############################################################################

SHELL = /bin/bash # for ubuntu

###############################################################################

SRC = $(wildcard *.c *.cc)
ASM = $(wildcard *.s)
EXE = $(basename $(ASM) $(SRC))
ATT = $(EXE:=.att)

###############################################################################

ASFLAGS = -m32 -g -nostartfiles
CFLAGS = -g3 -m32 -fno-omit-frame-pointer -Os -Wall
CXXFLAGS = $(CFLAGS)

###############################################################################

default: $(EXE)

all: 	default $(ATT)

clean:
	$(RM) -rfv $(ATT) $(EXE) core.* *.o *~

###############################################################################

%.att:	%.o
	objdump -C -d $< > $@

%.att:	%
	objdump -C -d $< > $@

###############################################################################

.PHONY: all clean default

