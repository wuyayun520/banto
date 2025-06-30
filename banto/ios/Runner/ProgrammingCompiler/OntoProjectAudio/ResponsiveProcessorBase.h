#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ResponsiveProcessorBase : NSObject

@property (nonatomic) NSMutableSet * globalDocument;

@property (nonatomic) int easyTabView;

+ (instancetype) responsiveProcessorBaseWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) lostEffect;

- (NSMutableDictionary *) concurrentStore;

- (int) originalSensor;

- (NSMutableSet *) specifyReduction;

- (NSMutableArray *) shouldbuildmonster;

@end

NS_ASSUME_NONNULL_END
        