#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MutableCompletionReference : NSObject

@property (nonatomic) NSMutableArray * shouldDismissActivity;

@property (nonatomic) NSString * utilSpeed;

+ (instancetype) mutableCompletionReferenceWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) metricsSaturation;

- (NSMutableDictionary *) aggregateQueue;

- (int) pagerDelay;

- (NSMutableSet *) renamePreview;

- (NSMutableArray *) canFormatDocument;

@end

NS_ASSUME_NONNULL_END
        