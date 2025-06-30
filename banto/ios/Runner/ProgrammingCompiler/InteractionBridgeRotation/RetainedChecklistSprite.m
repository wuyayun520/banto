#import "RetainedChecklistSprite.h"
    
@interface RetainedChecklistSprite ()

@end

@implementation RetainedChecklistSprite

- (void) savePetData: (NSMutableDictionary *)intermediateGraphic
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSInteger transformsize = intermediateGraphic.count;
		UIScrollView *subscribeGrayscale = [[UIScrollView alloc] initWithFrame:CGRectMake(184, 114, 375, 605)];
		subscribeGrayscale.delaysContentTouches = YES;
		subscribeGrayscale.maximumZoomScale = 42;
		subscribeGrayscale.contentSize = CGSizeMake(497, 944);
		subscribeGrayscale.maximumZoomScale = 73;
		subscribeGrayscale.pagingEnabled = YES;
		//NSLog(@"sets= bussiness3 gen_dic %@", bussiness3);
	});
}


@end
        