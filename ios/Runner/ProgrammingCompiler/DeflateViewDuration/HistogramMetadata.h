#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistogramMetadata : NSObject

@property (nonatomic) NSString * cupertinofragments;

@property (nonatomic) NSMutableSet * shouldStreamScroll;

@property (nonatomic) NSString * hasAlpha;

@property (nonatomic) NSMutableArray * selectedPositioned;

@property (nonatomic) NSMutableArray * unactivatedFragment;

+ (instancetype) histogramMetadataWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) similarRole;

- (NSMutableDictionary *) canRouteTask;

- (int) mutableRouter;

- (NSMutableSet *) hardRouter;

- (NSMutableArray *) secondBase;

@end

NS_ASSUME_NONNULL_END
        