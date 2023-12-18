#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    # get winner_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    #if not found
    if [[ -z $WINNER_ID ]]
    then
      # insert winner_id
      INS_WIN_ID=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")
      echo $INS_WIN_ID

      if [[ $INS_WIN_ID == "INSERT 0 1" ]]
      then
        echo Inserted team $WINNER
      fi
    fi

    # get opponent_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    if [[ -z $OPPONENT_ID ]]
    then
      INS_OPP_ID=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")
      echo $INS_OPP_ID

      if [[ $INS_OPP_ID == "INSERT 0 1" ]]
      then
        echo Inserted team $OPPONENT
      fi
    fi

    # get game_id
    GAME_ID=$($PSQL "SELECT game_id FROM games")

    # get the winner_id from winner team name in the file games.csv
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    # get the opponent_id from opponent team name in the file games.csv
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    INS_GAME=$($PSQL "INSERT INTO games (year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    echo $INS_GAME
    echo $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS

  fi
done
