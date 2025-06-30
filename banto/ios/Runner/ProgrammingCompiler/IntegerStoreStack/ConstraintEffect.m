#import "ConstraintEffect.h"
    
@interface ConstraintEffect ()

@end

@implementation ConstraintEffect

- (void) takeLargeFlexValue: (NSMutableSet *)compositionName
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSInteger scrollableDrawer =  [compositionName count];
		UIProgressView *immediateObserver = [[UIProgressView alloc] init];
		immediateObserver.progress = scrollableDrawer;
		BOOL textComposite = immediateObserver.focused;
		if (textComposite) {
			CALayer * litePoint = [[CALayer alloc] init];
			litePoint.borderColor = [UIColor blackColor].CGColor;
		}
		//NSLog(@"sets= bussiness8 gen_set %@", bussiness8);
	});
}


@end
        