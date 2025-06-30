#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NotifyMovementEntity : NSObject

@property (nonatomic) NSMutableDictionary * videoState;

+ (instancetype) notifyMovementEntityWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) canSetStateColumn;

- (NSMutableDictionary *) converterShape;

- (int) setupState;

- (NSMutableSet *) shouldTrainTask;

- (NSMutableArray *) shouldUnbindThread;

@end

NS_ASSUME_NONNULL_END
        