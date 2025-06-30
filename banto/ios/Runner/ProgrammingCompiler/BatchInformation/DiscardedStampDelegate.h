#import "RegulateMediaQueryPool.h"
#import "ConcreteModelAdapter.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DiscardedStampDelegate : NSObject


- (void) waitHasMediaQuery;

- (void) instantiateFlexWithDispatcher;

@end

NS_ASSUME_NONNULL_END
        