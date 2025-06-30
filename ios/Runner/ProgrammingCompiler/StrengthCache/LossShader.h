#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LossShader : NSObject

@property (nonatomic) NSString * nativeslider;

+ (instancetype) lossShaderWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) canStreamScroll;

- (NSMutableDictionary *) asynchronousPreview;

- (int) traversalVisibility;

- (NSMutableSet *) nodePhase;

- (NSMutableArray *) liteTriangles;

@end

NS_ASSUME_NONNULL_END
        