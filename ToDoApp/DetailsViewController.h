//
//  DetailsViewController.h
//  ToDoApp
//
//  Created by raneem on 02/04/2024.
//

#import <UIKit/UIKit.h>
#import "TaskDTO.h"
#import "TaskProtocol.h"
#import "DeleteProtocol.h"


@interface DetailsViewController : UIViewController

@property TaskDTO *oneTask;
@property id <TaskProtocol>taskProtocol;
@property id <DeleteProtocol>deleteProtocol;


@end


