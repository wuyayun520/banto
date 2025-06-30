#import "IntermediateBehaviorWrapper.h"
#import "SequentialStaticRichText.h"
#import "OffTaskEquivalent.h"
#import "PersistChecklistAdapter.h"
#import "BindPersistentRichText.h"
#import "SpriteDecoratorLocation.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DiversifiedMemberScheduler : NSObject


- (void) consumeRect;

- (void) keepOtherAsync;

@end

NS_ASSUME_NONNULL_END
        