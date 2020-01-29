mongoimport -h ds031271.mlab.com:31271 \
    -d backpack \
    -c transactions \
    -u $1 -p $2 \
    --file Budget\
    - Transactions.csv \
    --type csv \
    --headerline