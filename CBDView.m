#import "CBDView.h"

@implementation CBDView

-(CBDView *)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	self.alpha = 0.0;

	UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
	self.blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
	self.blurView.frame = self.bounds;
	self.blurView.translatesAutoresizingMaskIntoConstraints = NO;
	[self insertSubview:self.blurView atIndex:0];

	[NSLayoutConstraint activateConstraints:@[
		[self.blurView.topAnchor constraintEqualToAnchor:self.topAnchor],
		[self.blurView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
		[self.blurView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
		[self.blurView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
	]];

	CGFloat topInset = [UIApplication sharedApplication].statusBarFrame.size.height;
	
	self.contentView = [[CBDContentViewMain alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
	[self addSubview:self.contentView];

	[NSLayoutConstraint activateConstraints:@[
		[self.contentView.topAnchor constraintEqualToAnchor:self.topAnchor constant:topInset],
		[self.contentView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
		[self.contentView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
		[self.contentView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
	]];

	return self;
}

-(void)setPresented:(BOOL)presented {
	_presented = presented;
	if (presented) {
		[self.superview bringSubviewToFront:self];
		[UIView animateWithDuration:(0.15) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			self.alpha = 1.0;
			self.frame = CGRectMake(0, 0, self.frame.size.width, 300);
			[self layoutIfNeeded];
		} completion:NULL];
	} else {
		[UIView animateWithDuration:(0.15) delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			self.alpha = 0.0;
			self.frame = CGRectMake(0, 0, self.frame.size.width, 0);
			[self layoutIfNeeded];
		} completion:NULL];
	}
}

@end