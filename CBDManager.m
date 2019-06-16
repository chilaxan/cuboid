#import "CBDManager.h"

@implementation CBDManager

+(instancetype)sharedInstance {
	static CBDManager *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [CBDManager alloc];
		sharedInstance.defaults = [NSUserDefaults standardUserDefaults];
		[sharedInstance load];
	});
	return sharedInstance;
}

-(id)init {
	return [CBDManager sharedInstance];
}

-(NSUInteger)homescreenColumns {
	if (_homescreenColumns <= 0) return 4;
	return _homescreenColumns;
}

-(NSUInteger)homescreenRows {
	if (_homescreenRows <= 0) return 6;
	return _homescreenRows;
}

-(void)load {
	self.hideIconLabels = [self.defaults boolForKey:@"hideIconLabels"];
	self.homescreenColumns = [self.defaults integerForKey:@"homescreenColumns"];
	self.homescreenRows = [self.defaults integerForKey:@"homescreenRows"];
	self.verticalOffset = [self.defaults floatForKey:@"verticalOffset"];
	self.horizontalOffset = [self.defaults floatForKey:@"horizontalOffset"];
	self.verticalPadding = [self.defaults floatForKey:@"verticalPadding"];
	self.horizontalPadding = [self.defaults floatForKey:@"horizontalPadding"];
}

-(void)save {
	[self.defaults setBool:self.hideIconLabels forKey:@"hideIconLabels"];
	[self.defaults setInteger:self.homescreenColumns forKey:@"homescreenColumns"];
	[self.defaults setInteger:self.homescreenRows forKey:@"homescreenRows"];
	[self.defaults setFloat:self.verticalOffset forKey:@"verticalOffset"];
	[self.defaults setFloat:self.horizontalOffset forKey:@"horizontalOffset"];
	[self.defaults setFloat:self.verticalPadding forKey:@"verticalPadding"];
	[self.defaults setFloat:self.horizontalPadding forKey:@"horizontalPadding"];
	[self.defaults synchronize];
}

-(void)reset {
	self.hideIconLabels = 0;
	self.homescreenColumns = 0;
	self.homescreenRows = 0;
	self.verticalOffset = 0;
	self.horizontalOffset = 0;
	self.verticalPadding = 0;
	self.horizontalPadding = 0;
}

@end