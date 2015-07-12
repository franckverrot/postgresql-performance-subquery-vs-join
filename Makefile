psql < prepare_tables.sql
./run_benchmarks.sh
R --slave --no-restore-data -f analyze_data.r
