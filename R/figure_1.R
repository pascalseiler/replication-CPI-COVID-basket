
# Fig. 1: Changes in Swiss consumer spending
g <- ggplot(subset(Expenditure_CH_KWAgg) %>%
              filter(Year == 2020,
                     Date > "2020-01-02")) +
  geom_line(aes(x = Date, y = NormExp, group = Cat, col = Cat)) +
  labs(
    title = "Changes in Swiss consumer spending",
    x = "",
    y = "Percentage change"
  ) +
  geom_vline(xintercept = as.Date("2020-03-16"), linetype=4)
g <- grid.arrange(g +
                    theme_minimal() +
                    theme(legend.position = "bottom",
                          legend.title=element_blank()) +
                    guides(col = guide_legend(override.aes = list(size = 2.5))))
ggsave(plot=g, filename = paste0(fig.path,paste0("/fig_1.pdf")),
       device = cairo_pdf, height = 190/AspectRatio, width = 190, units = "mm",
       bg = "transparent")
