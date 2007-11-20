#import <Foundation/Foundation.h>
#import "../ValueMatrix.h"
#import "Line.h"

@interface SamplingGrid : NSObject
{
  // Actually NSObject[][]
  NSObject **grids;
  int dim;
}
-(SamplingGrid*)initWithAreas: (int) count;
-(void)initGrid: (int) ax ay: (int) ay width: (int) width height: (int) height;
-(void)setXLine: (int) ax ay: (int) ay X: (int) x line: (QRLine*) line;
-(void)setYLine: (int) ax ay: (int) ay Y: (int) y line: (QRLine*) line;
-(QRLine*)getXLine: (int) ax ay: (int) ay X: (int) x;
-(QRLine*)getYLine: (int) ax ay: (int) ay Y: (int) y;
-(NSArray*)getXLines: (int) ax ay: (int) ay;
-(NSArray*)getYLines: (int) ax ay: (int) ay;
-(int) getWidth;
-(int) getHeight;
-(int) getWidth: (int) ax ay: (int) ay;
-(int) getHeight: (int) ax ay: (int) ay;
-(int) getX: (int) ax x: (int) x;
-(int) getY: (int) ay y: (int) y;
-(void) adjust: (IntPoint) adjust;

-(int)TotalWidth;
-(int)TotalHeight;

@end
