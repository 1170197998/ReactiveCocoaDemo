//
//  ViewController.m
//  RAC
//
//  Created by ShaoFeng on 2017/2/13.
//  Copyright © 2017年 ShaoFeng. All rights reserved.
//  http://www.cnblogs.com/fengmin/p/5662270.html  概念多
//  http://blog.leichunfeng.com/blog/2015/12/25/reactivecocoa-v2-dot-5-yuan-ma-jie-xi-zhi-jia-gou-zong-lan/ //雷纯锋_全面
//  http://www.jianshu.com/p/05544e4ac972        各种使用
//  https://my.oschina.net/u/2346786/blog/614316 各种使用
//  http://www.jianshu.com/p/ff79a5ae0353 - > http://www.jianshu.com/p/aa155560bfed 用法全
//  http://www.cocoachina.com/ios/20160729/17236.html API手册

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (nonatomic,strong)RACCommand *commend;
@property (nonatomic,strong)NSString *string;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //RAC通过引入信号（Signal）的概念，来代替传统iOS开发中对于控件状态变化检查的代理（delegate）模式或target-action模式。因为RAC的信号是可以组合（combine）的，所以可以轻松地构造出另一个新的信号出来
    
    //RACSubscriber:表示订阅者的意思，用于发送信号，这是一个协议，不是一个类，只要遵守这个协议，并且实现方法才能成为订阅者。通过create创建的信号，都有一个订阅者，帮助他发送数据。
    //RACDisposable:用于取消订阅或者清理资源，当信号发送完成或者发送错误的时候，就会自动触发它。
    //RACSubject:RACSubject:信号提供者，自己可以充当信号，又能发送信号。
    //RACReplaySubject:重复提供信号类，RACSubject的子类。
    /*
    RACReplaySubject与RACSubject区别:
    RACReplaySubject可以先发送信号，在订阅信号，RACSubject就不可以。
    使用场景一:如果一个信号每被订阅一次，就需要把之前的值重复发送一遍，使用重复提供信号类。
    使用场景二:可以设置capacity数量来限制缓存的value的数量,即只缓充最新的几个值。
    */
    
    //[self test4];
    
    [RACObserve(self, string) subscribeNext:^(NSString *string) {
        NSLog(@"%@",string);
    }];
}

- (void)test1
{
    //遍历数组
    NSArray *array = @[@1,@3,@55,@76,@56,@45];
    
    // 第一步: 把数组转换成集合RACSequence array.rac_sequence
    // 第二步: 把集合RACSequence转换RACSignal信号类,array.rac_sequence.signal
    // 第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。
    [array.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    //遍历字典
    NSDictionary *dict = @{@"name":@"stevin",@"location":@"Beijing"};
    //RACTuple:元组类,类似NSArray,用来包装值.
    //RACSequence:RAC中的集合类，用于代替NSArray,NSDictionary,可以使用它来快速遍历数组和字典。
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        //解包元组，会把元组的值，按顺序给参数里面的变量赋值
        RACTupleUnpack(NSString *key, NSString *value) = x;
        NSLog(@"%@--%@",key,value);
    }];
}

- (void)test2
{
    //TextField使用
    [self.userName.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"输入了:%@",x);
    }];
    [[self.userName.rac_textSignal filter:^BOOL(id value) {
        NSString *text = value;
        return text.length > 3;
    }] subscribeNext:^(id x) {
        NSLog(@"输入长度大于3的内容:%@",x);
    }];
}

- (void)test3
{
    //按钮点击事件
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"rac_signalForControlEvents检测点击");
    }];
    self.button.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"rac_command检测点击");
        return [RACSignal empty];
    }];
}

- (void)test4
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        NSLog(@"点击了label");
    }];
    self.testLabel.userInteractionEnabled = YES;
    [self.testLabel addGestureRecognizer:tap];
}

- (IBAction)changeValue:(id)sender {
    self.string = [NSString stringWithFormat:@"哈哈%d",rand() % 100];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
