#!/usr/bin/env zsh
# Remove old files
rm -f log_join
rm -f log_subquery

# Prepare headers
echo "strategy,number_of_records,time" >> log_join
cp log_join log_subquery

for limit in `seq 1 201`
do
  execute="| psql | grep "Execution time" | sed -e 's/ Execution time: \([0-9.]*\).*/\1/g'"
  # join
  local join=`echo "explain analyze select p.id, count(1) from posts p left outer join comments c on p.id = c.post_id group by 1 limit $limit;" $execute`
  echo "join,$limit,$join" >> log_join

  # subquery
  local subquery=`echo "explain analyze select p.id, (select count(1) from comments c where c.post_id = p.id) from posts p limit $limit;" $execute`
  echo "subquery,$limit,$subquery" >> log_subquery
done
