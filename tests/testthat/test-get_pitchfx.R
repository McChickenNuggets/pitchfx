test_that("Success in obtaining PITCHf/x data", {
  temp<-get_pitchfx(game_id = "630851")
  expect_equal(length(temp), 53)
})
