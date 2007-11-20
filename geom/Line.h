#import <Foundation/Foundation.h>
#import "../ValueMatrix.h"

int fast_sqrt(int val);

@interface QRLine : NSObject
{
  int x1;
  int y1;
  int x2;
  int y2;
}
-(QRLine*)init;
-(QRLine*)initWithX1: (int) X1 Y1: (int) Y1 X2: (int) X2 Y2: (int) Y2;
-(QRLine*)initWithP1: (IntPoint) p1 P2: (IntPoint) p2;
-(IntPoint)getP1;
-(IntPoint)getP2;

-(BOOL)Horizontal;
-(BOOL)Vertical;
-(IntPoint)Center;
-(int)Length;
-(void)setLineWithX1: (int) X1 Y1: (int) Y1 X2: (int) X2 Y2: (int) Y2;
-(void)setX1: (int) X1 Y1: (int) Y1;
-(void)setX2: (int) X2 Y2: (int) Y2;
-(void)setP1: (IntPoint) p1;
-(void)setP2: (IntPoint)p2;
-(void)translateDx: (int) dx Dy: (int) dy;

-(BOOL)isNeighbor: (QRLine*) line2;
-(BOOL)isCross: (QRLine*) line2;

+(QRLine*)getLongest: (NSArray*) lines;
+(QRLine*)getLongest: (QRLine**) lines count: (int) count;
+(int)getLength: (IntPoint) p1 p2: (IntPoint) p2;
@end
