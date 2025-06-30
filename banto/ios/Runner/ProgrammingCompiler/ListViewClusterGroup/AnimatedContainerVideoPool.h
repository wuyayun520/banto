#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnimatedContainerVideoPool : NSObject

@property (nonatomic) int mergerFrequency;

@property (nonatomic) NSMutableArray * spineOpacity;

+ (instancetype) animatedContainerVideoPoolWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) sessionBrightness;

- (NSMutableDictionary *) reduceAsset;

- (int) rapidStep;

- (NSMutableSet *) canRebuildGesture;

- (NSMutableArray *) presenterColor;

@end

NS_ASSUME_NONNULL_END
        