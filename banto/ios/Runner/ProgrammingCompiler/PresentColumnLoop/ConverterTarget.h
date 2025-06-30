#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConverterTarget : NSObject

@property (nonatomic) NSMutableSet * reactivePreview;

@property (nonatomic) NSMutableSet * staticCallback;

@property (nonatomic) NSMutableDictionary * schedulerFlags;

@property (nonatomic) NSString * positionedMode;

+ (instancetype) converterTargetWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) referenceSystem;

- (NSMutableDictionary *) flexiblemediaquery;

- (int) activeImage;

- (NSMutableSet *) publisherSkewX;

- (NSMutableArray *) overridePreview;

@end

NS_ASSUME_NONNULL_END
        