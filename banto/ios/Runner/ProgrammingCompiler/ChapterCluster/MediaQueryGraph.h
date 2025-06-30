#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MediaQueryGraph : NSObject

@property (nonatomic) NSMutableSet * tentativePadding;

+ (instancetype) mediaQueryGraphWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) uniqueCapacities;

- (NSMutableDictionary *) synchronizeUseCase;

- (int) canStartExpanded;

- (NSMutableSet *) animateImage;

- (NSMutableArray *) permissiveEvolution;

@end

NS_ASSUME_NONNULL_END
        