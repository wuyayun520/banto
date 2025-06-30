#import "LimitStoryboardNotation.h"
    
@interface LimitStoryboardNotation ()

@end

@implementation LimitStoryboardNotation

- (void) presentPrimaryExpanded: (NSMutableArray *)onThreadTap
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSInteger compositionLeft = [onThreadTap count];
		int litePublisher=0;
		for (int i = 0; i < compositionLeft; i++) {
			litePublisher += [[onThreadTap objectAtIndex:i] intValue];
		}
		float momentumBridge = (float)litePublisher / compositionLeft;
		if (compositionLeft > 0) {
			NSLog(@"Average: %f", momentumBridge);
		} else {
			NSLog(@"Array is empty");
		}
		UIPickerView *currentSpecifier = [[UIPickerView alloc] initWithFrame:CGRectMake(108, 236, 78, 268)];
		currentSpecifier.layer.borderColor = [UIColor colorWithRed:243/255.0 green:208/255.0 blue:93/255.0 alpha:1.0].CGColor;
		currentSpecifier.frame = CGRectMake(62, 230, 87, 230);
		currentSpecifier.layer.cornerRadius = 3.7;
		[currentSpecifier reloadAllComponents];
		currentSpecifier.alpha = 0.4;
		//NSLog(@"Business17 gen_arr executed%@", Business17);
	});
}


@end
        