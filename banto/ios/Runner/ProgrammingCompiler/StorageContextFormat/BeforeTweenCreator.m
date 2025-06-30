#import "BeforeTweenCreator.h"
    
@interface BeforeTweenCreator ()

@end

@implementation BeforeTweenCreator

- (void) rebuildUnregisterByGrayscale: (NSString *)spineTheme
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSMutableDictionary *normalTicker = [NSMutableDictionary dictionary];
		normalTicker[@"None"] = [UIColor colorNamed:@"purpleColor"];;
		normalTicker[@"None"] = @165;
		[spineTheme drawAtPoint:CGPointMake(25, 233) withAttributes:normalTicker];
		UITableViewCell *referencelifecycle = [[UITableViewCell alloc]init];
		referencelifecycle.detailTextLabel.text = @"baseTemple";
		referencelifecycle.selectionStyle = UITableViewCellSelectionStyleGray;
		referencelifecycle.detailTextLabel.text = @"enumerateConstraint";
		//NSLog(@"sets= bussiness1 gen_str %@", bussiness1);
	});
}


@end
        