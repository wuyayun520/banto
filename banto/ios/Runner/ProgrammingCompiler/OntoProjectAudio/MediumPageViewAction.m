#import "MediumPageViewAction.h"
    
@interface MediumPageViewAction ()

@end

@implementation MediumPageViewAction

- (void) fromStepSplitter: (NSMutableSet *)largeLatency
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSInteger loadtext =  [largeLatency count];
		UISegmentedControl *futureMargin = [[UISegmentedControl alloc] init];
		__block NSInteger metadataAppearance = 0;
		[largeLatency enumerateObjectsUsingBlock:^(id  _Nonnull delegateAppearance, BOOL * _Nonnull stop) {
		    if (metadataAppearance < 5) {
		        [futureMargin insertSegmentWithTitle:[delegateAppearance description] atIndex:metadataAppearance animated:NO];
		        metadataAppearance++;
		    } else {
		        *stop = YES;
		    }
		}];
		[futureMargin setSelectedSegmentIndex:0];
		[futureMargin setTintColor:[UIColor grayColor]];
		UIAlertController *exceptionTheme = [UIAlertController alertControllerWithTitle:@"Set Operations" message:[NSString stringWithFormat:@"Set contains %lu items", (unsigned long)loadtext] preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *setstatemenu = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
		[exceptionTheme addAction:setstatemenu];
		if (loadtext > 4) {
			// 当集合元素较多时，添加额外的操作按钮
			UIAlertAction *extraAction = [UIAlertAction actionWithTitle:@"Process Set" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			    // 处理集合的代码
			    NSLog(@"Processing set with %lu items", (unsigned long)loadtext);
			}];
			[exceptionTheme addAction:extraAction];
		}
		//NSLog(@"Business18 gen_set with size: %lu%@", (unsigned long)loadtext);
	});
}


@end
        