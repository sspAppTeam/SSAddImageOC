//
//  SSViewController.m
//  SSAddImage
//
//  Created by SSPSource on 12/14/2019.
//  Copyright (c) 2019 SSPSource. All rights reserved.
//

#import "SSViewController.h"
#import "SSAddImage.h"
@interface SSViewController ()
@property(nonatomic,strong)UIButton *editBtn;
@property(nonatomic,strong)UIButton *addBtn;
@end

@implementation SSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
     UIImage *image1 = [UIImage imageNamed:@"trouble_select"];
     UIImage *image2 = [UIImage imageNamed:@"组织"];
     SSAddImage *cell=[[SSAddImage alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200)withImgs:@[image1,image2] withEditPhoto:NO];
        cell.backgroundColor=[UIColor greenColor];
 
        [self.view addSubview:cell];
    
    SSAddImage *cell1=[[SSAddImage alloc] initWithFrame:CGRectMake(0, 320, self.view.frame.size.width, 200)withImgs:@[image1,image2] withEditPhoto:YES];
           cell1.backgroundColor=[UIColor greenColor];
    
           [self.view addSubview:cell1];
}

-(UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn=[[UIButton alloc] init];
        [_addBtn setTitle:@"查看" forState:UIControlStateNormal];
        [_addBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(showPhoto) forControlEvents:UIControlEventTouchUpInside];

    }
    return _addBtn;
}
-(UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn=[[UIButton alloc] init];
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
 [_editBtn addTarget:self action:@selector(editPhoto) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
