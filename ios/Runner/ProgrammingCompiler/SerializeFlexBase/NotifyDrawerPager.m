#import "NotifyDrawerPager.h"
    
@interface NotifyDrawerPager ()

@end

@implementation NotifyDrawerPager

- (void) unregisterClipperAtShader
{
	dispatch_async(dispatch_get_main_queue(), ^{
		int dialogsborder = 82;
		int staticObserver[dialogsborder];
		for (int i = 0; i < dialogsborder; i++) {
			staticObserver[i] = i * 8;
		}
		int pinchableOption = (int)(sizeof(staticObserver) / sizeof(int));
		for (int i = 0; i < pinchableOption/2; i++) {
			staticObserver[pinchableOption - i - 1] = 4;
		}
		//NSLog(@"Business17 gen_int executed%@", Business17);
	});
}


@end
        