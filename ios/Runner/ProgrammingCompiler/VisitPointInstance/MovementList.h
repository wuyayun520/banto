#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovementList : NSObject

@property (nonatomic) NSString * globalEmitter;

@property (nonatomic) NSString * converterDelay;

@property (nonatomic) NSMutableSet * shouldSkipAnimation;

+ (instancetype) movementListWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) adaptiveAnimator;

- (NSMutableDictionary *) finishGradient;

- (int) permanenttweak;

- (NSMutableSet *) canAnimatePadding;

- (NSMutableArray *) nibDelay;

@end

NS_ASSUME_NONNULL_END
        