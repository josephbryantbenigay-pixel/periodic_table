#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

ARG=$1

# If argument is number
if [[ $ARG =~ ^[0-9]+$ ]]
then
  CONDITION="e.atomic_number = $ARG"
# If argument is symbol (1–2 letters)
elif [[ $ARG =~ ^[A-Za-z]{1,2}$ ]]
then
  CONDITION="e.symbol = '$ARG'"
# Otherwise assume name
else
  CONDITION="e.name = '$ARG'"
fi

ELEMENT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius 
FROM elements e
JOIN properties p ON e.atomic_number = p.atomic_number
JOIN types t ON p.type_id = t.type_id
WHERE $CONDITION;")

if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
  exit
fi

IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELT BOIL <<< "$ELEMENT"

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."

