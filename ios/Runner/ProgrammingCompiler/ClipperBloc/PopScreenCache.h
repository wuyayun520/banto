#import "WithoutBrushScheduler.h"
#import "AnimateNavigationAmortization.h"
#import "SharedMobilePool.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PopScreenCache : NSObject


- (void) buildCustomizedBloc;

- (void) unmountAddThroughTask;

@end

NS_ASSUME_NONNULL_END
        