#import "BackwardGridDecorator.h"
#import "SetupFixedPopup.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LayoutCompleterProtocol : NSObject


- (void) didMissedCompositionKind;

- (void) emitChecklistInsideRect;

@end

NS_ASSUME_NONNULL_END
        