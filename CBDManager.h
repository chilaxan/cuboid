@interface CBDManager : NSObject

@property (nonatomic, strong) NSUserDefaults* defaults;

@property (nonatomic, assign) BOOL hideIconLabels;
@property (nonatomic, assign) NSUInteger homescreenColumns;
@property (nonatomic, assign) NSUInteger homescreenRows;
@property (nonatomic, assign) CGFloat verticalOffset;
@property (nonatomic, assign) CGFloat horizontalOffset;
@property (nonatomic, assign) CGFloat verticalPadding;
@property (nonatomic, assign) CGFloat horizontalPadding;

+(instancetype)sharedInstance;
-(id)init;

-(void)load;
-(void)save;
-(void)reset;

@end