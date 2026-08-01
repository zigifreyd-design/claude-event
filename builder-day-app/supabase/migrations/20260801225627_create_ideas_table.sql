-- Create the ideas table, seeded with 3 example app ideas.
create table if not exists ideas (
  id bigint primary key generated always as identity,
  title text not null,
  created_at timestamptz default now()
);

-- Guard the seed so it only runs once, even if the table already has rows
-- (e.g. from running this by hand before the CLI could push it).
insert into ideas (title)
select title from (
  values
    ('An app that rates my coffee'),
    ('AI plant doctor'),
    ('Split the bill without the math')
) as seed(title)
where not exists (select 1 from ideas);

-- Lock the table down: RLS on, no policies. The public Data API returns
-- nothing for this table — only our backend, using the secret key, can
-- read or write it.
alter table ideas enable row level security;
