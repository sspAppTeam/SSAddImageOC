//
//  SZAddImage.h
//  AFNetworking
//
//  Created by ssp on 2019/12/12.
//

#import <UIKit/UIKit.h>
// 需求：
// 1.点击图片，放大图片
// 2.图片自动排列
// 3.删除自动排版
// 4.支持修改，编辑

NS_ASSUME_NONNULL_BEGIN
/**
  * 使用说明:直接创建此view添加到你需要放置的位置即可.
 * 属性images可以获取到当前选中的所有图片对象.
  */
@interface SSAddImage : UIView
 /**
  *  存储所有的照片(UIImage)
  */
 @property (nonatomic, strong) NSMutableArray *images;
//是否支持增加和删除
@property(nonatomic,assign)BOOL isEditPhoto;
//最多支持照片数目
@property(nonatomic,assign)NSInteger limitNumber;
-(instancetype)initWithFrame:(CGRect)frame withImgs:(NSArray *)imgs withEditPhoto:(BOOL)isEditPhoto;
@end

NS_ASSUME_NONNULL_END
