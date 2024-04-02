//
//  TodoViewController.m
//  ToDoApp
//
//  Created by raneem on 02/04/2024.
//

#import "TodoViewController.h"
#import "DetailsViewController.h"
#import "AddTaskViewController.h"

@interface TodoViewController ()
- (IBAction)addBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *toDoTable;
@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *piroritySegment;

@end

@implementation TodoViewController
- (IBAction)pirorityAction:(id)sender {
        UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
        switch (segmentedControl.selectedSegmentIndex) {
            case 0:
                [self filterTasksByPriority:0];
                break;
            case 1:
                [self filterTasksByPriority:1];
                break;
            case 2:
                [self filterTasksByPriority:2];
                break;
            default:
                break;
        }
    }
     
    - (void)filterTasksByPriority:(long )priority {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *existingTasks = [[defaults objectForKey:@"TasksArray"] mutableCopy];
        _toDoListArr = existingTasks ? [existingTasks mutableCopy] : [NSMutableArray array];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskPriority == %@",@(priority)];
        NSArray *filteredTasks = [_toDoListArr filteredArrayUsingPredicate:predicate];
        _toDoListArr = [NSMutableArray arrayWithArray:filteredTasks];
        [self.toDoTable reloadData];
    }

- (void)viewDidLoad {
    [super viewDidLoad];
    self.toDoTable.delegate = self;
    self.toDoTable.dataSource = self;
 
    
      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
      NSArray *existingTasks = [[defaults objectForKey:@"TasksArray"]mutableCopy];
//      _toDoListArr = existingTasks ? [existingTasks mutableCopy]:[NSMutableArray array];
    
    
    NSArray  *allTasks = existingTasks ? [existingTasks mutableCopy]:[NSMutableArray array];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"state == %@", @(0)];
    _toDoListArr = [[allTasks filteredArrayUsingPredicate:predicate] mutableCopy];
    
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _toDoListArr.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todoCell" forIndexPath:indexPath];
    
    if ([_toDoListArr count] > 0 && indexPath.row < [_toDoListArr count]) {
        
        NSDictionary *taskDic = _toDoListArr[indexPath.row];
        TaskDTO *currentTask = [self taskFromDictionary:taskDic];
        
        
        cell.textLabel.text = [currentTask title];
        long priorityValue = [currentTask myPriority];
        
        
        
        
        if (priorityValue == 0) {
            cell.imageView.image = [UIImage imageNamed:@"H"];
        } else if (priorityValue == 1) {
            cell.imageView.image = [UIImage imageNamed:@"M"];
        } else {
            cell.imageView.image = [UIImage imageNamed:@"L"];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        DetailsViewController *deatailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    
    NSDictionary *selectedTask;
    selectedTask = _toDoListArr[indexPath.row];
    TaskDTO *currentTask = [self taskFromDictionary:selectedTask];
    deatailsVC.oneTask = currentTask;
    
    [self.navigationController pushViewController:deatailsVC animated:YES];
}

- (IBAction)addBtn:(id)sender {
    AddTaskViewController *addTaskVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTaskViewController"];
    [self.navigationController pushViewController:addTaskVC animated:YES];
    addTaskVC.taskProtocol = self;

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.toDoListArr removeObject:_toDoListArr[indexPath.row]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:_toDoListArr forKey:@"TasksArray"];
        [defaults synchronize];
    [self.toDoTable reloadData];

}

- (void)reloadData:(NSDictionary *)t {
    [_toDoListArr addObject:t];
    [self.toDoTable reloadData];
}

- (void)deleteData:(NSDictionary *)task{
    [_toDoListArr removeObject:task];
    [self.toDoTable reloadData];
}

- (TaskDTO *)taskFromDictionary:(NSDictionary *)dict {
    TaskDTO *task = [[TaskDTO alloc] init];
    NSNumber *priorityNumber = dict[@"taskPriority"];
    NSNumber *stateNumber = dict[@"state"];

    task.title = dict[@"title"];
    task.desc = dict[@"description"];
    task.state = [stateNumber longValue];
    task.myPriority = [priorityNumber longValue];
    task.date = dict[@"date"];
    return task;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *existingTasks = [[defaults objectForKey:@"TasksArray"] mutableCopy];
        _toDoListArr = existingTasks ? [existingTasks mutableCopy] : [NSMutableArray array];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", searchText];
        NSArray *filteredTasks = [_toDoListArr filteredArrayUsingPredicate:predicate];
        
        _toDoListArr = [NSMutableArray arrayWithArray:filteredTasks];
    }
    
    [self.toDoTable reloadData];
}



@end

