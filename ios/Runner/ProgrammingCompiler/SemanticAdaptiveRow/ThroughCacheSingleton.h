#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThroughCacheSingleton : NSObject

@property (nonatomic) NSMutableArray * requiredGrayscale;

@property (nonatomic) NSString * loadtechnique;

@property (nonatomic) NSString * infoBorder;

+ (instancetype) throughCacheSingletonWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) documentSize;

- (NSMutableDictionary *) publishPriority;

- (int) slashCount;

- (NSMutableSet *) spriteLayer;

- (NSMutableArray *) requestDepth;

@end

NS_ASSUME_NONNULL_END
        