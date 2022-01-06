setwd("E:/Researches/Xiaqian/NGS/CleanData/宏基因组数据/Result/Results/Annotations/AAs")

F1 <-read.table("F01_bin.1.pI", sep = "\t", header = T)

## 以下4选1
# 单组加点
p1 <- ggplot(F1, aes(Isoelectric.point, Relative.frequency))+geom_point(size=2,shape=21)+geom_smooth(method= "gam")+theme_classic()

# 单组无点
p1 <- ggplot(F1, aes(Isoelectric.point, Relative.frequency))+geom_smooth(method= "gam")+theme_classic()

# 多组加点
p1 <- ggplot(F1, aes(Isoelectric.point, Relative.frequency, color=MAGs))+geom_point(size=3,shape=21)+geom_smooth(method= "gam")+theme_classic()


# 多组无点显示置信区间
p1 <- ggplot(F1, aes(Isoelectric.point, Relative.frequency, color=MAGs))+geom_smooth(method= "gam")+theme_classic()

# 多组无点去除置信区间
p1 <- ggplot(F1, aes(Isoelectric.point, Relative.frequency, color=MAGs))+geom_smooth(method= "gam",se = FALSE)+theme_classic()


# 美化
p1 + scale_x_continuous(limits=c(2, 14), breaks = seq(2, 14, 1))+ scale_y_continuous(limits=c(-0.01, max(F1$Relative.frequency)), breaks = seq(0,max(F1$Relative.frequency), 0.01))+ labs(x= "Isoelectric point",y = "Relative frequency")


# F04自定义颜色
p1 + scale_x_continuous(limits=c(2, 14), breaks = seq(2, 14, 1))+ scale_y_continuous(limits=c(-0.01, max(F1$Relative.frequency)), breaks = seq(0,max(F1$Relative.frequency), 0.01))+ labs(x= "Isoelectric point",y = "Relative frequency")+ scale_color_manual(name="MAGs", values=c("#1f77b4","#ff7f0e","#2ca02c", "#d62728", "#9467bd", "#8c564b", "#e377c2", "#bcbd22"))

# F05自定义颜色
p1 + scale_x_continuous(limits=c(2, 14), breaks = seq(2, 14, 1))+ scale_y_continuous(limits=c(-0.01, max(F1$Relative.frequency)), breaks = seq(0,max(F1$Relative.frequency), 0.01))+ labs(x= "Isoelectric point",y = "Relative frequency")+ scale_color_manual(name="MAGs", values=c("#1f77b4","#ff7f0e","#2ca02c", "#d62728", "#9467bd", "#8c564b", "#e377c2", "#bcbd22", "#17becf"))

# F06自定义颜色
p1 + scale_x_continuous(limits=c(2, 14), breaks = seq(2, 14, 1))+ scale_y_continuous(limits=c(-0.01, max(F1$Relative.frequency)), breaks = seq(0,max(F1$Relative.frequency), 0.01))+ labs(x= "Isoelectric point",y = "Relative frequency")+ scale_color_manual(name="MAGs", values=c("#1f77b4","#ff7f0e","#2ca02c", "#d62728", "#9467bd", "#8c564b", "#e377c2", "#bcbd22", "#17becf", "#f7b6d2", "#5254a3", "#000000"))
