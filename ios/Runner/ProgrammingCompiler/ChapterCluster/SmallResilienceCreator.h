#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SmallResilienceCreator : NSObject

@property (nonatomic) NSMutableArray * resultbound;

@property (nonatomic) int stampbyadapter;

+ (instancetype) smallResilienceCreatorWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) inheritedEquivalent;

- (NSMutableDictionary *) shouldProcessSlash;

- (int) pendingOverlay;

- (NSMutableSet *) pendingLayout;

- (NSMutableArray *) mediumDescriptor;

@end

NS_ASSUME_NONNULL_END
        