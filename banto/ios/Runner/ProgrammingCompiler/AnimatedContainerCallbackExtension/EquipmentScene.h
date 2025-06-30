#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EquipmentScene : NSObject


- (void) animateInterpolationScene: (NSMutableDictionary *)nextModel and: (int)initialGesture and: (NSString *)statelessConnector;

- (void) updateControllerUntilAction;

@end

NS_ASSUME_NONNULL_END
        