#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FromNavigationManager : NSObject

@property (nonatomic) NSMutableSet * shouldAttachBloc;

@property (nonatomic) NSMutableSet * nativeInteraction;

+ (instancetype) fromNavigationManagerWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) nextRect;

- (NSMutableDictionary *) rebuildScroll;

- (int) featureinformation;

- (NSMutableSet *) playbackVisitor;

- (NSMutableArray *) canPublishGesture;

@end

NS_ASSUME_NONNULL_END
        