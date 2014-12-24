//
//  UIComboBox.m
//  Sample
//
//  Created by abc123 on 14-12-24.
//  Copyright (c) 2014 Ralph Shane. All rights reserved.
//

#import "UIComboBox.h"


@interface UIComboBox () <UITableViewDelegate, UITableViewDataSource /*, UIGestureRecognizerDelegate */>

@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightView;

@property (strong, nonatomic) UITableView* tableView;

@end

@implementation UIComboBox

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadContentViewFromNib];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadContentViewFromNib];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadContentViewFromNib];
    }
    return self;
}

- (void)setSelectedItem:(NSUInteger)selectedItem {
    _selectedItem = selectedItem;
    _textLabel.text = _entries[_selectedItem];
    
    if (_tableView) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:_selectedItem inSection:0];
        [_tableView selectRowAtIndexPath:path
                                animated:YES
                          scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void)loadContentViewFromNib {
    NSString *className = NSStringFromClass([self class]);
    self.contentView = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
    [self addSubview:self.contentView];
    self.layer.cornerRadius = 7.;
    self.layer.borderWidth = .5;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.masksToBounds = YES;
    
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[self pin:_contentView attribute:NSLayoutAttributeTop]];
    [self addConstraint:[self pin:_contentView attribute:NSLayoutAttributeLeft]];
    [self addConstraint:[self pin:_contentView attribute:NSLayoutAttributeBottom]];
    [self addConstraint:[self pin:_contentView attribute:NSLayoutAttributeRight]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(tapHandle)];
    //tapGesture.cancelsTouchesInView = NO;
    //tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
    self.userInteractionEnabled = YES;
}

- (NSLayoutConstraint *)pin:(id)item attribute:(NSLayoutAttribute)attribute
{
    return [NSLayoutConstraint constraintWithItem:self
                                        attribute:attribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:item
                                        attribute:attribute
                                       multiplier:1.0
                                         constant:0.0];
}

#pragma mark - firstResponder
- (void)tapHandle {
    if (!_tableView) {
        CGRect frame = self.frame;
        frame.origin.y += self.frame.size.height + 2.0;
        frame.size.height = 160;
        _tableView = [[UITableView alloc] initWithFrame:frame];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        _tableView.layer.cornerRadius = 6.0f;
        _tableView.layer.borderWidth = 1.0f;
    }
    
    if (_tableView.superview == nil) {
        [self.superview addSubview:_tableView];

        
        NSIndexPath *path = [NSIndexPath indexPathForRow:_selectedItem inSection:0];
        [_tableView selectRowAtIndexPath:path
                                animated:YES
                          scrollPosition:UITableViewScrollPositionMiddle];
    }

}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    if (CGRectContainsPoint(_innerInputView.frame,
//                            [touch locationInView:[_innerInputView superview]]))
//    {
//        return NO;
//    }
//    return YES;
//}

#pragma mark - change state when highlighed

-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    _rightView.highlighted = highlighted; // change button to highlighed state
    _textLabel.highlighted = highlighted; // change label to highlighed state
    UIColor *shadowColor = highlighted ? [UIColor lightGrayColor] : nil;
    _textLabel.shadowColor = shadowColor;
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_entries count];
}


#define kTableViewCellHeight 32.0f

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableViewCellHeight;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"UIComboBoxCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [[_entries objectAtIndex:[indexPath row] ] description];
    return cell;
}

- (void)          tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedItem = indexPath.row;
    
    [_tableView removeFromSuperview];
}

@end
