#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GrayscaleTaxonomyFilter : NSObject

@property (nonatomic) NSMutableDictionary * invisibleMaster;

@property (nonatomic) NSMutableSet * accessiblehistogram;

+ (instancetype) grayscaleTaxonomyFilterWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) requestForm;

- (NSMutableDictionary *) canSerializeNib;

- (int) appendAsset;

- (NSMutableSet *) characterEnvironment;

- (NSMutableArray *) workflowSize;

@end

NS_ASSUME_NONNULL_END
        