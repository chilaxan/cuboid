#import "CBDView.h"

@interface SBIconController : UIViewController

@property (nonatomic, strong) CBDView *cbdView;
+(id)sharedInstance;
-(BOOL)isEditing;
-(BOOL)relayout;
-(void)setIsEditing:(BOOL)arg1;
@end

@interface UIStatusBarWindow : UIWindow
@end

@interface SBEditingDoneButton : UIView
@end