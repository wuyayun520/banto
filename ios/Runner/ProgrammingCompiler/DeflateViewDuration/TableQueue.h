#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableQueue : NSObject

@property (nonatomic) NSMutableDictionary * otherRange;

+ (instancetype) tableQueueWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) canDisposeConsumer;

- (NSMutableDictionary *) shouldUpdatePriority;

- (int) chartdelay;

- (NSMutableSet *) smallResolver;

- (NSMutableArray *) loaderHead;

@end

NS_ASSUME_NONNULL_END
        