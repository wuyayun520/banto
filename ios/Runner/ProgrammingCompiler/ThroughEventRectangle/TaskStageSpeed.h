#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskStageSpeed : NSObject

@property (nonatomic) NSString * explicitFragments;

@property (nonatomic) NSMutableArray * staticCurve;

+ (instancetype) taskStageSpeedWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) attachShader;

- (NSMutableDictionary *) navigateScreen;

- (int) semanticBehavior;

- (NSMutableSet *) oldMovement;

- (NSMutableArray *) nodestate;

@end

NS_ASSUME_NONNULL_END
        