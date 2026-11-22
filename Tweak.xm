#import <UIKit/UIKit.h>

// WINDIR MODE — interfaz demostrativa únicamente.
// Los controles no implementan aimbot, ESP ni modificaciones del juego.

static UIColor *WMRed(void) { return [UIColor colorWithRed:0.88 green:0.12 blue:0.15 alpha:1.0]; }
static UIColor *WMPink(void) { return [UIColor colorWithRed:0.28 green:0.055 blue:0.075 alpha:1.0]; }
static UIColor *WMBackground(void) { return [UIColor colorWithRed:0.035 green:0.04 blue:0.055 alpha:0.98]; }

@interface WMMenuView : UIView
@property(nonatomic,strong) UIView *panel;
@property(nonatomic,strong) UIView *header;
@property(nonatomic,strong) UIScrollView *content;
@property(nonatomic,strong) UIStackView *tabsStack;
@property(nonatomic,strong) UIButton *dragonButton;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) NSString *activeTab;
@end

@implementation WMMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    self.backgroundColor = UIColor.clearColor;

    self.dragonButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.dragonButton.frame = CGRectMake(18, 150, 58, 58);
    self.dragonButton.layer.cornerRadius = 29;
    self.dragonButton.backgroundColor = WMBackground();
    self.dragonButton.layer.borderWidth = 2;
    self.dragonButton.layer.borderColor = WMRed().CGColor;
    [self.dragonButton setTitle:@"🐉" forState:UIControlStateNormal];
    self.dragonButton.titleLabel.font = [UIFont systemFontOfSize:29];
    [self.dragonButton addTarget:self action:@selector(togglePanel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.dragonButton];
    UIPanGestureRecognizer *dragonPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragDragon:)];
    [self.dragonButton addGestureRecognizer:dragonPan];

    CGFloat w = MIN(410.0, MAX(300.0, self.bounds.size.width - 28.0));
    CGFloat h = MIN(430.0, MAX(300.0, self.bounds.size.height - 24.0));
    CGFloat x = MAX(10.0, (self.bounds.size.width - w) / 2.0);
    CGFloat y = MAX(10.0, (self.bounds.size.height - h) / 2.0);
    self.panel = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    self.panel.backgroundColor = WMBackground();
    self.panel.layer.cornerRadius = 14;
    self.panel.layer.borderWidth = 1.6;
    self.panel.layer.borderColor = WMRed().CGColor;
    self.panel.clipsToBounds = YES;
    self.panel.hidden = YES;
    [self addSubview:self.panel];

    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 43)];
    self.header.backgroundColor = [UIColor colorWithRed:0.10 green:0.045 blue:0.06 alpha:1];
    [self.panel addSubview:self.header];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 4, w-58, 34)];
    self.titleLabel.text = @"WINDIR MODE";
    self.titleLabel.textColor = UIColor.whiteColor;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.header addSubview:self.titleLabel];
    UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem];
    close.frame = CGRectMake(w-42, 4, 34, 34);
    [close setTitle:@"×" forState:UIControlStateNormal];
    [close setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    close.titleLabel.font = [UIFont boldSystemFontOfSize:26];
    [close addTarget:self action:@selector(hidePanel) forControlEvents:UIControlEventTouchUpInside];
    [self.header addSubview:close];
    UIPanGestureRecognizer *panelPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragPanel:)];
    [self.header addGestureRecognizer:panelPan];

    NSArray *tabs = @[@"AIMBOT", @"VISUAL", @"BRUTAL", @"EXTRA", @"INFO"];
    self.tabsStack = [[UIStackView alloc] initWithFrame:CGRectMake(9, 49, w-18, 34)];
    self.tabsStack.axis = UILayoutConstraintAxisHorizontal;
    self.tabsStack.distribution = UIStackViewDistributionFillEqually;
    self.tabsStack.spacing = 4;
    [self.panel addSubview:self.tabsStack];
    for (NSString *tab in tabs) {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
        [b setTitle:tab forState:UIControlStateNormal];
        [b setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        b.titleLabel.font = [UIFont boldSystemFontOfSize:9];
        b.backgroundColor = WMPink();
        b.layer.cornerRadius = 5;
        b.layer.borderWidth = 0.7;
        b.layer.borderColor = WMRed().CGColor;
        [b addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabsStack addArrangedSubview:b];
    }

    self.content = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 91, w-20, h-133)];
    self.content.alwaysBounceVertical = YES;
    [self.panel addSubview:self.content];

    UILabel *credit = [[UILabel alloc] initWithFrame:CGRectMake(8, h-37, w-16, 15)];
    credit.text = @"@dnxmodz";
    credit.textColor = [UIColor colorWithWhite:0.82 alpha:1];
    credit.font = [UIFont systemFontOfSize:10 weight:UIFontWeightSemibold];
    credit.textAlignment = NSTextAlignmentCenter;
    [self.panel addSubview:credit];
    UILabel *copyright = [[UILabel alloc] initWithFrame:CGRectMake(8, h-21, w-16, 12)];
    copyright.text = @"© dnxmodz. All right reserved.";
    copyright.textColor = [UIColor colorWithWhite:0.55 alpha:1];
    copyright.font = [UIFont systemFontOfSize:8];
    copyright.textAlignment = NSTextAlignmentCenter;
    [self.panel addSubview:copyright];

    [self showSection:@"AIMBOT"];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // Keep the overlay sized to its host window after rotation.
    self.frame = self.superview ? self.superview.bounds : self.frame;
}

