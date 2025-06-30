#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BetweenDimensionTrigger : NSObject

@property (nonatomic) int linkertail;

@property (nonatomic) int draggabletriangles;

+ (instancetype) betweenDimensionTriggerWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) notifierState;

- (NSMutableDictionary *) secondRequest;

- (int) prevDelegate;

- (NSMutableSet *) cleanDuration;

- (NSMutableArray *) intuitiveContraction;

@end

NS_ASSUME_NONNULL_END
        