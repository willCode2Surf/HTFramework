//  ListViewController.m
//
//  based on
//  SelectionListViewController.m
//  iContractor
//
//  Created by Jeff LaMarche on 2/18/09.
//  Copyright 2009 Jeff LaMarche Consulting. All rights reserved.
//
#import "ListViewController.h"

@implementation ListViewController
@synthesize delegate, indexed;
@synthesize rootVC;

- (TableSection*)addSectionWithTitle:(NSString*)title{
	TableSection *newSection = [[[TableSection alloc] init] autorelease];
	newSection.title = title;

	[[self sections] addObject:newSection];
	return newSection;
}

- (void)viewWillLoad {    
	[super viewDidLoad];
}

- (void)dealloc 
{
	[items release];
    [super dealloc];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
	
	NSMutableArray *sectionTitles = [NSMutableArray arrayWithCapacity:[sections count]];
	for (TableSection *section in sections){
		[sectionTitles addObject:section.title];
	}
	
	if (indexed)
		return sectionTitles;
	else {
		return nil;
	}

}

- (void)setItems:(NSArray*)theItems{

	for (NSObject* item in theItems){
		[self addItem:item];
	}
	
}

- (void)addItem:(NSObject*)item{
	TableSection *sectionToAddTo = nil;
	if ([[self sections] count] == 0){
		sectionToAddTo = [self addSectionWithTitle:@""];
	} else {
		sectionToAddTo = [sections objectAtIndex:0];
	}
	[sectionToAddTo addItem:item];
}

- (NSMutableArray*)sections{
	if (sections == nil) {
		sections = [NSMutableArray array];
		[sections retain];
	}
	return sections;
}

- (NSArray*)items{
	return [[sections objectAtIndex:0] items];
}

#pragma mark -
#pragma mark Tableview methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return [sections count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	TableSection *ts = [sections objectAtIndex:section];
	if (ts.title == nil)
		return @"";
	else
		return ts.title;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	TableSection *ts = [sections objectAtIndex:section];
    return [ts.items count];
}

- (UITableViewCellStyle)tableViewCellStyle{
	return UITableViewCellStyleDefault;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifier]];
    if (cell == nil) 
	{
		cell = [[UITableViewCell alloc] initWithStyle:[self tableViewCellStyle] reuseIdentifier:[self cellIdentifier]];
    }
    
	TableSection *ts = [sections objectAtIndex:indexPath.section];
	NSObject *itemForRow = [ts.items objectAtIndex:indexPath.row];
	
	if ([itemForRow respondsToSelector:@selector(tableItemDescription)]){
		cell.textLabel.text = [(id<HTTableItemDescription>)itemForRow tableItemDescription];
	} else {
		cell.textLabel.text = [ts.items objectAtIndex:indexPath.row];
	}
	
	if ([itemForRow respondsToSelector:@selector(accessoryType)]){
		cell.accessoryType = (UITableViewCellAccessoryType)[(TableControlItem*)itemForRow accessoryType];
	}
	
	if ([itemForRow respondsToSelector:@selector(control)]){
		cell.accessoryView = [(TableControlItem*)itemForRow control];
	}
	
	if ([itemForRow respondsToSelector:@selector(detail)]){
		cell.detailTextLabel.text = [(TableControlItem*)itemForRow detail];
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	TableSection *selectedSection = [self.sections objectAtIndex:indexPath.section];
	NSObject *selectedItem = [selectedSection.items objectAtIndex:indexPath.row];
	[self didSelectItem:selectedItem atIndexPath:indexPath];
}

- (void)didSelectItem:(NSObject*)item atIndexPath:(NSIndexPath*)indexPath{
	NSLog(@"you selected %@ at indexPath %@ (you should override this method)", item, indexPath);
}

- (NSString*)cellIdentifier{
	return @"abc";
}

+ (NSString*)cellIdentifier{
	return @"abc";
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}

@end

