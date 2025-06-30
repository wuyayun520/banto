#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InteractiveMetadataScope : NSObject

@property (nonatomic) NSString * cardScale;

+ (instancetype) interactiveMetadataScopeWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) tableLevel;

- (NSMutableDictionary *) shouldPublishMediaQuery;

- (int) transitionMaster;

- (NSMutableSet *) canCreateMobile;

- (NSMutableArray *) shouldTransformWorkflow;

@end

NS_ASSUME_NONNULL_END
        