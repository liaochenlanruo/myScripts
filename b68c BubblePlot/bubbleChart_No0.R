#!/usr/bin/env Rscript
# Author: Liu hualin
# Date: Oct 12, 2021

setwd("E:/Researches/lujia16S/Analysis_20200907/Downstream_analysis/Function")#设置工作目录
#setwd("E:/Researches/lujia16S/Analysis_20200907/Downstream_analysis/Venn/Functions")#设置工作目录

#pdf(file="FunctionsBubbleChart.pdf", width=14, height=11)
#pdf(file="FunctionsBubbleChartx20211012.pdf")

# 读取文件 sep 根据文件格式确定
data <- read.table("functional_table3.tsv",header = TRUE, sep = "\t")
library(ggplot2)
library(reshape)

data_melt <- melt(data)
names(data_melt) = c("Functions", "Samples", "Abundances")
data_melt$Sites=substring(data_melt$Samples,1,3)# 根据第二列的样本名称提取站位信息，用于后续着色
data_melt <-as.data.frame(data_melt)

# 做主图
bubble <- ggplot(data_melt[which(data_melt$Abundances>0),], aes(x = Samples, y = Functions, size = Abundances, color = Sites)) + geom_point()


# 字体修饰
##windowsFonts(myFont = windowsFont("Times New Roman"))

# 修改细节 — 图注，点大小，点shape
bubble_style <- bubble + theme_classic()+
  labs(
    x = "Sampling Sites",
    y = "Functions",
    color="Sites", # 颜色图注名
    size="Abundances")+    # 大小图注名
    scale_size(range = c(0.1, 10), breaks = seq(0.1, 0.6, 0.2)) +  #等比修改圆圈大小
    theme(plot.title=element_text(family="Times New Roman",size=8,
                                color="red",face="italic",
                                hjust=0.5,lineheight=0.5),
                                plot.subtitle = element_text(hjust = 0.5)) + 
    theme(axis.text.x = element_text(angle = 90, hjust = 1))

#dev.off()
