TARGET=libprintpreview.so
VLIBS=--pkg gtk+-3.0
LIBRARY_NAME=PrintPreview

all:
	valac --library=$(LIBRARY_NAME) -X -fPIC -X -shared $(VLIBS) -H $(LIBRARY_NAME).h -o $(TARGET) class.print-preview.vala

printpreview.o: class.print-preview.vala
	valac -c -o $@ $(VLIBS) class.print-preview.vala
	
install:
	
clean:
	rm *.h
	rm $(TARGET)
	rm *.vapi
	rm test
test:
	valac -o test test.vala --pkg gtk+-3.0 --pkg PrintPreview --vapidir=. -X -I. -X -L. -X -lprintpreview
