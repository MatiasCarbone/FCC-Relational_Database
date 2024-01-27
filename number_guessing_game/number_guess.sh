#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

random_number=$((1 + $RANDOM % 1000))

echo -e "\nEnter your username:"
read username

user_query=$($PSQL "SELECT user_id FROM users WHERE username='$username'")

if [[ -z $user_query ]]
then
  echo "Welcome, $username! It looks like this is your first time here."
  user_insert_result=$($PSQL "INSERT INTO users(username) VALUES('$username')")
  user_query=$($PSQL "SELECT user_id FROM users WHERE username='$username'")
else
  games_played=$($PSQL "SELECT COUNT(length) FROM games WHERE user_id=$user_query")
  best_game=$($PSQL "SELECT MIN(length) FROM games WHERE user_id=$user_query")
  
  echo "Welcome back, $username! You have played $games_played games, and your best game took $best_game guesses."
fi

echo "Guess the secret number between 1 and 1000:"
read number_input

tries=1
while [ True ]
do
  if [[ ! "$number_input" =~ ^[0-9]+$ ]]; 
  then 
    echo "That is not an integer, guess again:"
    read number_input
  else
    if [[ $number_input > $random_number ]]
    then
      echo "It's lower than that, guess again:"
      read number_input
    else
      if [[ $number_input < $random_number ]]
      then
        echo "It's higher than that, guess again:"
        read number_input
      else
        echo "You guessed it in $tries tries. The secret number was $random_number. Nice job!"
        games_insert_result=$($PSQL "INSERT INTO games(user_id, length) VALUES($user_query, $tries)")
        break
      fi
    fi
  fi
  tries=$(($tries + 1))
done