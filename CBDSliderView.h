@interface CBDSliderView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UIButton *valueButton;

-(void)updateValue:(id)sender;

@end