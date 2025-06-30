#import "ChartTentative.h"
    
@interface ChartTentative ()

@end

@implementation ChartTentative

- (void) setSpecifier: (NSString *)icontop
{
	dispatch_async(dispatch_get_main_queue(), ^{
		UITextField *directlyMapper = [[UITextField alloc] init];
		directlyMapper.text = @"icontop";
		directlyMapper.font = [UIFont fontWithName:@"TrebuchetMS-Italic" size:65.000000];
		//NSLog(@"Business19 gen_str with text: %@%@", icontop);
	});
}


@end
        