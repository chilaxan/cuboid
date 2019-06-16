#define OFFSETSETTINGS 0
#define PADDINGSETTINGS 1
#define PRESETSETTINGS 2
#define MISCSETTINGS 3

@interface SBIconController : NSObject
+(id)sharedInstance;
-(BOOL)isEditing;
-(BOOL)relayout;
-(void)setIsEditing:(BOOL)arg1;
@end

@interface UIStatusBarWindow : UIWindow
@end

@interface SBEditingDoneButton : UIView
@end

@interface CuboidMenu : NSObject
+(void)showSettingsAlert;
+(void)setMiscSettings;
+(void)setOffsetSettings;
+(void)setPaddingSettings;
+(void)setPresetSettings;
+(void)setValueIntegerInput:(NSString*)editingType withKey:(NSString*)key withCaller:(int)caller;
@end

NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

NSString *stringFromIntegerKey(NSString *key) {
	if([defaults objectForKey:key] == nil) {
		return @"Not Set";
	} else {
		return [NSString stringWithFormat:@"%ld",(long)[defaults integerForKey:key]];
	}
}

%hook SBRootFolderController
-(void)setEditingStatusBarAssertion:(id)arg1 {}
%end

%hook SBEditingDoneButton
-(void)layoutSubviews {
	%orig;
	self.hidden = 1;
}
%end

%hook SBIconLegibilityLabelView
-(void)setHidden:(BOOL)arg1 {
	if([defaults objectForKey:@"hideIconLabels"] == nil) {
		%orig(arg1);
	} else {
		%orig([defaults boolForKey:@"hideIconLabels"]);
	}
}
%end

%hook SBRootIconListView
+(NSUInteger)iconColumnsForInterfaceOrientation:(NSInteger)arg1{
	NSUInteger original = %orig;
	NSString *key = @"homescreenColumns";
	if([defaults objectForKey:key] == nil) {
		return original;
	} else {
		if((long)[defaults integerForKey:key] <= (long)0) { //Fixes Respring Loops due to 0 homescreenColumns
			[defaults setInteger:original forKey:key];
			[defaults synchronize];
		}
		return((NSUInteger)[defaults integerForKey:key]);
	}
}

+(NSUInteger)iconRowsForInterfaceOrientation:(NSInteger)arg1{
	NSUInteger original = %orig;
	NSString *key = @"homescreenRows";
	if([defaults objectForKey:key] == nil) {
		return original;
	} else {
		if((long)[defaults integerForKey:key] <= (long)0) { //Fixes Respring Loops due to 0 homescreenRows
			[defaults setInteger:original forKey:key];
			[defaults synchronize];
		}
		return((NSUInteger)[defaults integerForKey:key]);
	}
}

-(CGFloat)topIconInset {
	if([defaults objectForKey:@"verticalOffset"] == nil) {
		return %orig;
	} else {
		return((CGFloat)[defaults integerForKey:@"verticalOffset"]);
	}
}

-(CGFloat)bottomIconInset {
	if([defaults objectForKey:@"verticalOffset"] == nil) {
		return %orig;
	} else {
		return((CGFloat)[defaults integerForKey:@"verticalOffset"] * -1);
	}
}

-(CGFloat)sideIconInset {
	if([defaults objectForKey:@"horizontalOffset"] == nil) {
		return %orig;
	} else {
		return((CGFloat)[defaults integerForKey:@"horizontalOffset"]);
	}
}

-(CGFloat)verticalIconPadding {
	if([defaults objectForKey:@"verticalPadding"] == nil) {
		return %orig;
	} else {
		return((CGFloat)[defaults integerForKey:@"verticalPadding"]);
	}
}

-(CGFloat)horizontalIconPadding {
	if([defaults objectForKey:@"horizontalPadding"] == nil) {
		return %orig;
	} else {
		return((CGFloat)[defaults integerForKey:@"horizontalPadding"]);
	}
}
%end

%hook UIStatusBarWindow
- (instancetype)initWithFrame:(CGRect)frame {
		self = %orig;
		[self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:NSClassFromString(@"CuboidMenu") action:@selector(showSettingsAlert)]];
		return self;
}
%end

static BOOL ignoreIsEditing = NO;

