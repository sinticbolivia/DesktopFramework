VC=/opt/local/bin/valac
MACROS=-D __linux__ -D LIBPQ_9_3
PKG_CONFIG=pkg-config
# EXPORT_PKG_CONFIG_PATH=/usr/local/opt/libpq/lib/pkgconfig
#export PKG_CONFIG_PATH=$(EXPORT_PKG_CONFIG_PATH)
#AUX = $(shell $(PKG_CONFIG) libpq --cflags --libs)
#$(info $(PKG_CONFIG_PATH))
#$(info $(AUX))
USELIB_MYSQL = $(shell pkg-config --exists mysqlclient;echo $$?)
USELIB_MARIADB = $(shell pkg-config --exists libmariadb;echo $$?)
LIBSOUP_3 = $(shell pkg-config --exists libsoup-3.0;echo $$?)
LIBSOUP_2 = $(shell pkg-config --exists libsoup-2.4;echo $$?)
LIBSOUP=
#@echo $(USELIB_MYSQL)
#$(info mysql:$(USELIB_MYSQL))
#$(info mariadb:$(USELIB_MARIADB))
MYSQL_LIB=mysqlclient
VALA_MYSQL_LIB=mysql

ifeq ($(USELIB_MARIADB), 0)
$(info INFO: Using Maridb connector)
MYSQL_LIB=libmariadb
else
$(info INFO: Using MySQL connector)
MYSQL_LIB=mysqlclient
endif
ifeq ($(LIBSOUP_3), 0)
$(info INFO: Using libsoup-3.0)
LIBSOUP=libsoup-3.0
else
$(info INFO: Using libsoup-2.4)
LIBSOUP=libsoup-2.4
MACROS :=-D __SOUP_VERSION_2_70__
endif
#$(info $(USELIB_MYSQL))

VFLAGS=-X -DGETTEXT_PACKAGE

VLIBS=--pkg gmodule-2.0\
	--pkg $(VALA_MYSQL_LIB)\
	--pkg sqlite3\
	--pkg libpq\
	--pkg gee-0.8\
	--pkg gio-2.0\
	--pkg posix\
	--pkg libxml-2.0\
	--pkg json-glib-1.0\
	--pkg $(LIBSOUP)

CLIBS=`$(PKG_CONFIG) gio-2.0 --libs`\
		`$(PKG_CONFIG) gmodule-2.0 --libs`\
		`$(PKG_CONFIG) json-glib-1.0 --libs`\
		`$(PKG_CONFIG) libxml-2.0 --libs`\
		`$(PKG_CONFIG) gee-0.8 --libs`\
		`$(PKG_CONFIG) $(LIBSOUP) --libs`\
		`$(PKG_CONFIG) sqlite3 --libs`\
		`$(PKG_CONFIG) $(MYSQL_LIB) --libs`\
		`$(PKG_CONFIG) libpq --libs`
		#-lintl


SOURCES=$(wildcard classes/*.vala) $(wildcard Database/*.vala)

$(info Trying to detect the operating system)
#ifneq (, $(findstring /Library, $(PATH)))
ifneq ($(wildcard /Library/.*),)
OS=MACOS
PKG_CONFIG=/usr/local/bin/pkg-config
DEST_LIBRARY=libSinticBolivia.dylib
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/Cellar/icu4c/74.2/lib/pkgconfig:/usr/local/Cellar/libpq/16.2_1/lib/pkgconfig
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
	gcc -c ccode/cpuid.c -fPIC
	gcc -c ccode/smtp.c -fPIC
	gcc -c ccode/smtp_client.c -fPIC
	@#$(VC) $(MACROS) $(VFLAGS) $(VLIBS) --library=$(LIBRARY_NAME) -H $(LIBRARY_NAME).h $(SOURCES) -X -fPIC -X -shared -o bin/$@
	$(VC) -c $(MACROS) $(VFLAGS) $(VLIBS) --library=$(LIBRARY_NAME) -H $(LIBRARY_NAME).h $(SOURCES) -X -fPIC -X -I.
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
	$(VC) -X -I. -X -L. -X -L./bin $(VLIBS) -X -l$(LIBRARY_NAME) $(LIBRARY_NAME).vapi  test.vala -o test
api: tests/api-rest.vala
	$(VC) -X -I. -X -L. -X -L./bin $(VLIBS) -X -l$(LIBRARY_NAME) $(LIBRARY_NAME).vapi  tests/api-rest.vala -o test-api-rest
clean:
	-rm $(DEST_LIBRARY)
	-rm *.h
	-rm *.o
	-rm classes/*.vala.c
	-rm Database/*.vala.c
	-rm tests/*.c
	-rm $(LIBRARY_NAME).vapi
