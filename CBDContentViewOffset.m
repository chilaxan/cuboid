#import "CBDContentViewOffset.h"
#import "CBDManager.h"
#import "Tweak.h"

@implementation CBDContentViewOffset

-(CBDContentView *)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	self.titleLabel.text = @"Offset";

	self.verticalOffsetSliderView = [[CBDSliderView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	self.verticalOffsetSliderView.titleLabel.text = @"VERTICAL OFFSET";
	[self.verticalOffsetSliderView.slider addTarget:self action:@selector(updateVerticalOffset:) forControlEvents:UIControlEventValueChanged];
	self.verticalOffsetSliderView.slider.minimumValue = -150.0;
	self.verticalOffsetSliderView.slider.maximumValue = 150.0;
	self.verticalOffsetSliderView.slider.continuous = YES;
	[self.stackView addArrangedSubview:self.verticalOffsetSliderView];

	self.horizontalOffsetSliderView = [[CBDSliderView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	self.horizontalOffsetSliderView.titleLabel.text = @"HORIZONTAL OFFSET";
	[self.horizontalOffsetSliderView.slider addTarget:self action:@selector(updateHorizontalOffset:) forControlEvents:UIControlEventValueChanged];
	self.horizontalOffsetSliderView.slider.minimumValue = -150.0;
	self.horizontalOffsetSliderView.slider.maximumValue = 150.0;
	self.horizontalOffsetSliderView.slider.continuous = YES;
	[self.stackView addArrangedSubview:self.horizontalOffsetSliderView];

	[self refresh];

	return self;
}

-(void)refresh {
	self.verticalOffsetSliderView.slider.value = [CBDManager sharedInstance].verticalOffset;
	[self.verticalOffsetSliderView updateValue:nil];

	self.horizontalOffsetSliderView.slider.value = [CBDManager sharedInstance].horizontalOffset;
	[self.horizontalOffsetSliderView updateValue:nil];
}

-(void)updateVerticalOffset:(id)sender {
	[CBDManager sharedInstance].verticalOffset = self.verticalOffsetSliderView.slider.value;
	[[CBDManager sharedInstance] relayout];
}

-(void)updateHorizontalOffset:(id)sender {
	[CBDManager sharedInstance].horizontalOffset = self.horizontalOffsetSliderView.slider.value;
	[[CBDManager sharedInstance] relayout];
}

@end