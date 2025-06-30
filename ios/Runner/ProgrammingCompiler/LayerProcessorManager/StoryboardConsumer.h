#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StoryboardConsumer : NSObject

@property (nonatomic) NSString * switchInterval;

@property (nonatomic) NSMutableSet * staticBehavior;

+ (instancetype) storyboardConsumerWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) canEndPet;

- (NSMutableDictionary *) minNib;

- (int) semanticTolerance;

- (NSMutableSet *) managerFlyweight;

- (NSMutableArray *) interpolationStrategy;

@end

NS_ASSUME_NONNULL_END
        