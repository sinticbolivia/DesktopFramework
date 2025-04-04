VLIBS=--pkg gmodule-2.0 --pkg gtk+-3.0\
		--pkg gee-0.8\
		--pkg sqlite3\
		--pkg mysql\
		--pkg libpq\
		--pkg libxml-2.0\
		--pkg json-glib-1.0\
		--pkg libsoup-3.0\
		--pkg SinticBolivia

SOURCES=$(wildcard *.vala) printpreview/class.print-preview.vala
LIBRARY_NAME=GtkSinticBolivia
#VFLAGS=--vapidir=../ --vapidir=../printpreview
VFLAGS=--vapidir=../build
CFLAGS=-X -I. -X -I../build -X -L../build
CLIBS=$(shell pkg-config --libs gmodule-2.0) $(shell pkg-config --libs gtk+-3.0) $(shell pkg-config --libs gee-0.8)\
	-L../build -lSinticBolivia

#ifneq (, $(findstring /Library, $(PATH)))
ifneq ($(wildcard /Library/.*),)
OS=MACOS
DEST_LIBRARY=lib$(LIBRARY_NAME).dylib
$(info MACOS detected)
else ifneq (, $(findstring /usr/bin, $(PATH)))
OS=LINUX
DEST_LIBRARY=lib$(LIBRARY_NAME).so
$(info LINUX detected)
else ifneq (, $(findstring Windows, $(PATH)))
OS=WINDOWS_NT
DEST_LIBRARY=lib$(LIBRARY_NAME).so
$(info Windows detected)
endif

all:
	valac -c $(SOURCES) $(VFLAGS) $(CFLAGS) $(VLIBS) -X -fPIC --library=$(LIBRARY_NAME) -H $(LIBRARY_NAME).h
	# valac -o $(LIBRARY_NAME).so $(SOURCES) --library=$(LIBRARY_NAME) -H $(LIBRARY_NAME).h -X -fPIC -X -shared $(VFLAGS) $(CFLAGS) $(VLIBS) $(CLIBS)
	gcc -shared -fPIC -o $(DEST_LIBRARY) $(CLIBS) *.o
clean:
	-rm -f *.o *.vapi *.h $(DEST_LIBRARY)
