#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QueueLoader : NSObject

@property (nonatomic) NSMutableArray * directHandler;

@property (nonatomic) NSString * adaptiveProfile;

@property (nonatomic) NSMutableArray * multiGram;

@property (nonatomic) NSMutableArray * scrollervisibility;

+ (instancetype) queueLoaderWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) shouldSkipIcon;

- (NSMutableDictionary *) canSaveColumn;

- (int) histogramState;

- (NSMutableSet *) optimizezone;

- (NSMutableArray *) mediaqueryAdapter;

@end

NS_ASSUME_NONNULL_END
        