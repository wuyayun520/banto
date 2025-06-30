#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReadEquipmentManager : NSObject

@property (nonatomic) NSMutableSet * loadflex;

@property (nonatomic) NSMutableArray * shouldstoplayout;

@property (nonatomic) NSMutableSet * protectedInfo;

@property (nonatomic) int localizationCoord;

+ (instancetype) readEquipmentManagerWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) shouldnotifyexpanded;

- (NSMutableDictionary *) maxWorkflow;

- (int) shouldDismissCell;

- (NSMutableSet *) evaluationResponse;

- (NSMutableArray *) widgetimpact;

@end

NS_ASSUME_NONNULL_END
        