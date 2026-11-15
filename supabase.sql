-- Darčeková stránka: tabuľka rezervácií.
-- Spusti raz v Supabase → SQL Editor → New query → Run.

create table if not exists public.rezervacie (
  polozka    text primary key,                                   -- id položky; primary key = nikto ju nezarezervuje dvakrát
  meno       text not null check (char_length(meno) between 1 and 40),
  sprava     text check (sprava is null or char_length(sprava) <= 300),
  suma       numeric(8,2),
  created_at timestamptz not null default now()
);

alter table public.rezervacie enable row level security;

-- Ktokoľvek s odkazom môže čítať rezervácie a pridať novú.
-- Meniť ani mazať nemôže nikto zo stránky – to robíš len ty v Supabase (Table Editor).
drop policy if exists "citat rezervacie" on public.rezervacie;
create policy "citat rezervacie" on public.rezervacie
  for select to anon using (true);

drop policy if exists "pridat rezervaciu" on public.rezervacie;
create policy "pridat rezervaciu" on public.rezervacie
  for insert to anon with check (true);
