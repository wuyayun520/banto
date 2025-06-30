#import "AddPointReference.h"
    
@interface AddPointReference ()

@end

@implementation AddPointReference

- (void) popMaterial: (NSMutableSet *)responsiveMaterial
{
	dispatch_async(dispatch_get_main_queue(), ^{
		UIProgressView *vectorCount = [[UIProgressView alloc] init];
		vectorCount.multipleTouchEnabled = YES;
		vectorCount.layer.borderColor = [UIColor colorWithRed:111/255.0 green:114/255.0 blue:31/255.0 alpha:0].CGColor;
		vectorCount.frame = CGRectMake(28.000000, 59.000000, 75.000000, 84.000000);
		vectorCount.layer.borderWidth = 10;
		vectorCount.progressViewStyle = UIProgressViewStyleBar;
		vectorCount.progress = 86;
		vectorCount.layer.borderWidth = 0;
		vectorCount.layer.borderWidth = 19;
		vectorCount.progressViewStyle = UIProgressViewStyleDefault;
		//NSLog(@"sets= bussiness1 gen_set %@", bussiness1);
	});
}


@end
        