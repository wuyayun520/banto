#import "DecorationVarType.h"
    
@interface DecorationVarType ()

@end

@implementation DecorationVarType

- (void) buildInSensorStage: (NSMutableArray *)routecolor
{
	dispatch_async(dispatch_get_main_queue(), ^{
		CALayer * showGestureDetector = [[CALayer alloc] init];
		showGestureDetector.borderColor = [UIColor clearColor].CGColor;
		showGestureDetector.borderWidth -= 122;
		showGestureDetector.backgroundColor = [UIColor darkGrayColor].CGColor;
		showGestureDetector.bounds = CGRectMake(352, 227, 42, 811);
		showGestureDetector.position = CGPointMake(137, 285);
		showGestureDetector.backgroundColor = [UIColor whiteColor].CGColor;
		showGestureDetector.position = CGPointMake(305, 483);
		showGestureDetector.backgroundColor = [UIColor magentaColor].CGColor;
		//NSLog(@"sets= bussiness7 gen_arr %@", bussiness7);
	});
}


@end
        