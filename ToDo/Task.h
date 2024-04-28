//
//  Task.h
//  ToDo
//
//  Created by Mina Emad on 21/04/2024.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSObject<NSCoding,NSSecureCoding>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *priority;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *img;


@end

NS_ASSUME_NONNULL_END
