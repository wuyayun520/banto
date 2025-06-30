#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CriticalThemeTexture : NSObject

@property (nonatomic) NSMutableSet * priorStore;

+ (instancetype) criticalThemeTextureWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) canPushTangent;

- (NSMutableDictionary *) elementFlags;

- (int) shouldSubscribeDocument;

- (NSMutableSet *) scrollableConfidentiality;

- (NSMutableArray *) certificatevisible;

@end

NS_ASSUME_NONNULL_END
        