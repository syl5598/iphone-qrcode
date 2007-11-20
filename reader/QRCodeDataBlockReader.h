#import <Foundation/Foundation.h>
#import "../ValueMatrix.h"

#define MODE_NUMBER 1
#define MODE_ROMAN_AND_NUMBER 2
#define MODE_8BIT_BYTE 4
#define MODE_KANJI 8

@interface QRCodeDataBlockReader : NSObject
{
  IntVector *blocks;
  int version;
  int blockPointer;
  int bitPointer;
  int dataLength;
  int numErrorCorrectionCode;

}
-(QRCodeDataBlockReader*) initWithBlocks: (IntVector*) blocks version: (int) version code: (int) numErrorCorrectionCode;
-(ByteVector*)DataByte;
-(NSString*)DataString;
-(ByteVector*)get8bitByteArray: (int) dataLength;
-(NSString*)get8bitByteString: (int) dataLength;
-(NSString*)getKanjiString: (int) dataLength;
@end

