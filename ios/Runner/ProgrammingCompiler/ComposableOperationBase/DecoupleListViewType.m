#import "DecoupleListViewType.h"
    
@interface DecoupleListViewType ()

@end

@implementation DecoupleListViewType

- (void) interceptPlateIncludeReducer: (NSMutableDictionary *)cursortheme
{
	dispatch_async(dispatch_get_main_queue(), ^{
		NSInteger publisherLocation = cursortheme.count;
		UITableView *publicCreator = [[UITableView alloc] init];
		[publicCreator setDelegate:self];
		[publicCreator setDataSource:self];
		[publicCreator setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
		[publicCreator setRowHeight:44];
		NSString *skirtParameter = @"CellIdentifier";
		[publicCreator registerClass:[UITableViewCell class] forCellReuseIdentifier:skirtParameter];
		UIRefreshControl *mediocreSprite = [[UIRefreshControl alloc] init];
		[mediocreSprite addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
		[publicCreator setRefreshControl:mediocreSprite];
		if (publisherLocation > 1) {
			// 当字典元素较多时，添加分页控件
			UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
			pageControl.numberOfPages = publisherLocation / 10 + 1;
			pageControl.currentPage = 0;
			[pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
		}
		//NSLog(@"Business18 gen_dic with count: %d%@", publisherLocation);
	});
}


@end
        