#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

#pragma mark - WINDIR MOD V1 (visual-only menu)

static UIWindow *WINDIRWindow = nil;
static UIView *WINDIRRoot = nil;
static UIView *WINDIRPanel = nil;
static UIButton *WINDIRFloatButton = nil;
static UILabel *WINDIRTabTitle = nil;
static UIView *WINDIRContent = nil;
static NSString *WINDIRCurrentTab = @"AIMBOT";

static UIColor *WRed(void) { return [UIColor colorWithRed:1.0 green:0.06 blue:0.10 alpha:1.0]; }
static UIColor *WBlack(void) { return [UIColor colorWithRed:0.025 green:0.025 blue:0.035 alpha:0.97]; }
static UIColor *WGray(void) { return [UIColor colorWithRed:0.30 green:0.30 blue:0.34 alpha:1.0]; }

@interface WINDIRDragView : UIView
@end
@implementation WINDIRDragView {
    CGPoint _dragStart;
    CGPoint _viewStart;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _dragStart = [[touches anyObject] locationInView:self];
    _viewStart = self.frame.origin;
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint p = [[touches anyObject] locationInView:self];
    CGPoint delta = CGPointMake(p.x - _dragStart.x, p.y - _dragStart.y);
    CGRect f = self.frame;
    f.origin = CGPointMake(_viewStart.x + delta.x, _viewStart.y + delta.y);
    self.frame = f;
    [super touchesMoved:touches withEvent:event];
}
@end

static UILabel *WLabel(NSString *text, CGFloat size, UIColor *color, UIFontWeight weight) {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:size weight:weight];
    label.numberOfLines = 1;
    return label;
}

static void WClearContent(void) {
    for (UIView *v in WINDIRContent.subviews) [v removeFromSuperview];
}

static void WAddToggle(UIView *parent, NSString *title, CGFloat x, CGFloat y, CGFloat width) {
    UILabel *label = WLabel(title, 13, [UIColor whiteColor], UIFontWeightMedium);
    label.frame = CGRectMake(x, y, width - 58, 28);
    [parent addSubview:label];

    UIView *check = [[UIView alloc] initWithFrame:CGRectMake(x, y + 5, 16, 16)];
    check.layer.borderColor = WRed().CGColor;
    check.layer.borderWidth = 1.2;
    check.layer.cornerRadius = 3;
    [parent addSubview:check];

    UISwitch *toggle = [[UISwitch alloc] initWithFrame:CGRectMake(x + width - 52, y, 48, 28)];
    toggle.transform = CGAffineTransformMakeScale(0.72, 0.72);
    toggle.onTintColor = WRed();
    toggle.thumbTintColor = [UIColor colorWithWhite:0.92 alpha:1];
    toggle.backgroundColor = WGray();
    toggle.layer.cornerRadius = 15;
    [parent addSubview:toggle];
    // Visual-only: toggles do not alter or interact with the game.
}

static void WAddRowList(NSArray<NSString *> *items, UIView *parent, CGFloat x, CGFloat y, CGFloat width, NSInteger columns) {
    CGFloat gap = 18;
    CGFloat colWidth = (width - gap * (columns - 1)) / columns;
    for (NSUInteger i = 0; i < items.count; i++) {
        NSInteger col = (NSInteger)i % columns;
        NSInteger row = (NSInteger)i / columns;
        WAddToggle(parent, items[i], x + col * (colWidth + gap), y + row * 38, colWidth);
    }
}

static void WShowTab(NSString *tab);

static UIButton *WTabButton(NSString *title, CGFloat x, CGFloat y, CGFloat width) {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(x, y, width, 34);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightBold];
    button.backgroundColor = [title isEqualToString:WINDIRCurrentTab] ? WRed() : [UIColor colorWithWhite:0.08 alpha:1];
    button.layer.cornerRadius = 5;
    [button addAction:[UIAction actionWithHandler:^(__kindof UIAction *action) {
        WINDIRCurrentTab = title;
        WShowTab(title);
    }] forControlEvents:UIControlEventTouchUpInside];
    return button;
}

static void WBuildTabs(void) {
    UIView *bar = [WINDIRPanel viewWithTag:701];
    if (!bar) return;
    for (UIView *v in bar.subviews) [v removeFromSuperview];
    NSArray *tabs = @[@"AIMBOT", @"VISUAL", @"BRUTAL", @"EXTRA", @"INFO"];
    CGFloat w = CGRectGetWidth(bar.bounds) / tabs.count;
    for (NSUInteger i = 0; i < tabs.count; i++) {
        [bar addSubview:WTabButton(tabs[i], i * w + 3, 3, w - 6)];
    }
}

