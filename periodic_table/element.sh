#!/bin/bash
# element.sh - freeCodeCamp Periodic Table solution
PSQL="psql --username=freecodecamp --dbname=periodic_table -t -A -F '|' -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument"
  exit 0
fi

INPUT="$1"

# Determine whether input is atomic number (integer) or symbol/name
if [[ $INPUT =~ ^[0-9]+$ ]]
then
  QUERY="SELECT e.atomic_number,e.symbol,e.name,t.type,p.atomic_mass,p.melting_point_celsius,p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number=p.atomic_number JOIN types t ON p.type_id=t.type_id WHERE e.atomic_number=$INPUT;"
else
  # Use ILIKE for case-insensitive match
  QUERY="SELECT e.atomic_number,e.symbol,e.name,t.type,p.atomic_mass,p.melting_point_celsius,p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number=p.atomic_number JOIN types t ON p.type_id=t.type_id WHERE e.symbol ILIKE '$INPUT' OR e.name ILIKE '$INPUT';"
fi

RESULT=$($PSQL "$QUERY")

if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
  exit 0
fi

IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING BOILING <<< "$RESULT"

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
