#import <Foundation/Foundation.h>
#import "../ValueMatrix.h"
#import "../geom/SamplingGrid.h"
#import "../data/QRCodeSymbol.h"

@interface QRCodeImageReader : NSObject
{
  //boolean[][] image;
  //DP = 
  //23 ...side pixels of image will be limited maximum 255 (8 bits)
  //22 .. side pixels of image will be limited maximum 511 (9 bits)
  //21 .. side pixels of image will be limited maximum 1023 (10 bits)
  
  //I think it's good idea to use DECIMAL_POINT with type "long" too.
  SamplingGrid *_samplingGrid;
  BoolMatrix *_bitmap;
}
-(QRCodeImageReader*)initReader;
-(QRCodeSymbol*)getQRCodeSymbol: (IntMatrix*) image;
-(QRCodeSymbol*)getQRCodeSymbolWithAdjustedGrid: (IntPoint) adjust;
-(BOOL)hasSamplingGrid;
+(int)DECIMAL_POINT;
@end
