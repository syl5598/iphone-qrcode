#import "../QRCommon.h"
#import "Line.h"

// Because CLDC1.0 does not support Math.sqrt(), we have to define it manually.
// faster sqrt (GuoQing Hu's FIX)
int fast_sqrt(int val)
{
  return sqrt(val);
  /*
  //		using estimate method from http://www.azillionmonkeys.com/qed/sqroot.html 
  //		Console.out.print(val + ", " + (int)Math.sqrt(val) + ", "); 
  int temp, g = 0, b = 0x8000, bshft = 15;
  do 
    {
      if (val >= (temp = (((g << 1) + b) << bshft--)))
	{
	  g += b;
	  val -= temp;
	}
    }
  while ((b >>= 1) > 0);
  
  return g;
  */
}

@implementation QRLine
-(QRLine*)init
{
  [super init];
  x1 = y1 = x2 = y2 = 0;
  return self;
}

-(QRLine*)initWithX1: (int) X1 Y1: (int) Y1 X2: (int) X2 Y2: (int) Y2
{
  [super init];
  x1 = X1;
  y1 = Y1;
  x2 = X2;
  y2 = Y2;
  return self;
}

-(QRLine*)initWithP1: (IntPoint) p1 P2: (IntPoint) p2;
{
  [super init];
  x1 = p1.x;
  y1 = p1.y;
  x2 = p2.x;
  y2 = p2.y;
  return self;
}

-(IntPoint)getP1
{
  IntPoint ip = { x1, y1 };
  return ip;
}

-(IntPoint)getP2
{
  IntPoint ip = { x2, y2 };
  return ip;
}

-(BOOL)Horizontal
{
  return (y1 == y2) ? YES : NO;
}

-(BOOL)Vertical
{
  return (x1 == x2) ? YES : NO;
}

-(IntPoint)Center
{
  IntPoint ip;
  ip.x = (x1 + x2) / 2;
  ip.y = (y1 + y2) / 2;
  return ip;
}

-(int)Length
{
  int x = abs(x2 - x1);
  int y = abs(y2 - y1);
  return fast_sqrt(x * x + y * y);
}

-(void)setLineWithX1: (int) X1 Y1: (int) Y1 X2: (int) X2 Y2: (int) Y2
{
  x1 = X1;
  y1 = Y1;
  x2 = X2;
  y2 = Y2;
}
-(void)setX1: (int) X1 Y1: (int) Y1
{
  x1 = X1;
  y1 = Y1;
}
-(void)setX2: (int) X2 Y2: (int) Y2
{
  x2 = X2;
  y2 = Y2;
}

-(void)setP1: (IntPoint) p1
{
  x1 = p1.x;
  y1 = p1.y;
}

-(void)setP2: (IntPoint) p2
{
  x2 = p2.x;
  y2 = p2.y;
}

-(void)translateDx: (int) dx Dy: (int) dy
{
  x1 += dx;
  y1 += dy;
  x2 += dx;
  y2 += dy;
}

//check if two lines are neighboring. allow only 1 dot difference 
-(BOOL)isNeighbor: (QRLine*) line2
{
  if ((abs(x1 - line2->x1) < 2 && abs(y1 - line2->y1) < 2) && (abs(x2 - line2->x2) < 2 && abs(y2 - line2->y2) < 2))
    {
      return YES;
    }
  else
    {
      return NO;
    }
}

-(BOOL)isCross: (QRLine*) line2
{
  if ([self Horizontal] && [line2 Vertical])
    {
      if (y1 > line2->y1 && y1 < line2->y2 && line2->x1 > x1 && line2->x1 < x2)
	{
	  return YES;
	}
    }
  else if ([self Vertical] && [line2 Horizontal])
    {
      if (x1 > line2->x1 && x1 < line2->x2 && line2->y1 > y1 && line2->y1 < y2)
	{
	  return YES;
	}
    }
  
  return NO;
}

+(QRLine*)getLongest: (NSArray*) lines
{
  int i, l = [lines count];
  QRLine *longest = nil;
  int llen = -1;
  for (i = 0; i < l; i++)
    {
      QRLine* c = [lines objectAtIndex: i];
      int nlen = [c Length];
      if (nlen > llen)
	{
	  longest = c;
	  llen = nlen;
	}
    }
  if (!longest)
    {
      return [[[QRLine alloc] init] autorelease];
    }
  return longest; // already autoreleased
}

+(QRLine*)getLongest: (QRLine**) lines count: (int) count
{
  int i, l = count;
  QRLine *longest = nil;
  int llen = -1;
  for (i = 0; i < l; i++)
    {
      QRLine* c = lines[i];
      int nlen = [c Length];
      if (nlen > llen)
	{
	  longest = c;
	  llen = nlen;
	}
    }
  if (!longest)
    {
      return [[[QRLine alloc] init] autorelease];
    }
  return longest; // already autoreleased
}

+(int)getLength: (IntPoint) p1 p2: (IntPoint) p2
{
  int x = abs(p2.x - p1.x);
  int y = abs(p2.y - p1.y);
  return sqrt(x * x + y * y);
}

RETAIN_RELEASE(QRLine)
@end
