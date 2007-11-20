#import <Foundation/Foundation.h>
#import "../ValueMatrix.h"

@interface ReedSolomon : NSObject
{
  IntVector *yyyyy;

  int NPAR;
  int MAXDEG;

  IntVector *synBytes;

  /* The Error Locator Polynomial, also known as Lambda or Sigma. Lambda[0] == 1 */
  IntVector *Lambda;
		
  /* The Error Evaluator Polynomial */
  IntVector *Omega;
  
  /* local ANSI declarations */
  
  /* error locations found using Chien's search*/
  int ErrorLocs[256];
  int NErrors;
		
  /* erasure flags */
  int ErasureLocs[256];
  int NErasures;
		
  BOOL correctionSucceeded;
}
-(ReedSolomon*)initWithSource: (IntVector*)source NPAR: (int) NPAR;

-(BOOL)CorrectionSucceeded;
-(int) NumCorrectedErrors;

-(void)correct;
@end
