#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RetainFunctionalEvent : NSObject

@property (nonatomic) NSMutableArray * usedDependency;

@property (nonatomic) NSMutableArray * unsortedSubpixel;

@property (nonatomic) NSMutableArray * ignoredChannel;

@property (nonatomic) NSMutableSet * shouldContinueStateful;

+ (instancetype) retainFunctionalEventWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) asynchronousEquivalent;

- (NSMutableDictionary *) measurelayer;

- (int) significantAxis;

- (NSMutableSet *) cupertinoCombiner;

- (NSMutableArray *) cupertinoState;

@end

NS_ASSUME_NONNULL_END
        