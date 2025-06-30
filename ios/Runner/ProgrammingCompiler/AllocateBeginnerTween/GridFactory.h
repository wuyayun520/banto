#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GridFactory : NSObject

@property (nonatomic) int shouldShowStamp;

@property (nonatomic) int enabledPolyfill;

+ (instancetype) gridFactoryWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) constraintVariable;

- (NSMutableDictionary *) delicateTween;

- (int) materialConnector;

- (NSMutableSet *) shouldSetStateChannels;

- (NSMutableArray *) widgetObserver;

@end

NS_ASSUME_NONNULL_END
        