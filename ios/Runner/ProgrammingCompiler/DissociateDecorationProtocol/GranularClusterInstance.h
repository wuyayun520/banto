#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GranularClusterInstance : NSObject

@property (nonatomic) int schemaHue;

@property (nonatomic) NSMutableSet * ignoredHash;

@property (nonatomic) NSMutableDictionary * shouldAttachAspectRatio;

@property (nonatomic) NSString * metricsLocation;

+ (instancetype) granularClusterInstanceWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) canShowGrayscale;

- (NSMutableDictionary *) inflateMultiplication;

- (int) canSerializeThread;

- (NSMutableSet *) lifecycleLeft;

- (NSMutableArray *) eagerDecoration;

@end

NS_ASSUME_NONNULL_END
        