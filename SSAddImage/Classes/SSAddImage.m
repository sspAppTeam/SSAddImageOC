//
//  SZAddImage.m
//  AFNetworking
//
//  Created by ssp on 2019/12/12.
//

#import "SSAddImage.h"
#import "XHPicView.h"
#define imageH 100 // 图片高度
 #define imageW 75 // 图片宽度
 #define kMaxColumn 3 // 每行显示数量
 #define MaxImageCount 9 // 最多显示图片个数
 #define deleImageWH 25 // 删除按钮的宽高
 #define kAdeleImage @"edit" // 删除按钮图片
 #define kAddImage @"edit" // 添加按钮图片

@interface SSAddImage()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
  {
      // 标识被编辑的按钮 -1 为添加新的按钮
      NSInteger editTag;
  }
  @end
 
  @implementation SSAddImage
-(instancetype)initWithFrame:(CGRect)frame withImgs:(NSArray *)imgs withEditPhoto:(BOOL)isEditPhoto{
    self = [super initWithFrame:frame];
    if (self) {
        self.images=[NSMutableArray arrayWithArray:imgs];
        self.isEditPhoto=isEditPhoto;
      
        if (self.isEditPhoto) {
            self.images=[NSMutableArray array];
            UIButton *btn = [self createButtonWithImage:kAddImage andSeletor:@selector(addNew:)];
                   [self addSubview:btn];
        }else{
            [self.images enumerateObjectsUsingBlock:^(UIImage* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *btn = [self createButtonWithImage:obj andSeletor:@selector(changeOld:)];
                                    [self insertSubview:btn atIndex:idx];
                                  
                                   if (self.subviews.count - 1 == MaxImageCount) {
                                        [[self.subviews lastObject] setHidden:YES];

                                    }
            }];
           
        }
        
     }
     return self;
}
//  - (id)initWithFrame:(CGRect)frame
//  {
//     self = [super initWithFrame:frame];
//     if (self) {
//         if (_isEditPhoto) {
//             UIButton *btn = [self createButtonWithImage:kAddImage andSeletor:@selector(addNew:)];
//                    [self addSubview:btn];
//         }else{
//             [self.images enumerateObjectsUsingBlock:^(UIImage* obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                 UIButton *btn = [self createButtonWithImage:obj andSeletor:@selector(changeOld:)];
//                                     [self insertSubview:btn atIndex:self.subviews.count - 1];
//
//                                    if (self.subviews.count - 1 == MaxImageCount) {
//                                         [[self.subviews lastObject] setHidden:YES];
//
//                                     }
//             }];
//
//         }
//
//      }
//      return self;
//  }
 
 
  // 添加新的控件
  - (void)addNew:(UIButton *)btn
  {
     // 标识为添加一个新的图片
 
      if (![self deleClose:btn]) {
         editTag = -1;
          [self callImagePicker];
      }
 
 
  }
 
  // 修改旧的控件
  - (void)changeOld:(UIButton *)btn
  {
//      显示大图

     XHPicView *picView = [[XHPicView alloc]initWithFrame:[UIScreen mainScreen].bounds withImgs:self.images withImgUrl:nil];
//             self.navigationController.navigationBar.hidden = YES;
             picView.eventBlock = ^(NSString *event){
//                 self.navigationController.navigationBar.hidden = NO;
             };
             [self.window addSubview:picView];
      
      return;
     // 标识为修改(tag为修改标识)
     if (![self deleClose:btn]) {
        editTag = btn.tag;
         [self callImagePicker];
      }
 }

  // 删除"删除按钮"
 - (BOOL)deleClose:(UIButton *)btn
 {
    if (btn.subviews.count == 2) {
          [[btn.subviews lastObject] removeFromSuperview];
         [self stop:btn];
          return YES;
      }
 
     return NO;
  }


