//
//  Created by wMellon on 16/7/21.
//  Copyright 
//

#import "XBSlidItemViewController.h"
#import "XBSlidItemTypeCell.h"

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height//获取屏幕高度，兼容性测试
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width//获取屏幕宽度，兼容性测试
//带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

@interface XBSlidItemViewController ()<UITableViewDataSource,UITableViewDelegate>{
    CGFloat _tableViewH;
    
    NSString *_currentKey;
    NSIndexPath *_currentIndexPath;
}
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation XBSlidItemViewController

@synthesize tableView;

static NSInteger const typeCellHeight = 88; //typecell的高度
static NSInteger const typeCellHalfHeight = 44; //typeCell的高度
static NSString * const typeCellID = @"XBSlidItemTypeCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableViewH = ScreenHeight - 45;
    
    self.tableView.separatorStyle = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"XBSlidItemTypeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:typeCellID];
    //当第一个typeCell被点亮时，tableView的第一个cell高度刚好就是(_tableViewH - typeCellHeight)/2；当最后一个typeCell被点亮时，tableView的最后一个高度刚好就是(_tableViewH - typeCellHeight)/2
    self.tableView.contentSize = CGSizeMake(ScreenWidth, self.dataSource.count * typeCellHeight + (_tableViewH - typeCellHeight));
    //添加两条线
    [self addTwoLine];
 
    [self loadDataSource];
}

-(void)addTwoLine{
    //两条line的高度就是cell的高度，而且两条line的组合在tableView的中间
    CGFloat lineFlameY = 45 + (_tableViewH - typeCellHeight) / 2;
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(20, lineFlameY, ScreenWidth - 40, 1)];
    line1.backgroundColor = COLOR(222, 222, 222, 100);
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(20, lineFlameY + 88, ScreenWidth - 40, 1)];
    line2.backgroundColor = COLOR(222, 222, 222, 100);
    
    [self.view addSubview:line1];
    [self.view addSubview:line2];
}


#pragma mark - dataSource

-(void)loadDataSource{
    
    _dataSource = [@[
                    @{
                        @"key":@"0",
                        @"title":@"猫",
                        @"detail":@"这是什么猫",
                        @"image":@"image1.jpg"
                    },@{
                        @"key":@"1",
                        @"title":@"金毛",
                        @"detail":@"金毛狮王",
                        @"image":@"image2.jpg"
                    },@{
                        @"key":@"2",
                        @"title":@"萨摩",
                        @"detail":@"都是萨摩很可爱",
                        @"image":@"image3.jpg"
                    },@{
                        @"key":@"3",
                        @"title":@"哈士奇",
                        @"detail":@"二哈",
                        @"image":@"image4.jpg"
                    },@{
                        @"key":@"4",
                        @"title":@"老鼠",
                        @"detail":@"不是太和谐的样子",
                        @"image":@"image5.jpg"
                    }
                ] mutableCopy];
    //加载数据后，默认第3个typeCell被点亮，如果不存在，取第一个
    NSDictionary *dict = [_dataSource firstObject];
    NSInteger dataIndex = 0;
    NSInteger cellIndex = dataIndex + 1;
    if(_dataSource.count > 2){
        dataIndex = 2;
        dict = _dataSource[dataIndex];
        cellIndex = dataIndex + 1;
    }
    _currentKey = dict[@"key"];
    _currentIndexPath = [NSIndexPath indexPathForRow:cellIndex inSection:0];
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointMake(0, dataIndex * typeCellHeight)];
}

#pragma mark - delegate

#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0 || indexPath.row > self.dataSource.count){
        static NSString * const cellID = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }else{
        XBSlidItemTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:typeCellID];
        NSDictionary *dict = _dataSource[indexPath.row - 1];
        cell.zhLabel.text = dict[@"title"];
        cell.enLabel.text = dict[@"detail"];
        cell.imageView.image = [UIImage imageNamed:dict[@"image"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark -UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0 || indexPath.row > self.dataSource.count){
        return (_tableViewH - typeCellHeight) / 2;
    }else{
        return typeCellHeight;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    XBSlidItemTypeCell *cell = [self.tableView cellForRowAtIndexPath:_currentIndexPath];
    if([cell isKindOfClass:[XBSlidItemTypeCell class]]){
        cell.zhLabel.textColor = COLOR(146, 146, 146, 100);
    }
    NSInteger cellIndex = [self getCurrentDataIndex] + 1;
    _currentIndexPath = [NSIndexPath indexPathForRow:cellIndex inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:_currentIndexPath];
    if([cell isKindOfClass:[XBSlidItemTypeCell class]]){
        cell.zhLabel.textColor = [UIColor blackColor];
    }
}

#pragma mark -手指触摸松开后不再滚动

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
        [self autoSetContent];
    }
}

#pragma mark -手指触摸松开后还在滚动的处理

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self autoSetContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - action

-(void)autoSetContent{
    NSInteger dataIndex = [self getCurrentDataIndex];
    
    NSInteger cellIndex = dataIndex + 1;
    _currentIndexPath = [NSIndexPath indexPathForRow:cellIndex inSection:0];
    [self.tableView setContentOffset:CGPointMake(0, dataIndex * typeCellHeight)];
    NSDictionary *dict = _dataSource[dataIndex];
    _currentKey = dict[@"key"];
}

#pragma mark -获取dataSource当前要显示的索引

-(NSInteger)getCurrentDataIndex{
    NSInteger dataIndex;
    CGFloat offsetY = self.tableView.contentOffset.y;
    if(offsetY <= typeCellHalfHeight){
        //偏移量在[0,typeCellHeight / 2]之间的都是属于第一个typeCell被点亮
        dataIndex = 0;
    }else if(offsetY >= (self.dataSource.count - 1) * typeCellHeight - (typeCellHalfHeight-1)){
        dataIndex = self.dataSource.count - 1;
    }else{
        //其他情况
        CGFloat temp = (offsetY - typeCellHalfHeight) / typeCellHeight;
        dataIndex = ceil(temp);
    }
    return dataIndex;
}


@end
