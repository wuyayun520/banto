#import "CollectionView.h"
#import "StatelessTickerLifecycle.h"
#import "UnactivatedScalabilityGroup.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnimationDelivery : NSObject


- (void) saveWidget;

- (void) rebuildFlexibleRow;

@end

NS_ASSUME_NONNULL_END
        