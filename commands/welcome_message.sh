#! usr/bin/env bash

hour=$(date +"%H")

# bash comparisons treat numbers as strings sometimes.
# to avoid issues, remove any leading zeros from the hour.
hour=$(echo $hour | sed 's/^0*//')

# convert hour to a number
hour=$((10#$hour))

# Check the hour to determine the appropriate greeting
if [ "$hour" -lt 12 ]; then
  echo "Bonjour, Monsieur"
elif [ "$hour" -gt 12 ] && [ "$hour" -lt 17 ]; then
  echo "Guten Tag, Herr Pontius"
else
  echo "Bonsoir, Monsieur"
fi