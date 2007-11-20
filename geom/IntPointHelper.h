#import <Foundation/Foundation.h>
#import "../ValueMatrix.h"

#define IPRIGHT 1
#define IPBOTTOM 2
#define IPLEFT 4
#define IPTOP 8

@interface IntPointHelper : NSObject
{
}
+(IntPoint) translate: (IntPoint) p X: (int) x Y: (int) y;
+(IntPoint) getCenter: (IntPoint)p1 p2: (IntPoint)p2;
+(BOOL) equals: (IntPoint)p1 p2: (IntPoint)p2;
+(int) distanceOf: (IntPoint)p1 to: (IntPoint)p2;
@end
