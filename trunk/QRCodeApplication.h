#ifndef NOTPHONE

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIProgressBar.h>
#import <UIKit/UIProgressIndicator.h>
#import <UIKit/UIProgressHUD.h>
#import <UIKit/UIWindow.h>

#import "QRCommon.h"

@class QRCameraView;
@class CameraController;

@interface QRCodeApplication : UIApplication {
  QRCameraView *cameraView;
  CameraController* camController;
  UIPushButton *snap;
  UIView *mainView;
  UIProgressHUD *mProgress;
  UIWindow *mWindow;
  BOOL inRun;
}

+(QRCodeApplication*)application;
- (void)cameraControllerReadyStateChanged:(id)fp8;
- (id) createButton;
- (void) takePicture:(id)sender;
- (void) process: (UIImage*) picture;
- (void) alertSheet:(UIAlertSheet*)sheet buttonClicked:(int)button;

- (void) showSuccess: (NSString*) result;
- (void) showURL:     (NSString*) url;
- (void) showFailure: (NSString*) result;
@end

#endif
