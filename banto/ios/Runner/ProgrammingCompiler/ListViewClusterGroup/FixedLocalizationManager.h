#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FixedLocalizationManager : NSObject

@property (nonatomic) NSMutableSet * singleBinary;

@property (nonatomic) int shouldBuildCertificate;

+ (instancetype) fixedLocalizationManagerWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) defaultScreen;

- (NSMutableDictionary *) compositionalMesh;

- (int) marshallayout;

- (NSMutableSet *) shouldDecodeTangent;

- (NSMutableArray *) canDispatchStep;

@end

NS_ASSUME_NONNULL_END
        