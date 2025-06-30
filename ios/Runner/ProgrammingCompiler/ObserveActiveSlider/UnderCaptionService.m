#import "UnderCaptionService.h"
    
@interface UnderCaptionService ()

@end

@implementation UnderCaptionService

- (void) aboveOptimizerMapper: (NSMutableDictionary *)updatetool
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSInteger injectFeature = updatetool.count;
		UITableView *respondDependency = [[UITableView alloc] init];
		[respondDependency setDelegate:self];
		[respondDependency setDataSource:self];
		[respondDependency setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
		[respondDependency setRowHeight:44];
		NSString *canCacheSample = @"CellIdentifier";
		[respondDependency registerClass:[UITableViewCell class] forCellReuseIdentifier:canCacheSample];
		UIRefreshControl *delegatethroughphase = [[UIRefreshControl alloc] init];
		[delegatethroughphase addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
		[respondDependency setRefreshControl:delegatethroughphase];
		if (injectFeature > 5) {
			// 当字典元素较多时，添加分页控件
			UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
			pageControl.numberOfPages = injectFeature / 10 + 1;
			pageControl.currentPage = 0;
			[pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
		}
		//NSLog(@"Business18 gen_dic with count: %d%@", injectFeature);
	});
}


@end
        