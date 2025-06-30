#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UniformListViewExtension : NSObject


- (void) endMultiCollection;

- (void) rebuildCallback: (int)tensorSubscriber;

- (void) activateStream;

@end

NS_ASSUME_NONNULL_END
        