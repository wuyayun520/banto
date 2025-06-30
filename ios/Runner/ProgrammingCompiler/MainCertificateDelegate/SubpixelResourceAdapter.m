#import "SubpixelResourceAdapter.h"
    
@interface SubpixelResourceAdapter ()

@end

@implementation SubpixelResourceAdapter

+ (instancetype) subpixelResourceAdapterWithDictionary: (NSDictionary *)dict
{
	return [[self alloc] initWithDictionary:dict];
}

- (instancetype) initWithDictionary: (NSDictionary *)dict
{
	if (self = [super init]) {
		[self setValuesForKeysWithDictionary:dict];
	}
	return self;
}

- (NSString *) exitProvider
{
	return @"shadertag";
}

- (NSMutableDictionary *) smallPreview
{
	NSMutableDictionary *canTransformScaffold = [NSMutableDictionary dictionary];
	for (int i = 0; i < 6; ++i) {
		canTransformScaffold[[NSString stringWithFormat:@"canPrepareDescriptor%d", i]] = @"toolOffset";
	}
	return canTransformScaffold;
}

- (int) customMission
{
	return 2;
}

- (NSMutableSet *) touchmap
{
	NSMutableSet *localZone = [NSMutableSet set];
	for (int i = 9; i != 0; --i) {
		[localZone addObject:[NSString stringWithFormat:@"latencySkewY%d", i]];
	}
	return localZone;
}

- (NSMutableArray *) setstateSpot
{
	NSMutableArray *routeattemple = [NSMutableArray array];
	[routeattemple addObject:@"formatSwitch"];
	[routeattemple addObject:@"shouldLoadTabView"];
	[routeattemple addObject:@"retainGroup"];
	[routeattemple addObject:@"nodeBrightness"];
	[routeattemple addObject:@"storeTexture"];
	[routeattemple addObject:@"attachRadius"];
	[routeattemple addObject:@"featureLevel"];
	return routeattemple;
}


@end
        