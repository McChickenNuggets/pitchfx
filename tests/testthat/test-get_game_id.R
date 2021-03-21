test_that("Success in obtaining game_id", {
  ids<-as.numeric(c(630851,631377))
  game_ids<-as.numeric(get_game_ids(date_start = "2020-7-23"))
  expect_identical(ids,game_ids)
})
