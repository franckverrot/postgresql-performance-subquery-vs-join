drop table posts; drop table comments;
create table posts as (select generate_series id from generate_series(1,500));
create unique index unique_post on posts (id);
create table comments as (select ((generate_series % 500)) post_id from generate_series(1,50000));
