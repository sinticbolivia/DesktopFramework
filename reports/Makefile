VFLAGS=-X -DGETTEXT_PACKAGE\
		-X -I..
		#-X -I../../libs/libharu/libharu-RELEASE_2_2_0/include
		
PKG = --pkg gmodule-2.0\
	--pkg gee-0.8\
	--pkg gio-2.0\
	--pkg posix\
	--pkg libharu\
	--pkg SinticBolivia\
	--pkg sqlite3\
	--pkg mysql\
	--pkg libxml-2.0\
	--pkg json-glib-1.0
		
VLIBS=-X -L.. -X -lSinticBolivia\
		-X /usr/local/lib/libharu.a
		#-X -L/usr/local/lib -X -l:libharu.a
		#-L../../libs/libharu/libharu-RELEASE_2_2_0/src -lhpdf
		#-ljson-glib-1.0\
		#-lxml2\
		#-lsqlite3\
		#-lmysql
		
VAPI=--vapidir=.. --vapidir=../vapi\
		--vapidir=../../libs/libharu
		
VC=valac
SOURCES=$(wildcard *.vala)
OBJ=$(wildcard *.o)

ifneq ($(wildcard /Library/.*),)
OS=MACOS
DEST_LIBRARY=libSinticBoliviaReports.dylib
$(info MACOS detected)
else ifneq (, $(findstring /usr/bin, $(PATH)))
OS=LINUX
DEST_LIBRARY=libSinticBoliviaReports.so
endif

LIBRARY_NAME=SinticBoliviaReports
#include Database/Makefile
all: $(SOURCES) $(DEST_LIBRARY)

$(DEST_LIBRARY): $(SOURCES)
	@#$(VC) -c -D __linux__ $(VFLAGS) $(VAPI) $(PKG) --library=$(LIBRARY_NAME) -H $(LIBRARY_NAME).h $(SOURCES) -X -fPIC
	@#gcc -o ../bin/$@ *.o $(VLIBS) -shared
	@#rm *.o
	$(VC) -o ../$@ -D __linux__ $(VFLAGS) $(VAPI) $(VLIBS) $(PKG) --library=$(LIBRARY_NAME) -H $(LIBRARY_NAME).h $(SOURCES) -X -fPIC -X -shared
clean:
	rm -fv bin/$(DEST_LIBRARY) *.h *.c *.o
