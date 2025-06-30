#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WidgetActionInset : NSObject

@property (nonatomic) NSMutableSet * shouldYieldBase;

@property (nonatomic) NSMutableArray * playmetadata;

+ (instancetype) widgetActionInsetWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) shouldFormatGift;

- (NSMutableDictionary *) resourceParam;

- (int) oldBorder;

- (NSMutableSet *) currentCheckbox;

- (NSMutableArray *) appendEntity;

@end

NS_ASSUME_NONNULL_END
        