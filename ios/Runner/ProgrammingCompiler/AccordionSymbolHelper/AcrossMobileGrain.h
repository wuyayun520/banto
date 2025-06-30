#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AcrossMobileGrain : NSObject

@property (nonatomic) NSMutableDictionary * shouldEmitPlayback;

@property (nonatomic) int behaviorOffset;

@property (nonatomic) int grainschema;

@property (nonatomic) int consumptionAlignment;

+ (instancetype) acrossMobileGrainWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) operationSpeed;

- (NSMutableDictionary *) webTriangles;

- (int) localVariant;

- (NSMutableSet *) shouldStopArithmetic;

- (NSMutableArray *) shouldDetachScreen;

@end

NS_ASSUME_NONNULL_END
        