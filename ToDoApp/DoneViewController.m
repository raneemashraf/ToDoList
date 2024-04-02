//
//  DoneViewController.m
//  ToDoApp
//
//  Created by raneem on 02/04/2024.
//

#import "DoneViewController.h"
#import "DetailsViewController.h"

@interface DoneViewController ()
@property (weak, nonatomic) IBOutlet UITableView *doneTable;

@end

@implementation DoneViewController
- (IBAction)piroritySeg:(id)sender {
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
    NSArray *existingTasks = [[defaults objectForKey:@"DoneArray"] mutableCopy];
    _doneListArr = existingTasks ? [existingTasks mutableCopy] : [NSMutableArray array];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taskPriority == %@",@(priority)];
    NSArray *filteredTasks = [_doneListArr filteredArrayUsingPredicate:predicate];
    _doneListArr = [NSMutableArray arrayWithArray:filteredTasks];
    [self.doneTable reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.doneTable.delegate = self;
    self.doneTable.dataSource = self;
    
    
      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
      NSArray *existingTasks = [[defaults objectForKey:@"DoneArray"]mutableCopy];
      _doneListArr = existingTasks ? [existingTasks mutableCopy]:[NSMutableArray array];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _doneListArr.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DoneCell" forIndexPath:indexPath];
    
    if ([_doneListArr count] > 0 && indexPath.row < [_doneListArr count]) {
        NSDictionary *taskDic = _doneListArr[indexPath.row];
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
    selectedTask = _doneListArr[indexPath.row];
    TaskDTO *currentTask = [self taskFromDictionary:selectedTask];
    deatailsVC.oneTask = currentTask;
    
    [self.navigationController pushViewController:deatailsVC animated:YES];
}

//- (IBAction)addBtn:(id)sender {
//    AddTaskViewController *addTaskVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTaskViewController"];
//    [self.navigationController pushViewController:addTaskVC animated:YES];
//    addTaskVC.taskProtocol = self;
//
//}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
[self.doneListArr removeObject:_doneListArr[indexPath.row]];
NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
 
    [defaults setObject:_doneListArr forKey:@"DoneArray"];
    [defaults synchronize];
[self.doneTable reloadData];

}

- (void)reloadData:(NSDictionary *)t {
    [_doneListArr addObject:t];
    [self.doneTable reloadData];
}

- (void)viewWillAppear:(BOOL)animated{

[self.doneTable reloadData];

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
@end
