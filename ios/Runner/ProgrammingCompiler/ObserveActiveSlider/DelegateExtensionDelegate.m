#import "DelegateExtensionDelegate.h"
    
@interface DelegateExtensionDelegate ()

@end

@implementation DelegateExtensionDelegate

- (void) markCycleAsQueue: (NSMutableDictionary *)throughputHue
{
	dispatch_async(dispatch_get_main_queue(), ^{
		for (NSString *activatedDetail in throughputHue.allKeys) {
			if ([activatedDetail length] > 0) {
				NSLog(@"Key found: %@", activatedDetail);
			}
		}
		CABasicAnimation *autoTransition = [CABasicAnimation animationWithKeyPath:@"liteInteger"];
		autoTransition.fillMode = kCAFillModeRemoved;
		autoTransition.toValue = [NSValue valueWithCGPoint:CGPointMake(38, 273)];
		//NSLog(@"sets= business11 gen_dic %@", business11);
	});
}


@end
        