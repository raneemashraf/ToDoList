//
//  TaskProtocol.h
//  ToDoApp
//
//  Created by raneem on 02/04/2024.
//

#import <Foundation/Foundation.h>
#import "TaskDTO.h"

@protocol TaskProtocol <NSObject>

-(void)reloadData:(NSDictionary*)t;


@end


