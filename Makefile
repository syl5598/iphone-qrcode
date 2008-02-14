LDFLAGS=-Wl -lobjc libqrencode.dylib -framework CoreFoundation -framework Foundation -framework CoreGraphics -framework UIKit -framework LayerKit -framework PhotoLibrary -framework Camera
EXTRAOBJS = QRCameraView.o QRCodeApplication.o Shimmer.o
CC=arm-apple-darwin-gcc
CFLAGS=-Wall -g
#CC=gcc
#LDFLAGS=-Wl -ljpeg -lobjc -framework CoreFoundation -framework Foundation -framework ApplicationServices
#CFLAGS=-DDEBUG -DNOTPHONE -fobjc-exceptions -g -Wall

PHONE=maxiphone
TARGET=QRDecode
LD=$(CC) -macosx_version_min=10.4u

all: package

$(TARGET): ValueMatrix.o data/QRCodeImage.o data/QRCodeSymbol.o ecc/BCH15_5.o ecc/ReedSolomon.o \
	geom/Line.o geom/Axis.o geom/IntPointHelper.o geom/SamplingGrid.o \
	reader/pattern/LogicalSeed.o reader/pattern/FinderPattern.o reader/pattern/AlignmentPattern.o \
	reader/QRCodeDataBlockReader.o reader/QRCodeImageReader.o \
	Exceptions.o QRCodeDecoder.o iPhoneMain.o \
	$(EXTRAOBJS)
	$(LD) $(LDFLAGS) -o $@ $^

%.o:    %.m
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

clean:
	find . -name "*.o" -print | xargs rm

package: $(TARGET)
	@echo Assembling .app package...
	@rm -fr $(TARGET).app
	@mkdir -p $(TARGET).app
	@cp QRDecode $(TARGET).app
	@cp Default.png $(TARGET).app
	@cp snap.png $(TARGET).app
	@cp snap_down.png $(TARGET).app
	@cp Info.plist $(TARGET).app
	@cp icon.png $(TARGET).app 

install: all
	scp -r $(TARGET).app root@$(PHONE):/Applications
