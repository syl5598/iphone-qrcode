#import <Foundation/Foundation.h>
#import "Exceptions.h"

#define EXCEPTION_CLASS(cname) @implementation cname \
+(id)withMessage: (NSString*) msg \
{ \
  return [[[cname alloc] initWithName: @#cname reason: msg userInfo: nil] autorelease]; \
} \
@end

EXCEPTION_CLASS(FinderPatternNotFoundException)

EXCEPTION_CLASS(InvalidVersionInfoException)

EXCEPTION_CLASS(VersionInformationException)

EXCEPTION_CLASS(AlignmentPatternNotFoundException)

EXCEPTION_CLASS(InvalidDataBlockException)

EXCEPTION_CLASS(IndexOutOfRangeException)

EXCEPTION_CLASS(SymbolNotFoundException)

EXCEPTION_CLASS(InvalidVersionException)

EXCEPTION_CLASS(DecodingFailedException)

@implementation DebugAbortException
+(id)create
{
  return [[[DebugAbortException alloc] initWithName: @"DebugAbort" reason: @"none" userInfo: nil] autorelease]; \
}
@end
