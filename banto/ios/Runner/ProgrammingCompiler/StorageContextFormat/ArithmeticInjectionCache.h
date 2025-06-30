#import "PlayDirectlyAllocator.h"
#import "ImmutableSemanticInjection.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArithmeticInjectionCache : NSObject


- (void) propagateEquivalent;

- (void) processDiffableStream;

@end

NS_ASSUME_NONNULL_END
        