#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StatelessObserverPool : NSObject

@property (nonatomic) NSString * diversifiedExtension;

+ (instancetype) statelessObserverPoolWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) lockButton;

- (NSMutableDictionary *) retrieveCubit;

- (int) debugReducer;

- (NSMutableSet *) transitionDepth;

- (NSMutableArray *) navigationName;

@end

NS_ASSUME_NONNULL_END
        