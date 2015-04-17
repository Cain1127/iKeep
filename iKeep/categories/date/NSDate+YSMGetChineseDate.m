//
//  NSDate+YSMGetChineseDate.m
//  XMPPFrameworkUseDemo
//
//  Created by ysmeng on 14/10/29.
//  Copyright (c) 2014年 zhang jian. All rights reserved.
//

#import "NSDate+YSMGetChineseDate.h"

@implementation NSDate (YSMGetChineseDate)

//*************************************
//      取当前日期的农历信息
//*************************************
#pragma mark - 取给当天日期的农历信息
+ (NSString *)getChineseYear
{
    return [self getChineseYear:[self getCurrentDate]];
}

+ (NSString *)getChineseMonth
{
    return [self getChineseMonth:[self getCurrentDate]];
}

+ (NSString *)getChineseDate
{
    return [self getChineseDate:[self getCurrentDate]];
}

+ (NSString *)getChineseJieqi
{
    return [self getChineseJieqi:[self getCurrentDate]];
}

+ (NSString *)getChineseFestivals
{
    return [self getChineseFestivals:[self getCurrentDate]];
}

+ (NSDictionary *)getChineseCalenderInfo
{
    return [self getChineseCalenderInfo:[self getCurrentDate]];
}

+ (NSDate *)getCurrentDate
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit
                                    | NSMonthCalendarUnit
                                    | NSDayCalendarUnit
                                               fromDate:now];
    
    NSDate *currentDate = [calendar dateFromComponents:components];
    return currentDate;
}

+ (NSString *)getCurrentDateString
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
    dateFormate.dateFormat = @"YYYYMMdd";
    NSString *currentDateString = [dateFormate stringFromDate:date];
    return currentDateString;
}

+ (NSDate *)getCurrentDateTime
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:(8 * 60 * 60)];
//    NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
//    dateFormate.dateFormat = @"YYYY-MM-dd HH:mm:ss";
//    NSString *currentDateString = [dateFormate stringFromDate:date];
//    NSDate *currentDateTime = [dateFormate dateFromString:currentDateString];
    return date;
}

+ (NSString *)getCurrentDateTimeString
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
    dateFormate.dateFormat = @"YYYYMMdd HH:mm:ss";
    NSString *currentTimeString = [dateFormate stringFromDate:date];
    return currentTimeString;
}

//*************************************
//      取给定新历日期的农历信息
//*************************************
#pragma mark - 取给定新历日期的农历信息
+ (NSString *)getChineseYear:(NSDate *)date
{
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
                             @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
                             @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
                             @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
                             @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
                             @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];

    return y_str;
}

+ (NSString *)getChineseMonth:(NSDate *)date
{
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    
    return m_str;
}

+ (NSString *)getChineseDate:(NSDate *)date
{
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    
    return d_str;
}

