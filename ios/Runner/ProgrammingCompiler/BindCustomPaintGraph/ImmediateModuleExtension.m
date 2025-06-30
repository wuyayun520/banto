#import "ImmediateModuleExtension.h"
    
@interface ImmediateModuleExtension ()

@end

@implementation ImmediateModuleExtension

- (void) wasEncapsulateGram: (NSMutableDictionary *)explicitcallback
{
	dispatch_async(dispatch_get_main_queue(), ^{
		//NSLog(@"sets= bussiness2 gen_dic %@", bussiness2);
	});
}


@end
        