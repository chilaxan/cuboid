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