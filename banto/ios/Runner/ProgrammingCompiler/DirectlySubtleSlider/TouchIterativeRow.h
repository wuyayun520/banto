#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TouchIterativeRow : NSObject


- (void) disconnectStatelessGrid;

- (void) notifySkinAtManager: (NSMutableDictionary *)segmentOrientation and: (NSString *)oldLayout;

@end

NS_ASSUME_NONNULL_END
        