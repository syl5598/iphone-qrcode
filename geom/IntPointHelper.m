#import "IntPointHelper.h"

@implementation IntPointHelper

+(IntPoint) translate: (IntPoint) p X: (int) x Y: (int) y
{
  IntPoint r = { p.x + x, p.y + y };
  return r;
}

+(IntPoint) getCenter: (IntPoint) p1 p2: (IntPoint) p2
{
  IntPoint r = {
    (p1.x + p2.x) / 2,
    (p1.y + p2.y) / 2
  };
  return r;
}

+(BOOL) equals: (IntPoint)p1 p2: (IntPoint)p2
{
  return (p1.x == p2.x && p1.y == p2.y) ? YES : NO;
}

+(int) distanceOf: (IntPoint)p1 to: (IntPoint)p2
{
  int x1 = p1.x - p2.x, y1 = p1.y - p2.y;
  return sqrt(x1*x1+y1*y1);
}
@end
