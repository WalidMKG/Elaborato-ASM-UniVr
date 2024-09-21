AS_FLAGS = --32 
DEBUG = -gstabs
LD_FLAGS = -m elf_i386

all: bin/pianificatore

bin/pianificatore: obj/pianificatore.o obj/EDF.o obj/atoi.o obj/Sorter.o obj/task.o obj/printInt.o obj/HPF.o
	ld $(LD_FLAGS)	obj/pianificatore.o obj/EDF.o obj/atoi.o obj/Sorter.o obj/task.o obj/printInt.o obj/HPF.o -o bin/pianificatore

obj/pianificatore.o: src/pianificatore.s
	as $(AS_FLAGS) $(DEBUG) src/pianificatore.s -o obj/pianificatore.o

obj/EDF.o: src/EDF.s
	as $(AS_FLAGS) $(DEBUG) src/EDF.s -o obj/EDF.o

obj/atoi.o: src/atoi.s
	as $(AS_FLAGS) $(DEBUG) src/atoi.s -o obj/atoi.o

obj/Sorter.o: src/Sorter.s
	as $(AS_FLAGS) $(DEBUG) src/Sorter.s -o obj/Sorter.o

obj/task.o: src/task.s
	as $(AS_FLAGS) $(DEBUG) src/task.s -o obj/task.o

obj/printInt.o: src/printInt.s
	as $(AS_FLAGS) $(DEBUG) src/printInt.s -o obj/printInt.o
	
obj/HPF.o: src/HPF.s
	as $(AS_FLAGS) $(DEBUG) src/HPF.s -o obj/HPF.o
clean:
	rm -f obj/*.o bin/pianificatore
	