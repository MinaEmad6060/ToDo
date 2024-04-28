//
//  Task.m
//  ToDo
//
//  Created by Mina Emad on 21/04/2024.
//

#import "Task.h"

@implementation Task


- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_title forKey:@"title"];
    [coder encodeObject:_desc forKey:@"desc"];
    [coder encodeObject:_priority forKey:@"priority"];
    [coder encodeObject:_type forKey:@"type"];
    [coder encodeObject:_date forKey:@"date"];
    [coder encodeObject:_img forKey:@"img"];
}


- (instancetype)initWithCoder:(NSCoder *)coder {
    _title = [coder decodeObjectForKey:@"title"];
    _desc = [coder decodeObjectForKey:@"desc"];
    _priority = [coder decodeObjectForKey:@"priority"];
    _type = [coder decodeObjectForKey:@"type"];
    _date = [coder decodeObjectForKey:@"date"];
    _img = [coder decodeObjectForKey:@"img"];
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
