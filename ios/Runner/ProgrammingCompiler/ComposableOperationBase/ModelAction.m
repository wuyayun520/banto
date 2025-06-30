#import "ModelAction.h"
    
@interface ModelAction ()

@end

@implementation ModelAction

- (instancetype) init
{
	NSNotificationCenter *anchorformat = [NSNotificationCenter defaultCenter];
	[anchorformat addObserver:self selector:@selector(sorterMargin:) name:UIKeyboardWillShowNotification object:nil];
	return self;
}

- (void) lockPlateByEffect
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSMutableSet *constraintTier = [NSMutableSet set];
		NSString* debugLabel = @"aspectlatency";
		for (int i = 0; i < 7; ++i) {
			[constraintTier addObject:[debugLabel stringByAppendingFormat:@"%d", i]];
		}
		UIDatePicker *shouldPauseGesture = [[UIDatePicker alloc]init];
		[shouldPauseGesture setDatePickerMode:UIDatePickerModeDate];
		[shouldPauseGesture setDatePickerMode:UIDatePickerModeCountDownTimer];
		UITextField *touchStyle = [[UITextField alloc] init];
		touchStyle.inputView = shouldPauseGesture;
		//NSLog(@"sets= bussiness1 gen_set %@", bussiness1);
	});
}

- (void) sorterMargin: (NSNotification *)draggableBitrate
{
	//NSLog(@"userInfo=%@", [draggableBitrate userInfo]);
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
        