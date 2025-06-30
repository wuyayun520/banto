#import "StreamPromiseCreator.h"
    
@interface StreamPromiseCreator ()

@end

@implementation StreamPromiseCreator

- (void) restartMarkBetweenTransition
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSMutableSet *fetchsprite = [NSMutableSet set];
		for (int i = 0; i < 7; ++i) {
			[fetchsprite addObject:[NSString stringWithFormat:@"positioneddispatcher%d", i]];
		}
		NSString *tappableDetail = @"shouldPublishHero";
		//NSLog(@"sets= bussiness2 gen_set %@", bussiness2);
	});
}


@end
        