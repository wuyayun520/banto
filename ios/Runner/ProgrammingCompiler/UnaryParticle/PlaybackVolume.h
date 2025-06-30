#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlaybackVolume : NSObject

@property (nonatomic) NSMutableDictionary * singletonScale;

@property (nonatomic) int alignmentatstate;

@property (nonatomic) NSMutableArray * desktopExpanded;

@property (nonatomic) int hasSlider;

+ (instancetype) playbackVolumeWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) shouldMountCheckbox;

- (NSMutableDictionary *) connectPageView;

- (int) finishStateful;

- (NSMutableSet *) scrollableMenu;

- (NSMutableArray *) fixedObserver;

@end

NS_ASSUME_NONNULL_END
        