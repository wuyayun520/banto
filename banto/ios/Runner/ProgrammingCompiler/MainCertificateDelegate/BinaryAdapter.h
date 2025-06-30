#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BinaryAdapter : NSObject

@property (nonatomic) int composableWidget;

+ (instancetype) binaryAdapterWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) pinchableEffect;

- (NSMutableDictionary *) builderProxy;

- (int) associatedDropdownButton;

- (NSMutableSet *) gradientVisible;

- (NSMutableArray *) opaqueCubit;

@end

NS_ASSUME_NONNULL_END
        