@implementation CuboidMenu
+(void)showSettingsAlert {
		if([[NSClassFromString(@"SBIconController") sharedInstance] isEditing] || ignoreIsEditing) {
			ignoreIsEditing = YES;
			UIAlertController *settingsAlertController = [UIAlertController
																alertControllerWithTitle:@"Cuboid Settings"
																message:[NSString stringWithFormat:@"Homescreen Columns: %@\rHomescreen Rows: %@\rVertical Offset: %@\rHorizontal Offset: %@\rVertical Padding: %@\rHorizontal Padding: %@\rHide Icon Labels: %@",
																	stringFromIntegerKey(@"homescreenColumns"),
																	stringFromIntegerKey(@"homescreenRows"),
																	stringFromIntegerKey(@"verticalOffset"),
																	stringFromIntegerKey(@"horizontalOffset"),
																	stringFromIntegerKey(@"verticalPadding"),
																	stringFromIntegerKey(@"horizontalPadding"),
																	[defaults boolForKey:@"hideIconLabels"] ? @"YES" : @"NO"]
																preferredStyle:UIAlertControllerStyleAlert];

			UIAlertAction *showOffsetSettings = [UIAlertAction
																				actionWithTitle:@"Offset Settings"
																				style:UIAlertActionStyleDefault
																				handler:^(UIAlertAction *action){[self setOffsetSettings];}];
																				
			UIAlertAction *showPaddingSettings = [UIAlertAction
																				actionWithTitle:@"Padding Settings"
																				style:UIAlertActionStyleDefault
																				handler:^(UIAlertAction *action){[self setPaddingSettings];}];

			UIAlertAction *showPresetSettings = [UIAlertAction
																				actionWithTitle:@"Save/Restore"
																				style:UIAlertActionStyleDefault
																				handler:^(UIAlertAction *action){[self setPresetSettings];}];
																				
			UIAlertAction *showMiscSettings = [UIAlertAction
																				actionWithTitle:@"Miscellaneous"
																				style:UIAlertActionStyleDefault
																				handler:^(UIAlertAction *action){[self setMiscSettings];}];
			
			UIAlertAction *confirmDone = [UIAlertAction
																		actionWithTitle:@"Done"
																		style:UIAlertActionStyleDefault
																		handler:^(UIAlertAction *action){
																			ignoreIsEditing = NO;
																			[[NSClassFromString(@"SBIconController") sharedInstance] setIsEditing:NO];
																		}];
			
			[settingsAlertController addAction:showOffsetSettings];
			[settingsAlertController addAction:showPaddingSettings];
			[settingsAlertController addAction:showPresetSettings];
			[settingsAlertController addAction:showMiscSettings];
			[settingsAlertController addAction:confirmDone];
			[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:settingsAlertController animated:YES completion:NULL];
		}
}

+(void)setOffsetSettings {
	UIAlertController *offsetSettingsAlertController = [UIAlertController
																											alertControllerWithTitle:@"Offset Settings"
																											message:[NSString stringWithFormat:@"Vertical Offset: %@\rHorizontal Offset: %@",
																												stringFromIntegerKey(@"verticalOffset"),
																												stringFromIntegerKey(@"horizontalOffset")]
																											preferredStyle:UIAlertControllerStyleAlert];
																	
	UIAlertAction *changeVerticalOffset = [UIAlertAction
																				actionWithTitle:@"Change Vertical Offset"
																				style:UIAlertActionStyleDefault
																				handler:^(UIAlertAction *action){
																					[self setValueIntegerInput:@"Vertical Offset"
																						withKey:@"verticalOffset" withCaller:OFFSETSETTINGS];
																				}];
																		 
	UIAlertAction *changeHorizontalOffset = [UIAlertAction
																					actionWithTitle:@"Change Horizontal Offset"
																					style:UIAlertActionStyleDefault
																					handler:^(UIAlertAction *action){
																						[self setValueIntegerInput:@"Horizontal Offset"
																							withKey:@"horizontalOffset" withCaller:OFFSETSETTINGS];
																					}];
																					
	UIAlertAction *backToMain = [UIAlertAction
															actionWithTitle:@"Back"
															style:UIAlertActionStyleDefault
															handler:^(UIAlertAction *action){
																[self showSettingsAlert];
															}];
															
	[offsetSettingsAlertController addAction:changeVerticalOffset];
	[offsetSettingsAlertController addAction:changeHorizontalOffset];
	[offsetSettingsAlertController addAction:backToMain];
	[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:offsetSettingsAlertController animated:YES completion:NULL];
}

