#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RelationalMaterialWidget : NSObject

@property (nonatomic) int storyboardFormat;

@property (nonatomic) int shouldConnectAccessory;

@property (nonatomic) NSMutableArray * channelFrequency;

@property (nonatomic) NSMutableDictionary * disabledRadio;

+ (instancetype) relationalMaterialWidgetWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) canSerializeCard;

- (NSMutableDictionary *) playbackbandwidth;

- (int) binderBrightness;

- (NSMutableSet *) samplebrightness;

- (NSMutableArray *) searcherPosition;

@end

NS_ASSUME_NONNULL_END
        