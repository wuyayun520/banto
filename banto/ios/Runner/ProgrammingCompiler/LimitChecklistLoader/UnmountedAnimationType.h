#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UnmountedAnimationType : NSObject

@property (nonatomic) NSMutableSet * protectedTrajectory;

@property (nonatomic) NSMutableSet * temporaryPlayback;

@property (nonatomic) int videoPadding;

+ (instancetype) unmountedAnimationTypeWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) embedDependency;

- (NSMutableDictionary *) partitionChapter;

- (int) combinerBehavior;

- (NSMutableSet *) mitigateSink;

- (NSMutableArray *) tabviewTop;

@end

NS_ASSUME_NONNULL_END
        