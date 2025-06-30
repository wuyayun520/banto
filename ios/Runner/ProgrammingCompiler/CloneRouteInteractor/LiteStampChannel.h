#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiteStampChannel : NSObject


- (void) overScrollDetail: (NSString *)accessibleCluster and: (NSString *)ignoredProtocol and: (int)lastTimeline;

- (void) interceptNode;

@end

NS_ASSUME_NONNULL_END
        