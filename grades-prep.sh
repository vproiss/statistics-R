#!/usr/bin/env Rscript
# produces a .csv file with matriculation numbers and exercise grades
# and a list of emails

library(tidyverse)
grades <- read_csv("IDA202223.csv")

to_percent <- function(x, na.rm = FALSE) (round(as.numeric(x) * 100, 2))
grades <- grades |>
  select(Matrikelnr, `E-Mail`, matches("grade.*percent"),
         `Midterm submitted`) |>
  filter(!is.na(Matrikelnr)) |>
  mutate(`Do you need to submit R exercise sheet #5?` = case_when(
  `R sheet #1 grade (percent)` < 0.5 ~ "Yes",
  `R sheet #2 grade (percent)` < 0.5 ~ "Yes",
  `R sheet #3 grade (percent)` < 0.5 ~ "Yes",
  `R sheet #4 grade (percent)` < 0.5 ~ "Yes",
  TRUE ~ "No")
  )

grades$`Do you need to submit R exercise sheet #5?`[grades$`Midterm submitted` != "Yes"] <- "-"

emails <- file("emails.txt")
writeLines(grades |>
            filter(`Do you need to submit R exercise sheet #5?` == "Yes") |>
            arrange(`E-Mail`) |>
            pull(`E-Mail`), emails)
close(emails)

grades <- grades |>
  mutate_at(vars(matches("percent")), to_percent) |>
  select(-`E-Mail`, -`Midterm submitted`) |>
  arrange(Matrikelnr)

write_csv(grades,
          file = paste("grades_",
                       lubridate::today(),
                       ".csv",
                       sep = ""))
