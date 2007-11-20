#import <Foundation/Foundation.h>
#import "../ValueMatrix.h"

@interface Axis : NSObject
{
  int _sin;
  int _cos;
  int _modulePitch;
  IntPoint _origin;
}
-(Axis*)initWithAngle: (const int*) sinAndCos pitch: (int) pitch;

-(void)setOrigin: (IntPoint) p;
-(void)setModulePitch: (int) p;
-(IntPoint)translate: (IntPoint) offset;
-(IntPoint)translate: (IntPoint) origin offset: (IntPoint) offset;
-(IntPoint)translate: (IntPoint) origin X: (int) moveX Y: (int) moveY;
-(IntPoint)translate: (IntPoint) origin pitch: (int) modulePitch X: (int) moveX Y: (int) moveY;
-(IntPoint)translateX: (int) moveX Y: (int) moveY;
@end
