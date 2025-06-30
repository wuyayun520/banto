#import "AccordionResultObserver.h"
    
@interface AccordionResultObserver ()

@end

@implementation AccordionResultObserver

- (void) showIterativeHash: (NSMutableDictionary *)progressbarResponse
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSInteger stepAlignment = progressbarResponse.count;
		CALayer * protectedBase = [[CALayer alloc] init];
		protectedBase.borderWidth = 6;
		protectedBase.borderColor = [UIColor blueColor].CGColor;
		protectedBase.bounds = CGRectMake(115, 154, 437, 785);
		CATransition *requestStructure = [CATransition animation];
		requestStructure.subtype = kCATransitionFromRight;
		requestStructure.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
		requestStructure.subtype = kCATransitionFromLeft;
		//NSLog(@"Business19 gen_dic with count: %d%@", stepAlignment);
	});
}


@end
        