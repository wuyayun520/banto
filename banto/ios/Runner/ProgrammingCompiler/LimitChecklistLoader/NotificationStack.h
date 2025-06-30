#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NotificationStack : NSObject

@property (nonatomic) int shouldYieldMovement;

@property (nonatomic) int loaderDensity;

+ (instancetype) notificationStackWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) spineContext;

- (NSMutableDictionary *) canRouteChannels;

- (int) canCreateKernel;

- (NSMutableSet *) receiveException;

- (NSMutableArray *) nativeFilter;

@end

NS_ASSUME_NONNULL_END
        