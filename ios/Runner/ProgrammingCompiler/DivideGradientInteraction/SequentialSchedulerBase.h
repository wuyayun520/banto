#import "BufferCallbackInstance.h"
#import "BindBuilderFactory.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SequentialSchedulerBase : NSObject


- (void) yieldReadBelowMomentum;

- (void) pushBorderForReplica;

@end

NS_ASSUME_NONNULL_END
        