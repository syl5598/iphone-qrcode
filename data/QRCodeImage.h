#import <Foundation/Foundation.h>

#ifndef NOTPHONE
@class UIImage;
#endif

@interface QRCodeImage : NSObject
{
  BOOL rgbSpace;
  BOOL rotate90;
  size_t width;
  size_t height;
  CGContextRef cgctx;
  unsigned char *imageData;
#ifdef NOTPHONE
  BOOL isJpeg;
#endif
}
#ifndef NOTPHONE
-(QRCodeImage*)init:(UIImage*)image;
#else
-(QRCodeImage*)initFromJpeg: (const char*) filename;
#endif
-(BOOL)isGrayscale;
-(QRCodeImage*)initFromFile: (NSString*) filename;
-(int)Width;
-(int)Height;
-(int)X: (int) x Y: (int) y;
@end