- (void)togglePanel { self.panel.hidden = !self.panel.hidden; }
- (void)hidePanel { self.panel.hidden = YES; }

- (void)dragDragon:(UIPanGestureRecognizer *)g {
    CGPoint t = [g translationInView:self];
    CGPoint c = self.dragonButton.center; c.x += t.x; c.y += t.y;
    CGFloat hw = self.dragonButton.bounds.size.width/2, hh = self.dragonButton.bounds.size.height/2;
    c.x = MAX(hw, MIN(self.bounds.size.width-hw, c.x));
    c.y = MAX(hh, MIN(self.bounds.size.height-hh, c.y));
    self.dragonButton.center = c;
    [g setTranslation:CGPointZero inView:self];
}

- (void)dragPanel:(UIPanGestureRecognizer *)g {
    CGPoint t = [g translationInView:self];
    CGPoint c = self.panel.center; c.x += t.x; c.y += t.y;
    CGFloat hw = self.panel.bounds.size.width/2, hh = self.panel.bounds.size.height/2;
    c.x = MAX(hw+4, MIN(self.bounds.size.width-hw-4, c.x));
    c.y = MAX(hh+4, MIN(self.bounds.size.height-hh-4, c.y));
    self.panel.center = c;
    [g setTranslation:CGPointZero inView:self];
}

- (void)selectTab:(UIButton *)sender { [self showSection:sender.currentTitle ?: @"AIMBOT"]; }

- (void)addSwitchRow:(NSString *)name y:(CGFloat)y {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(7, y, self.content.bounds.size.width-92, 32)];
    label.text = name; label.textColor = UIColor.whiteColor;
    label.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    [self.content addSubview:label];
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(self.content.bounds.size.width-66, y+1, 51, 30)];
    sw.onTintColor = WMRed(); sw.transform = CGAffineTransformMakeScale(0.78, 0.78);
    [self.content addSubview:sw];
}

- (void)addInfoRow:(NSString *)name y:(CGFloat)y {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, y, self.content.bounds.size.width-16, 34)];
    label.text = name; label.textColor = UIColor.whiteColor;
    label.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    label.backgroundColor = [UIColor colorWithWhite:1 alpha:0.045];
    label.layer.cornerRadius = 5; label.clipsToBounds = YES;
    [self.content addSubview:label];
}

