#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SkipDecorationEvent : NSObject

@property (nonatomic) NSMutableSet * requiredDuration;

@property (nonatomic) int normrow;

+ (instancetype) skipDecorationEventWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) signforce;

- (NSMutableDictionary *) shouldUnmountSegue;

- (int) discardedComponent;

- (NSMutableSet *) declarativeEntity;

- (NSMutableArray *) substantialInteraction;

@end

NS_ASSUME_NONNULL_END
        