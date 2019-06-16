#import "CBDContentViewMain.h"

@interface CBDView : UIView

@property (nonatomic, assign) BOOL presented;
@property (nonatomic, strong) UIVisualEffectView* blurView;
@property (nonatomic, strong) NSLayoutConstraint* heightConstraint;

@property (nonatomic, strong) CBDContentViewMain* contentView;

@end