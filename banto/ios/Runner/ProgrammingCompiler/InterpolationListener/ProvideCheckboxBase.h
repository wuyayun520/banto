#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProvideCheckboxBase : NSObject

@property (nonatomic) NSMutableSet * popupIndex;

@property (nonatomic) NSString * shouldAnimateSpot;

@property (nonatomic) NSMutableDictionary * displayableGrain;

+ (instancetype) provideCheckboxBaseWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) cacheAnchor;

- (NSMutableDictionary *) canValidateSlider;

- (int) mainSubpixel;

- (NSMutableSet *) createDelegate;

- (NSMutableArray *) normalbloc;

@end

NS_ASSUME_NONNULL_END
        