+(void)setPaddingSettings {
	UIAlertController *paddingSettingsAlertController = [UIAlertController
																											alertControllerWithTitle:@"Padding Settings"
																											message:[NSString stringWithFormat:@"Vertical Padding: %@\rHorizontal Padding: %@",
																												stringFromIntegerKey(@"verticalPadding"),
																												stringFromIntegerKey(@"horizontalPadding")]
																											preferredStyle:UIAlertControllerStyleAlert];
																
	UIAlertAction *changeVerticalPadding = [UIAlertAction
																				actionWithTitle:@"Change Vertical Padding"
																				style:UIAlertActionStyleDefault
																				handler:^(UIAlertAction *action){
																					[self setValueIntegerInput:@"Vertical Padding"
																						withKey:@"verticalPadding" withCaller:PADDINGSETTINGS];
																				}];
																		 
	UIAlertAction *changeHorizontalPadding = [UIAlertAction
																					actionWithTitle:@"Change Horizontal Padding"
																					style:UIAlertActionStyleDefault
																					handler:^(UIAlertAction *action){
																						[self setValueIntegerInput:@"Horizontal Padding"
																							withKey:@"horizontalPadding" withCaller:PADDINGSETTINGS];
																					}];
																					
	UIAlertAction *backToMain = [UIAlertAction
															actionWithTitle:@"Back"
															style:UIAlertActionStyleDefault
															handler:^(UIAlertAction *action){
																[self showSettingsAlert];
															}];
															
	[paddingSettingsAlertController addAction:changeVerticalPadding];
	[paddingSettingsAlertController addAction:changeHorizontalPadding];
	[paddingSettingsAlertController addAction:backToMain];
	[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:paddingSettingsAlertController animated:YES completion:NULL];
}

