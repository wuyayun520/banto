#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaveProviderListener : NSObject

@property (nonatomic) NSMutableDictionary * protectedAspect;

+ (instancetype) saveProviderListenerWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) storyboardFunction;

- (NSMutableDictionary *) shouldValidatePromise;

- (int) restartdelegate;

- (NSMutableSet *) lostStamp;

- (NSMutableArray *) globalInfo;

@end

NS_ASSUME_NONNULL_END
        