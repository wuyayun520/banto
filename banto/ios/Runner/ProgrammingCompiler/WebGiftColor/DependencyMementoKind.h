#import "StandaloneRepositoryCache.h"
#import "OffsetPainterMetadata.h"
#import "PlaybackCluster.h"
#import "OptimizeActivatedFeature.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DependencyMementoKind : NSObject


- (void) computeBaselineFuture;

- (void) disconnectUnaryAlongCompleter;

@end

NS_ASSUME_NONNULL_END
        