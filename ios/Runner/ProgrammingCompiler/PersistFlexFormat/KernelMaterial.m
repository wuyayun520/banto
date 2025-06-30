#import "KernelMaterial.h"
    
@interface KernelMaterial ()

@end

@implementation KernelMaterial

- (void) shearEvaluation: (NSString *)dimensiontop
{
	dispatch_async(dispatch_get_main_queue(), ^{
		UISegmentedControl *parsebloc = [[UISegmentedControl alloc] init];
		[parsebloc insertSegmentWithTitle:dimensiontop atIndex:0 animated:YES];
		parsebloc.enabled = NO;
		parsebloc.selected = YES;
		UITableView *visiblecaption = [[UITableView alloc] init];
		[visiblecaption setContentSize:CGSizeMake(232, 456)];
		[visiblecaption setSectionFooterHeight:630];
		[visiblecaption setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
		[visiblecaption setSectionFooterHeight:456];
		//NSLog(@"sets= bussiness5 gen_str %@", bussiness5);
	});
}


@end
        