/*
 Copyright 2017-2018 FUJITSU CLOUD TECHNOLOGIES LIMITED All Rights Reserved.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "MenuViewController.h"
#import "Demo1ViewController.h"
#import "Demo2ViewController.h"
#import "Demo3ViewController.h"
#import "Demo32ViewController.h"

@interface MenuViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong,nonatomic) NSArray     *content;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.content = @[ @"demo1：保存", @"demo2：全件検索", @"demo3-1：条件検索",@"demo3-2：条件検索"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellMenu";
    
    UITableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    cell.textLabel.text =  [_content objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"Selected %@", [_content objectAtIndex:indexPath.row]);
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"showDemo1" sender:tableView];
            break;
        case 1:
            [self performSegueWithIdentifier:@"showDemo2" sender:tableView];
            break;
        case 2:
            [self performSegueWithIdentifier:@"showDemo31" sender:tableView];
            break;
        case 3:
            [self performSegueWithIdentifier:@"showDemo32" sender:tableView];
            break;
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated{
//    [self.navigationController setNavigationBarHidden:YES];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
