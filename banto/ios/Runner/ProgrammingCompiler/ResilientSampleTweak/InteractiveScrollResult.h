#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InteractiveScrollResult : NSObject

@property (nonatomic) NSMutableDictionary * symmetricTouch;

@property (nonatomic) NSString * frameBrightness;

@property (nonatomic) NSMutableArray * denseView;

@property (nonatomic) NSMutableSet * originalZone;

+ (instancetype) interactiveScrollResultWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) requiredChecklist;

- (NSMutableDictionary *) curveTop;

- (int) substantialTrigger;

- (NSMutableSet *) scenarioBound;

- (NSMutableArray *) displayableSchema;

@end

NS_ASSUME_NONNULL_END
        