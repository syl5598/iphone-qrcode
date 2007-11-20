#import "../QRCommon.h"
#import "Axis.h"
#import "IntPointHelper.h"
#import "../reader/QRCodeImageReader.h"

@implementation Axis
-(Axis*)initWithAngle: (const int*) sinAndCos pitch: (int) pitch
{
  [super init];
  _sin = sinAndCos[0];
  _cos = sinAndCos[1];
  _modulePitch = pitch;
  return self;
}

-(void)setOrigin: (IntPoint) p
{
  _origin = p;
}

-(void)setModulePitch: (int) p
{
  _modulePitch = p;
}

-(IntPoint)translate: (IntPoint) offset
{
  return [self translateX: offset.x Y: offset.y];
}

-(IntPoint)translate: (IntPoint) origin offset: (IntPoint) offset
{
  _origin = origin;
  return [self translateX: offset.x Y: offset.y];
}

-(IntPoint)translate: (IntPoint) origin X: (int) moveX Y: (int) moveY
{
  _origin = origin;
  return [self translateX: moveX Y: moveY];
}

-(IntPoint)translate: (IntPoint) origin pitch: (int) modulePitch X: (int) moveX Y: (int) moveY
{
  _origin = origin;
  _modulePitch = modulePitch;
  return [self translateX: moveX Y: moveY];
}

-(IntPoint)translateX: (int) moveX Y: (int) moveY
{
  int dp = [QRCodeImageReader DECIMAL_POINT];

  int yf = 0;
  if((moveX >= 0) & (moveY >= 0))
    {
      yf = 1;
    }
  else
    {
      if((moveX < 0) & (moveY >= 0))
	{
	  yf = -1;
	}
      else
	{
	  if((moveX >= 0) & (moveY < 0))
	    {
	      yf = -1;
	    }
	  else
	    {
	      if((moveX < 0) & (moveY < 0))
		{
		  yf = 1;
		}
	    }
	}
    }
  
  int dx = (moveX == 0)?0:(_modulePitch * moveX) >> dp;
  int dy = (moveY == 0)?0:(_modulePitch * moveY) >> dp;
  IntPoint p = { 0, 0 };
  if (dx != 0 && dy != 0)
    {
      p = [IntPointHelper translate: p X: ((dx * _cos - dy * _sin) >> dp) Y: (yf * (dx * _cos + dy * _sin)) >> dp];
    }
  else if (dy == 0)
    {
      if (dx < 0)
	{
	  yf = -yf;
	}
      p = [IntPointHelper translate: p X: ((dx * _cos) >> dp) Y: (yf * (dx * _sin)) >> dp];
    }
  else if (dx == 0)
    {
      if (dy < 0)
	{
	  yf = -yf;
	}
      p = [IntPointHelper translate: p X: ((-yf * (dy * _sin)) >> dp) Y: (dy * _cos) >> dp];
    }
  p = [IntPointHelper translate: p X: _origin.x Y: _origin.y];
  return p;
}

RETAIN_RELEASE(Axis)
@end
