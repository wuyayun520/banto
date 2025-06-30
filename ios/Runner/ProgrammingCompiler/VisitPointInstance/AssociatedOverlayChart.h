#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssociatedOverlayChart : NSObject

@property (nonatomic) NSString * toolcontainer;

@property (nonatomic) NSString * notifypoint;

@property (nonatomic) int observerAcceleration;

+ (instancetype) associatedOverlayChartWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) shouldRebuildInterpolation;

- (NSMutableDictionary *) shouldEndIndicator;

- (int) skinVelocity;

- (NSMutableSet *) renderbase;

- (NSMutableArray *) canDeserializeVariant;

@end

NS_ASSUME_NONNULL_END
        