#import <Foundation/Foundation.h>

@interface FinderPatternNotFoundException : NSException
+(id)withMessage: (NSString*) msg;
@end

@interface InvalidVersionInfoException : NSException
+(id)withMessage: (NSString*) msg;
@end

@interface VersionInformationException : NSException
+(id)withMessage: (NSString*) msg;
@end

@interface AlignmentPatternNotFoundException : NSException
+(id)withMessage: (NSString*) msg;
@end

@interface InvalidDataBlockException : NSException
+(id)withMessage: (NSString*) msg;
@end

@interface IndexOutOfRangeException : NSException
+(id)withMessage: (NSString*) msg;
@end

@interface SymbolNotFoundException : NSException
+(id)withMessage: (NSString*) msg;
@end

@interface InvalidVersionException : NSException
+(id)withMessage: (NSString*) msg;
@end

@interface DecodingFailedException : NSException
+(id)withMessage: (NSString*) msg;
@end

@interface DebugAbortException : NSException
+(id)create;
@end
