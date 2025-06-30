#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GroupActionDensity : NSObject

@property (nonatomic) int fixedResilience;

@property (nonatomic) int inactiveStrength;

@property (nonatomic) NSMutableDictionary * hardData;

@property (nonatomic) NSMutableDictionary * mainInfo;

@property (nonatomic) NSString * pointDensity;

@property (nonatomic) NSString * ismediaquery;

+ (instancetype) groupActionDensityWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) handleCube;

- (NSMutableDictionary *) publicAlert;

- (int) accessibleBorder;

- (NSMutableSet *) nextOffset;

- (NSMutableArray *) protectedFragments;

@end

NS_ASSUME_NONNULL_END
        