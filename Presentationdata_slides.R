library(dplyr)
library(rpart)
library(rpart.plot)
library(ggplot2)
library(glmnet)




nbaplayoffs = read.csv("~/Desktop/School Files/CSUN/CSUN 2022-23/BANA 320/2021-2022NBAPlayerStatsPlayoffs.csv")

# Use the gsub() function to replace the ? with c in the "Player" column, had players in the data set that had ? instead of C in their names
nbaplayoffs$Player = gsub("\\?", "c", nbaplayoffs$Player)


#Find the best offensive players in the playoff using points, rebounds, and assist
playersOffense = subset(nbaplayoffs, PTS >= 20 & TRB >= 5 & AST >= 5)

# Add up the scores for each player
playersOffense$score = playersOffense$PTS + playersOffense$TRB + playersOffense$AST

# Sort the players by score in descending order
playersOffense = playersOffense[order(playersOffense$score, decreasing = TRUE), ]

# Show the top 5 players
showOffense = head(playersOffense, 5)
print(showOffense)

# Create a bar chart for the top 5 players Offense
topFivePlayersOffense = head(playersOffense, 5)
ggplot(topFivePlayersOffense, aes(x = reorder(Player, -score), y = score)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  xlab("Player") + ylab("Total Score") +
  ggtitle("Top 5 Players in the NBA 2021-22 Playoffs Offensively")

#Find the best defensive players in the playoff using blocks, rebounds, steals, and personal fouls
playersDefense = subset(nbaplayoffs, BLK >= 0.1 & TRB >= 8 & STL >= 0.1 & PF <= 4)

# Add up the scores for each player
playersDefense$score = playersDefense$BLK + playersDefense$TRB + playersDefense$STL 

# Sort the players by score in descending order
playersDefense = playersDefense[order(playersDefense$score, decreasing = TRUE), ]

# Show the top 5 players
showDefense = head(playersDefense, 5)
print(showDefense)


# Filter Teams with G >= 17 and Tm equals DAL or GSW
westernConference = subset(nbaplayoffs, G >= 17 & Tm %in% c("DAL", "GSW"))

#Create a bar chart to display the Western Confrence finalist and how many games they played
westernConfrencePlot = ggplot(westernConference, aes(x = Tm, y = G, fill = Tm)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = G), position = position_stack(vjust = 0.5)) +
  scale_fill_manual(values = c("DAL" = "blue", "GSW" = "yellow")) +
  labs(x = NULL, y = "Games Played") +
  ggtitle("Western Conference Finals") +
  ylim(0, max(westernConference$G)) 
print(westernConfrencePlot)


# Filter Teams with G >= 17 and Tm equals MIA or BOS
easternConference = subset(nbaplayoffs, G >= 17 & Tm %in% c("MIA", "BOS"))

#Create a bar chart to display the Eastern Confrence finalist and how many games they played
easternConfrencePlot = ggplot(easternConference, aes(x = Tm, y = G, fill = Tm)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = G), position = position_stack(vjust = 0.5)) +
  scale_fill_manual(values = c("MIA" = "red", "BOS" = "green")) +
  labs(x = NULL, y = "Games Played") +
  ggtitle("Eastern Conference Finals") +
  ylim(0, max(easternConference$G)) 

print(easternConfrencePlot)


westernConference2 = subset(nbaplayoffs, G >= 20 & Tm %in% c("GSW"))

#Create a bar chart to display the Western Conference winner and how many games they played
westernConfrencePlot2 = ggplot(westernConference2, aes(x = Tm, y = G, fill = Tm)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = G), position = position_stack(vjust = 0.5)) +
  scale_fill_manual(values = c("GSW" = "yellow")) +
  labs(x = NULL, y = "Games Played") +
  ggtitle("Western Confrence Finals Champs") +
  ylim(0, max(westernConference2$G)) 
print(westernConfrencePlot2)


# Filter Teams with G >= 20 and Tm equals BOS
easternConference2 = subset(nbaplayoffs, G >= 17 & Tm %in% c("BOS"))

#Create a bar chart to display the Eastern Conference winner and how many games they played
easternConfrencePlot2 = ggplot(easternConference2, aes(x = Tm, y = G, fill = Tm)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = G), position = position_stack(vjust = 0.5)) +
  scale_fill_manual(values = c("BOS" = "green")) +
  labs(x = NULL, y = "Games Played") +
  ggtitle("Eastern Confrence Finals Champs") +
  ylim(0, max(easternConference2$G)) 

print(easternConfrencePlot2)

  
# Subset the data to include teams who have won at least 20 games
finalsTeam = subset(nbaplayoffs, G >= 20)

# Create a binary variable using as.numeric to find if the best team and the best player on it 
finalsTeam$bestTeam = as.numeric(finalsTeam$Tm == "GSW", "BOS")

# Using a logistic regression model to predict the best team based on player with the best sum statistics
logModel = glm(bestTeam ~ PTS + TRB + AST + BLK + STL - PF, data = finalsTeam, family = "binomial")

# Predict the Best player on the best team based on the model
bestPlayer = finalsTeam[which.max(predict(logModel)), "Player"]
bestTeam = ifelse(predict(logModel, type = "response") > 0.5, "GSW", "BOS")

# Create a data frame with the top player on best team
topPlayers = finalsTeam %>%
  group_by(Tm) %>%
  top_n(1, PTS)

# Create a bar chart with the top players on each team, and highlight the best player on the predicted best team
ggplot(topPlayers, aes(x = bestTeam, y = bestPlayer, fill = ifelse(Tm == "GSW" & Player == bestPlayer, "Best Player", "Top Player"))) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("Top Player" = "Blue", "Best Player" = "Yellow")) +
  labs(title = "Top Player on the Best Team",
       x = "Total Points Scored",
       y = "Player",
       fill = "") +
  theme_minimal() +
  theme(legend.position = "bottom")



# Subset the data to include teams who have won at least 20 games
finalsTeam2 = subset(nbaplayoffs, G >= 20)

# Create a binary variable using as.numeric to find if the best team and the best player on it 
finalsTeam2$bestTeam2 = as.numeric(finalsTeam2$Tm == "GSW", "BOS")

# Using a logistic regression model to predict the best team based on player with the best sum using percenatges, had to use the I function to create independent variables and agruments
logModel2 = glm(bestTeam2 ~ I(FGP >= 0.45) + I(THPP >= 0.38) + I(TPP >= 0.5) + I(eFGP >= 0.5) + I(FTP > 0.8) + I(PTS >= 25), data = finalsTeam2, family = "binomial")

# Predict the Best player on the best team based on the model
bestPlayer2 = finalsTeam2[which.max(predict(logModel2)), "Player"]
bestTeam2 = ifelse(predict(logModel2, type = "response") > 0.5, "GSW", "BOS")

# Create a data frame with the top players on best team
topPlayers = finalsTeam2 %>%
  group_by(Tm) %>%
  top_n(1, PTS)

# Create a bar chart with the top players on each team, and highlight the best player on the predicted best team
ggplot(topPlayers, aes(x = bestTeam2, y = bestPlayer2, fill = ifelse(Tm == "GSW" & Player == bestPlayer2, "Best Player", "Top Player"))) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("Best Player" = "Yellow")) +
  labs(title = "Top Player on the Best Team",
       x = "Total Points Scored",
       y = "Player",
       fill = "") +
  theme_minimal() +
  theme(legend.position = "bottom")










