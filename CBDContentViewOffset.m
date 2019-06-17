#import "CBDContentViewOffset.h"
#import "CBDManager.h"
#import "Tweak.h"

@implementation CBDContentViewOffset

-(CBDContentView *)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	self.titleLabel.text = @"Offset";

	self.verticalOffsetSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	[self.verticalOffsetSlider addTarget:self action:@selector(updateVerticalOffset:) forControlEvents:UIControlEventValueChanged];
	self.verticalOffsetSlider.minimumValue = -150.0;
	self.verticalOffsetSlider.maximumValue = 150.0;
	self.verticalOffsetSlider.continuous = YES;
	[self.stackView addArrangedSubview:self.verticalOffsetSlider];

	self.horizontalOffsetSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	[self.horizontalOffsetSlider addTarget:self action:@selector(updateHorizontalOffset:) forControlEvents:UIControlEventValueChanged];
	self.horizontalOffsetSlider.minimumValue = -150.0;
	self.horizontalOffsetSlider.maximumValue = 150.0;
	self.horizontalOffsetSlider.continuous = YES;
	[self.stackView addArrangedSubview:self.horizontalOffsetSlider];

	[self refresh];

	return self;
}

-(void)refresh {
	self.verticalOffsetSlider.value = [CBDManager sharedInstance].verticalOffset;
	self.horizontalOffsetSlider.value = [CBDManager sharedInstance].horizontalOffset;
}

-(void)updateVerticalOffset:(id)sender {
	[CBDManager sharedInstance].verticalOffset = self.verticalOffsetSlider.value;
	[[CBDManager sharedInstance] relayout];
}

-(void)updateHorizontalOffset:(id)sender {
	[CBDManager sharedInstance].horizontalOffset = self.horizontalOffsetSlider.value;
	[[CBDManager sharedInstance] relayout];
}

@end