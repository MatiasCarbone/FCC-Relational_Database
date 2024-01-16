#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE TABLE teams, games RESTART IDENTITY;")"

while IFS="," read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # Add each unique team to teams table
  echo "$($PSQL "INSERT INTO teams(name) VALUES('$WINNER') ON CONFLICT DO NOTHING")"
  echo "$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT') ON CONFLICT DO NOTHING")"

  # Add every row to games table
  WNN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  echo "$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id,winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WNN_ID, $OPP_ID, $WINNER_GOALS, $OPPONENT_GOALS)")"
done < <(tail -n +2 games.csv)