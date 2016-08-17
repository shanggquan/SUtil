//
//  UIUtil.m
//  SUtilDemo
//
//  Created by User01 on 16/8/17.
//  Copyright © 2016年 Spring. All rights reserved.
//

#import "SUtil.h"
#import <CoreLocation/CoreLocation.h>
#import <CommonCrypto/CommonDigest.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "sys/utsname.h"

@implementation SUtil

+ (UIImageView *)ProcessCircleImageView:(UIImageView *)imageView{
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = imageView.frame.size.width*0.5;
    
    return imageView;
}

+ (UIImageView *)ProcessCircleImageView:(UIImageView *)imageView Radius:(CGFloat)radius{
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = radius;
    return imageView;
}
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}
+ (void)saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath{
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        //ALog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", imageName, @""]] options:NSAtomicWrite error:nil];
    }
}

+ (BOOL)getIsCanLocation{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        NSLog(@"请打开您的位置服务!");
        return NO;
    }else{
        NSLog(@"已经打开位置服务!");
        return YES;
        
    }
}

+ (void)hiddenAllKeyboard{
    [[[UIApplication sharedApplication] keyWindow]endEditing:NO];
}
+ (void)viewAddHiddenKeyboard:(UIView *)view{
    [view setUserInteractionEnabled:YES];
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenAllKeyboard)];
    [view addGestureRecognizer:tapGesture];
}

+ (void)createActivityView:(UIView *)view{
    
    [view setUserInteractionEnabled:NO];
    
    UIView * activityView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 80)];
    [activityView setBackgroundColor:[UIColor blackColor]];
    [activityView setCenter:CGPointMake(view.frame.size.width * 0.5, view.frame.size.height * 0.5)];
    [activityView setAlpha:0.3];
    [activityView setTag:102030];
    activityView.layer.cornerRadius = 10;
    
    UIActivityIndicatorView *_activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];    //创建一个UIActivityIndicatorView对象：_activityIndicatorView，并初始化风格。
    //    _activityIndicatorView.frame = CGRectMake(160, 230, 0, 0);
    [_activityIndicatorView setCenter:CGPointMake(activityView.frame.size.width * 0.5, activityView.frame.size.height * 0.5)];    //设置对象的位置，大小是固定不变的。WhiteLarge为37 * 37，White为20 * 20
    _activityIndicatorView.color = [UIColor whiteColor];    //设置活动指示器的颜色
    _activityIndicatorView.hidesWhenStopped = NO;    //hidesWhenStopped默认为YES，会隐藏活动指示器。要改为NO
    [activityView addSubview:_activityIndicatorView];//将对象加入到view
    [_activityIndicatorView startAnimating];//开始动画
    [view addSubview:activityView];
    [view bringSubviewToFront:activityView];
}
+ (void)removeActivityView:(UIView *)view{
    [view setUserInteractionEnabled:YES];
    [[view viewWithTag:102030] removeFromSuperview];
}


+ (NSString *)getUUID{
    NSString * uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
    if (!uuid || [uuid isEqualToString:@""]) {
        
        CFUUIDRef puuid = CFUUIDCreate(nil);
        CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
        NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
        CFRelease(puuid);
        CFRelease(uuidString);
        
        
        uuid = [result stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:@"uuid"];
    }
    return uuid;
}

//iCloud 防止备份
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSString *)fileURL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: fileURL]);
    
    NSURL * URL = [NSURL fileURLWithPath:fileURL];
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

+ (BOOL)removeDirectoryWithPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL res=[fileManager removeItemAtPath:path error:nil];
    if (res) {
        //NSLog(@"文件删除成功");
        return YES;
    }else{
        return NO;
    }
}

+ (UIImage *)createQRcodeWithString:(NSString *)string withSize:(CGFloat)size
{
    //1.实例化一个滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //1.1>设置filter的默认值
    //因为之前如果使用过滤镜，输入有可能会被保留，因此，在使用滤镜之前，最好恢复默认设置
    [filter setDefaults];
    
    //2将传入的字符串转换为NSData
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    //3.将NSData传递给滤镜（通过KVC的方式，设置inputMessage）
    [filter setValue:data forKey:@"inputMessage"];
    // 误差矫正水平
    [filter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    //4.由filter输出图像
    CIImage *outputImage = [filter outputImage];
    
    //5.将CIImage转换为UIImage
    CGRect extent = CGRectIntegral(outputImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:outputImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    UIImage *image = [UIImage imageWithCGImage:scaledImage];
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    CGImageRelease(scaledImage);
    CGColorSpaceRelease(cs);
    
    return image;
}
+ (void)callPhoneNumberView:(UIView *)view PhoneNumber:(NSString *)phoneNumber{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNumber];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [view addSubview:callWebview];
}

+ (void)setWebViewAboutBlank:(UIWebView *)webView{
    NSURL* url = [NSURL URLWithString:@"about:blank"];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [webView loadRequest:request];
}




+ (NSString*)getUserDeviceModel
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini";
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    
    
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    
    return deviceString;
    
}

