# pitchfx
Scrape PITCHf/x dataset

## Basic Usage
Function `get_pitchfx(date_start, date_end, game_id)`
```r
## get PITCHf/x data for one specific day
get_pitchfx(date_start = "2020-7-23")
 breakAngle breakLength breakY spinRate spinDirection    aY     aZ  pfxX  pfxZ    pX   pZ   vX0     vY0   vZ0      x      y    x0    y0   z0
4        34.8         3.6     24     2484           225 28.24 -15.69 -6.45  8.38 -1.16 3.06  7.50 -138.72 -3.51 161.39 156.25 -3.05 50.00 5.37
5        37.2         3.6     24     2476           225 30.15 -12.48 -6.02  9.91 -1.17 2.75  7.60 -139.77 -4.48 161.51 164.40 -3.13 50.01 5.19
6        33.6         3.6     24     2420           223 30.88 -14.10 -6.40  9.04  0.48 2.07 11.55 -140.29 -6.00  98.62 182.79 -2.85 50.00 5.15
7        12.0        12.0     24     2846            59 22.13 -39.87  5.64 -5.65 -0.41 1.85  4.69 -116.06  0.32 132.70 188.77 -3.19 50.00 5.52
8        32.4         3.6     24     2450           227 30.13 -14.96 -6.06  8.68 -0.19 2.41  9.90 -139.63 -4.47 124.35 173.83 -2.99 50.00 5.01
9        39.6         3.6     24     2575           223 28.64 -12.02 -6.57 10.02 -0.17 1.50  9.85 -140.20 -8.43 123.61 198.30 -2.86 50.01 5.31
10        3.6         8.4     24     2531            93 21.98 -33.16  0.73 -0.60 -0.33 2.34  7.04 -126.31 -0.96 129.58 175.55 -3.23 50.00 5.36
11       40.8         3.6     24     2618           219 30.74 -13.25 -7.08  9.42 -0.61 2.64  9.14 -140.60 -4.99 140.08 167.47 -2.97 50.00 5.29
12        6.0         7.2     24     2327           146 27.72 -28.58  0.78  2.21 -0.05 2.27  7.47 -127.13 -1.83 118.76 177.37 -3.13 50.00 5.29
13       25.2         3.6     24     2413           210 28.76 -15.63 -4.99  8.48  0.43 3.81 10.90 -138.30 -1.71 100.52 135.85 -2.90 50.01 5.48
14       30.0         3.6     24     2373           218 28.76 -16.43 -6.44  8.10  0.68 2.36 12.28 -138.03 -4.45  91.21 175.04 -2.98 50.00 5.09
15        3.6         8.4     24     2388           127 24.22 -30.67  0.19  0.92  0.63 0.52  9.31 -126.40 -5.41  93.14 224.77 -3.12 50.00 5.13
16        6.0         8.4     24     2371           124 25.95 -30.10  1.02  1.30  0.71 0.99  8.87 -126.01 -4.39  89.76 211.99 -2.99 50.01 5.19
17        8.4         8.4     24     2395           140 22.76 -30.61  2.32  0.97 -0.06 2.85  6.54 -125.17 -0.74 119.21 161.73 -3.00 50.00 5.64
18       26.4         4.8     24     2441           222 27.45 -17.65 -5.25  7.49 -1.63 2.72  6.11 -137.65 -3.13 179.05 165.21 -3.18 50.01 5.06
19       27.6         3.6     24     2502           221 28.02 -15.62 -5.21  8.31 -0.30 2.80  8.98 -139.45 -4.25 128.53 163.12 -2.87 50.00 5.36
20       12.0        12.0     24     2687            62 19.40 -36.71  5.65 -3.48  0.31 0.13  5.91 -113.03 -3.53 105.19 235.38 -3.07 50.01 5.37
21       25.2         3.6     24     2304           225 30.08 -16.39 -5.35  8.08  0.39 2.36 10.73 -138.70 -4.95 102.04 175.04 -2.83 50.00 5.26

## get PITCHf/x data for dates between start_date and end_date
get_pitchfx(date_start = "2020-7-23", date_end = "2020-7-24")

## get PITCHf/x data for single game
get_pitchfx(game_id = "630851")

```

Function `get_game_id(date_start, date_end, game_id)`
```r
## get game_ids for one specific day
get_game_ids(date_start = "2020-7-23")
[1] 630851 631377

## get game_ids for dates between start_date and end_date
get_game_ids(date_start = "2020-7-23", date_end = "2020-7-24")
[1] 630851 631377 631242 631589 630966 631121 631563 631641 631664 630941 631514 630989 631091 631438 631378 631182
```

## Important Notes

I have to mention, it will be really slow if you want to scrape whole season. It will be better to use to obtain a short period of PITCHf/x data by calling `get_pitchfx` directly unless you have supreme computation on your laptop, or you will spend nearly a whole day to scrape a season even as short as season 2020.

I will probably update two feautures in the future if I'm still interested in PITCHf/x in the future.
- Multithreading (Boost the speed)
- Floating Proxy IP pools (Handle blocked-ip by excessive requesting)

You have an alternative to use `google cloud platform` and to rent a GPU if you want to get the data quickly.

## Contact 
Contact me via jaunechen@qq.com if you have troubles using this rpackage, or pulling requests on issues tabs directly. 
