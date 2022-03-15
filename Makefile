VFLAGS=-X -DGETTEXT_PACKAGE
		
VLIBS=--pkg gmodule-2.0\
	--pkg mysql\
	--pkg sqlite3\
	--pkg gee-0.8\
	--pkg gio-2.0\
	--pkg posix\
	--pkg libxml-2.0\
	--pkg json-glib-1.0
	
CLIBS=`pkg-config gio-2.0 --libs`\
		`pkg-config gmodule-2.0 --libs`\
		`pkg-config json-glib-1.0 --libs`\
		`pkg-config libxml-2.0 --libs`\
		`pkg-config gee-0.8 --libs`\
		`pkg-config sqlite3 --libs`\
		`pkg-config mysqlclient --libs`
		#-lintl

VC=valac
MACROS=-D __linux__
SOURCES=$(wildcard classes/*.vala) $(wildcard Database/*.vala)

$(info Trying to detect the operating system)
ifneq (, $(findstring /Library, $(PATH)))
OS=MACOS
DEST_LIBRARY=libSinticBolivia.dylib
$(info MACOS detected)
else ifneq (, $(findstring /usr/bin, $(PATH)))
OS=LINUX
DEST_LIBRARY=libSinticBolivia.so
$(info LINUX detected)
else ifneq (, $(findstring Windows, $(PATH)))
OS=WINDOWS_NT
DEST_LIBRARY=libSinticBolivia.dll
$(info Windows detected)
endif


LIBRARY_NAME=SinticBolivia
#include Database/Makefile

all: $(SOURCES) $(DEST_LIBRARY)

$(DEST_LIBRARY): $(SOURCES)
	@#$(VC) $(MACROS) $(VFLAGS) $(VLIBS) --library=$(LIBRARY_NAME) -H $(LIBRARY_NAME).h $(SOURCES) -X -fPIC -X -shared -o bin/$@
	$(VC) -c $(MACROS) $(VFLAGS) $(VLIBS) --library=$(LIBRARY_NAME) -H $(LIBRARY_NAME).h $(SOURCES) -X -fPIC -X -I.
	gcc -c ccode/cpuid.c -fPIC
	gcc -o $@ *.o $(CLIBS) -shared
	
	
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
	-rm $(DEST_LIBRARY)
	-rm *.h
	-rm *.o
