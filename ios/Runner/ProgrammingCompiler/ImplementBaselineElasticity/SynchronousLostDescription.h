#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SynchronousLostDescription : NSObject

@property (nonatomic) NSMutableDictionary * mapDistance;

+ (instancetype) synchronousLostDescriptionWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) binaryStyle;

- (NSMutableDictionary *) sinkDepth;

- (int) publisherDelay;

- (NSMutableSet *) canPauseStream;

- (NSMutableArray *) deferredSkin;

@end

NS_ASSUME_NONNULL_END
        