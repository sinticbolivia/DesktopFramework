VFLAGS=-X -DGETTEXT_PACKAGE\
		-X -I..\
		-X -I../../libs/libharu/libharu-RELEASE_2_2_0/include
		
PKG = --pkg gmodule-2.0\
		--pkg gee-1.0\
		--pkg gio-2.0\
		--pkg posix\
		--pkg libharu\
		--pkg SinticBolivia\
		--pkg sqlite3\
		--pkg mysql\
		--pkg libxml-2.0
		#--pkg json-glib-1.0
		
VLIBS=-L../bin -lSinticBolivia\
		-L../../libs/libharu/libharu-RELEASE_2_2_0/src -lhpdf
		#-ljson-glib-1.0\
		#-lxml2\
		#-lsqlite3\
		#-lmysql
VAPI=--vapidir=..\
		--vapidir=../../libs/libharu		
		
VC=valac
SOURCES=$(wildcard *.vala)
OBJ=$(wildcard *.o)
DEST_LIBRARY=libSinticBoliviaReports.so
LIBRARY_NAME=SinticBoliviaReports
#include Database/Makefile
all: $(SOURCES) $(DEST_LIBRARY)

$(DEST_LIBRARY): $(SOURCES)
	@#$(VC) -c -D __linux__ $(VFLAGS) $(VAPI) $(PKG) --library=$(LIBRARY_NAME) -H $(LIBRARY_NAME).h $(SOURCES) -X -fPIC
	@#gcc -o ../bin/$@ *.o $(VLIBS) -shared
	@#rm *.o
	$(VC) -o ../bin/$@ -D __linux__ $(VFLAGS) $(VAPI) $(PKG) --library=$(LIBRARY_NAME) -H $(LIBRARY_NAME).h $(SOURCES) -X -fPIC -X -shared
clean:
	rm -fv bin/$(DEST_LIBRARY) *.h *.c *.o
