-- División Imposible · ranking (proxecto xogos, prefixo dimp_)
create table if not exists public.dimp_ranking (
  id bigint generated always as identity primary key,
  dia date not null,
  nome text not null check (char_length(nome) between 1 and 20),
  puntos int not null check (puntos between 0 and 100),
  pratos jsonb,
  lingua text,
  vegano boolean not null default false,
  device text not null,
  creado timestamptz not null default now(),
  unique (dia, device)
);
alter table public.dimp_ranking add column if not exists vegano boolean not null default false;
create index if not exists dimp_ranking_dia_idx on public.dimp_ranking (dia, puntos desc);
alter table public.dimp_ranking enable row level security;
drop policy if exists "dimp ler" on public.dimp_ranking;
create policy "dimp ler" on public.dimp_ranking for select using (true);
drop policy if exists "dimp anotar" on public.dimp_ranking;
create policy "dimp anotar" on public.dimp_ranking for insert
  with check (dia between current_date - 1 and current_date + 1);
