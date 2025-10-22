#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Set Secret number
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))
echo $SECRET_NUMBER

# Get user name
echo "Enter your username:"
read USERNAME

USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

# check if user is in db
if [[ -z $USER_ID ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  # insert the user
  USER_ID=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  
# else user in db
else
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id=$USER_ID")
  BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games WHERE user_id=$USER_ID")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# guessing game
GUESS_COUNT=0
CORRECT_GUESS=false

echo "Guess the secret number between 1 and 1000:"

while ! $CORRECT_GUESS
do
  read GUESS
  
  # Check if input is an integer
  if [[ ! $GUESS =~ ^-?[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
    continue
  fi
  ((GUESS_COUNT++))
  
  if [[ $GUESS -eq $SECRET_NUMBER ]]
  then
    CORRECT_GUESS=true
    # Save game result
    $PSQL "INSERT INTO games(user_id, guesses, secret_number) VALUES($USER_ID, $GUESS_COUNT, $SECRET_NUMBER)" > /dev/null
    echo "You guessed it in $GUESS_COUNT tries. The secret number was $SECRET_NUMBER. Nice job!"
  elif [[ $GUESS -gt $SECRET_NUMBER ]]
  then
    echo "It's lower than that, guess again:"
  else
    echo "It's higher than that, guess again:"
  fi
done