#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SeamlessLoaderTarget : NSObject

@property (nonatomic) NSMutableSet * instructionMode;

+ (instancetype) seamlessLoaderTargetWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) localizationAlignment;

- (NSMutableDictionary *) shouldUnbindShader;

- (int) primaryMatrix;

- (NSMutableSet *) selectedWidget;

- (NSMutableArray *) heapStructure;

@end

NS_ASSUME_NONNULL_END
        