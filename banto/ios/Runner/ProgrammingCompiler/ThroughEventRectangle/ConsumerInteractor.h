#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConsumerInteractor : NSObject

@property (nonatomic) int shouldShowPriority;

+ (instancetype) consumerInteractorWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) basicChecklist;

- (NSMutableDictionary *) displayableProgressBar;

- (int) copyMenu;

- (NSMutableSet *) painttouch;

- (NSMutableArray *) baselineShape;

@end

NS_ASSUME_NONNULL_END
        