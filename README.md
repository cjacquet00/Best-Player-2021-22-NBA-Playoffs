# NBA Playoffs Analysis

This R script performs an analysis of NBA playoff player statistics for the 2021-2022 season. The script covers offensive and defensive player analysis, conference finalists, conference winners, and a logistic regression model predicting the best team and player based on various statistics.

## Data Loading and Cleaning

The script loads NBA playoff player statistics from a CSV file, replacing "?" in the "Player" column with "c" using `gsub()`.

## Offensive Player Analysis

The script identifies the top offensive players based on points (PTS), rebounds (TRB), and assists (AST). It calculates a score for each player and creates a bar chart displaying the top 5 offensive players.

## Defensive Player Analysis

Similarly, the script identifies the top defensive players based on blocks (BLK), rebounds (TRB), steals (STL), and personal fouls (PF). It calculates a score for each player and creates a bar chart displaying the top 5 defensive players.

## Conference Finalists

The script filters teams from the Western and Eastern conferences that played at least 17 games. It creates bar charts to display the number of games played by each team in the conference finals.

## Conference Winners

Separate bar charts are created for the Western and Eastern Conference winners, highlighting the number of games played.

## Logistic Regression Model

The script uses a logistic regression model to predict the best team and player based on player statistics. Two models are applied, one using basic statistics (PTS, TRB, AST, BLK, STL, PF) and another using percentages (FGP, THPP, TPP, eFGP, FTP, PTS).

The predicted best player on the best team is highlighted in a bar chart alongside other top players.

Feel free to explore the script, modify it, and provide feedback!
