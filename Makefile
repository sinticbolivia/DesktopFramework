VFLAGS=-X -DGETTEXT_PACKAGE --vapidir=../libs/libharu
VLIBS=--pkg gmodule-2.0\
	--pkg mysql\
	--pkg sqlite3\
	--pkg gee-1.0\
	--pkg gio-2.0\
	--pkg posix\
	--pkg libxml-2.0\
	--pkg json-glib-1.0
VC=valac
MACROS=-D __linux__
SOURCES=$(wildcard *.vala) $(wildcard classes/*.vala) $(wildcard Database/*.vala)
DEST_LIBRARY=libSinticBolivia.so
LIBRARY_NAME=SinticBolivia
#include Database/Makefile

all: $(SOURCES) $(DEST_LIBRARY)

$(DEST_LIBRARY): $(SOURCES)
	$(VC) $(MACROS) $(VFLAGS) $(VLIBS) --library=$(LIBRARY_NAME) -H $(LIBRARY_NAME).h $(SOURCES) -X -fPIC -X -shared -o bin/$@
	
	
#$(OBJECTS): $(SOURCES)
	#$(VC) $(VFLAGS) $< -c $(OBJECTS)
#	$(VC) $(VFLAGS) -c $(SOURCES)
#modules section
#$(MODULES): 
#	cd $<; make $<	
#.vala.o:
#	$(VC) $(VFLAGS) $< -o $@
test: test.vala
	$(VC) -X -I. -X -L./bin $(VLIBS) -X -l$(LIBRARY_NAME) $(LIBRARY_NAME).vapi  test.vala -o bin/test 
clean:
	rm -fv bin/$(DEST_LIBRARY)
	rm *.h
	rm *.c
	rm *.o
