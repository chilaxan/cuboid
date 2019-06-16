#import "CBDContentViewMain.h"
#import "CBDManager.h"

@implementation CBDContentViewMain

-(CBDContentView *)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	self.offsetSettingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.offsetSettingsButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
	[self.offsetSettingsButton setTitle:@"Offset Settings" forState:UIControlStateNormal];
	[self.stackView addArrangedSubview:self.offsetSettingsButton];

	self.paddingSettingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.paddingSettingsButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
	[self.paddingSettingsButton setTitle:@"Padding Settings" forState:UIControlStateNormal];
	[self.stackView addArrangedSubview:self.paddingSettingsButton];

	self.saveRestoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.saveRestoreButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
	[self.saveRestoreButton setTitle:@"Save / Restore" forState:UIControlStateNormal];
	[self.stackView addArrangedSubview:self.saveRestoreButton];

	self.miscellaneousButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.miscellaneousButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
	[self.miscellaneousButton setTitle:@"Miscellaneous" forState:UIControlStateNormal];
	[self.stackView addArrangedSubview:self.miscellaneousButton];

	[self.backButton setTitle:@"Done" forState:UIControlStateNormal];

	return self;
}

-(void)back:(id)sender {
	[[CBDManager sharedInstance].view setPresented:NO];
}

@end