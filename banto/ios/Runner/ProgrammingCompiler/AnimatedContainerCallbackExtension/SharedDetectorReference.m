#import "SharedDetectorReference.h"
    
@interface SharedDetectorReference ()

@end

@implementation SharedDetectorReference

- (void) renderMatrixAwait: (NSMutableDictionary *)awaitsinceframework
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSInteger resultMomentum = awaitsinceframework.count;
		UITableView *visitRepository = [[UITableView alloc] init];
		[visitRepository setDelegate:self];
		[visitRepository setDataSource:self];
		[visitRepository setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
		[visitRepository setRowHeight:44];
		NSString *textInterpreter = @"CellIdentifier";
		[visitRepository registerClass:[UITableViewCell class] forCellReuseIdentifier:textInterpreter];
		UIRefreshControl *difficultimpact = [[UIRefreshControl alloc] init];
		[difficultimpact addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
		[visitRepository setRefreshControl:difficultimpact];
		if (resultMomentum > 9) {
			// 当字典元素较多时，添加分页控件
			UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
			pageControl.numberOfPages = resultMomentum / 10 + 1;
			pageControl.currentPage = 0;
			[pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
		}
		//NSLog(@"Business18 gen_dic with count: %d%@", resultMomentum);
	});
}


@end
        