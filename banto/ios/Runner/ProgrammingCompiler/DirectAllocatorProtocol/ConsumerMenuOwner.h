#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConsumerMenuOwner : NSObject

@property (nonatomic) NSMutableSet * equivalentBound;

+ (instancetype) consumerMenuOwnerWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) shouldEncodePositioned;

- (NSMutableDictionary *) responseChain;

- (int) refactorBuilder;

- (NSMutableSet *) lastSize;

- (NSMutableArray *) canMountMargin;

@end

NS_ASSUME_NONNULL_END
        