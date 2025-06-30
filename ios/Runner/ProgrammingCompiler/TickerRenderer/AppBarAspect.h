#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppBarAspect : NSObject

@property (nonatomic) NSString * resourceKind;

+ (instancetype) appBaraspectWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) completerDelay;

- (NSMutableDictionary *) scaleValue;

- (int) unactivatedContrast;

- (NSMutableSet *) layoutCapacities;

- (NSMutableArray *) intensityCoord;

@end

NS_ASSUME_NONNULL_END
        