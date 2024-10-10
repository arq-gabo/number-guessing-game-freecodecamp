#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Function for handling the username
USER_NAME(){
  echo "Enter your username:"
  read INPUT
  # If input is greater than 22 or is empty
  if [ ${#INPUT} -gt 22 ] || [[ -z $INPUT ]]
  then
    echo "Please enter a valid username"
    USER_NAME
  else
    # Show username data
    USER_DATA=$($PSQL "SELECT * FROM number_guessing_game WHERE username = '$INPUT'")
  fi
}

GUESS_NUMBER(){
  # Variables from MAIN_MENU function with reference to the current game
  RANDOM_NUMBER_ARG=$1
  IS_PLAYING_ARG=$2
  NUMBER_OF_GUESSES_ARG=$3
  
  # Variables from MAIN_MENU function with reference to user
  USERNAME_ARG=$4
  GAMES_PLAYED_ARG=$5
  BEST_GAME_ARG=$6

  # Number Input
  read NUMBER

  # If the user enters an input, the game starts
  IS_PLAYING_ARG=true
  
  # If the input is invalid
  if [[ ! $NUMBER =~ ^[0-9]+$ ]]
  then
    echo -e "That is not an integer, guess again:"
    GUESS_NUMBER $RANDOM_NUMBER_ARG $IS_PLAYING_ARG $NUMBER_OF_GUESSES_ARG $USERNAME_ARG $GAMES_PLAYED_ARG $BEST_GAME_ARG
  # If the input is valid
  else
    # Add one to number of guesses
    NUMBER_OF_GUESSES_ARG=$((NUMBER_OF_GUESSES_ARG+1))
    # If the number is greater than the random number
    if (( $NUMBER > $RANDOM_NUMBER_ARG ))
    then
      echo -e "It's lower than that, guess again:"
      GUESS_NUMBER $RANDOM_NUMBER_ARG $IS_PLAYING_ARG $NUMBER_OF_GUESSES_ARG $USERNAME_ARG $GAMES_PLAYED_ARG $BEST_GAME_ARG
    # if the number is less than the random number
    elif (( $NUMBER < $RANDOM_NUMBER_ARG ))
    then
      echo -e "It's higher than that, guess again:"
      GUESS_NUMBER $RANDOM_NUMBER_ARG $IS_PLAYING_ARG $NUMBER_OF_GUESSES_ARG $USERNAME_ARG $GAMES_PLAYED_ARG $BEST_GAME_ARG
    # if you catch the random number
    else
      # If the user entered an entry, we add 1 to the times he has played
      GAMES_PLAYED_DATA=$([ "$IS_PLAYING_ARG" == true ] && echo $((GAMES_PLAYED_ARG+1)) || echo $GAMES_PLAYED_ARG)
      # Times the user has tried to guess the number, if they have not played before the best game will be the number of times they have tried
      # If the user has played before, the least number of times he has tried will be sent to the database.
      BEST_GAME_DATA=$([ $BEST_GAME_ARG == 0 ] && echo $NUMBER_OF_GUESSES_ARG || ([ "$BEST_GAME_ARG" -gt "$NUMBER_OF_GUESSES_ARG" ] && echo $NUMBER_OF_GUESSES_ARG || echo $BEST_GAME_ARG ))

      # We update the row username
      UPDATE_USER_DATA=$($PSQL "UPDATE number_guessing_game SET games_played = $GAMES_PLAYED_DATA, best_game = $BEST_GAME_DATA WHERE username = '$USERNAME_ARG'";)
      if [[ $UPDATE_USER_DATA = 'UPDATE 1' ]]
      then
        echo -e "You guessed it in $NUMBER_OF_GUESSES_ARG tries. The secret number was $RANDOM_NUMBER_ARG. Nice job!"
      fi
    fi
  fi
}

MAIN_MENU(){
  # Generate random number
  RANDOM_NUMBER=$(shuf -i 1-1000 -n 1)
  IS_PLAYING=false
  NUMBER_OF_GUESSES=0

  # Call function for handling the username an cast username data string to array
  USER_NAME
  IFS='|' read -a USER_ARR <<< $USER_DATA
  USERNAME=${USER_ARR[0]}
  GAMES_PLAYED=${USER_ARR[1]}
  BEST_GAME=${USER_ARR[2]}

  # if username exist
  if [[ -z $USER_DATA ]]
  then
    # Send data to database
    USER_SAVED_RESULT=$($PSQL "INSERT INTO number_guessing_game(username) VALUES('$INPUT')")
    if [[ $USER_SAVED_RESULT = 'INSERT 0 1' ]]
    then
      echo -e "Welcome, $INPUT! It looks like this is your first time here."
      USERNAME=$INPUT
      GAMES_PLAYED=0
      BEST_GAME=0
    fi
  else
    echo -e "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  fi

  # After greeting the user we start playing by calling the function GUESS_NUMBER
  echo -e "Guess the secret number between 1 and 1000:"
  GUESS_NUMBER $RANDOM_NUMBER $IS_PLAYING $NUMBER_OF_GUESSES $USERNAME $GAMES_PLAYED $BEST_GAME
}

MAIN_MENU
