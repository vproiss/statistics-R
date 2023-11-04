#!/usr/bin/env Rscript
# creates a dataset of 5,000 Spotify songs

library(tidyverse)
set.seed(7)
songs <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-09-14/audio_features.csv')
sample_songs <- songs |>
  filter(!is.na(spotify_track_popularity)) |>
  slice_sample(n = 5000, weight_by = spotify_track_popularity) |>
  select(song_id, performer, song, spotify_genre,
         danceability, loudness, speechiness, valence,
         spotify_track_popularity)

write_csv(sample_songs, 'songs.csv')
