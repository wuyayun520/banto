#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SkinDelivery : NSObject

@property (nonatomic) NSMutableArray * textschema;

@property (nonatomic) NSMutableDictionary * materialSkin;

+ (instancetype) skinDeliveryWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) comprehensiveDetector;

- (NSMutableDictionary *) uniqueUsage;

- (int) requiredDelivery;

- (NSMutableSet *) accessibleSpecifier;

- (NSMutableArray *) otherTrajectory;

@end

NS_ASSUME_NONNULL_END
        