#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CombineScreenDelegate : NSObject

@property (nonatomic) int clipperagainstplatform;

@property (nonatomic) NSMutableDictionary * shouldDeserializeActivity;

+ (instancetype) combineScreenDelegateWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) obtainBloc;

- (NSMutableDictionary *) statefulDependency;

- (int) connectHeap;

- (NSMutableSet *) handlerSpacing;

- (NSMutableArray *) canRouteRow;

@end

NS_ASSUME_NONNULL_END
        