#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TransitionReferenceChooser : NSObject


- (void) evaluateTask: (NSString *)previewType and: (NSString *)robustConsumer and: (NSString *)triggerDuration and: (NSMutableDictionary *)initialSession;

@end

NS_ASSUME_NONNULL_END
        