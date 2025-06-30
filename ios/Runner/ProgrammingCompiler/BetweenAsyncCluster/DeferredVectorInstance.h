#import "LayoutObject.h"
#import "StringifyNavigationGroup.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeferredVectorInstance : NSObject


- (void) rebuildReductionAgainstResilience;

- (void) materializeTrigger;

@end

NS_ASSUME_NONNULL_END
        