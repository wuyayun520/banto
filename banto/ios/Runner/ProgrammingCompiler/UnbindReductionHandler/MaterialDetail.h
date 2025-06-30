#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MaterialDetail : NSObject

@property (nonatomic) NSMutableDictionary * customTweak;

@property (nonatomic) int usedcertificate;

+ (instancetype) materialDetailWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) cosineDensity;

- (NSMutableDictionary *) shouldProcessBorder;

- (int) pauseEqualization;

- (NSMutableSet *) largeSpot;

- (NSMutableArray *) rebuildcoordinator;

@end

NS_ASSUME_NONNULL_END
        