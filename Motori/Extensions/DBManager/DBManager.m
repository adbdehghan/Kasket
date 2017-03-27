///
//  DBManager.h
//  Iran Weather
//
//  Created by aDb on 12/19/14.
//  Copyright (c) 2014 aDb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"


#define debugMethod(...) NSLog((@"In %s,%s [Line %d] "), __PRETTY_FUNCTION__,__FILE__,__LINE__,##__VA_ARGS__)
static FMDatabase *shareDataBase = nil;
@implementation DBManager


 

//+ (FMDatabase *)createDataBase {
//    //debugMethod();
//    @synchronized (self) {
//        if (shareDataBase == nil) {
//
//            shareDataBase = [[FMDatabase databaseWithPath:dataBasePath] retain];
//        }
//        return shareDataBase;
//    }
//}




+ (FMDatabase *)createDataBase {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareDataBase = [FMDatabase databaseWithPath:dataBasePath];
    });
    return shareDataBase;
}


+ (BOOL) isTableExist:(NSString *)tableName
{
    FMResultSet *rs = [shareDataBase executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        NSLog(@"%@ isOK %ld", tableName,(long)count);
        
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    
    return NO;
}


+ (BOOL)createTable {
 
    NSLog(@"%@",dataBasePath);
    if (1){
        {
            shareDataBase = [DBManager createDataBase];
            if ([shareDataBase open]) {
                if (![DBManager isTableExist:@"setting_table"]) {
                    NSString *sql = @"CREATE TABLE \"setting_table\" (\"setting_id\" TEXT PRIMARY KEY  NOT NULL , \"password\" TEXT NOT NULL, \"accesstoken\" TEXT NOT NULL)";
                    NSLog(@"no Medicine ");
                    [shareDataBase executeUpdate:sql];
                }
                [shareDataBase close];
            }
        }
    }
    return YES;
}

+ (BOOL)createSourceTable {
    
    NSLog(@"%@",dataBasePath);
    if (1){
        {
            shareDataBase = [DBManager createDataBase];
            if ([shareDataBase open]) {
                if (![DBManager isTableExist:@"SourceTable"]) {
                    NSString *sql = @"CREATE TABLE \"SourceTable\" (\"s_id\" INTEGER PRIMARY KEY  NOT NULL , \"SourceLat\" TEXT , \"SourceLon\" TEXT , \"SourceAddress\" TEXT , \"SourceBell\" TEXT , \"SourcePlate\" TEXT)";
                    NSLog(@"no Medicine ");
                    
                    [shareDataBase executeUpdate:sql];
                }
                [shareDataBase close];
            }
        }
    }
    return YES;
}

+ (BOOL) InsertToSourceTable:(DataCollector *)Data
{
    BOOL isOk = NO;
    shareDataBase = [DBManager createDataBase];
    if ([shareDataBase open]) {
        isOk = [shareDataBase executeUpdate:
                @"INSERT INTO \"SourceTable\" (\"SourceLat\",\"SourceLon\",\"SourceAddress\",\"SourceBell\",\"SourcePlate\") VALUES(?,?,?,?,?)",Data.sourceLat,Data.sourceLon,Data.sourceAddress,Data.sourceBell,Data.sourcePlate];
        [shareDataBase close];
    }
    return isOk;
}

+ (NSMutableArray*)selectSourceTable
{
    Source *m = nil;
    NSMutableArray *settingArray = [[NSMutableArray alloc]init];
    
    shareDataBase = [DBManager createDataBase];
    if ([shareDataBase open]) {
        FMResultSet *s = [shareDataBase executeQuery:@"SELECT * FROM \"SourceTable\""];
        while ([s next]) {
            m = [[Source alloc] init];
            m.sourceId = [s stringForColumn:@"s_id"];
            m.sourceLat = [s stringForColumn:@"SourceLat"];
            m.sourceLon = [s stringForColumn:@"SourceLon"];
            m.sourceAddress = [s stringForColumn:@"SourceAddress"];
            m.sourceBell = [s stringForColumn:@"SourceBell"];
            m.sourcePlate = [s stringForColumn:@"SourcePlate"];
            [settingArray addObject:m];
        }
        
        [shareDataBase close];
    }
    return settingArray;
}

+ (BOOL)createDestinationTable {
    
    NSLog(@"%@",dataBasePath);
    if (1){
        {
            shareDataBase = [DBManager createDataBase];
            if ([shareDataBase open]) {
                if (![DBManager isTableExist:@"DestinationTable"]) {
                    NSString *sql = @"CREATE TABLE \"DestinationTable\" (\"d_id\" INTEGER PRIMARY KEY NOT NULL , \"DestinationLat\" TEXT , \"DestinationLon\" TEXT , \"DestinationAddress\" TEXT , \"DestinationBell\" TEXT , \"DestinationPlate\" TEXT, \"DestinationPhoneNumber\" TEXT, \"DestinationFullname\" TEXT)";
                    NSLog(@"no Medicine ");
                    
                    [shareDataBase executeUpdate:sql];
                }
                [shareDataBase close];
            }
        }
    }
    return YES;
}

+ (BOOL)InsertToDestinationTable:(DataCollector *)Data
{
    BOOL isOk = NO;
    shareDataBase = [DBManager createDataBase];
    if ([shareDataBase open]) {
        isOk = [shareDataBase executeUpdate:
                @"INSERT INTO \"DestinationTable\" (\"DestinationLat\",\"DestinationLon\",\"DestinationAddress\",\"DestinationBell\",\"DestinationPlate\",\"DestinationPhoneNumber\",\"DestinationFullname\") VALUES(?,?,?,?,?,?,?)",Data.destinationLat,Data.destinationLon,Data.destinationAddress,Data.destinationBell,Data.destinationPlate,Data.destinationPhoneNumber,Data.destinationFullName];
        [shareDataBase close];
    }
    return isOk;
}

+ (NSMutableArray*)selectDestinationTable
{
    Destination *m = nil;
    NSMutableArray *settingArray = [[NSMutableArray alloc]init];
    
    shareDataBase = [DBManager createDataBase];
    if ([shareDataBase open]) {
        FMResultSet *s = [shareDataBase executeQuery:@"SELECT * FROM \"DestinationTable\""];
        while ([s next]) {
            m = [[Destination alloc] init];
            m.destinationId = [s stringForColumn:@"d_id"];
            m.destinationLat = [s stringForColumn:@"DestinationLat"];
            m.destinationLon = [s stringForColumn:@"DestinationLon"];
            m.destinationAddress = [s stringForColumn:@"DestinationAddress"];
            m.destinationBell = [s stringForColumn:@"DestinationBell"];
            m.destinationPlate = [s stringForColumn:@"DestinationPlate"];
            m.destinationPhoneNumber = [s stringForColumn:@"DestinationPhoneNumber"];
            m.destinationFullName = [s stringForColumn:@"DestinationFullname"];
            [settingArray addObject:m];
        }
        
        [shareDataBase close];
    }
    return settingArray;
}

+ (void)closeDataBase {
    if(![shareDataBase close]) {
        NSLog(@"connection Closed.");
        return;
    }
}

+ (void)deleteDataBase {
    
    shareDataBase = [DBManager createDataBase];
    if ([shareDataBase open]) {
        [shareDataBase executeUpdate:@"DROP TABLE \"setting_table\" "];
    }
    [shareDataBase close];}

+ (BOOL) saveOrUpdataSetting:(Settings *)Data
{
    BOOL isOk = NO;
    shareDataBase = [DBManager createDataBase];
    if ([shareDataBase open]) {
        isOk = [shareDataBase executeUpdate:
                @"INSERT INTO \"setting_table\" (\"setting_id\",\"password\",\"accesstoken\") VALUES(?,?,?)",Data.settingId,Data.password,Data.accesstoken];
        [shareDataBase close];
    }
    return isOk;
}

+ (Settings *) selectSettingBySettingId:(NSString*)SettingId
{
    Settings *m = nil;
    shareDataBase = [DBManager createDataBase];
    if ([shareDataBase open]) {
        FMResultSet *s = [shareDataBase executeQuery:[NSString stringWithFormat:@"SELECT * FROM \"setting_table\" WHERE \"setting_id\" = '%@'",SettingId]];
        if ([s next]) {
            m = [[Settings alloc] init];
            m.settingId = [s stringForColumn:@"setting_id"];
            m.password = [s stringForColumn:@"password"];
            m.accesstoken = [s stringForColumn:@"accesstoken"];
        }
        [shareDataBase close];
    }
    return m;
}

+(void) deleteRow:(NSString*)ObjId
{
    
    shareDataBase = [DBManager createDataBase];
    if ([shareDataBase open]) {
        [shareDataBase executeUpdate:[NSString stringWithFormat:@"DELETE FROM \"setting_table\" WHERE \"setting_id\"=%@",ObjId]];
    }
    [shareDataBase close];
}

+(void) deleteRow:(NSString*)ObjId FromTable:(NSString*)tableName
{
    
    if ([tableName isEqualToString:@"SourceTable"]) {
    
        shareDataBase = [DBManager createDataBase];
        if ([shareDataBase open]) {
            [shareDataBase executeUpdate:[NSString stringWithFormat:@"DELETE FROM \"SourceTable\" WHERE \"s_id\"=%@",ObjId]];
        }
        [shareDataBase close];
    }
    else
    {
        shareDataBase = [DBManager createDataBase];
        if ([shareDataBase open]) {
            [shareDataBase executeUpdate:[NSString stringWithFormat:@"DELETE FROM \"DestinationTable\" WHERE \"d_id\"=%@",ObjId]];
        }
        [shareDataBase close];
    }
    
}

+ (void)Updata:(Settings*)weatherData
{
        BOOL isOk = NO;
    shareDataBase = [DBManager createDataBase];
    if ([shareDataBase open]) {
         isOk = [shareDataBase executeUpdate:[NSString stringWithFormat:@"UPDATE \"setting_table\" SET \"password\"=%@,\"accesstoken\"=%@ WHERE \"setting_id\"=%@",weatherData.password,weatherData.accesstoken,weatherData.settingId]];
    }
    [shareDataBase close];
}


+ (NSMutableArray *) selectSetting
{
    Settings *m = nil;
    NSMutableArray *settingArray = [[NSMutableArray alloc]init];
    
    shareDataBase = [DBManager createDataBase];
    if ([shareDataBase open]) {
        FMResultSet *s = [shareDataBase executeQuery:@"SELECT * FROM \"setting_table\""];
        while ([s next]) {
            m = [[Settings alloc] init];
            m.settingId = [s stringForColumn:@"setting_id"];
            m.password = [s stringForColumn:@"password"];
            m.accesstoken = [s stringForColumn:@"accesstoken"];
            [settingArray addObject:m];
        }
        
        [shareDataBase close];
    }
    return settingArray;
}



@end
