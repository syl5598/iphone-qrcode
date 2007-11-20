#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>

typedef char byte;

typedef struct
{
  int x;
  int y;
} IntPoint;

@interface ValueMatrix : NSObject
{
  NSMutableData *data;
  int mWidth;
  int mHeight;
  int mElementSize;
}
-(id) initWithElementsOfSize: (int) elementSize width: (int) width height: (int) height;

-(void*)mutableBytes;
-(int)width;
-(int)height;
-(int)elementSize;
// Zero it all out
-(void)zero;
@end

@interface BoolMatrix : ValueMatrix
{
}

-(id)initWithWidth: (int) width height: (int) height;
-(BOOL)X: (int)x Y: (int)y;
-(void)setValue: (BOOL) v X: (int) x Y: (int) y;
@end

@interface BoolVector : BoolMatrix
{
}
-(id)initWithLength: (int) length;
-(int)length;
-(BOOL)get: (int) x;
-(void)setValue: (BOOL) v at: (int) x;
-(void)add: (BOOL) p;
@end

@interface ByteMatrix : ValueMatrix
{
}

-(id)initWithWidth: (int) width height: (int) height;
-(byte)X: (int)x Y: (int)y;
-(void)setValue: (byte) v X: (int) x Y: (int) y;
@end

@interface ByteVector : ByteMatrix
{
}
-(ByteVector*)initWithLength: (int) length;
-(ByteVector*)initWithBytes: (const byte*) v count: (int) count;
-(int)length;
-(byte)get: (int) x;
-(void)setValue: (byte) v at: (int) x;
-(const byte *)asROArray;
-(void)appendBytes: (const byte*) v count: (int) count;
@end

@class IntVector;

@interface IntMatrix : ValueMatrix
{
}

-initWithWidth: (int) width height: (int) height;
-(int)X: (int)x Y: (int)y;
-(void)setValue: (int) v X: (int) x Y: (int) y;
-(IntVector*)column: (int) x;
@end

@interface IntVector : IntMatrix
{
}
-(id)initWithLength: (int) length;
-(int)length;
-(int)get: (int) x;
-(void)setValue: (int) v at: (int) x;
-(const int*)asROArray;
+(IntVector*)fromArray: (int*) array count: (int) count;
-(void)add: (int) p;
@end

@interface IntPointMatrix : ValueMatrix
{
}

-initWithWidth: (int) width height: (int) height;
-(IntPoint)X: (int)x Y: (int)y;
-(void)setValue: (IntPoint) v X: (int) x Y: (int) y;
-(void)setXValue: (int) v X: (int) x Y: (int) y;
-(void)setYValue: (int) v X: (int) x Y: (int) y;
@end

@interface IntPointVector : IntPointMatrix
{
}

-(id)initWithLength: (int) length;
-(int)length;
-(IntPoint)get: (int) x;
-(void)setValue: (IntPoint) v at: (int) x;
-(const IntPoint*)asROArray;
-(void)add: (IntPoint) p;
@end


/****
@interface RectMatrix : ValueMatrix
{
}

-(id)initWithWidth: (int) width height: (int) height;
-(NSRect)X: (int)x Y: (int)y;
@end
****/
