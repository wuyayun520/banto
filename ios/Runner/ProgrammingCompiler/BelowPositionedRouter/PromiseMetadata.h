#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PromiseMetadata : NSObject

@property (nonatomic) NSMutableSet * deliveryVisible;

@property (nonatomic) NSString * moduleBrightness;

+ (instancetype) promiseMetadataWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) inflateChannels;

- (NSMutableDictionary *) respectiveTransformer;

- (int) graphicslider;

- (NSMutableSet *) spriteOpacity;

- (NSMutableArray *) apertureAction;

@end

NS_ASSUME_NONNULL_END
        