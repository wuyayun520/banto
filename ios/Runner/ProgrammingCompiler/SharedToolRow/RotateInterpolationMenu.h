#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RotateInterpolationMenu : NSObject

@property (nonatomic) NSMutableArray * rapidpicker;

@property (nonatomic) NSString * customizedExtension;

@property (nonatomic) NSMutableSet * shouldLoadBox;

+ (instancetype) rotateInterpolationMenuWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) callbackStructure;

- (NSMutableDictionary *) serializeAsync;

- (int) multiDuration;

- (NSMutableSet *) shouldEndChecklist;

- (NSMutableArray *) canResumeStamp;

@end

NS_ASSUME_NONNULL_END
        