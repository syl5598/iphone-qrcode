#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <CoreSurface/CoreSurface.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UIPushButton.h>
#import <UIKit/UIThreePartButton.h>
#import <UIKit/UINavigationBar.h>
#import <UIKit/UIWindow.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIHardware.h>
#import <UIKit/UITable.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UITableColumn.h>
#import <UIKit/UITile.h>
#import <UIKit/UITiledView.h>

#import "Shimmer.h"
#import "QRCameraView.h"
#import "QRCodeApplication.h"
#import "QRCodeDecoder.h"
#import "Exceptions.h"

static QRCodeApplication *_theApp;
id<ProgressCallback> gProgress;

@interface QRPicture
{
  UIImage *picture;
  UIImage *preview;
}
@end

@implementation QRCodeApplication

- (void) applicationDidFinishLaunching: (id) unused
{
  inRun = NO;
  _theApp = self;
  gProgress = self;
  UIWindow *window;

  // hide status bar
  [self setStatusBarMode:2 duration:0];

  mWindow = window = [[UIWindow alloc] initWithContentRect: [UIHardware fullScreenApplicationContentRect]];

  struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
  rect.origin.x = rect.origin.y = 0.0f;

  mainView = [[UIView alloc] initWithFrame: rect];
  rect.origin.y = -20.0f;
  rect.size.height = 321.0f;

  cameraView = [[QRCameraView alloc] initWithFrame: rect];
  [mainView addSubview: cameraView];

  camController = [CameraController sharedInstance];
  [[CameraController sharedInstance] setDelegate:self];
  [camController startPreview];

  snap = [self createButton];
  [mainView addSubview: snap];

  [window setContentView: mainView];
  [window orderFront: self];
  [window makeKey: self];
  [window _setHidden: NO];

  [NSThread detachNewThreadSelector:@selector(checkForUpdates:) toTarget:self withObject:cameraView];
}

-(void)checkForUpdates:(id)anObject{
  NSAutoreleasePool *peeIn = [[NSAutoreleasePool alloc] init];
  Shimmer *updater = [[Shimmer alloc] init];
  [updater setUseCustomView:YES]; //you must add this if you specify a view for the alert to appear over
  [updater setAboveThisView:anObject]; //you must add this if you specify a view for the alert to appear over
  
  if(![updater checkForUpdateHere:@"http://tools.povo.com/iPhone/QRDecode/update.xml"])
    {
      //this user doesn't have pxl installed or there is no update, so drop it
      [updater release];
    }
  else
    {
      [updater doUpdate];
    }
  [peeIn release];
}

+(QRCodeApplication*)application
{
  return _theApp;
}

- (id) createButton
{
  UIPushButton *button = [[UIPushButton alloc] initWithFrame: CGRectMake(0.0f, 407.0f, 100.0f, 60.0f)];
  NSString *onFile = [NSString stringWithFormat:@"/Applications/QRDecode.app/snap_down.png"];
  UIImage* on = [[UIImage alloc] initWithContentsOfFile: onFile];
  [button setImage:on forState:1];
  NSString *offFile = [NSString	stringWithFormat:@"/Applications/QRDecode.app/snap.png"];
  UIImage* off = [[UIImage alloc] initWithContentsOfFile: offFile];
  [button setImage:off forState:0];
  [button setEnabled:YES];
  [button setDrawContentsCentered:YES];
  [button setAutosizesToFit:NO];
  [button setNeedsDisplay];
  [button addTarget:self action:@selector(takePicture:) forEvents:255];
  [on release];
  [off release];
  return button;
}

-(void)takePicture:(id)sender
{
    // Turn the take-picture button off so we do not snap multiple pics at once.
    [snap setEnabled: NO];
    if (!inRun)
    {
	[cameraView _playShutterSound];
	[camController capturePhoto];
    }
}

