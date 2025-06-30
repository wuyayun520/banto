#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FetchHistogramBase : NSObject

@property (nonatomic) NSMutableArray * shouldStreamEqualization;

@property (nonatomic) int localThreshold;

@property (nonatomic) NSMutableSet * requiredReplica;

+ (instancetype) fetchHistogramBaseWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) similarElement;

- (NSMutableDictionary *) findDelegate;

- (int) partitionProgressBar;

- (NSMutableSet *) fusedFragment;

- (NSMutableArray *) reflectIsolate;

@end

NS_ASSUME_NONNULL_END
        