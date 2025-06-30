#import "WidgetItemDelegate.h"
    
@interface WidgetItemDelegate ()

@end

@implementation WidgetItemDelegate

- (void) compileInteraction
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSMutableDictionary *canPublishScale = [NSMutableDictionary dictionary];
		for (int i = 0; i < 1; ++i) {
			canPublishScale[[NSString stringWithFormat:@"logTag%d", i]] = @"widgetCycle";
		}
		//NSLog(@"sets= bussiness2 gen_dic %@", bussiness2);
	});
}


@end
        