-(void)cameraController:(id)sender tookPicture:(UIImage*)picture withPreview:(UIImage*)preview jpegData:(NSData*)jpeg imageProperties:(NSDictionary *)exif
{
    inRun = YES;
    [camController stopPreview];
    mProgress = [[UIProgressHUD alloc] initWithWindow: mWindow];
    [mProgress setText: @"Processing..."];
    [mainView addSubview: mProgress];
  
    //  [(NSData*)jpeg writeToFile:@"image.jpg" atomically:TRUE];
    [preview retain];
    [NSThread detachNewThreadSelector:@selector(process:) toTarget:self withObject:preview];
}

- (void) process: (UIImage*) picture
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    @try
    {
	QRCodeDecoder *decoder = [[QRCodeDecoder alloc] init];
	QRCodeImage *qrc = [[QRCodeImage alloc] init: picture];
	NSString *decodedString = [decoder decode: qrc];

	[qrc release];
	[decoder release];
	
	NSLog(@"String: %@", decodedString);
	[decodedString retain];
	if( [decodedString compare: @"http"] < 0 )
	{
	    [self performSelectorOnMainThread:@selector(showSuccess:) withObject: decodedString waitUntilDone: NO];
	}
	else
	{
	    [self performSelectorOnMainThread:@selector(showURL:) withObject: decodedString waitUntilDone: NO];
	}
    }
    @catch (DecodingFailedException *de)
    {
	[self performSelectorOnMainThread:@selector(showFailure:) withObject: nil waitUntilDone: NO];
    }
    @finally
    {
	inRun = NO;
	[mProgress removeFromSuperview];
	[mProgress release];
	[picture release];
    }
    [pool release];
}

- (void)alertSheet:(UIAlertSheet*)sheet buttonClicked:(int)button
{
    if( [[sheet context] isKindOfClass: [NSURL class]] && button == 1)
    {
	NSURL*	url = [sheet context];
	[self openURL: url];
	[url release];
	[sheet dismiss];
    }
    else
    {
	[sheet dismiss];
    }
    // Turn the snap button back on to take the next picture.
    [snap setEnabled: YES];
}

- (void)cameraControllerReadyStateChanged:(id)fp8
{
}
/*
-(BOOL)respondsToSelector:(SEL)sel {
  BOOL r = [super respondsToSelector:sel];
  NSLog(@"QRCode respondsToSelector \"%@\" %d\n",
	NSStringFromSelector(sel), r);
  return r;
}
*/
- (void) showSuccess: (NSString*) result
{
  // Alert sheet displayed at centre of screen.
  NSArray *buttons = [NSArray arrayWithObjects:@"Dismiss", nil];
  UIAlertSheet *alertSheet = [[UIAlertSheet alloc] initWithTitle:@"Success!" buttons:buttons defaultButtonIndex:1 delegate: self context: self];
  if (result)
    {
      [alertSheet setBodyText: result];
    }
  [alertSheet popupAlertAnimated:YES];
  [result release];
}

- (void) showURL: (NSString*) url
{
    NSString *theMessage = @"URL decoded. Would you like to visit ";
    NSArray *buttons = [NSArray arrayWithObjects:@"Visit", @"Cancel", nil];
    NSURL* theURL = [NSURL URLWithString: url];
    
    [theURL retain];
    
    UIAlertSheet *alertSheet = [[UIAlertSheet alloc] initWithTitle:@"Success!" buttons:buttons defaultButtonIndex:1 delegate: self context: theURL];
    
    // Form our dialog message
    theMessage = [theMessage stringByAppendingString: url];
    theMessage = [theMessage stringByAppendingString: @"?"];
    
    if( url )
    {
	[alertSheet setBodyText: theMessage];
    }
    [alertSheet popupAlertAnimated:YES];
    [url release];
}

- (void) showFailure: (NSString*) result
{
  // Alert sheet displayed at centre of screen.
  NSArray *buttons = [NSArray arrayWithObjects:@"Dismiss", nil];
  UIAlertSheet *alertSheet = [[UIAlertSheet alloc] initWithTitle:@"Unreadable" buttons:buttons defaultButtonIndex:1 delegate:self context:self];
  [alertSheet setBodyText:@"Sorry, we could not read the QR Code."];
  [alertSheet popupAlertAnimated:YES];
  [result release];
}

@end
