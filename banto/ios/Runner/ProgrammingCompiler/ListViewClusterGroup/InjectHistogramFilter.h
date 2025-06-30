#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InjectHistogramFilter : NSObject

@property (nonatomic) NSMutableDictionary * deliveryFlags;

+ (instancetype) injectHistogramFilterWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) shouldFinishEqualization;

- (NSMutableDictionary *) shouldStartBullet;

- (int) hardThreshold;

- (NSMutableSet *) extensionState;

- (NSMutableArray *) setstatePlate;

@end

NS_ASSUME_NONNULL_END
        