- (void)showSection:(NSString *)section {
    self.activeTab = section;
    for (UIView *v in self.content.subviews) [v removeFromSuperview];
    NSArray *options = @[];
    if ([section isEqualToString:@"AIMBOT"]) options = @[@"Enable Aimbot", @"Visible Check", @"Aim-Silent", @"Aim-Kill"];
    else if ([section isEqualToString:@"VISUAL"]) options = @[@"Enable ESP", @"Mode Streamers", @"ESP Lines", @"ESP Skeletons", @"ESP Boxes", @"ESP Healths", @"ESP NickNames", @"ESP Counts"];
    else if ([section isEqualToString:@"BRUTAL"]) options = @[@"Ninja Dash", @"Fly Ultira", @"UnderKill", @"Move Player", @"Enemies Pull", @"Spine Player", @"Enemies Air", @"Fly Map", @"Fly Sky", @"Fly Altura"];
    else if ([section isEqualToString:@"EXTRA"]) options = @[@"Panel Animations", @"Dark Mode", @"Compact Mode", @"Show Notifications", @"Sound Effects", @"Auto Save Settings"];

    CGFloat y = 5;
    if ([section isEqualToString:@"AIMBOT"]) {
        [self addSwitchRow:@"Enable Aimbot" y:y]; y += 39;
        [self addSwitchRow:@"Visible Check" y:y]; y += 39;
        [self addSwitchRow:@"Aim-Silent" y:y]; y += 39;
        [self addSwitchRow:@"Aim-Kill" y:y]; y += 43;
        UILabel *r = [[UILabel alloc] initWithFrame:CGRectMake(7,y,self.content.bounds.size.width-14,24)];
        r.text = @"AimRadius"; r.textColor = UIColor.whiteColor; r.font = [UIFont systemFontOfSize:13]; [self.content addSubview:r]; y += 25;
        UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[@"180°", @"360°"]];
        seg.frame = CGRectMake(7,y,self.content.bounds.size.width-14,30); seg.selectedSegmentIndex = 0;
        seg.selectedSegmentTintColor = WMRed(); [self.content addSubview:seg]; y += 40;
        UILabel *f = [[UILabel alloc] initWithFrame:CGRectMake(7,y,100,24)]; f.text = @"AimFov"; f.textColor = UIColor.whiteColor; f.font = [UIFont systemFontOfSize:13]; [self.content addSubview:f];
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(85,y,self.content.bounds.size.width-95,24)]; slider.minimumValue=0; slider.maximumValue=100; slider.value=50; slider.minimumTrackTintColor=WMRed(); [self.content addSubview:slider]; y += 40;
    } else if ([section isEqualToString:@"INFO"]) {
        [self addInfoRow:@"WINDIR MODE" y:y]; y += 42;
        [self addInfoRow:@"Device Info" y:y]; y += 42;
        [self addInfoRow:@"Fix Login (visual only)" y:y]; y += 42;
        [self addInfoRow:@"Change Mode (visual only)" y:y]; y += 42;
        [self addInfoRow:@"Language: Español / English" y:y]; y += 42;
        [self addInfoRow:@"@dnxmodz" y:y]; y += 42;
    } else {
        for (NSString *option in options) { [self addSwitchRow:option y:y]; y += 39; }
        if ([section isEqualToString:@"EXTRA"]) {
            UILabel *lang = [[UILabel alloc] initWithFrame:CGRectMake(7,y+4,self.content.bounds.size.width-14,25)];
            lang.text = @"Language"; lang.textColor = UIColor.whiteColor; lang.font = [UIFont systemFontOfSize:13]; [self.content addSubview:lang]; y += 32;
            UISegmentedControl *languages = [[UISegmentedControl alloc] initWithItems:@[@"ES", @"EN"]];
            languages.frame = CGRectMake(7,y,self.content.bounds.size.width-14,30); languages.selectedSegmentIndex=0; languages.selectedSegmentTintColor=WMRed(); [self.content addSubview:languages]; y += 38;
        }
    }
    self.content.contentSize = CGSizeMake(self.content.bounds.size.width, y+8);
    for (UIView *v in self.tabsStack.arrangedSubviews) {
        if (![v isKindOfClass:UIButton.class]) continue;
        UIButton *b = (UIButton *)v;
        b.backgroundColor = [b.currentTitle isEqualToString:section] ? WMRed() : WMPink();
    }
}
@end

static void WMInstallMenu(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = nil;
        for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
            if (![scene isKindOfClass:UIWindowScene.class]) continue;
            for (UIWindow *candidate in ((UIWindowScene *)scene).windows) {
                if (candidate.isKeyWindow) { window = candidate; break; }
            }
            if (window) break;
        }
        if (!window || [window viewWithTag:0xD0D0]) return;
        WMMenuView *menu = [[WMMenuView alloc] initWithFrame:window.bounds];
        menu.tag = 0xD0D0;
        menu.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [window addSubview:menu];
    });
}

%ctor {
    @autoreleasepool {
        WMInstallMenu();
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(__unused NSNotification *note) { WMInstallMenu(); }];
    }
}
