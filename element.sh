#!/bin/bash

#Periodic table
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

QUESTION=$1
TEMA () {
  if [[ -z $QUESTION ]]
  then
    echo Please provide an element as an argument.
  else 
    if [[ $QUESTION =~ ^[0-9]+$ && $QUESTION -le 10 ]]
    then
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM properties WHERE atomic_number=$QUESTION")
      NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$QUESTION")
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$QUESTION")
      TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$QUESTION")
      ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$QUESTION")
      MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$QUESTION")
      BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$QUESTION")
      TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    else 
      LENGTH=$(echo "$QUESTION" | wc -m)
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$QUESTION'")
      if [[ -n $SYMBOL && $LENGTH -le 2 ]]
      then
        SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$QUESTION'")
        ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$SYMBOL'")
        NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
        TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
        ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
        MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
        BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
        TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      else
        CONTROL=$($PSQL "SELECT name FROM elements WHERE name ILIKE '$QUESTION%'")
        if [[ -z $CONTROL ]]
        then
          echo I could not find that element in the database.
        else
          NAME=$($PSQL "SELECT name FROM elements WHERE name='$CONTROL'")
          ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$NAME'")
          SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
          TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
          ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
          MELTING=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
          BOILING=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
          TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
          echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
        fi
      fi
    fi  
  fi
}

TEMA
