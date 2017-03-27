//
//  MapCharacter.m
//  Motori
//
//  Created by aDb on 2/25/17.
//  Copyright © 2017 Arena. All rights reserved.
//

#import "MapCharacter.h"

@implementation MapCharacter

+(NSString*)MapCharacter:(NSString*)character
{
    if ([character containsString:@"1"])
        character = [character stringByReplacingOccurrencesOfString:@"1" withString:@"۱"];
    if ([character containsString:@"2"])
        character =[character stringByReplacingOccurrencesOfString:@"2" withString:@"۲"];
    if ([character containsString:@"3"])
        character =[character stringByReplacingOccurrencesOfString:@"3" withString:@"۳"];
    if ([character containsString:@"4"])
        character =[character stringByReplacingOccurrencesOfString:@"4" withString:@"۴"];
    if ([character containsString:@"5"])
        character =[character stringByReplacingOccurrencesOfString:@"5" withString:@"۵"];
    if ([character containsString:@"6"])
        character =[character stringByReplacingOccurrencesOfString:@"6" withString:@"۶"];
    if ([character containsString:@"7"])
        character =[character stringByReplacingOccurrencesOfString:@"7" withString:@"۷"];
    if ([character containsString:@"8"])
        character =[character stringByReplacingOccurrencesOfString:@"8" withString:@"۸"];
    if ([character containsString:@"9"])
        character =[character stringByReplacingOccurrencesOfString:@"9" withString:@"۹"];
    if ([character containsString:@"0"])
        character =[character stringByReplacingOccurrencesOfString:@"0" withString:@"۰"];
    
    return character;
}

+(NSString*)MapCharacterReverse:(NSString*)character
{
    if ([character containsString:@"۱"])
        character = [character stringByReplacingOccurrencesOfString:@"۱" withString:@"1"];
    if ([character containsString:@"۲"])
        character =[character stringByReplacingOccurrencesOfString:@"۲" withString:@"2"];
    if ([character containsString:@"۳"])
        character =[character stringByReplacingOccurrencesOfString:@"۳" withString:@"3"];
    if ([character containsString:@"۴"])
        character =[character stringByReplacingOccurrencesOfString:@"۴" withString:@"4"];
    if ([character containsString:@"۵"])
        character =[character stringByReplacingOccurrencesOfString:@"۵" withString:@"5"];
    if ([character containsString:@"۶"])
        character =[character stringByReplacingOccurrencesOfString:@"۶" withString:@"6"];
    if ([character containsString:@"۷"])
        character =[character stringByReplacingOccurrencesOfString:@"۷" withString:@"7"];
    if ([character containsString:@"۸"])
        character =[character stringByReplacingOccurrencesOfString:@"۸" withString:@"8"];
    if ([character containsString:@"۹"])
        character =[character stringByReplacingOccurrencesOfString:@"۹" withString:@"9"];
    if ([character containsString:@"۰"])
        character =[character stringByReplacingOccurrencesOfString:@"۰" withString:@"0"];
    
    return character;
}

@end
