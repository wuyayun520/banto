#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SensorFragmentsBase : NSObject

@property (nonatomic) NSString * preparetitle;

@property (nonatomic) NSMutableSet * geometricTable;

@property (nonatomic) NSString * labelVisibility;

@property (nonatomic) NSString * eventRotation;

@property (nonatomic) NSString * cancelgrid;

+ (instancetype) sensorFragmentsBaseWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) unactivatedLog;

- (NSMutableDictionary *) connectNotification;

- (int) lastDescription;

- (NSMutableSet *) taskForce;

- (NSMutableArray *) shouldDeserializeDuration;

@end

NS_ASSUME_NONNULL_END
        