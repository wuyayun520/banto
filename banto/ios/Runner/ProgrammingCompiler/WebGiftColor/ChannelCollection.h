#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChannelCollection : NSObject

@property (nonatomic) NSMutableDictionary * shouldInflateBuilder;

@property (nonatomic) int composableThread;

+ (instancetype) channelcollectionWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) prevRenderer;

- (NSMutableDictionary *) materialManager;

- (int) shouldValidatePageView;

- (NSMutableSet *) textDecorator;

- (NSMutableArray *) smartTable;

@end

NS_ASSUME_NONNULL_END
        