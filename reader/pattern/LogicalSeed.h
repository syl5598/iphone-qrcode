#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>

#import "../../ValueMatrix.h"

@interface LogicalSeed : NSObject
{
  NSArray* seed;
}

+(IntVector*)getSeed: (int) version;
+(int)getSeed: (int) version pattern: (int) patternNumber;
@end
