#import "NewestRouteSound.h"
    
@interface NewestRouteSound ()

@end

@implementation NewestRouteSound

- (void) updateTouchOntoButton: (NSString *)curveposition
{
	dispatch_async(dispatch_get_main_queue(), ^{
		UIDatePicker *densealpha = [[UIDatePicker alloc] init];
		UILabel *alertFlyweight = [[UILabel alloc] initWithFrame:CGRectMake(356, 47, 981, 178)];
		alertFlyweight.lineBreakMode = 1;
		alertFlyweight.layer.shadowOffset = CGSizeMake(290, 36);
		alertFlyweight.center = CGPointMake(409, 436);
		NSMutableAttributedString *pivotalStore = [[NSMutableAttributedString alloc] initWithString:curveposition];
		[pivotalStore addAttribute:NSUnderlineStyleAttributeName value:@5 range:NSMakeRange(0, MIN(10, [curveposition length] - 0))];
		[pivotalStore addAttribute:NSForegroundColorAttributeName value:[UIColor purpleColor] range:NSMakeRange(2, MIN(10, [curveposition length] - 2))];
		[pivotalStore addAttribute:NSBackgroundColorAttributeName value:[UIColor brownColor] range:NSMakeRange(4, MIN(2, [curveposition length] - 4))];
		//NSLog(@"Business18 gen_str with text: %@%@", curveposition);
	});
}


@end
        