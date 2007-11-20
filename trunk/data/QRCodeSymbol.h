#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>

#import "../ValueMatrix.h"

@interface QRCodeSymbol : NSObject
{
  int version;
  int errorCollectionLevel;
  int maskPattern;
  int dataCapacity;
  
  BoolMatrix *moduleMatrix;
  int width;
  int height;

  IntPointMatrix *alignmentPattern;
}

-(QRCodeSymbol*)initWithModuleMatrix: (BoolMatrix*) matrix;
-(int)NumErrorCollectionCode;
-(int)NumRSBlocks;
-(int)Version;
-(NSString*)VersionReference;
-(IntPointMatrix*)AlignmentPattern;
-(int)DataCapacity;
-(int)ErrorCollectionLevel;
-(int)MaskPatternReferer;
-(NSString*)MaskPatternRefererAsString;
-(int)Width;
-(int)Height;
-(IntVector*)Blocks;
-(BOOL)getElementAtX: (int) x Y: (int) y;
-(void)reverseElementAtX: (int) x Y: (int) y;
-(BOOL)isInFunctionPatternAtX: (int) targetX Y: (int) targetY;
@end

