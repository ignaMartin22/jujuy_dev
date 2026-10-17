-- Tren Solar: las personas que se suman con GitHub viajan en los vagones de la home.
--
-- Correr una vez en Supabase → SQL Editor. Cómo configurar todo: README.md,
-- sección "Tren Solar".
--
-- El navegador nunca escribe en esta tabla: un trigger la llena con lo que
-- devuelve GitHub cuando alguien autoriza el login. Así nadie puede subir a
-- otra persona ni poner una imagen cualquiera.

create table if not exists public.tren_miembros (
  user_id      uuid primary key references auth.users (id) on delete cascade,
  github_id    bigint not null unique,
  github_login text not null,
  avatar_url   text not null,
  joined_at    timestamptz not null default now()
);

alter table public.tren_miembros enable row level security;

-- Cualquiera puede ver quién viaja (es lo que muestra la home).
drop policy if exists "tren: lectura pública" on public.tren_miembros;
create policy "tren: lectura pública" on public.tren_miembros
  for select to anon, authenticated using (true);

-- Cada persona puede bajarse del tren (borrar su propia fila).
drop policy if exists "tren: bajarse" on public.tren_miembros;
create policy "tren: bajarse" on public.tren_miembros
  for delete to authenticated using (auth.uid() = user_id);

-- Sube (o actualiza el avatar de) quien entra con GitHub.
create or replace function public.tren_subir()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  meta jsonb := new.raw_user_meta_data;
begin
  if coalesce(new.raw_app_meta_data ->> 'provider', '') <> 'github'
     or meta ->> 'provider_id' is null
     or coalesce(meta ->> 'avatar_url', '') not like 'https://avatars.githubusercontent.com/%' then
    return new;
  end if;

  insert into public.tren_miembros (user_id, github_id, github_login, avatar_url)
  values (new.id, (meta ->> 'provider_id')::bigint, meta ->> 'user_name', meta ->> 'avatar_url')
  on conflict (user_id) do update
    set github_login = excluded.github_login,
        avatar_url   = excluded.avatar_url;
  return new;
end;
$$;

drop trigger if exists tren_subir_al_crear on auth.users;
create trigger tren_subir_al_crear
  after insert on auth.users
  for each row execute function public.tren_subir();

-- Every GitHub login refreshes the metadata, so a new avatar shows up too.
drop trigger if exists tren_subir_al_entrar on auth.users;
create trigger tren_subir_al_entrar
  after update of raw_user_meta_data on auth.users
  for each row execute function public.tren_subir();
