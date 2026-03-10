#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Add Possession Usage
# @raycast.mode silent
# @raycast.packageName Database
# @raycast.argument1 { "type": "text", "placeholder": "Amount" }
# @raycast.argument2 { "type": "text", "placeholder": "Start Date (YYYY-MM-DD)" }
# @raycast.argument3 { "type": "text", "placeholder": "End Date (YYYY-MM-DD)" }

docker exec \
    -it hominem-postgres psql \ 
    -U postgres \
    -d postgres \ 
    -c "INSERT INTO possessions_usage (possession_id, type, amount, start_date, end_date) VALUES ('c8744876-2621-4828-900f-985777191ec6', 'pattern', $1, '$2', '$3');"
