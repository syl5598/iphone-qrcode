//#import <UIKit/UIKit.h>
#import "ValueMatrix.h"
#import <Foundation/NSDebug.h>
#import "Exceptions.h"
#import "QRCodeApplication.h"
#import "QRCodeDecoder.h"

int main(int argc, char **argv)
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  int appReturn = 0;
  
  if (argc > 1)
    {
      QRCodeDecoder *decoder = [[QRCodeDecoder alloc] init];
      #ifndef NOTPHONE
      QRCodeImage *qrc = [[QRCodeImage alloc] initFromFile: [NSString stringWithUTF8String: argv[1]]];
      #else
      QRCodeImage *qrc = [[QRCodeImage alloc] initFromFile: [NSString stringWithUTF8String: argv[1]]];
      //      QRCodeImage *qrc = [[QRCodeImage alloc] initFromJpeg: argv[1]];
      #endif
      
      @try
	{
	  NSString *decodedString = [decoder decode: qrc];
	  NSLog(@"String: %@", decodedString);
	}
      @catch (DebugAbortException *de)
	{
	}
      [qrc release];
      [decoder release];
    }
  else
    {
#ifndef NOTPHONE
      appReturn = UIApplicationMain(argc, argv, [QRCodeApplication class]);
#endif
    }

  //Free all memory and return result of application's run
  [pool release];
  return appReturn;
}
