#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SoundAdapterIndex : NSObject


- (void) scheduleUsedTransition;

- (void) executeRequest: (int)samplestroke;

- (void) retrieveSession;

@end

NS_ASSUME_NONNULL_END
        