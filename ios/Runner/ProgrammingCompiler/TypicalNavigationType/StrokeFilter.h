#import "SinkState.h"
#import "AspectModelProtocol.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StrokeFilter : NSObject


- (void) skipGradientAlongEvolution;

- (void) navigateRotateUnderSubpixel;

@end

NS_ASSUME_NONNULL_END
        