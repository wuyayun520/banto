#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EffectTransformerOwner : NSObject

@property (nonatomic) NSMutableSet * strengthDuration;

@property (nonatomic) int cardBehavior;

+ (instancetype) effectTransformerOwnerWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) curveType;

- (NSMutableDictionary *) nextDuration;

- (int) chapterBuffer;

- (NSMutableSet *) commonOption;

- (NSMutableArray *) sinkdirection;

@end

NS_ASSUME_NONNULL_END
        