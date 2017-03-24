//
//  HRPopupMenuCell.m
//  FHBaiJuYi
//
//  Created by 许昊然 on 2017/2/14.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import "HRPopupMenuCell.h"
#import "HRCocoaKit.h"

@interface  HRPopupMenuCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@end

@implementation HRPopupMenuCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView {
    HRPopupMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HRPopupMenuCell"];
    if (!cell) {
        cell = [[HRPopupMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HRPopupMenuCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)configCellWithTitle:(NSString *)title image:(NSString *)imageName {
    [self.contentView removeAllSubviews];
    [self.contentView addSubview:self.titleLabel];
    if (imageName.length > 0 && imageName) {
        [self.contentView addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.centerY.equalTo(0);
            make.width.height.equalTo(20);
        }];
        self.iconImageView.image = [UIImage imageNamed:imageName];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.right).offset(5);
            make.centerY.equalTo(0);
            make.width.greaterThanOrEqualTo(30);
            make.height.equalTo(20);
        }];
        self.titleLabel.text = title;
    } else {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.height.equalTo(20);
            make.width.greaterThanOrEqualTo(30);
        }];
        self.titleLabel.text = title;
    }
    UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_line_bottom"]];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(0);
        make.right.equalTo(-12);
        make.left.equalTo(12);
        make.height.equalTo(1);
    }];
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = kHexRGB(0x555555);
    }
    return _titleLabel;
}

- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeCenter;
    }
    return _iconImageView;
}

@end
