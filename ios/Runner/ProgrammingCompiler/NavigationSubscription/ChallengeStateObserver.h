#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChallengeStateObserver : NSObject

@property (nonatomic) NSMutableSet * currentstep;

@property (nonatomic) NSMutableSet * boxshadowlocation;

+ (instancetype) challengeStateObserverWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) logLayer;

- (NSMutableDictionary *) movementSaturation;

- (int) checkAwait;

- (NSMutableSet *) shouldMountTask;

- (NSMutableArray *) queueVisible;

@end

NS_ASSUME_NONNULL_END
        