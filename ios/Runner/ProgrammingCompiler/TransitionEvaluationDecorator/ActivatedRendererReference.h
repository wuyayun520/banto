#import "UnmountModalNotation.h"
#import "HierarchicalEffectEmitter.h"
#import "ByMetadataDescription.h"
#import "AccordionDependencyConsumption.h"

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ActivatedRendererReference : NSObject


- (void) transitionShowFromConsumer;

- (void) executeInCoordinatorMemento;

@end

NS_ASSUME_NONNULL_END
        