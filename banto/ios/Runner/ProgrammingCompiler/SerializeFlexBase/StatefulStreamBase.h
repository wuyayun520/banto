#import "NativeComponentInstance.h"
#import "MountedCardResponse.h"
#import "NativeRadioOffset.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StatefulStreamBase : NSObject


- (void) skipDependency;

- (void) unbindAsync;

@end

NS_ASSUME_NONNULL_END
        