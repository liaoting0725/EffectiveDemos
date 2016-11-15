//
//  LoadingPageViewController.m
//  YangDongXi
//
//  Created by Ron on 14-1-2.
//  Copyright (c) 2014年 HGG. All rights reserved.
//

#import "LoadingPageViewController.h"
#import "AppDelegate.h"

static const NSInteger IntroCount = 3;

@interface LoadingPageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic ,strong) UIPageControl *pageControl;
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,assign) BOOL shouldUseBackgroundImage;
@property (nonatomic ,assign) BOOL closing;
@end

@implementation LoadingPageViewController

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
        CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds);
        layout.itemSize = CGSizeMake(width, height);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, width, height) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}



- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.dismissBlock != nil)
    {
        self.dismissBlock();
    }
}

- (IBAction)onClickEnterWeiyi:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark -
#pragma mark -------------------- Properties ---------------------
- (void)setShouldUseBackgroundImage:(BOOL)shouldUseBackgroundImage{
    _shouldUseBackgroundImage = shouldUseBackgroundImage;
    if (shouldUseBackgroundImage) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[getMainTabBar.view imageByRenderingView]];
;

    }else {
        self.view.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark -
#pragma mark -------------------- UICollectionView DataSource ---------------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return self.pageCount;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PagingCell" forIndexPath:indexPath];
    UIImageView *bgImgView = (UIImageView*)[cell viewWithTag:tagOfBgImgInLoadingPage];
    UIButton *button = (UIButton*)[cell viewWithTag:1];
    
    if (indexPath.row == 4) {
        bgImgView.image = nil;
        button.hidden = YES;
        self.pageControl.hidden = YES;
    }else {
        self.pageControl.hidden = NO;
        if (CGSizeEqualToSize(CGSizeMake(640, 1136), [appDelegate.appConfig screenResolution]))
        {
            bgImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"loadingpage_%ld_1136.jpg",indexPath.row+1]];
           
        }
        else if(CGSizeEqualToSize(CGSizeMake(750, 1334), [appDelegate.appConfig screenResolution]))
        {
            bgImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"loadingpage_%ld_1334.jpg",indexPath.row+1]];
        }
        else if(CGSizeEqualToSize(CGSizeMake(1242, 2208), [appDelegate.appConfig screenResolution]))
        {
            bgImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"loadingpage_%ld_2208.jpg",indexPath.row+1]];
        }
        else
        {
            bgImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"loadingpage_%ld_960.jpg",indexPath.row+1]];
        }
        
        if (indexPath.row == 3
            ) {
            button.hidden = NO;
        }else {
            button.hidden = YES;
        }
    }
    for (UIView *subview in cell.subviews) {
        CGSize size = subview.frame.size;
        if (subview.frame.size.height> cell.frame.size.height) {
            size.height = cell.frame.size.height;
       
        }
    }
    
    if (CGSizeEqualToSize(CGSizeMake(640, 960), [appDelegate.appConfig screenResolution]))
    {
        bgImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    else
    {
        bgImgView.contentMode = UIViewContentModeScaleToFill;
        
    }
    if (indexPath.row == self.pageCount-1) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
    return cell;
}

#pragma mark -
#pragma mark -------------------- UIScrollview Delegate ---------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = [[self.collectionView indexPathForItemAtPoint:CGPointMake(self.collectionView.contentOffset.x + 100, self.collectionView.frame.size.height/4)] row];
    if (scrollView.contentOffset.x > self.collectionView.frame.size.width*4.5) {
        self.pageControl.hidden = YES;
    }else {
        self.pageControl.hidden = NO;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > 0)
    {
        if (!self.shouldUseBackgroundImage)
        {
            self.shouldUseBackgroundImage = YES;
        }
        if (scrollView.contentOffset.x > self.collectionView.frame.size.width*4.5 && !self.closing)
        {
            self.closing = YES;
            self.pageControl.hidden = YES;
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
            {
                [self dismissViewControllerAnimated:NO completion:NULL];
            });
        }
    }
    else
    {
        if (self.shouldUseBackgroundImage)
        {
            self.shouldUseBackgroundImage = NO;
        }
    }
}


#pragma mark -
#pragma mark -------------------- UICollectionViewFlowLayoutDelegate ---------------------
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size;
}

@end
