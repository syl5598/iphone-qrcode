#ifndef NOTPHONE

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIProgressBar.h>
#import <UIKit/UIProgressIndicator.h>
#import <UIKit/UIProgressHUD.h>
#import <UIKit/UIWindow.h>

#import "QRCommon.h"

enum PHONE_ORIENTATION
{
    ORIENT_UP = 0,
    ORIENT_NORMAL,
    ORIENT_INVERTED,
    ORIENT_LEFT,
    ORIENT_RIGHT,
    ORIENT_NA,
    ORIENT_DOWN
};

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
