#ifndef NOTPHONE

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIProgressBar.h>

#import "QRCommon.h"

@class QRCameraView;
@class CameraController;

@interface QRCodeApplication : UIApplication <ProgressCallback> {
  QRCameraView *cameraView;
  CameraController* camController;
  UIPushButton *snap;
  UIView *mainView;
  BOOL inRun;
  UIProgressBar* mProgress;
}

+(QRCodeApplication*)application;
- (void)cameraControllerReadyStateChanged:(id)fp8;
- (id) createButton;
- (void) takePicture:(id)sender;
- (void) process: (UIImage*) picture;
- (void)alertSheet:(UIAlertSheet*)sheet buttonClicked:(int)button;

- (void) showSuccess: (NSString*) result;
- (void) showFailure: (NSString*) result;
@end

#endif
