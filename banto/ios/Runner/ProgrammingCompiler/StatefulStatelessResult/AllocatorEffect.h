#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AllocatorEffect : NSObject

@property (nonatomic) NSMutableDictionary * mobileamongmemento;

+ (instancetype) allocatorEffectWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) draggableSpecifier;

- (NSMutableDictionary *) shouldDecodeAccessory;

- (int) cancelMovement;

- (NSMutableSet *) transpileSink;

- (NSMutableArray *) shouldContinuePoint;

@end

NS_ASSUME_NONNULL_END
        