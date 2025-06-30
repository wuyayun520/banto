#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DiscoverSwitchList : NSObject

@property (nonatomic) int spriteFrequency;

@property (nonatomic) NSMutableArray * animateaction;

@property (nonatomic) NSMutableArray * captionOffset;

@property (nonatomic) NSMutableArray * containeranimator;

+ (instancetype) discoverSwitchListWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) integerValue;

- (NSMutableDictionary *) shouldPublishCard;

- (int) shouldProcessModulus;

- (NSMutableSet *) statefulActivity;

- (NSMutableArray *) shouldStartInterpolation;

@end

NS_ASSUME_NONNULL_END
        