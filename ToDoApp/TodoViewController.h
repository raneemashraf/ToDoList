//
//  TodoViewController.h
//  ToDoApp
//
//  Created by raneem on 02/04/2024.
//

#import <UIKit/UIKit.h>
#import "TaskDTO.h"
#import "TaskProtocol.h"
#import "DeleteProtocol.h"


@interface TodoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,DeleteProtocol,TaskProtocol,UISearchBarDelegate>

@property NSMutableArray *toDoListArr;


@end


