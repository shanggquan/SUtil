//
//  UIUtil.h
//  SUtilDemo
//
//  Created by User01 on 16/8/17.
//  Copyright © 2016年 Spring. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@interface SUtil : NSObject
/**
 *  UIImageView切圆形
 *
 *  @param imageView 切圆形前的View
 *
 *  @return 切圆形后的View
 */
+ (UIImageView *)ProcessCircleImageView:(UIImageView *)imageView;
/**
 *  UIImageView切圆角
 *
 *  @param imageView 切圆角前的View
 *  @param radius    圆角的角度
 *
 *  @return 切圆形后的View
 */
+ (UIImageView *)ProcessCircleImageView:(UIImageView *)imageView Radius:(CGFloat)radius;
/**
 *  改变图片的大小
 *
 *  @param img  图片
 *  @param size 改变后的大小
 *
 *  @return 图片
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
/**
 *  保存图片
 *
 *  @param image         图片
 *  @param imageNameed   图片名称
 *  @param extension     图片扩展名
 *  @param directoryPath 图片保存路径
 */
+ (void)saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;

/**
 *  查看当前应用是否可以访问地理位置
 *
 *  @return YES/NO YES是可以访问 NO不可以访问
 */
+ (BOOL)getIsCanLocation;

/**
 *  隐藏键盘
 */
+ (void)hiddenAllKeyboard;
/**
 *  给一个View加隐藏键盘事件
 *
 *  @param view 需要加事件的View
 */
+ (void)viewAddHiddenKeyboard:(UIView *)view;

/**
 *  在View的中心上加一个loading 与下面的移除loading组合使用
 *
 *  @param view 要加loading的View
 */
+ (void)createActivityView:(UIView *)view;
/**
 *  移除View的loading 与上面的添加loading组合使用
 *
 *  @param view 要移除loading的View
 */
+ (void)removeActivityView:(UIView *)view;

/**
 *  得到当前应用的UUID
 *
 *  @return UUID
 */
+ (NSString *)getUUID;

/**
 *  iCloud 防止备份
 *
 *  @param fileURL 防止备份的文件或文件夹的path
 *
 *  @return 是否防止成功
 */
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSString *)fileURL;
/**
 *  删除一个文件或文件夹
 *
 *  @param path 文件或文件夹所在目录
 *
 *  @return 是否删除成功
 */
+ (BOOL)removeDirectoryWithPath:(NSString *)path;
/**
 *  生成二维码
 *
 *  @param string 生成二维码的原字符串
 *  @param size   二维码的size
 *
 *  @return 二维码图片
 */
+ (UIImage *)createQRcodeWithString:(NSString *)string withSize:(CGFloat)size;
/**
 *  打电话
 *
 *  @param view        所依托的view
 *  @param phoneNumber 电话号码
 */
+ (void)callPhoneNumberView:(UIView *)view PhoneNumber:(NSString *)phoneNumber;
/**
 *  将UIWebView置成空白页用来释放内存
 *
 *  @param webView UIWebView
 */
+ (void)setWebViewAboutBlank:(UIWebView *)webView;
/**
 *  得到用户手机的型号 例 "iPhone 6" "iPhone 6 Plus"
 *
 *  @return 手机型号
 */
+ (NSString*)getUserDeviceModel;

#pragma mark - Date -
/**
 *  得到日期对应的星期
 *
 *  @param date 日期
 *
 *  @return 星期几
 */
+ (NSString *)getWeekFromDate:(NSDate *)date;
/**
 *  根据日期来计算年龄
 *
 *  @param date 日期
 *
 *  @return 年龄
 */
+ (NSString *)getAgeFromDate:(NSDate *)date;
/**
 *  时间戳变为时间
 *
 *  @param timeInterval 时间戳
 *  @param format       时间格式
 *
 *  @return 格式化后的时间戳
 */
+ (NSString *)timeIntervalToTimeString:(NSString *)timeInterval WithFormat:(NSString *)format;
/**
 *  时间格式化
 *
 *  @param date   时间
 *  @param format 时间格式
 *
 *  @return 格式化后的时间
 */
+ (NSString *)dateToTimeString:(NSDate *)date WithFormat:(NSString *)format;
/**
 *  删除html字符串里的html标签
 *
 *  @param html html字符串
 *
 *  @return 删除html标签后的字符串
 */
+ (NSString *)removeHTML:(NSString *)html;
/**
 *  字符串MD5加密
 *
 *  @param str 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (NSString *)creatMD5Secret:(NSString *)str;
/**
 *  获取文件的MD5码 -- 多用于文件完整度校对
 *
 *  @param path 文件路径
 *
 *  @return 文件的MD5码
 */
+ (NSString*)getFileMD5WithPath:(NSString*)path;
/**
 *  打印字典
 *
 *  @param object 字典
 */
+ (void)LogDic:(NSDictionary *)object;

/**
 *  截图功能
 *
 *  @param view 截图的View
 *
 *  @return 截图
 */
+ (UIImage *)screenShot:(UIView *)view;

/**
 *  截图功能
 *
 *  @param scrollView 截图的scrollView UIScrollView截屏（一屏无法显示完整）
 *
 *  @return 截图
 */
+ (UIImage *)screenShotScrollView:(UIScrollView *)scrollView;
@end