#pragma mark - Date - 
//得到日期对应的星期
+ (NSString *)getWeekFromDate:(NSDate *)date{
    NSArray * arrWeek=[NSArray arrayWithObjects:[NSNull null],@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitWeekday |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger week = [comps weekday];
    //    int year=[comps year];
    //    int month = [comps month];
    //    int day = [comps day];
    return [arrWeek objectAtIndex:week];
    //    m_labDate.text=[NSString stringWithFormat:@"%d年%d月",year,month];
    //    m_labToday.text=[NSString stringWithFormat:@"%d",day];
    //    m_labWeek.text=[NSString stringWithFormat:@"%@",[arrWeek objectAtIndex:week]];
}

//根据日期来计算年龄
+ (NSString*)getAgeFromDate:(NSDate*)date{
    if (!date) {
        return nil;
    }
    NSDate *myDate = date;
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitYear;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:myDate toDate:nowDate options:0];
    NSInteger year = [comps year];
    return [NSString stringWithFormat:@"%ld",(long)year];
}
//时间戳变为时间
+ (NSString *)timeIntervalToTimeString:(NSString *)timeInterval WithFormat:(NSString *)format{
    NSTimeInterval interval = [timeInterval longLongValue];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:format];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
    
    
}
//NSDate Format
+ (NSString *)dateToTimeString:(NSDate *)date WithFormat:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *strDate = [dateFormatter stringFromDate:date];
    //    NSLog(@"%@", strDate);
    return strDate;
}

////根据日期来得到年月日
//+ (NSString *)getMonthAndDayFromDate:(NSDate *)date{
//    NSCalendar*calendar = [NSCalendar currentCalendar];
//    NSDateComponents*comps;
//    
//    // 年月日获得
//    comps =[calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay)
//                       fromDate:date];
//    NSInteger year = [comps year];
//    NSInteger month = [comps month];
//    NSInteger day = [comps day];
//    //    NSLog(@"year:%d month: %d, day: %d", year, month, day);
//    NSString * dateStr = [NSString stringWithFormat:@"%ld年%ld月%ld日",(long)year,(long)month,(long)day];
//    return dateStr;
//}
////根据日期来得到时分秒
//+ (NSString *)getTimeFromDate:(NSDate *)date{
//    NSCalendar*calendar = [NSCalendar currentCalendar];
//    NSDateComponents*comps;
//    
//    //当前的时分秒获得
//    comps =[calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond)
//                       fromDate:date];
//    NSInteger hour = [comps hour];
//    NSInteger minute = [comps minute];
//    //    NSInteger second = [comps second];
//    //    NSLog(@"hour:%d minute: %d second: %d", hour, minute, second);
//    NSString * timeStr = [NSString stringWithFormat:@"%ld:%0ld",(long)hour,(long)minute];
//    if (minute<10) {
//        timeStr = [NSString stringWithFormat:@"%ld:0%ld",(long)hour,(long)minute];
//    }
//    return timeStr;
//    
//}


+ (NSString *)removeHTML:(NSString *)html {
    if ([[NSNull null] isEqual:html]) {
        return @"";
    }
    NSString *text = nil;
    
    
    //去空格
    
    html = [html stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    //</p> 换\n
    html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<p>"] withString:@""];
    html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"</p>"] withString:@""];
    html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"&nbsp;"] withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"\n\n\n" withString:@"\n\n"];
    
    
    NSScanner * theScanner2 = [NSScanner scannerWithString:html];
    while ([theScanner2 isAtEnd] == NO) {
        // find start of tag
        [theScanner2 scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner2 scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
        
    }
    
    return html;
}


+ (NSString *)creatMD5Secret:(NSString *)str
{
    
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+(NSString*)getFileMD5WithPath:(NSString*)path
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if( handle== nil ) {
        return nil;
    }
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    while(!done)
    {
        NSData* fileData = [handle readDataOfLength: 256 ];
        CC_MD5_Update(&md5, [fileData bytes], (int)[fileData length]);
        if( [fileData length] == 0 ) done = YES;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    
    return s;
}
+ (void)LogDic:(NSDictionary *)object{
    NSMutableString * logString = [[NSMutableString alloc]init];
    [logString appendString:@"\n{\n"];
    for (NSString *key in [object allKeys]) {
        NSString * string = [NSString stringWithFormat:@"%@ = %@;\n",key, [object objectForKey:key]];
        [logString appendString:string];
    }
    [logString appendString:@"}\n"];
    //    DLog(@"%@",logString);
}

+ (NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        //        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    //    NSLog(@"%@",jsonString);
    return jsonString;
}
+ (void)LogData:(id)object{
    [self DataTOjsonString:object];
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
        
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/**
 *截图功能
 */
+ (UIImage *)screenShot:(UIView *)view{
    CGSize viewSize = view.frame.size;
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat width = viewSize.width * scale;
    CGFloat height = viewSize.height * scale;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), YES, 0);
    
    //设置截屏大小
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGImageRef imageRef = viewImage.CGImage;
    CGRect rect = CGRectMake(0, 0, width, height);//这里可以设置想要截图的区域
    
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    
    
    //以下为图片保存代码
    UIImageWriteToSavedPhotosAlbum(sendImage, nil, nil, nil);//保存图片到照片库
    
    NSData *imageViewData = UIImagePNGRepresentation(sendImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pictureName= @"screenShow.png";
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:pictureName];
    [imageViewData writeToFile:savedImagePath atomically:YES];//保存照片到沙盒目录
    
    CGImageRelease(imageRefRect);
    
    //从手机本地加载图片
    
    UIImage *bgImage2 = [[UIImage alloc]initWithContentsOfFile:savedImagePath];
    return bgImage2;
    
}


/**
 *截图
 */
+ (UIImage *)screenShotScrollView:(UIScrollView *)scrollView{
    UIImage* image = nil;
    UIGraphicsBeginImageContext(scrollView.contentSize);
    
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        scrollView.contentOffset = CGPointZero;
        
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        NSLog(@"截图成功!");
        return image;
    }else{
        return nil;
    }
}


@end
