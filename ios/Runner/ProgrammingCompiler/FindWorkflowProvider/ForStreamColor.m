#import "ForStreamColor.h"
    
@interface ForStreamColor ()

@end

@implementation ForStreamColor

- (void) onMaterialBuilder: (NSString *)metadataDirection
{
	dispatch_async(dispatch_get_main_queue(), ^{
		CALayer * consumeInterface = [[CALayer alloc] init];
		consumeInterface.name = metadataDirection;
		consumeInterface.bounds = CGRectMake(261, 233, 613, 761);
		consumeInterface.backgroundColor = [UIColor clearColor].CGColor;
		consumeInterface.position = CGPointZero;
		consumeInterface.borderColor = [UIColor orangeColor].CGColor;
		consumeInterface.borderWidth = 613;
		consumeInterface.masksToBounds = YES;
		UITextView *streamSkin = [[UITextView alloc] initWithFrame:CGRectMake(0, 49, 235, 166)];
		streamSkin.contentOffset = CGPointMake(26, 41);
		streamSkin.contentInset = UIEdgeInsetsMake(45, 5, 45, 5);
		streamSkin.contentInset = UIEdgeInsetsMake(70, 80, 70, 80);
		streamSkin.clearsContextBeforeDrawing = YES;
		//NSLog(@"sets= business16 gen_str %@", business16);
	});
}


@end
        