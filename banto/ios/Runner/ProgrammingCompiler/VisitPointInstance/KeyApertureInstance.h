#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyApertureInstance : NSObject

@property (nonatomic) NSMutableArray * responsiveAnimation;

+ (instancetype) keyApertureInstanceWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) activateStore;

- (NSMutableDictionary *) shouldNotifyLoss;

- (int) touchlifecycle;

- (NSMutableSet *) canNotifyTabBar;

- (NSMutableArray *) buildObserver;

@end

NS_ASSUME_NONNULL_END
        