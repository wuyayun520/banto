#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KernelCompleter : NSObject

@property (nonatomic) NSMutableArray * originalModule;

@property (nonatomic) NSMutableDictionary * shouldInflateTabBar;

@property (nonatomic) NSMutableArray * materialKind;

@property (nonatomic) int similarAnimation;

+ (instancetype) kernelCompleterWithDictionary: (NSDictionary *)dict;

- (instancetype) initWithDictionary: (NSDictionary *)dict;

- (NSString *) canStartSwift;

- (NSMutableDictionary *) resizeConfiguration;

- (int) smartPositioned;

- (NSMutableSet *) defaultobserver;

- (NSMutableArray *) cupertinoInterpolation;

@end

NS_ASSUME_NONNULL_END
        