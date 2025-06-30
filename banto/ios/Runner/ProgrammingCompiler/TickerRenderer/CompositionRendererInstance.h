#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CompositionRendererInstance : NSObject

@property (nonatomic) NSMutableDictionary * latencyTail;

@property (nonatomic) int taskOpacity;

+ (instancetype) compositionRendererInstanceWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) divideSprite;

- (NSMutableDictionary *) shouldHandleBehavior;

- (int) transposeRequest;

- (NSMutableSet *) materialDirection;

- (NSMutableArray *) optionrotation;

@end

NS_ASSUME_NONNULL_END
        