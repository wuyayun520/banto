#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BitrateSingleton : NSObject

@property (nonatomic) NSMutableArray * localGradient;

@property (nonatomic) NSMutableArray * ephemeralGradient;

@property (nonatomic) NSString * reductionBottom;

+ (instancetype) bitrateSingletonWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) gramdata;

- (NSMutableDictionary *) loadDropdownButton;

- (int) shouldContinueTabBar;

- (NSMutableSet *) canCacheSensor;

- (NSMutableArray *) reusableHeap;

@end

NS_ASSUME_NONNULL_END
        