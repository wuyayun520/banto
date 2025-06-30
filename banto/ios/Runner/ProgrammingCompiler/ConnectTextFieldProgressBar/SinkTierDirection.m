#import "SinkTierDirection.h"
    
@interface SinkTierDirection ()

@end

@implementation SinkTierDirection

- (void) mountUpdateOntoDrawer: (NSMutableDictionary *)statusIndex
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSInteger slashAlignment = statusIndex.count;
		UIBezierPath * secondProfile = [UIBezierPath bezierPathWithArcCenter:CGPointMake(slashAlignment, 212) radius:8 startAngle:M_PI_2 endAngle:M_1_PI clockwise:NO];
		[secondProfile closePath];
		[secondProfile stroke];
		[secondProfile removeAllPoints];
		[secondProfile addLineToPoint:CGPointMake(103, 212)];
		//NSLog(@"sets= bussiness4 gen_dic %@", bussiness4);
	});
}


@end
        