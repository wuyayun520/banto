#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DialogsTrigger : NSObject

@property (nonatomic) NSMutableDictionary * displayableTimeline;

@property (nonatomic) NSMutableSet * shouldPresentBox;

@property (nonatomic) NSMutableDictionary * missedrect;

@property (nonatomic) NSMutableArray * globalGridView;

@property (nonatomic) NSMutableSet * shouldEndDuration;

@property (nonatomic) NSMutableArray * alignmentSize;

@property (nonatomic) NSMutableDictionary * persistinkwell;

+ (instancetype) dialogsTriggerWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) resolveZone;

- (NSMutableDictionary *) canPersistAnimatedContainer;

- (int) finishentity;

- (NSMutableSet *) decodeSize;

- (NSMutableArray *) liteservice;

@end

NS_ASSUME_NONNULL_END
        