+(void)setPresetSettings {
	if(![defaults objectForKey:@"savedLayouts"]) {
		NSDictionary *emptyDict = [[NSMutableDictionary	alloc] init];
		[defaults setObject:emptyDict forKey:@"savedLayouts"];
		[defaults synchronize];
	}
	
	UIAlertController *presetSettingsAlertController = [UIAlertController
																											alertControllerWithTitle:@"Save/Restore"
																											message:@""
																											preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *saveLayout = [UIAlertAction
															actionWithTitle:@"Save Current Layout"
															style:UIAlertActionStyleDefault
															handler:^(UIAlertAction *action){
																UIAlertController *layoutInputController = [UIAlertController
																																						alertControllerWithTitle:@"Layout Name"
																																						message:@"To replace an existing layout, give the same name"
																																						preferredStyle:UIAlertControllerStyleAlert];
																																																												
																[layoutInputController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {}];

																UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK"
																																style:UIAlertActionStyleDefault
																																handler:^(UIAlertAction * _Nonnull action) {
																																	if([[layoutInputController textFields][0] text].length != 0) {
																																		NSString *homescreenColumns = stringFromIntegerKey(@"homescreenColumns");
																																		NSString *homescreenRows = stringFromIntegerKey(@"homescreenRows");
																																		NSString *verticalOffset = stringFromIntegerKey(@"verticalOffset");
																																		NSString *horizontalOffset = stringFromIntegerKey(@"horizontalOffset");
																																		NSString *verticalPadding = stringFromIntegerKey(@"verticalPadding");
																																		NSString *horizontalPadding = stringFromIntegerKey(@"horizontalPadding");
																																		NSString *isHidingLabels = [defaults boolForKey:@"hideIconLabels"] ? @"YES" : @"NO";
																																		
																																		NSArray *objectsArray = [NSArray arrayWithObjects:homescreenColumns,homescreenRows,verticalOffset,horizontalOffset,verticalPadding,horizontalPadding,isHidingLabels,nil];
																																		NSArray *keysArray = [NSArray arrayWithObjects:@"homescreenColumns",@"homescreenRows",@"verticalOffset", @"horizontalOffset",@"verticalPadding",@"horizontalPadding",@"hideIconLabels",nil];
																																		
																																		NSDictionary *currentLayout = [[NSDictionary alloc] initWithObjects:objectsArray forKeys:keysArray];
																																		NSMutableDictionary *savedLayouts = [[defaults objectForKey:@"savedLayouts"] mutableCopy];
																																		
																																		[savedLayouts setObject:currentLayout forKey:[[layoutInputController textFields][0] text]];
																																		[defaults setObject:savedLayouts forKey:@"savedLayouts"];
																																		[defaults synchronize];
																																	}
																																	[self setPresetSettings];
																																}];
																																
																[layoutInputController addAction:confirmAction];
																[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:layoutInputController animated:YES completion:NULL];
															}];
	
	UIAlertAction *restoreLayout = [UIAlertAction
																	actionWithTitle:@"Restore Saved Layout"
																	style:UIAlertActionStyleDefault
																	handler:^(UIAlertAction *action){
																		NSDictionary *savedLayouts = [defaults dictionaryForKey:@"savedLayouts"];
																		NSArray *allNames = [savedLayouts allKeys];
																		UIAlertController *savedLayoutsAlertController = [UIAlertController
																																						alertControllerWithTitle:@"Saved Layouts"
																																						message:@""
																																						preferredStyle:UIAlertControllerStyleAlert];
																		
																		UIAlertAction *cancelAction = [UIAlertAction
																																	actionWithTitle:@"Cancel"
																																	style:UIAlertActionStyleDefault
																																	handler:^(UIAlertAction *action) {
																																		[self setPresetSettings];
																																	}];
																		
																		for(NSString *layoutName in allNames) {
																			UIAlertAction *nameItem = [UIAlertAction
																									actionWithTitle:layoutName
																									style:UIAlertActionStyleDefault
																									handler:^(UIAlertAction *action) {
																										NSDictionary *restoreTo = [savedLayouts objectForKey:layoutName];
																										NSArray *keys = [NSArray arrayWithObjects:@"homescreenColumns",@"homescreenRows",@"verticalOffset", @"horizontalOffset",@"verticalPadding",@"horizontalPadding",nil];
																										for(NSString *key in keys) {
																											if([[restoreTo objectForKey:key] isEqualToString:@"Not Set"]) {
																												[defaults removeObjectForKey:key];
																											} else {
																												[defaults setInteger:[[restoreTo objectForKey:key] intValue] forKey:key];
																											}
																										}
																										[defaults setBool:[[restoreTo objectForKey:@"hideIconLabels"] boolValue] forKey:@"hideIconLabels"];
																										[defaults synchronize];
																										[[NSClassFromString(@"SBIconController") sharedInstance] relayout];
																										[self setPresetSettings];
																									}];
																			[savedLayoutsAlertController addAction:nameItem];
																		}
																		[savedLayoutsAlertController addAction:cancelAction];
																		[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:savedLayoutsAlertController animated:YES completion:NULL];
																	}];
	
	UIAlertAction *deleteLayout = [UIAlertAction
																actionWithTitle:@"Delete Saved Layout"
																style:UIAlertActionStyleDefault
																handler:^(UIAlertAction *action){
																	NSMutableDictionary *savedLayouts = [[defaults objectForKey:@"savedLayouts"] mutableCopy];
																	NSArray *allNames = [savedLayouts allKeys];
																	UIAlertController *savedLayoutsAlertController = [UIAlertController
																																										alertControllerWithTitle:@"Saved Layouts"
																																										message:@""
																																										preferredStyle:UIAlertControllerStyleAlert];
																		
																	UIAlertAction *cancelAction = [UIAlertAction
																																actionWithTitle:@"Cancel"
																																style:UIAlertActionStyleDefault
																																handler:^(UIAlertAction *action) {
																																	[self setPresetSettings];
																																}];
																		
																	for(NSString *layoutName in allNames) {
																		UIAlertAction *nameItem = [UIAlertAction
																															actionWithTitle:layoutName
																															style:UIAlertActionStyleDefault
																															handler:^(UIAlertAction *action) {
																																[savedLayouts removeObjectForKey:layoutName];
																																[defaults setObject:savedLayouts forKey:@"savedLayouts"];
																																[defaults synchronize];
																																[self setPresetSettings];
																															}];
																		[savedLayoutsAlertController addAction:nameItem];
																	}
																	[savedLayoutsAlertController addAction:cancelAction];
																	[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:savedLayoutsAlertController animated:YES completion:NULL];
																}];
	
	UIAlertAction *resetSettings = [UIAlertAction
																 actionWithTitle:@"Reset Saved Layouts"
																 style:UIAlertActionStyleDestructive
																 handler:^(UIAlertAction *action){
																	 NSDictionary *emptyDict = [[NSMutableDictionary	alloc] init];
																	 [defaults setObject:emptyDict forKey:@"savedLayouts"];
																	 [defaults synchronize];
																	 [self setPresetSettings];
																 }];
	
	UIAlertAction *backToMain = [UIAlertAction
															actionWithTitle:@"Back"
															style:UIAlertActionStyleDefault
															handler:^(UIAlertAction *action){
																[self showSettingsAlert];
															}];
	
	[presetSettingsAlertController addAction:saveLayout];
	[presetSettingsAlertController addAction:restoreLayout];
	[presetSettingsAlertController addAction:deleteLayout];
	[presetSettingsAlertController addAction:resetSettings];
	[presetSettingsAlertController addAction:backToMain];
	[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:presetSettingsAlertController animated:YES completion:NULL];
}