+ (NSString *)getChineseJieqi:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"mm@dd";
    
    NSString *dateString = [dateFormat stringFromDate:date];
    NSArray *dateArray = [dateString componentsSeparatedByString:@"@"];
    
    NSInteger monthNum = [dateArray[0] integerValue];
    NSInteger dateNum = [dateArray[1] integerValue];
    
    switch (monthNum) {
        case 1:
            if (dateNum >= 5 && dateNum <= 7) {
                return @"小寒";
            }
            
            if (dateNum >= 20 && dateNum <= 21) {
                return @"大寒";
            }
            break;
            
        case 2:
            if (dateNum >= 3 && dateNum <= 5) {
                return @"立春";
            }
            
            if (dateNum >= 18 && dateNum <= 20) {
                return @"雨水";
            }
            break;
            
        case 3:
            if (dateNum >= 5 && dateNum <= 7) {
                return @"惊蛰";
            }
            
            if (dateNum >= 20 && dateNum <= 22) {
                return @"春分";
            }
            break;
            
        case 4:
            if (dateNum >= 4 && dateNum <= 6) {
                return @"清明";
            }
            
            if (dateNum >= 19 && dateNum <= 21) {
                return @"谷雨";
            }
            break;
            
        case 5:
            if (dateNum >= 5 && dateNum <= 7) {
                return @"立夏";
            }
            
            if (dateNum >= 20 && dateNum <= 22) {
                return @"小满";
            }
            break;
            
        case 6:
            if (dateNum >= 5 && dateNum <= 7) {
                return @"芒种";
            }
            
            if (dateNum >= 21 && dateNum <= 22) {
                return @"夏至";
            }
            break;
            
        case 7:
            if (dateNum >= 6 && dateNum <= 8) {
                return @"小署";
            }
            
            if (dateNum >= 22 && dateNum <= 24) {
                return @"大署";
            }
            break;
            
        case 8:
            if (dateNum >= 7 && dateNum <= 9) {
                return @"立秋";
            }
            
            if (dateNum >= 22 && dateNum <= 24) {
                return @"处署";
            }
            break;
            
        case 9:
            if (dateNum >= 7 && dateNum <= 9) {
                return @"白露";
            }
            
            if (dateNum >= 22 && dateNum <= 24) {
                return @"秋分";
            }
            break;
            
        case 10:
            if (dateNum >= 8 && dateNum <= 9) {
                return @"寒露";
            }
            
            if (dateNum >= 23 && dateNum <= 24) {
                return @"霜降";
            }
            break;
            
        case 11:
            if (dateNum >= 7 && dateNum <= 8) {
                return @"立冬";
            }
            
            if (dateNum >= 22 && dateNum <= 23) {
                return @"小雪";
            }
            break;
            
        case 12:
            if (dateNum >= 6 && dateNum <= 8) {
                return @"大雪";
            }
            
            if (dateNum >= 21 && dateNum <= 23) {
                return @"冬至";
            }
            break;
    }
    
    return nil;
}

+ (NSString *)getChineseFestivals:(NSDate *)date
{
    NSTimeInterval timeInterval_day = 60.0f * 60.0f * 24.0f;
    
    NSDate *nextDay_date = [NSDate dateWithTimeInterval:timeInterval_day sinceDate:date];
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:nextDay_date];
    
    if ( 1 == localeComp.month && 1 == localeComp.day ) {
        
        return @"除夕";
    }
    
    NSDictionary *chineseHoliDay = [NSDictionary dictionaryWithObjectsAndKeys:
                                    
                                    @"春节", @"1-1",
                                    
                                    @"元宵", @"1-15",
                                    
                                    @"端午", @"5-5",
                                    
                                    @"七夕", @"7-7",
                                    
                                    @"中元", @"7-15",
                                    
                                    @"中秋", @"8-15",
                                    
                                    @"重阳", @"9-9",
                                    
                                    @"腊八", @"12-8",
                                    
                                    @"小年", @"12-24",
                                    
                                    nil];
    
    localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    NSString *key_str = [NSString stringWithFormat:@"%ld-%ld",(long)localeComp.month,(long)localeComp.day];
    
    return [chineseHoliDay objectForKey:key_str];
}

+ (NSDictionary *)getChineseCalenderInfo:(NSDate *)date
{
    NSString *y_str = [self getChineseYear:date];
    NSString *m_str = [self getChineseMonth:date];
    NSString *d_str = [self getChineseDate:date];
    NSString *j_str = [self getChineseJieqi:date];
    NSString *f_str = [self getChineseFestivals:date];
    
    NSMutableDictionary *dateInfo = [[NSMutableDictionary alloc] init];
    if (y_str) {
        [dateInfo setObject:y_str forKey:YSMCHINESEDATE_KEY_YEAR];
    }
    if (m_str) {
        [dateInfo setObject:m_str forKey:YSMCHINESEDATE_KEY_MONTH];
    }
    if (d_str) {
        [dateInfo setObject:d_str forKey:YSMCHINESEDATE_KEY_DATE];
    }
    if (j_str) {
        [dateInfo setObject:j_str forKey:YSMCHINESEDATE_KEY_JIEQI];
    }
    if (f_str) {
        [dateInfo setObject:f_str forKey:YSMCHINESEDATE_KEY_FESTIVAL];
    }
    
    NSDictionary *dateDicte = [NSDictionary dictionaryWithDictionary:dateInfo];
    
    return dateDicte;
}

@end
