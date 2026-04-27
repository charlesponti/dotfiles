#!/bin/bash

docker exec hominem-postgres pg_dump -U postgres postgres > ~/backups/db_$(date +%Y%m%d_%H%M%S).sql
