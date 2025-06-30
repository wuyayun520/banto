#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DirectConcurrentState : NSObject

@property (nonatomic) NSMutableSet * gemCoord;

@property (nonatomic) NSString * operationTag;

@property (nonatomic) NSMutableArray * rendersize;

+ (instancetype) directConcurrentStateWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) coordinatorStructure;

- (NSMutableDictionary *) singleLoss;

- (int) mediadecoratortransparency;

- (NSMutableSet *) enhanceRequest;

- (NSMutableArray *) shouldPushEquipment;

@end

NS_ASSUME_NONNULL_END
        