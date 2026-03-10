#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title DB Snapshot
# @raycast.mode silent
# @raycast.packageName Database

docker exec hominem-postgres pg_dump -U postgres postgres > ~/backups/db_$(date +%Y%m%d_%H%M%S).sql
