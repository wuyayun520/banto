#import "SingleActivatedLabel.h"
#import "StoryboardStageScale.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ComposablePreviewAnalyzer : NSObject


- (void) needAsynchronousStoryboardBuffer;

- (void) popContainerAtSelector;

@end

NS_ASSUME_NONNULL_END
        