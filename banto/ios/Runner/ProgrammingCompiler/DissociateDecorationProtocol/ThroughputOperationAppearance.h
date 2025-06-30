#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThroughputOperationAppearance : NSObject

@property (nonatomic) NSMutableSet * equipmentSkewX;

+ (instancetype) throughputOperationAppearanceWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) symbolSpeed;

- (NSMutableDictionary *) serializeCapacities;

- (int) statefulCount;

- (NSMutableSet *) shouldUnmountEntropy;

- (NSMutableArray *) specifierIndex;

@end

NS_ASSUME_NONNULL_END
        