static void WShowTab(NSString *tab) {
    if (!WINDIRPanel || !WINDIRContent) return;
    WINDIRCurrentTab = tab;
    WBuildTabs();
    WClearContent();

    CGFloat width = CGRectGetWidth(WINDIRContent.bounds);
    if ([tab isEqualToString:@"AIMBOT"]) {
        WAddRowList(@[@"Enable Aimbot", @"Visible Check", @"Aim-Silent", @"Aim-Kill",
                      @"AimRadius 180°", @"AimRadius 360°", @"AimFov", @"Target Type",
                      @"Target Lock"], WINDIRContent, 14, 14, width - 28, 2);
    } else if ([tab isEqualToString:@"VISUAL"]) {
        WAddRowList(@[@"Enable ESP", @"Mode Streamers", @"ESP Lines", @"ESP Skeletons",
                      @"ESP Boxes", @"ESP Healths", @"ESP NickNames", @"ESP Counts"], WINDIRContent, 14, 14, width - 28, 2);
    } else if ([tab isEqualToString:@"BRUTAL"]) {
        WAddRowList(@[@"Ghost VIP", @"Ninja Dash", @"Fly Ultira", @"Enemies Pull",
                      @"TeleKill", @"UnderKill", @"Move Player", @"Spine Player",
                      @"Enemies Air", @"Fly Map", @"Fly Altura", @"Break Wall",
                      @"Object United"], WINDIRContent, 14, 14, width - 28, 2);
    } else if ([tab isEqualToString:@"EXTRA"]) {
        WAddRowList(@[@"Wall Glow", @"Glow Jump", @"Wall Fly", @"Wall Hack",
                      @"No Reload", @"Speed Run", @"Speed Time", @"Fast Fire",
                      @"Speed Fire"], WINDIRContent, 14, 14, width - 28, 2);
    } else {
        UILabel *owners = WLabel(@"[x] Owners: @dnxmodz @Windirmode1", 14, WRed(), UIFontWeightBold);
        owners.frame = CGRectMake(14, 12, width - 28, 25);
        [WINDIRContent addSubview:owners];

        UILabel *brand = WLabel(@"WINDIR MOD V1", 24, [UIColor whiteColor], UIFontWeightHeavy);
        brand.textAlignment = NSTextAlignmentCenter;
        brand.frame = CGRectMake(10, 52, width - 20, 34);
        [WINDIRContent addSubview:brand];

        UILabel *version = WLabel(@"FF Version 1.120.1", 13, WRed(), UIFontWeightSemibold);
        version.textAlignment = NSTextAlignmentCenter;
        version.frame = CGRectMake(10, 84, width - 20, 22);
        [WINDIRContent addSubview:version];

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(14, 116, width - 28, 1)];
        line.backgroundColor = WRed();
        [WINDIRContent addSubview:line];

        NSArray *info = @[@"▣  Información del dispositivo",
                          @"▣  Batería",
                          @"▣  RAM",
                          @"▣  CPU",
                          @"▣  Fix Login",
                          @"▣  Change Mode",
                          @"▣  Idiomas"];
        CGFloat y = 130;
        for (NSString *item in info) {
            UILabel *l = WLabel(item, 13, [UIColor whiteColor], UIFontWeightMedium);
            l.frame = CGRectMake(20, y, width - 40, 25);
            [WINDIRContent addSubview:l];
            y += 30;
        }
    }
}

static void WMakeDraggable(UIView *view) {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:view action:@selector(windir_pan:)];
    [view addGestureRecognizer:pan];
}

