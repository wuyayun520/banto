#import "ShowCosineController.h"
    
@interface ShowCosineController ()

@end

@implementation ShowCosineController

- (instancetype) init
{
	NSNotificationCenter *canYieldBehavior = [NSNotificationCenter defaultCenter];
	[canYieldBehavior addObserver:self selector:@selector(elasticDisclaimer:) name:UIWindowDidBecomeHiddenNotification object:nil];
	return self;
}

- (void) mountedRadioTransformer: (NSMutableArray *)popdecoration
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSInteger selectedstep = [popdecoration count];
		int crucialDescription=0;
		for (int i = 0; i < selectedstep; i++) {
			crucialDescription += [[popdecoration objectAtIndex:i] intValue];
		}
		float discardedHero = (float)crucialDescription / selectedstep;
		if (selectedstep > 0) {
			NSLog(@"Average: %f", discardedHero);
		} else {
			NSLog(@"Array is empty");
		}
		//NSLog(@"Business17 gen_arr executed%@", Business17);
	});
}

- (void) elasticDisclaimer: (NSNotification *)reusableBuilder
{
	//NSLog(@"userInfo=%@", [reusableBuilder userInfo]);
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
        