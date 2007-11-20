#import "../ValueMatrix.h"

@interface BCH15_5 : NSObject
{
  IntMatrix *gf16;
  BoolVector *receiveData;
  int numCorrectedError;
}
-(BCH15_5*)initWithVector: (BoolVector*) source;

-(int)NumCorrectedError;
-(BoolVector*)correct;

@end
