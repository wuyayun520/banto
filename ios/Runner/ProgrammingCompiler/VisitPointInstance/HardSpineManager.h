#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HardSpineManager : NSObject

@property (nonatomic) int retainedBloc;

+ (instancetype) hardSpineManagerWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) fusedNotation;

- (NSMutableDictionary *) connectInterface;

- (int) flexibleStateful;

- (NSMutableSet *) unbindUsage;

- (NSMutableArray *) canRenderCell;

@end

NS_ASSUME_NONNULL_END
        