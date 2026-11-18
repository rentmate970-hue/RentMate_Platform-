-- RentMate foundational schema. Review and apply only to a dedicated RentMate project.
create extension if not exists pgcrypto;
create extension if not exists btree_gist;

create type public.profile_status as enum ('pending','active','suspended','deleted');
create type public.booking_status as enum ('requested','pending_payment','held','confirmed','in_progress','completed','cancelled','expired','disputed','refunded');

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null check (char_length(display_name) between 1 and 60),
  date_of_birth date,
  is_adult_verified boolean not null default false,
  status public.profile_status not null default 'pending',
  bio text check (char_length(coalesce(bio,'')) <= 1000),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.companion_listings (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.profiles(id),
  title text not null check (char_length(title) between 5 and 100),
  description text not null check (char_length(description) <= 2000),
  activity_type text not null check (activity_type in ('coffee','dining','movie','public_event','sports','gaming','other_public_activity')),
  price_minor bigint not null check (price_minor >= 0),
  duration_minutes integer not null check (duration_minutes between 30 and 720),
  city text not null,
  active boolean not null default false,
  created_at timestamptz not null default now()
);

create table public.bookings (
  id uuid primary key default gen_random_uuid(),
  listing_id uuid not null references public.companion_listings(id),
  buyer_id uuid not null references public.profiles(id),
  companion_id uuid not null references public.profiles(id),
  starts_at timestamptz not null,
  ends_at timestamptz not null,
  status public.booking_status not null default 'requested',
  hold_expires_at timestamptz,
  total_price_minor bigint not null check (total_price_minor >= 0),
  currency char(3) not null default 'INR',
  created_at timestamptz not null default now(),
  check (ends_at > starts_at),
  check (buyer_id <> companion_id)
);

-- Prevent overlapping confirmed/held/in-progress bookings for a companion.
-- Use a transaction and verify payment before transitioning HELD -> CONFIRMED.
alter table public.bookings add constraint no_companion_booking_overlap
exclude using gist (
  companion_id with =,
  tstzrange(starts_at, ends_at, '[)') with &&
) where (status in ('held','confirmed','in_progress'));

create table public.wallet_ledger (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id),
  entry_type text not null check (entry_type in ('credit','debit','adjustment','refund')),
  amount_tokens bigint not null check (amount_tokens > 0),
  reference_type text not null,
  reference_id uuid,
  idempotency_key text not null unique,
  note text,
  created_at timestamptz not null default now()
);

create table public.booking_financial_ledger (
  id uuid primary key default gen_random_uuid(),
  booking_id uuid not null references public.bookings(id),
  entry_type text not null check (entry_type in ('booking_gross','platform_commission','companion_payable','gateway_fee','tax','refund')),
  amount_minor bigint not null check (amount_minor >= 0),
  currency char(3) not null default 'INR',
  created_at timestamptz not null default now()
);

create table public.reports (
  id uuid primary key default gen_random_uuid(),
  reporter_id uuid not null references public.profiles(id),
  reported_user_id uuid references public.profiles(id),
  booking_id uuid references public.bookings(id),
  category text not null,
  details text check (char_length(coalesce(details,'')) <= 3000),
  status text not null default 'open' check (status in ('open','reviewing','resolved','dismissed')),
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.companion_listings enable row level security;
alter table public.bookings enable row level security;
alter table public.wallet_ledger enable row level security;
alter table public.booking_financial_ledger enable row level security;
alter table public.reports enable row level security;

create policy "profiles readable by owner" on public.profiles for select using (auth.uid() = id);
create policy "profiles update by owner" on public.profiles for update using (auth.uid() = id) with check (auth.uid() = id);
create policy "active listings visible" on public.companion_listings for select using (active = true);
create policy "listing owner reads own" on public.companion_listings for select using (auth.uid() = owner_id);
create policy "listing owner manages own" on public.companion_listings for all using (auth.uid() = owner_id) with check (auth.uid() = owner_id);
create policy "booking parties read booking" on public.bookings for select using (auth.uid() = buyer_id or auth.uid() = companion_id);
create policy "wallet owner reads ledger" on public.wallet_ledger for select using (auth.uid() = user_id);
create policy "financial ledger parties read" on public.booking_financial_ledger for select using (
  exists(select 1 from public.bookings b where b.id = booking_id and (b.buyer_id = auth.uid() or b.companion_id = auth.uid()))
);
create policy "reporter reads own reports" on public.reports for select using (auth.uid() = reporter_id);
create policy "reporter creates report" on public.reports for insert with check (auth.uid() = reporter_id);

-- IMPORTANT:
-- No client-side INSERT/UPDATE policies are provided for bookings or ledgers.
-- Mutations must be implemented in trusted server-side functions after authorization,
-- payment verification, idempotency checks and legal approval.
