//
//  ViewController.m
//  TableHeaderView
//
//

#import "ViewController.h"
#import <BlocksKit.h>
#import <BlocksKit+UIKit.h>
#import <Masonry.h>
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
static const CGFloat headerHeight = 200.0f;
static const CGFloat scale = 1;
@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIImageView *imageViewHeader;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation ViewController
- (IBAction)makeQRCodePic:(id)sender {
}

- (UITableView *)tableView {
    if (!_tableView) {
        self.imageViewHeader = [UIImageView new];
        self.imageViewHeader.frame = CGRectMake(0, -headerHeight, SCREENWIDTH, headerHeight);//设置frame
        self.imageViewHeader.clipsToBounds = YES;
        self.imageViewHeader.image = [UIImage imageNamed:@"BGimage.jpg"];
        self.imageViewHeader.userInteractionEnabled = YES;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.contentInset = UIEdgeInsetsMake(headerHeight, 0, 0, 0);//设置contentInset
        [_tableView addSubview:_imageViewHeader];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            (void)make.edges;
        }];
    }
    return _tableView;
}

- (void)setNavi {
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"left" style:UIBarButtonItemStylePlain handler:^(id sender) {
        NSLog(@"left");
    }];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"right" style:UIBarButtonItemStylePlain handler:^(id sender) {
        NSLog(@"right");
    }];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.titleLabel = [UILabel new];
    self.titleLabel.text = @"very good";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:18.0];
    self.titleLabel.frame = CGRectMake(0, 0, SCREENWIDTH, 44);
    self.titleLabel.textColor = [UIColor clearColor];
    self.navigationItem.titleView = self.titleLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavi];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.tableView setContentOffset:CGPointMake(0, -headerHeight)];
    [self.tableView bk_addObserverForKeyPath:@"contentOffset" task:^(id target) {
        CGFloat y = self.tableView.contentOffset.y;
        CGFloat alpha = 0;
        if (y <=-headerHeight) {
            alpha =0;
            
            //这里修改背景图片的frame，有放大缩小功能
            CGFloat compY = (fabs(y) - headerHeight)*scale;
            CGRect rect = _imageViewHeader.frame;
            rect.origin.y = y;
            rect.size.height = fabs(y) ;
            rect.origin.x = -compY;
            rect.size.width = SCREENWIDTH + compY*2;
            _imageViewHeader.frame = rect;
        } else {
            alpha = (y +headerHeight)/(headerHeight -64);
            
            //修改vc标题
            self.titleLabel.textColor = y >=-64?[UIColor blackColor]:[UIColor clearColor];
            
            //修改statusbar外观
            [[UIApplication sharedApplication] setStatusBarStyle:y>=-64? UIStatusBarStyleDefault:UIStatusBarStyleLightContent];
            [self setNeedsStatusBarAppearanceUpdate];
        }
        
        //这里修改navigitionitem的tintcolor
        self.navigationItem.leftBarButtonItem.tintColor = self.navigationItem.rightBarButtonItem.tintColor = (y<=-headerHeight?[UIColor whiteColor]:[UIColor blackColor]);
        
        //设置navigationbar的alpha
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:alpha];
    }];
}

- (void)dealloc {
    [self.tableView bk_removeAllBlockObservers];
}

#pragma - mark tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellid = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

- (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
