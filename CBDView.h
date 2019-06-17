#import "CBDContentView.h"

@interface CBDView : UIView

@property (nonatomic, assign) BOOL presented;
@property (nonatomic, strong) UIVisualEffectView* blurView;
@property (nonatomic, strong) NSLayoutConstraint* heightConstraint;

@property (nonatomic, strong) CBDContentView* contentViewMain;
@property (nonatomic, strong) CBDContentView* contentViewOffset;

@property (nonatomic, weak) CBDContentView* contentViewPresented;

-(void)presentView:(CBDContentView*)view;
-(void)createView:(NSString*)key ofClass:(Class)theClass;

@end