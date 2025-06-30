#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MenuModelFactory : NSObject

@property (nonatomic) int toolawait;

+ (instancetype) menumodelFactoryWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) loadIcon;

- (NSMutableDictionary *) statelessCard;

- (int) shouldTransformTouch;

- (NSMutableSet *) limitsymbol;

- (NSMutableArray *) asyncBottom;

@end

NS_ASSUME_NONNULL_END
        