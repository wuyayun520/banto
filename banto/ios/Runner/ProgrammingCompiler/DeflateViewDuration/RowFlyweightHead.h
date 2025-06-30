#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RowFlyweightHead : NSObject

@property (nonatomic) NSString * sharedFeature;

@property (nonatomic) int enabledCosine;

+ (instancetype) rowFlyweightHeadWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) impactTail;

- (NSMutableDictionary *) gridobject;

- (int) shouldRenderCell;

- (NSMutableSet *) interfaceTag;

- (NSMutableArray *) curveperparameter;

@end

NS_ASSUME_NONNULL_END
        