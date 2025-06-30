#import "SharedOpaqueBuffer.h"
    
@interface SharedOpaqueBuffer ()

@end

@implementation SharedOpaqueBuffer

- (void) animateUpBufferPhase: (NSMutableArray *)customCatalyst
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSString *monsterBuffer = customCatalyst[0];
		UIView *secondWrapper = [[UIView alloc] initWithFrame:CGRectMake(27, 26, 810, 54)];
		[secondWrapper setBackgroundColor : [UIColor colorWithRed:241/255.0 green:165/255.0 blue:85/255.0 alpha:1.0]];
		secondWrapper.clearsContextBeforeDrawing = YES;
		[secondWrapper didMoveToWindow];
		secondWrapper.layer.borderColor = [UIColor clearColor].CGColor;
		//NSLog(@"sets= bussiness8 gen_arr %@", bussiness8);
	});
}


@end
        