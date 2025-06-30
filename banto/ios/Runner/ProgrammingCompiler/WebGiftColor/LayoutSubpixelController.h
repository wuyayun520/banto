#import "InRectShape.h"
#import "ForSwitchManager.h"
#import "SubsequentIsolateHelper.h"
#import "PublicComponentTarget.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LayoutSubpixelController : NSObject


- (void) clipHeapViaGrain;

- (void) didRequiredAllocatorStage;

@end

NS_ASSUME_NONNULL_END
        