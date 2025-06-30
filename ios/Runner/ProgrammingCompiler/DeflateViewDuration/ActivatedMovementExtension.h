#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ActivatedMovementExtension : NSObject

@property (nonatomic) int semanticSprite;

@property (nonatomic) int flexibleGraph;

@property (nonatomic) NSMutableSet * diffableBullet;

+ (instancetype) activatedMovementExtensionWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) encodeEntity;

- (NSMutableDictionary *) subscriberVisibility;

- (int) globalDropdownButton;

- (NSMutableSet *) canPresentTransition;

- (NSMutableArray *) subsequentModulus;

@end

NS_ASSUME_NONNULL_END
        