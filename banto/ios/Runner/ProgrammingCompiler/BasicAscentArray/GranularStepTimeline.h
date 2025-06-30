#import "IntermediateTriggerList.h"
#import "ObserverKindDepth.h"
#import "PauseShaderFilter.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GranularStepTimeline : NSObject


- (void) moveNewestRoute;

- (void) updateDisabledSubscription;

@end

NS_ASSUME_NONNULL_END
        