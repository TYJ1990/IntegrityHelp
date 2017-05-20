//
//  IntegralView.m
//  IntegrityHelp
//
//  Created by 小凡 on 2017/4/28.
//  Copyright © 2017年 小凡. All rights reserved.
//

#import "IntegralView.h"

@implementation IntegralView




- (void)getChartsWithValueArray:(NSArray *)valueArr nameArray:(NSArray *)nameArr{
    
    [_kEchartView setOption:[IntegralView standardPieOptionWithValueArray:valueArr nameArray:nameArr]];
    [_kEchartView loadEcharts];
}




/**  标准饼图 */
+ (PYOption *)standardPieOptionWithValueArray:(NSArray *)valueArr nameArray:(NSArray *)nameArr{
    return [PYOption initPYOptionWithBlock:^(PYOption *option) {
        option.tooltipEqual([PYTooltip initPYTooltipWithBlock:^(PYTooltip *tooltip) {
            tooltip.triggerEqual(PYTooltipTriggerItem)
            .formatterEqual(@"{a} <br/>{b} : {c} ({d}%)");
        }])
        .colorEqual(@[@"rgb(251,166,46)",@"rgb(242,106,85)",@"rgb(85,242,140)",@"rgb(0,162,255)",@"rgb(242,218,84)",@"rgb(103,200,255)",@"rgb(0,230,178)"])
        .legendEqual([PYLegend initPYLegendWithBlock:^(PYLegend *legend) {
            legend.orientEqual(PYOrientVertical)
            .paddingEqual(@[@60,@0,@0,@15])
            .xEqual(PYPositionLeft)
            .dataEqual(nameArr);
        }])
        .addSeries([PYPieSeries initPYPieSeriesWithBlock:^(PYPieSeries *series) {
            series.radiusEqual(@"55%")
            .centerEqual(@[@"72%",@"50%"])
            .typeEqual(PYSeriesTypePie)
            .dataEqual(@[@{@"value":valueArr[0],@"name":nameArr[0]},@{@"value":valueArr[1],@"name":nameArr[1]},@{@"value":valueArr[2],@"name":nameArr[2]},@{@"value":valueArr[3],@"name":nameArr[3]},@{@"value":valueArr[4],@"name":nameArr[4]},@{@"value":valueArr[5],@"name":nameArr[5]},@{@"value":valueArr[6],@"name":nameArr[6]}])
            .itemStyleEqual([PYItemStyle initPYItemStyleWithBlock:^(PYItemStyle *itemStyle) {
                itemStyle.normalEqual([PYItemStyleProp initPYItemStylePropWithBlock:^(PYItemStyleProp *itemStyleProp){
                    itemStyleProp.labelEqual([PYLabel initPYLabelWithBlock:^(PYLabel *label) {
                        label.showEqual(NO);
                    }])
                    .labelLineEqual([PYLabelLine initPYLabelLineWithBlock:^(PYLabelLine *labelLine) {
                        labelLine.showEqual(NO);
                    }]);
                }]);
            }]);
        }]);
    }];
}

@end
