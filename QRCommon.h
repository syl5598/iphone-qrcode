#ifdef RETAIN_DEBUG

#define RETAIN_RELEASE(x) \
-(id) retain { NSLog(@"-->retaining %s %x", #x, self); return [super retain]; } \
-(oneway void) release { int rc = [self retainCount]; NSLog(@"-->releasing %s %x %d", #x, self, [self retainCount]); [super release]; NSLog(@"Done %x %d", self, rc == 1 ? 0 : [self retainCount]); } \
-(id) autorelease { NSLog(@"-->AutoRelease %s %x", #x, self); return [super autorelease]; }

#else

#define RETAIN_RELEASE(x)
#endif

@protocol ProgressCallback
-(void)setProgress: (float) progress;
@end

extern id<ProgressCallback> gProgress;
