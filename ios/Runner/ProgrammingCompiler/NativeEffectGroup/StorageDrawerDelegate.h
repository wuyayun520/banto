#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StorageDrawerDelegate : NSObject

@property (nonatomic) int prevText;

@property (nonatomic) int boxshadowinset;

+ (instancetype) storageDrawerDelegateWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) canPrepareCard;

- (NSMutableDictionary *) logfinder;

- (int) continueMatrix;

- (NSMutableSet *) equipmentJob;

- (NSMutableArray *) shouldDispatchPriority;

@end

NS_ASSUME_NONNULL_END
        