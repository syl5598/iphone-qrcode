#import <Foundation/Foundation.h>
#import "../../ValueMatrix.h"
#import "../../geom/Line.h"

#define FP_UL 0
#define FP_UR 1
#define FP_DL 2

#define POINT_LIGHT NO
#define POINT_DARK YES

@interface FinderPattern : NSObject
{
  IntPointVector *center;
  int version;
  IntVector *sincos;
  IntVector *width;
  int moduleSize;
}
-(int)Version;
-(int)SqrtNumModules;
-(IntPointVector*)getCenter;
-(IntPoint)getCenter: (int) position;
-(int)getWidth: (int) position;
-(IntVector*)getAngle;
-(int)getModuleSize;

+(FinderPattern*)findFinderPattern: (BoolMatrix*) image;

@end
