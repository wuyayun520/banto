#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ElasticSliderLoader : NSObject

@property (nonatomic) int displayableradioscale;

@property (nonatomic) NSString * significantPadding;

+ (instancetype) elasticSliderLoaderWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) activatedTimeline;

- (NSMutableDictionary *) subpixelSize;

- (int) shouldResumeTabView;

- (NSMutableSet *) shouldUpdateHero;

- (NSMutableArray *) notifierKind;

@end

NS_ASSUME_NONNULL_END
        