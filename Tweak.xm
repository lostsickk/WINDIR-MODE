#import <UIKit/UIKit.h>

@interface WMMenuView : UIView
@property(nonatomic, strong) UIView *panel;
@property(nonatomic, strong) UIButton *dragonButton;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) NSArray<NSString *> *tabs;
@property(nonatomic, strong) UIStackView *tabStack;
@end

@implementation WMMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.tabs = @[@"AIMBOT", @"VISUAL", @"BRUTAL", @"EXTRA", @"INFO"];

        self.dragonButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.dragonButton.frame = CGRectMake(20, 180, 58, 58);
        self.dragonButton.layer.cornerRadius = 29;
        self.dragonButton.backgroundColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.16 alpha:0.96];
        self.dragonButton.layer.borderWidth = 2;
        self.dragonButton.layer.borderColor = [UIColor colorWithRed:0.95 green:0.22 blue:0.18 alpha:1].CGColor;
        [self.dragonButton setTitle:@"🐉" forState:UIControlStateNormal];
        self.dragonButton.titleLabel.font = [UIFont systemFontOfSize:29];
        [self.dragonButton addTarget:self action:@selector(togglePanel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.dragonButton];

        UIPanGestureRecognizer *drag = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragDragon:)];
        [self.dragonButton addGestureRecognizer:drag];

        self.panel = [[UIView alloc] initWithFrame:CGRectMake(90, 170, 245, 310)];
        self.panel.backgroundColor = [UIColor colorWithRed:0.055 green:0.06 blue:0.085 alpha:0.97];
        self.panel.layer.cornerRadius = 15;
        self.panel.layer.borderWidth = 1.5;
        self.panel.layer.borderColor = [UIColor colorWithRed:0.9 green:0.18 blue:0.16 alpha:1].CGColor;
        self.panel.hidden = YES;
        [self addSubview:self.panel];

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 220, 30)];
        self.titleLabel.text = @"WINDIR MODE";
        self.titleLabel.textColor = UIColor.whiteColor;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.panel addSubview:self.titleLabel];

        self.tabStack = [[UIStackView alloc] initWithFrame:CGRectMake(9, 48, 227, 38)];
        self.tabStack.axis = UILayoutConstraintAxisHorizontal;
        self.tabStack.distribution = UIStackViewDistributionFillEqually;
        self.tabStack.spacing = 3;
        [self.panel addSubview:self.tabStack];

        for (NSString *tab in self.tabs) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button setTitle:tab forState:UIControlStateNormal];
            [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:8];
            button.backgroundColor = [UIColor colorWithRed:0.24 green:0.08 blue:0.09 alpha:1];
            button.layer.cornerRadius = 5;
            [button addTarget:self action:@selector(selectTab:) forControlEvents:UIControlEventTouchUpInside];
            [self.tabStack addArrangedSubview:button];
        }

        [self showSection:@"AIMBOT"];
        UILabel *credit = [[UILabel alloc] initWithFrame:CGRectMake(10, 278, 225, 22)];
        credit.text = @"@dnxmodz";
        credit.textColor = [UIColor colorWithWhite:0.72 alpha:1];
        credit.font = [UIFont systemFontOfSize:11 weight:UIFontWeightSemibold];
        credit.textAlignment = NSTextAlignmentCenter;
        [self.panel addSubview:credit];

        UILabel *copyright = [[UILabel alloc] initWithFrame:CGRectMake(5, 294, 235, 12)];
        copyright.text = @"© dnxmodz. All right reserved.";
        copyright.textColor = [UIColor colorWithWhite:0.48 alpha:1];
        copyright.font = [UIFont systemFontOfSize:8];
        copyright.textAlignment = NSTextAlignmentCenter;
        [self.panel addSubview:copyright];
    }
    return self;
}

- (void)togglePanel {
    self.panel.hidden = !self.panel.hidden;
}

- (void)dragDragon:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self];
    CGPoint center = self.dragonButton.center;
    center.x += translation.x;
    center.y += translation.y;
    CGFloat halfW = CGRectGetWidth(self.dragonButton.bounds) / 2.0;
    CGFloat halfH = CGRectGetHeight(self.dragonButton.bounds) / 2.0;
    center.x = MAX(halfW, MIN(self.bounds.size.width - halfW, center.x));
    center.y = MAX(halfH, MIN(self.bounds.size.height - halfH, center.y));
    self.dragonButton.center = center;
    [gesture setTranslation:CGPointZero inView:self];
}

- (void)selectTab:(UIButton *)sender {
    [self showSection:sender.currentTitle ?: @"INFO"];
}

- (void)showSection:(NSString *)section {
    for (UIView *view in self.panel.subviews.copy) {
        if ([view isKindOfClass:UILabel.class] && view != self.titleLabel) {
            UILabel *label = (UILabel *)view;
            if ([label.text isEqualToString:@"@dnxmodz"] ||
                [label.text isEqualToString:@"© dnxmodz. All right reserved."]) continue;
            [label removeFromSuperview];
        }
    }
    NSArray *options = @[@"Activar", @"Mostrar estado", @"Opción visual"];
    if ([section isEqualToString:@"INFO"]) {
        options = @[@"WINDIR MODE", @"Interfaz visual", @"@dnxmodz"];
    }
    CGFloat y = 101;
    for (NSString *option in options) {
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(17, y, 145, 34)];
        name.text = option;
        name.textColor = UIColor.whiteColor;
        name.font = [UIFont systemFontOfSize:13];
        [self.panel addSubview:name];

        if (![section isEqualToString:@"INFO"]) {
            UISwitch *toggle = [[UISwitch alloc] initWithFrame:CGRectMake(174, y + 1, 45, 28)];
            toggle.transform = CGAffineTransformMakeScale(0.72, 0.72);
            [self.panel addSubview:toggle];
        }
        y += 48;
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
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                          object:nil
                                                           queue:NSOperationQueue.mainQueue
                                                      usingBlock:^(__unused NSNotification *note) {
            WMInstallMenu();
        }];
    }
}
