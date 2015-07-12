library(ggplot2)

# Read logs
subquery = read.csv('log_subquery')
join = read.csv('log_join')

# Combine series
all = rbind(subquery, join)

# Ensure we know what colors to put on the labels
# Follow ggplot's algorithm
# See [1] for details
#
# [1] https://stackoverflow.com/questions/8197559/emulate-ggplot2-default-color-palette
gg_color_hue <- function(n) {
    hues = seq(15, 375, length=n+1)
  hcl(h=hues, l=65, c=100)[1:n]
}

# Find coeffs for series
co_subquery <- coef(lm(time ~ number_of_records, data = subquery))
co_join <- coef(lm(time ~ number_of_records, data = join))

# Drop plot and set labels
pl <- qplot(time, data = all, x = number_of_records, color=strategy,  geom = c("point", "smooth"))
subquery_label <- annotate("text", x = 100, y = 700,  label = paste("Subquery = ", round(co_subquery[1],5), " * x + ", round(co_subquery[2],5)), color=gg_color_hue(2)[1])
join_label     <- annotate("text", x = 100, y = 50, label = paste("Join = ",     round(co_join[1],5), " * x + ", round(co_join[2],5)), color=gg_color_hue(2)[2])
pl + join_label + subquery_label
