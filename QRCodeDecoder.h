#import <Foundation/Foundation.h>
#import "ValueMatrix.h"
#import "data/QRCodeImage.h"
#import "data/QRCodeSymbol.h"
#import "reader/QRCodeImageReader.h"

@interface QRCodeDecoder : NSObject
{
  QRCodeSymbol *qrCodeSymbol;
  int numTryDecode;
  NSMutableArray *results;
  NSMutableArray *lastResults;
  QRCodeImageReader *imageReader;
  int numLastCorrections;
  BOOL correctionSucceeded;
}
-(QRCodeDecoder*)init;
-(ByteVector*) decodeBytes: (QRCodeImage*) qrCodeImage;
-(NSString*) decode: (QRCodeImage*) qrCodeImage encoding: (NSStringEncoding) encoding;
-(NSString*) decode: (QRCodeImage*) qrCodeImage;
@end

