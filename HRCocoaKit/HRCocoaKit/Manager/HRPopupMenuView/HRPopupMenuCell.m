//
//  HRPopupMenuCell.m
//  FHBaiJuYi
//
//  Created by 许昊然 on 2017/2/14.
//  Copyright © 2017年 许昊然. All rights reserved.
//

#import "HRPopupMenuCell.h"
#import "Masonry.h"
#import "UIView+CustomMethod.h"
#import "CommonDefine.h"

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
            make.left.mas_equalTo(@(10));
            make.centerY.mas_equalTo(@(0));
            make.width.height.mas_equalTo(@(20));
        }];
        self.iconImageView.image = [UIImage imageNamed:imageName];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImageView.mas_right).offset(5);
            make.centerY.mas_equalTo(@(0));
            make.width.mas_greaterThanOrEqualTo(@(30));
            make.height.mas_equalTo(@(20));
        }];
        self.titleLabel.text = title;
    } else {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.contentView);
            make.height.mas_equalTo(@(20));
            make.width.mas_greaterThanOrEqualTo(@(30));
        }];
        self.titleLabel.text = title;
    }
    UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_line_bottom"]];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(@(0));
        make.right.mas_equalTo(@(-12));
        make.left.mas_equalTo(@(12));
        make.height.mas_equalTo(@(1));
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
