#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShowNotifierAdapter : NSObject

@property (nonatomic) NSMutableDictionary * priorGridView;

@property (nonatomic) int shouldSaveAlpha;

+ (instancetype) showNotifierAdapterWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) quantizationManager;

- (NSMutableDictionary *) shouldYieldProvider;

- (int) bufferCoord;

- (NSMutableSet *) shouldCacheExponent;

- (NSMutableArray *) subsequentInstruction;

@end

NS_ASSUME_NONNULL_END
        