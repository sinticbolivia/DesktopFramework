VLIBS=--pkg gtk+-3.0\
		--pkg gee-1.0\
		--pkg gmodule-2.0\
		--pkg SinticBolivia\
		--pkg sqlite3\
		--pkg mysql\
		--pkg libxml-2.0
SOURCES=$(wildcard *.vala) printpreview/class.print-preview.vala
LIBRARY_NAME=GtkSinticBolivia
VFLAGS=--vapidir=../ --vapidir=../printpreview
CFLAGS=-X -I.. -X -L../bin
CLIBS=-X -lSinticBolivia
all: 
	valac -o ../bin/lib$(LIBRARY_NAME).so $(SOURCES) --library=$(LIBRARY_NAME) -H $(LIBRARY_NAME).h -X -fPIC -X -shared $(VFLAGS) $(CFLAGS) $(VLIBS) $(CLIBS)
clean:
	rm -f *.vapi *.h *.c *.so
	