- (UIImage *)getImageWithBoudleName:(NSString *)boudleName imgName:(NSString *)imgName {
NSBundle *bundle = [NSBundle bundleForClass:[self class]];
NSURL *url = [bundle URLForResource:boudleName withExtension:@"bundle"];
NSBundle *targetBundle = [NSBundle bundleWithURL:url];
UIImage *image = [UIImage imageNamed:imgName
                            inBundle:targetBundle
       compatibleWithTraitCollection:nil];
return image;
}
 // 调用图片选择器
  - (void)callImagePicker
  {
      UIImagePickerController *pc = [[UIImagePickerController alloc] init];
      pc.allowsEditing = YES;
      pc.delegate = self;
      [self.window.rootViewController presentViewController:pc animated:YES completion:nil];
      return;

      UIImage *image = [self getImageWithBoudleName:@"SSAddImage" imgName:@"edit"];
      if (editTag == -1) {
              // 创建一个新的控件
              UIButton *btn = [self createButtonWithImage:image andSeletor:@selector(changeOld:)];
              [self insertSubview:btn atIndex:self.subviews.count - 1];
              [self.images addObject:image];
             if (self.subviews.count - 1 == MaxImageCount) {
                  [[self.subviews lastObject] setHidden:YES];

              }
          }
         else
          {
             // 根据tag修改需要编辑的控件
              UIButton *btn = (UIButton *)[self viewWithTag:editTag];
             int index = [self.images indexOfObject:[btn imageForState:UIControlStateNormal]];
             [self.images removeObjectAtIndex:index];
              [btn setImage:image forState:UIControlStateNormal];
             [self.images insertObject:image atIndex:index];
          }
 }
 
 // 根据图片名称或者图片创建一个新的显示控件
 - (UIButton *)createButtonWithImage:(id)imageNameOrImage andSeletor : (SEL)selector
  {
      UIImage *addImage = nil;
      if ([imageNameOrImage isKindOfClass:[NSString class]]) {
        addImage = [UIImage imageNamed:imageNameOrImage];
      }
    else if([imageNameOrImage isKindOfClass:[UIImage class]])
    {
        addImage = imageNameOrImage;
     }
     UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     [addBtn setImage:addImage forState:UIControlStateNormal];
      [addBtn setBackgroundColor:[UIColor redColor]];
    [addBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
     addBtn.tag = self.subviews.count;
      if (self.isEditPhoto) {
            // 添加长按手势,用作删除.加号按钮不添加
               if(addBtn.tag != 0)
               {
          //     UILongPressGestureRecognizer *gester = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
          //    [addBtn addGestureRecognizer:gester];
                   
                   UIButton *dele = [UIButton buttonWithType:UIButtonTypeCustom];
                       dele.bounds = CGRectMake(0, 0, deleImageWH, deleImageWH);
                      [dele setImage:[UIImage imageNamed:kAdeleImage] forState:UIControlStateNormal];
                       [dele addTarget:self action:@selector(deletePic:) forControlEvents:UIControlEventTouchUpInside];
                       dele.frame = CGRectMake(imageW - dele.frame.size.width, 0, dele.frame.size.width, dele.frame.size.height);
                          [dele setBackgroundColor:[UIColor purpleColor]];
                       [addBtn addSubview:dele];
                   
               }
      }

   
     return addBtn;

 }




 // 删除图片
 - (void)deletePic : (UIButton *)btn
 {
    [self.images removeObject:[(UIButton *)btn.superview imageForState:UIControlStateNormal]];
     [btn.superview removeFromSuperview];
    if ([[self.subviews lastObject] isHidden]) {
        [[self.subviews lastObject] setHidden:NO];
     }


 }

 // 对所有子控件进行布局
- (void)layoutSubviews
 {
     [super layoutSubviews];
     int count = self.subviews.count;
     CGFloat btnW = imageW;
    CGFloat btnH = imageH;
    int maxColumn = kMaxColumn > self.frame.size.width / imageW ? self.frame.size.width / imageW : kMaxColumn;
     CGFloat marginX = (self.frame.size.width - maxColumn * btnW) / (count + 1);
     CGFloat marginY = marginX;
    for (int i = 0; i < count; i++) {
         UIButton *btn = self.subviews[i];
         CGFloat btnX = (i % maxColumn) * (marginX + btnW) + marginX;
         CGFloat btnY = (i / maxColumn) * (marginY + btnH) + marginY;
         btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
     }

 }

 #pragma mark - UIImagePickerController 代理方法
 -(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
 {
    UIImage *image = info[UIImagePickerControllerEditedImage];
     if (editTag == -1) {
         // 创建一个新的控件
         UIButton *btn = [self createButtonWithImage:image andSeletor:@selector(changeOld:)];
         [self insertSubview:btn atIndex:self.subviews.count - 1];
         [self.images addObject:image];
        if (self.subviews.count - 1 == MaxImageCount) {
             [[self.subviews lastObject] setHidden:YES];

         }
     }
    else
     {
        // 根据tag修改需要编辑的控件
         UIButton *btn = (UIButton *)[self viewWithTag:editTag];
        int index = [self.images indexOfObject:[btn imageForState:UIControlStateNormal]];
        [self.images removeObjectAtIndex:index];
         [btn setImage:image forState:UIControlStateNormal];
        [self.images insertObject:image atIndex:index];
     }
    // 退出图片选择控制器
     [picker dismissViewControllerAnimated:YES completion:nil];
 }

 // 长按添加删除按钮
- (void)longPress : (UIGestureRecognizer *)gester
{
     if (gester.state == UIGestureRecognizerStateBegan)
    {
    UIButton *btn = (UIButton *)gester.view;

     UIButton *dele = [UIButton buttonWithType:UIButtonTypeCustom];
     dele.bounds = CGRectMake(0, 0, deleImageWH, deleImageWH);
    [dele setImage:[UIImage imageNamed:kAdeleImage] forState:UIControlStateNormal];
     [dele addTarget:self action:@selector(deletePic:) forControlEvents:UIControlEventTouchUpInside];
     dele.frame = CGRectMake(btn.frame.size.width - dele.frame.size.width, 0, dele.frame.size.width, dele.frame.size.height);
        [dele setBackgroundColor:[UIColor purpleColor]];
     [btn addSubview:dele];
     [self start : btn];


     }

 }

 // 长按开始抖动
 - (void)start : (UIButton *)btn {
     double angle1 = -5.0 / 180.0 * M_PI;
     double angle2 = 5.0 / 180.0 * M_PI;
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
     anim.keyPath = @"transform.rotation";

    anim.values = @[@(angle1),  @(angle2), @(angle1)];
     anim.duration = 0.25;
     // 动画的重复执行次数
     anim.repeatCount = MAXFLOAT;

     // 保持动画执行完毕后的状态
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;

    [btn.layer addAnimation:anim forKey:@"shake"];
}

// 停止抖动
 - (void)stop : (UIButton *)btn{
     [btn.layer removeAnimationForKey:@"shake"];
 }
#pragma mark - 上传图片

#pragma mark - 属性
-(void)setIsEditPhoto:(BOOL)isEditPhoto{
    _isEditPhoto=isEditPhoto;
}
-(void)setLimitNumber:(NSInteger)limitNumber{
    _limitNumber=limitNumber;
}
-(void)setImages:(NSMutableArray *)images{
    _images=images;
}

 @end
