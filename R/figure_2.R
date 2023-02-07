
# Fig. 2(a): Swiss CPI with Covid expenditure weights, monthly inflation
g <- ggplot() +
  geom_line(data = CPI_CovidBasket_IP_agg_1[CPI_CovidBasket_IP_agg_1$Date >= "2020-01-01",], mapping = aes(x = Date, y = CPI_CovidBasket_MoM, col = "Covid basket"), size = 1.2) +
  geom_line(data = CPI_Total[CPI_Total$Date >= "2020-01-01",], mapping = aes(x = Date, y = CPIMoM, col = "Consumer price index (CPI)"), size = 1.2) +

  labs(
    title = "Swiss CPI with Covid expenditure weights",
    subtitle = "Monthly inflation rate (%)",
    x = "",
    y = ""
  ) +
  ylim(-0.55, 0.55) +
  geom_vline(xintercept = as.Date("2020-03-16"), linetype=4)
g <- grid.arrange(g +
                    theme_minimal() +
                    theme(legend.position = "bottom",
                          legend.title=element_blank()) +
                    guides(col = guide_legend(override.aes = list(size = 2.5))))
ggsave(plot=g, filename = paste0(fig.path,paste0("/fig_2a.pdf")),
       device = cairo_pdf, height = 190/AspectRatio, width = 190, units = "mm", bg = "transparent")

# Fig. 2(b): Swiss CPI with Covid expenditure weights, annual inflation
g <- ggplot() +
  geom_line(data = CPI_CovidBasket_IP_agg_12[CPI_CovidBasket_IP_agg_12$Date >= "2020-01-01",], mapping = aes(x = Date, y = CPI_CovidBasket_YoY, col = "Covid basket"), size = 1.2) +
  geom_line(data = CPI_Total[CPI_Total$Date >= "2020-01-01",], mapping = aes(x = Date, y = CPIYoY, col = "Consumer price index (CPI)"), size = 1.2) +

  labs(
    title = "Swiss CPI with Covid expenditure weights",
    subtitle = "Annual inflation rate (%)",
    x = "",
    y = ""
  ) +
  ylim(-1.4, 0.8) +
  geom_vline(xintercept = as.Date("2020-03-16"), linetype=4)
g <- grid.arrange(g +
                    theme_minimal() +
                    theme(legend.position = "bottom",
                          legend.title=element_blank()) +
                    guides(col = guide_legend(override.aes = list(size = 2.5))))
ggsave(plot=g, filename = paste0(fig.path,paste0("/fig_2b.pdf")),
       device = cairo_pdf, height = 190/AspectRatio, width = 190, units = "mm", bg = "transparent")
