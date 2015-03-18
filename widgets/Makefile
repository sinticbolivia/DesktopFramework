VLIBS=--pkg gtk+-3.0 --pkg gee-1.0 --pkg gmodule-2.0 --pkg PrintPreview --pkg SinticBolivia --pkg sqlite3 --pkg libxml-2.0
SOURCES=SBNotebook.vala class.cairo-table.vala class.dashboard.vala widget.datepicker.vala class.report.vala\
		class.gtk-module.vala
LIBRARY_NAME=GtkSinticBolivia
VFLAGS=--vapidir=../ --vapidir=../printpreview
CFLAGS=-X -I.. -X -I../printpreview -X -L../bin -X -L../printpreview
CLIBS=-X -lSinticBolivia -X -lprintpreview
all: 
	valac -o lib$(LIBRARY_NAME).so $(SOURCES) --library=$(LIBRARY_NAME) -H $(LIBRARY_NAME).h -X -fPIC -X -shared $(VFLAGS) $(CFLAGS) $(VLIBS) $(CLIBS)
clean:
	rm -f *.vapi
	rm -f *.h
	#rm -f *.c
	
