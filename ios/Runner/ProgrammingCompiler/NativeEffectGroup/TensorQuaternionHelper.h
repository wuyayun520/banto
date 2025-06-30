#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TensorQuaternionHelper : NSObject

@property (nonatomic) int builderOrientation;

@property (nonatomic) NSMutableDictionary * basicListView;

@property (nonatomic) int currentflex;

@property (nonatomic) NSMutableDictionary * routefromstate;

+ (instancetype) tensorQuaternionHelperWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) attachPosition;

- (NSMutableDictionary *) fetchRichText;

- (int) fixedCycle;

- (NSMutableSet *) keyProcessor;

- (NSMutableArray *) sortedRadius;

@end

NS_ASSUME_NONNULL_END
        