+(void)setMiscSettings {
	UIAlertController *miscSettingsAlertController = [UIAlertController
																										alertControllerWithTitle:@"Miscellaneous"
																										message:[NSString stringWithFormat:@"Homescreen Columns: %@\rHomescreen Rows: %@\rHide Icon Labels: %@",
																											stringFromIntegerKey(@"homescreenColumns"),
																											stringFromIntegerKey(@"homescreenRows"),
																											[defaults boolForKey:@"hideIconLabels"] ? @"YES" : @"NO"]
																										preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *changeHomescreenColumns = [UIAlertAction
																						actionWithTitle:@"Change Homescreen Columns"
																						style:UIAlertActionStyleDefault
																						handler:^(UIAlertAction *action){
																							[self setValueIntegerInput:@"Homescreen Columns"
																								withKey:@"homescreenColumns" withCaller:MISCSETTINGS];
																						}];
	
	UIAlertAction *changeHomescreenRows = [UIAlertAction
																				actionWithTitle:@"Change Homescreen Rows"
																				style:UIAlertActionStyleDefault
																				handler:^(UIAlertAction *action){
																					[self setValueIntegerInput:@"Homescreen Rows"
																						withKey:@"homescreenRows" withCaller:MISCSETTINGS];
																				}];

	UIAlertAction *toggleHideLabels = [UIAlertAction
																		actionWithTitle:@"Toggle Hiding Labels"
																		style:UIAlertActionStyleDefault
																		handler:^(UIAlertAction *action){
																			[defaults setBool:![defaults boolForKey:@"hideIconLabels"] forKey:@"hideIconLabels"];
																			[[NSClassFromString(@"SBIconController") sharedInstance] relayout];
																			[self setMiscSettings];
																		}];

	UIAlertAction *resetSettings = [UIAlertAction
																 actionWithTitle:@"Reset all Settings"
																 style:UIAlertActionStyleDestructive
																 handler:^(UIAlertAction *action){
																	[defaults removeObjectForKey:@"verticalOffset"];
																	[defaults removeObjectForKey:@"horizontalOffset"];
																	[defaults removeObjectForKey:@"verticalPadding"];
																	[defaults removeObjectForKey:@"horizontalPadding"];
																	[defaults setInteger:4 forKey:@"homescreenColumns"]; //Fixes Respring Loops due to nil or 0 homescreenColumns
																	[defaults setInteger:6 forKey:@"homescreenRows"]; //Fixes Respring Loops due to nil or 0 homescreenRows
																	[defaults removeObjectForKey:@"hideIconLabels"];
																	[defaults synchronize];
																	[[NSClassFromString(@"SBIconController") sharedInstance] relayout];
																	[self setMiscSettings];
																}];
																 
	UIAlertAction *backToMain = [UIAlertAction
															actionWithTitle:@"Back"
															style:UIAlertActionStyleDefault
															handler:^(UIAlertAction *action){
																[self showSettingsAlert];
															}];
															
	[miscSettingsAlertController addAction:changeHomescreenColumns];
	[miscSettingsAlertController addAction:changeHomescreenRows];
	[miscSettingsAlertController addAction:toggleHideLabels];
	[miscSettingsAlertController addAction:resetSettings];
	[miscSettingsAlertController addAction:backToMain];
	[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:miscSettingsAlertController animated:YES completion:NULL];
}

static BOOL shouldSwitchSign = NO;
NSString *oldText;

+(void)setValueIntegerInput:(NSString*)editingType withKey:(NSString*)key withCaller:(int)caller {
		long placeholder = (long)[defaults integerForKey:key];
		UIAlertController *integerInputController = [UIAlertController
																							alertControllerWithTitle:editingType
																							message:@""
																							preferredStyle:UIAlertControllerStyleAlert];
																																													
		[integerInputController
		addTextFieldWithConfigurationHandler:^(UITextField *textField) {
				textField.placeholder = stringFromIntegerKey(key);
				if(shouldSwitchSign) {
					if ([oldText hasPrefix:@"-"]) {
						textField.text = [oldText substringFromIndex:1];
					} else {
						textField.text = [NSString stringWithFormat:@"-%@",oldText];
					}
					shouldSwitchSign = NO;
				}
		}];
		
		[[integerInputController textFields][0] setKeyboardType:UIKeyboardTypeNumberPad];
																								
		UIAlertAction *confirmAction = [UIAlertAction
																		actionWithTitle:@"OK"
																		style:UIAlertActionStyleDefault
																		handler:^(UIAlertAction *action) {
																			if([[integerInputController textFields][0] text].length == 0 || [[integerInputController textFields][0].text isEqualToString:@"-"]) {
																				if([[integerInputController textFields][0].placeholder isEqualToString:@"Not Set"]) {
																					[defaults removeObjectForKey:key];
																				} else {
																					[integerInputController textFields][0].text = [NSString stringWithFormat:@"%ld", placeholder];
																					[defaults setInteger:[[[integerInputController textFields][0] text] intValue] forKey:key];
																				}
																			} else {
																				[defaults setInteger:[[[integerInputController textFields][0] text] intValue] forKey:key];
																			}
																			[defaults synchronize];
																			[[NSClassFromString(@"SBIconController") sharedInstance] relayout];
																			switch(caller) {
																				case OFFSETSETTINGS:
																					[self setOffsetSettings];
																					break;
																				
																				case PADDINGSETTINGS:
																					[self setPaddingSettings];
																					break;
																				
																				case PRESETSETTINGS:
																					[self setPresetSettings];
																					break;
																				
																				case MISCSETTINGS:
																					[self setMiscSettings];
																					break;
																				}
																		}];
		
		UIAlertAction *switchSign = [UIAlertAction
																	actionWithTitle:@"+/-"
																	style:UIAlertActionStyleDefault
																	handler:^(UIAlertAction *action) {
																		oldText = [[integerInputController textFields][0] text];
																		shouldSwitchSign = YES;
																		[self setValueIntegerInput:editingType withKey:key withCaller:caller];
																	}];
		
		UIAlertAction *unsetAction = [UIAlertAction
																	actionWithTitle:@"Set Default"
																	style:UIAlertActionStyleDestructive
																	handler:^(UIAlertAction *action) {
																		[defaults removeObjectForKey:key];
																		[defaults synchronize];
																		[[NSClassFromString(@"SBIconController") sharedInstance] relayout];
																		switch(caller) {
																			case OFFSETSETTINGS:
																				[self setOffsetSettings];
																				break;
																					
																			case PADDINGSETTINGS:
																				[self setPaddingSettings];
																				break;
																					
																			case PRESETSETTINGS:
																				[self setPresetSettings];
																				break;
																					
																			case MISCSETTINGS:
																				[self setMiscSettings];
																				break;
																		}
																	}];
																	
		[integerInputController addAction:unsetAction];
		if(![key isEqualToString:@"homescreenColumns"] && ![key isEqualToString:@"homescreenRows"]) {
			[integerInputController addAction:switchSign];
		}
		[integerInputController addAction:confirmAction];
		[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:integerInputController animated:YES completion:NULL];
}
@end