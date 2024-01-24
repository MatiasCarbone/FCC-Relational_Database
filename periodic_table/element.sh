#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  else
  
  COMMON_PART="SELECT * FROM elements 
    FULL JOIN properties USING(atomic_number) 
    LEFT JOIN types USING(type_id)"

  if [[ $1 =~ ^[0-9] ]]
  then
    QUERY=$($PSQL "$COMMON_PART WHERE atomic_number = $1")
  else
    if [[ $1 =~ ^[A-Za-z]{3,20} ]]
    then
      QUERY=$($PSQL "$COMMON_PART WHERE name = '$1'")
    else
      if [[ $1 =~ ^[A-Z]{1}[a-z]? ]]
      then
        QUERY=$($PSQL "$COMMON_PART WHERE symbol = '$1'")
      fi
    fi
  fi

  if [[ -z $QUERY ]]
  then
    echo "I could not find that element in the database."
  else
    read _ _ NUMBER _ SYMBOL _ NAME _ MASS _ MELTING _ BOILING _ TYPE <<< $QUERY
    echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  fi
fi