@interface UIView (WINDIRDrag)
- (void)windir_pan:(UIPanGestureRecognizer *)pan;
@end
@implementation UIView (WINDIRDrag)
- (void)windir_pan:(UIPanGestureRecognizer *)pan {
    CGPoint delta = [pan translationInView:self.superview];
    if (pan.state == UIGestureRecognizerStateBegan) {
        objc_setAssociatedObject(self, @selector(windir_pan:), [NSValue valueWithCGPoint:self.frame.origin], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    NSValue *v = objc_getAssociatedObject(self, @selector(windir_pan:));
    CGPoint start = v ? v.CGPointValue : self.frame.origin;
    self.frame = CGRectMake(start.x + delta.x, start.y + delta.y, self.frame.size.width, self.frame.size.height);
}
@end

static void WCreateMenu(void) {
    if (WINDIRRoot) return;
    UIWindow *host = nil;
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
            if (scene.activationState != UISceneActivationStateForegroundActive ||
                ![scene isKindOfClass:UIWindowScene.class]) continue;
            for (UIWindow *w in ((UIWindowScene *)scene).windows) {
                if (w.isKeyWindow) { host = w; break; }
            }
            if (host) break;
        }
    } else {
        // Fallback for iOS versions before scenes.
        for (UIWindow *w in UIApplication.sharedApplication.windows) {
            if (w.isKeyWindow) { host = w; break; }
        }
    }
    if (!host) return;

    WINDIRRoot = [[UIView alloc] initWithFrame:host.bounds];
    WINDIRRoot.backgroundColor = UIColor.clearColor;
    WINDIRRoot.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [host addSubview:WINDIRRoot];

    WINDIRFloatButton = [UIButton buttonWithType:UIButtonTypeSystem];
    WINDIRFloatButton.frame = CGRectMake(18, 90, 54, 54);
    WINDIRFloatButton.backgroundColor = [UIColor colorWithRed:0.10 green:0.02 blue:0.03 alpha:0.95];
    WINDIRFloatButton.layer.borderColor = WRed().CGColor;
    WINDIRFloatButton.layer.borderWidth = 2;
    WINDIRFloatButton.layer.cornerRadius = 27;
    [WINDIRFloatButton setTitle:@"W" forState:UIControlStateNormal];
    [WINDIRFloatButton setTitleColor:WRed() forState:UIControlStateNormal];
    WINDIRFloatButton.titleLabel.font = [UIFont systemFontOfSize:25 weight:UIFontWeightBlack];
    [WINDIRRoot addSubview:WINDIRFloatButton];

    WINDIRPanel = [[WINDIRDragView alloc] initWithFrame:CGRectMake(70, 70, MIN(host.bounds.size.width - 90, 720), MIN(host.bounds.size.height - 120, 390))];
    WINDIRPanel.backgroundColor = WBlack();
    WINDIRPanel.layer.borderColor = WRed().CGColor;
    WINDIRPanel.layer.borderWidth = 2;
    WINDIRPanel.layer.cornerRadius = 12;
    WINDIRPanel.clipsToBounds = YES;
    [WINDIRRoot addSubview:WINDIRPanel];

    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINDIRPanel.bounds.size.width, 46)];
    header.backgroundColor = [UIColor colorWithWhite:0.035 alpha:1];
    [WINDIRPanel addSubview:header];

    UILabel *title = WLabel(@"WINDIR MOD V1 - FF Version 1.120.1", 17, [UIColor whiteColor], UIFontWeightHeavy);
    title.frame = CGRectMake(14, 5, WINDIRPanel.bounds.size.width - 62, 36);
    [header addSubview:title];

    UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem];
    close.frame = CGRectMake(WINDIRPanel.bounds.size.width - 42, 7, 32, 32);
    [close setTitle:@"×" forState:UIControlStateNormal];
    [close setTitleColor:WRed() forState:UIControlStateNormal];
    close.titleLabel.font = [UIFont systemFontOfSize:29 weight:UIFontWeightBold];
    [close addAction:[UIAction actionWithHandler:^(__kindof UIAction *action) {
        WINDIRPanel.hidden = YES;
        WINDIRFloatButton.hidden = NO;
    }] forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:close];

    UIView *tabBar = [[UIView alloc] initWithFrame:CGRectMake(8, 50, WINDIRPanel.bounds.size.width - 16, 40)];
    tabBar.tag = 701;
    [WINDIRPanel addSubview:tabBar];

    WINDIRContent = [[UIView alloc] initWithFrame:CGRectMake(8, 96, WINDIRPanel.bounds.size.width - 16, WINDIRPanel.bounds.size.height - 104)];
    WINDIRContent.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [WINDIRPanel addSubview:WINDIRContent];

    [WINDIRFloatButton addAction:[UIAction actionWithHandler:^(__kindof UIAction *action) {
        WINDIRPanel.hidden = !WINDIRPanel.hidden;
        WINDIRFloatButton.hidden = !WINDIRPanel.hidden;
    }] forControlEvents:UIControlEventTouchUpInside];

    UIPanGestureRecognizer *floatPan = [[UIPanGestureRecognizer alloc] initWithTarget:WINDIRFloatButton action:@selector(windir_pan:)];
    [WINDIRFloatButton addGestureRecognizer:floatPan];
    WMakeDraggable(WINDIRPanel);
    WShowTab(@"AIMBOT");
    WINDIRFloatButton.hidden = YES;
}

%ctor {
    @autoreleasepool {
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                WCreateMenu();
            });
        });
    }
}
