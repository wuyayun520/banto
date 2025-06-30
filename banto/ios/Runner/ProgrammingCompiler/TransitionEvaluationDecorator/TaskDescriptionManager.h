#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskDescriptionManager : NSObject

@property (nonatomic) NSMutableArray * strengthState;

+ (instancetype) taskDescriptionManagerWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) mobileEnvironment;

- (NSMutableDictionary *) diffableAction;

- (int) tappableOperation;

- (NSMutableSet *) brushCommand;

- (NSMutableArray *) rowanimator;

@end

NS_ASSUME_NONNULL_END
        