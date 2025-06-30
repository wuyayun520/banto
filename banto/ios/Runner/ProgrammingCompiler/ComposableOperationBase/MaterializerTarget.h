#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MaterializerTarget : NSObject

@property (nonatomic) NSMutableSet * subtleScope;

+ (instancetype) materializerTargetWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) primaryPainter;

- (NSMutableDictionary *) adaptiveCharacter;

- (int) alignmentDirection;

- (NSMutableSet *) usedScroll;

- (NSMutableArray *) markbloc;

@end

NS_ASSUME_NONNULL_END
        