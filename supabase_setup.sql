-- AWB quiz: run once in Supabase Dashboard > SQL Editor > New query > Run
create table if not exists public.quiz_submissions (
  id bigint generated always as identity primary key,
  created_at timestamptz not null default now(),
  name text not null check (char_length(name) between 1 and 20),
  score int not null check (score between 0 and 100),
  correct int not null check (correct between 0 and 15),
  answers text not null check (char_length(answers) = 15),
  code text not null check (char_length(code) <= 40),
  duration_sec int check (duration_sec between 0 and 86400),
  device text check (char_length(device) <= 20),
  user_agent text check (char_length(user_agent) <= 300)
);

create table if not exists public.quiz_visits (
  id bigint generated always as identity primary key,
  created_at timestamptz not null default now(),
  visitor_id text check (char_length(visitor_id) <= 40),
  device text check (char_length(device) <= 20)
);

alter table public.quiz_submissions enable row level security;
alter table public.quiz_visits enable row level security;

-- Visitors may only add rows; no read, update or delete policy exists for them.
drop policy if exists "anon insert submissions" on public.quiz_submissions;
create policy "anon insert submissions" on public.quiz_submissions
  for insert to anon with check (true);
drop policy if exists "anon insert visits" on public.quiz_visits;
create policy "anon insert visits" on public.quiz_visits
  for insert to anon with check (true);

grant insert on public.quiz_submissions, public.quiz_visits to anon;
revoke select, update, delete on public.quiz_submissions, public.quiz_visits from anon;
