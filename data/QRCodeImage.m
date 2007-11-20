#import <Foundation/Foundation.h>
#import <CoreGraphics/CGColor.h>

#ifndef NOTPHONE
#import <GraphicsServices/GraphicsServices.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UIImage.h>
#else
#include <jpeglib.h>
#endif

#import "QRCodeImage.h"

#if DEBUG
#define LOG(x) NSLog(x)
#else
#define LOG(x)
#endif

CGContextRef CreateBitmapContext (CGImageRef inImage, BOOL rgb)
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace = NULL;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;

     // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);

    bitmapBytesPerRow   = pixelsWide * (rgb ? 4 : 1);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);

    // Use the generic grayscale color space.
    if (!rgb)
      {
	colorSpace = CGColorSpaceCreateWithName(rgb ? kCGColorSpaceGenericRGB : kCGColorSpaceGenericGray);
	if (colorSpace == NULL)
	  {
	    fprintf(stderr, "Error allocating color space\n");
	    return NULL;
	  }
      }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }

    context = CGBitmapContextCreate (bitmapData,
				     pixelsWide,
				     pixelsHigh,
				     8,      // bits per component
				     bitmapBytesPerRow,
				     (colorSpace == NULL) ? CGImageGetColorSpace(inImage) : colorSpace,
				     rgb ? kCGImageAlphaNoneSkipFirst : kCGImageAlphaNone);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    // Make sure and release colorspace before returning
    if (colorSpace)
      {
	CGColorSpaceRelease( colorSpace );
      }

    return context;
}

@implementation QRCodeImage
#ifndef NOTPHONE
-(QRCodeImage*)init:(UIImage*)image
{
  [super init];
  rotate90 = NO;
  rgbSpace = NO;
  CGImageRef imgRef = [image imageRef];

  cgctx = CreateBitmapContext(imgRef, rgbSpace);

  // Get image width, height. We'll use the entire image.
  width = CGImageGetWidth(imgRef);
  height = CGImageGetHeight(imgRef);
  CGRect rect = {{0,0},{width,height}};

  // Draw the image to the bitmap context. Once we draw, the memory
  // allocated for the context for rendering will then contain the
  // raw image data in the specified color space.
  CGContextDrawImage(cgctx, rect, imgRef);
  imageData = CGBitmapContextGetData (cgctx);

  /*
  NSLog(@"Width: %d Height: %d", [self Width], [self Height]);
  FILE *fp = fopen("/tmp/gray.raw", "w");
  int x, y;
  for (x = 0; x < [self Width]; x++)
    {
      for (y = 0; y < [self Height]; y++)
	{
	  char c = (char) [self X: x Y: y];
	  fwrite(&c, 1, 1, fp);
	}
    }
  fflush(fp);
  fclose(fp);
  NSLog(@"Wrote image");
  */
  return self;
}
#endif

#ifdef NOTPHONE
-(QRCodeImage*)initFromJpeg: (const char *) filename
{
  [super init];
  rotate90 = NO;
  isJpeg = YES;

  FILE *infile = fopen(filename, "rb");

  struct jpeg_decompress_struct cinfo;
  struct jpeg_error_mgr jerr;
  cinfo.err = jpeg_std_error(&jerr);
  jpeg_create_decompress(&cinfo);
  jpeg_stdio_src(&cinfo, infile);
  jpeg_read_header(&cinfo, TRUE);
  jpeg_start_decompress(&cinfo);

  width = cinfo.output_width;
  height = cinfo.output_height;

  imageData = malloc(3 * width * height);
  
  unsigned char *ptr = imageData;
  while (cinfo.output_scanline < height)
    {
      jpeg_read_scanlines(&cinfo, &ptr, 1);
      ptr += (3*width);
    }
  jpeg_finish_decompress(&cinfo);
  jpeg_destroy_decompress(&cinfo);
  fclose(infile);
  return self;
}
#endif

-(QRCodeImage*)initFromFile: (NSString*) filename
{
  [super init];
  rotate90 = NO;
  rgbSpace = YES;
  NSURL* url = [NSURL fileURLWithPath: filename];
  CGImageSourceRef  sourceRef;
  CGImageRef imgRef;

  sourceRef = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
  if(sourceRef) 
    {
      imgRef = CGImageSourceCreateImageAtIndex(sourceRef, 0, NULL);
      CFRelease(sourceRef);
    }

  cgctx = CreateBitmapContext(imgRef, rgbSpace);

  // Get image width, height. We'll use the entire image.
  width = CGImageGetWidth(imgRef);
  height = CGImageGetHeight(imgRef);
  CGRect rect = {{0,0},{width,height}};

  // Draw the image to the bitmap context. Once we draw, the memory
  // allocated for the context for rendering will then contain the
  // raw image data in the specified color space.
  CGContextDrawImage(cgctx, rect, imgRef);
  imageData = CGBitmapContextGetData (cgctx);

  return self;
}

-(void)dealloc
{
  // When finished, release the context
  CGContextRelease(cgctx);
  // Free image data memory for the context
  if (imageData)
    {
      free(imageData);
    }
  //[image release];
  [super dealloc];
}

-(int) Width
{
  if (rotate90)
    {
      return height;
    }
  return width;
}

-(int) Height
{
  if (rotate90)
    {
      return width;
    }
  return height;
}

-(int)X: (int) x Y: (int) y
{
  if (rotate90)
    {
      int xo = x, yo = y;
      x = yo;
      y = height - xo - 1;
    }
#ifdef NOTPHONE
  if (isJpeg)
    {
      unsigned char *px = imageData + (3 * ((y*width)+x));
      int r = px[0], g = px[1], b = px[2];
      return (r * 30 + g * 59 + b * 11) / 100;
    }
  else 
#endif
    if (rgbSpace)
    {
      int px = *(((int*) imageData)+(y*width)+x); // bgra
      // Modified for Mac color order (bgra)
      int r = px >> 8 & 0xFF;
      int g = px >> 16 & 0xFF;
      int b = px >> 24 & 0xFF;
      return (r * 30 + g * 59 + b * 11) / 100;
    }
  else
    {
      unsigned char *pixel = (unsigned char*) (imageData + (y * width) + x);
      int p = (int) *pixel;
      return p*3;
    }
}

-(BOOL)isGrayscale
{
  return !rgbSpace;
}
@end
