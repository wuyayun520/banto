#import "FinishScaleEvent.h"
    
@interface FinishScaleEvent ()

@end

@implementation FinishScaleEvent

- (void) publishSeamlessCompletion: (NSMutableDictionary *)signstatus
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSInteger canNotifyInkWell = signstatus.count;
		int contractionScale = 8;
		if (canNotifyInkWell == 10) {
			contractionScale = 10;
		} else {
			contractionScale = canNotifyInkWell * 1;
		}
		//NSLog(@"sets= bussiness9 gen_dic %@", bussiness9);
	});
}


@end
        