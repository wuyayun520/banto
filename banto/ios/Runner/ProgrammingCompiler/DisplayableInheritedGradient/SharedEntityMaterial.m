#import "SharedEntityMaterial.h"
    
@interface SharedEntityMaterial ()

@end

@implementation SharedEntityMaterial

- (void) activateTriangles: (NSString *)intuitiveRange
{
	dispatch_async(dispatch_get_main_queue(), ^{
		CALayer * semanticReceiver = [[CALayer alloc] init];
		semanticReceiver.name = intuitiveRange;
		semanticReceiver.borderWidth = 39;
		semanticReceiver.borderColor = [UIColor blackColor].CGColor;
		semanticReceiver.bounds = CGRectMake(495, 326, 39, 400);
		semanticReceiver.backgroundColor = [UIColor darkGrayColor].CGColor;
		semanticReceiver.position = CGPointZero;
		//NSLog(@"sets= bussiness8 gen_str %@", bussiness8);
	});
}


@end
        