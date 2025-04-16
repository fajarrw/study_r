library(nycflights13)
library(tidyverse)
library(Lahman)
flights |> 
  filter(month %in% c(1,2))

jan1 <- flights |> 
  filter(month == 1 & day == 1)

flights |> 
  arrange(year, month, day, dep_time)

flights |> 
  arrange(desc(dep_delay))

flights |> 
  distinct(origin, dest)

flights |> 
  distinct(origin, dest, .keep_all = TRUE)

flights |>
  count(origin, dest, sort = TRUE)

flights |>
  filter(
    arr_delay >= 120 | 
    dest %in% c("IAH","HOU") | 
    carrier %in% c("UA","DL") | 
    month %in% c(7,8,9) | 
    (arr_delay > 120 & dep_delay <= 0) | 
    (dep_delay >= 60 & (dep_delay - arr_delay > 30))
  )

flights |> 
  arrange(desc(dep_delay), dep_time)

flights |> 
  arrange(air_time)

flights |> 
  distinct(month, day)

flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60
  )
flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    hours = air_time / 60,
    gain_per_hour = gain / hours,
    .keep = "used"
  )

flights |> 
  select(year, month, day)

flights |> 
  select(year:day)

flights |> 
  select(!year:day)

flights |>
  select(starts_with("dep") | starts_with("arr")) 

flights |> 
  select("dep_delay","dep_delay")

flights |> 
  select(contains("TIME"))

flights |> 
  select(contains("TIME", ignore.case = FALSE))

flights |> 
  rename(air_time_min = air_time) |> 
  relocate(air_time_min)

flights |> 
  group_by(carrier) |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE), 
    n = n()
  ) |>
  arrange(desc(avg_delay))

flights |> 
  group_by(carrier, dest) |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE), 
    n()
  ) |>
  arrange(desc(avg_delay))

flights |> 
  group_by(dest) |>
  slice_max(dep_delay, n = -1) |>
  relocate(dest)
  
avg_delay_during_day_by_hour <- flights |>
  group_by(hour) |>
  summarize(avg_delay = mean(dep_delay, na.rm = TRUE), n())

ggplot(
  avg_delay_during_day_by_hour, 
  aes(x = hour, y = avg_delay)
) +
  geom_point(na.rm = TRUE) +
  geom_smooth(method = "loess")

df <- tibble(
  x = 1:5,
  y = c("a", "b", "a", "a", "b"),
  z = c("K", "K", "L", "L", "K")
)

df |>
  group_by(y)

df |>
  arrange(y)

df |> 
  group_by(y) |>
  summarize(mean_x = mean(x))

df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x), .groups = "drop")

df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x))

df |>
  group_by(y, z) |>
  mutate(mean_x = mean(x))

batters <- Batting |> 
  group_by(playerID) |> 
  summarize(
    performance = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    n = sum(AB, na.rm = TRUE)
  )

batters |> 
  filter(n > 100) |> 
  ggplot(aes(x = n, y = performance)) +
  geom_point(alpha = 1 / 10) + 
  geom_smooth(se = FALSE)



