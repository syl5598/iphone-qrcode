#import <Foundation/Foundation.h>
#import "../../ValueMatrix.h"
#import "FinderPattern.h"

#define RIGHT 1
#define BOTTOM 2
#define LEFT 3
#define TOP 4

@interface AlignmentPattern : NSObject
{
  IntPointMatrix *center;
  int patternDistance;
}

-(int) LogicalDistance;
-(IntPointMatrix*) getCenter;
-(void)setCenter: (IntPointMatrix*) center;

+(AlignmentPattern*) findAlignmentPattern: (BoolMatrix*) image pattern: (FinderPattern*) finderPattern;
+(IntPointMatrix*) getLogicalCenter: (FinderPattern*) finderPattern;
@end
