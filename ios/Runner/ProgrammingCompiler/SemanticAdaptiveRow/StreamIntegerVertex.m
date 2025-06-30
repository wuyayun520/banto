#import "StreamIntegerVertex.h"
    
@interface StreamIntegerVertex ()

@end

@implementation StreamIntegerVertex

- (void) doesOnTabBarTap: (NSString *)radiusmodecount
{
	dispatch_async(dispatch_get_main_queue(), ^{
		UILabel *singleTimer = [[UILabel alloc] initWithFrame:CGRectMake(232, 28, 408, 973)];
		singleTimer.shadowColor = [UIColor colorWithRed:105/255.0 green:336/255.0 blue:105/255.0 alpha:1.0];
		singleTimer.text = @"obtainTicker";
		UIDatePicker *encodePoint = [[UIDatePicker alloc]init];
		[encodePoint setLocale: [NSLocale  localeWithLocaleIdentifier:@"ru"]];
		[encodePoint setLocale: [NSLocale  localeWithLocaleIdentifier:@"fr-Canada"]];
		UITextField *notifyHistogram = [[UITextField alloc] init];
		notifyHistogram.inputView = encodePoint;
		//NSLog(@"sets= bussiness3 gen_str %@", bussiness3);
	});
}


@end
        