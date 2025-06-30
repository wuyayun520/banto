#import "HistogramTempleType.h"
    
@interface HistogramTempleType ()

@end

@implementation HistogramTempleType

- (instancetype) init
{
	NSNotificationCenter *makeModel = [NSNotificationCenter defaultCenter];
	[makeModel addObserver:self selector:@selector(compositionalGraph:) name:UIKeyboardWillChangeFrameNotification object:nil];
	return self;
}

- (void) popOutIconState: (NSMutableArray *)directInfo
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSString *explicitUsage = @"shouldPopGestureDetector";
		//NSLog(@"sets= bussiness9 gen_arr %@", bussiness9);
	});
}

- (void) compositionalGraph: (NSNotification *)canProcessNotification
{
	//NSLog(@"userInfo=%@", [canProcessNotification userInfo]);
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
        