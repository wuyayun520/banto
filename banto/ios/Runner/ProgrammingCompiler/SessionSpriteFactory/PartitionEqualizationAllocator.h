#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PartitionEqualizationAllocator : NSObject


- (void) generateDraggableStateful: (NSString *)statelessfilter;

- (void) pushAnimatedInstruction: (NSMutableSet *)compositionalEquivalent;

@end

NS_ASSUME_NONNULL_END
        