#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BlocResponse : NSObject

@property (nonatomic) NSMutableDictionary * sequentialInfo;

+ (instancetype) blocResponseWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) shouldEndWorkflow;

- (NSMutableDictionary *) sortedAnimation;

- (int) ongradienttap;

- (NSMutableSet *) ephemeralHistogram;

- (NSMutableArray *) blocDensity;

@end

NS_ASSUME_NONNULL_END
        