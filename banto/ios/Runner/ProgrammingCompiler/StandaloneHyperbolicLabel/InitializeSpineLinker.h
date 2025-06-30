#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InitializeSpineLinker : NSObject

@property (nonatomic) NSMutableArray * shouldDispatchSegue;

+ (instancetype) initializeSpineLinkerWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) shouldUpdateSignature;

- (NSMutableDictionary *) pinchableResolver;

- (int) observeCallback;

- (NSMutableSet *) smallIcon;

- (NSMutableArray *) borderDepth;

@end

NS_ASSUME_NONNULL_END
        