#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME

NAME=$($PSQL "SELECT name FROM users WHERE name = '$USERNAME'")

if [[ -z $NAME ]]
then
  INSERT_NAME=$($PSQL "INSERT INTO users(name) VALUES('$USERNAME')")
  echo "$USERNAME inserted into users"
else
  echo "Welcom back, $NAME! You have played 
fi