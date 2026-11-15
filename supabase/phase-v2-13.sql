-- Phase v2-13: transfers inside the same account (two bank accounts kept in one asset).
-- Safe to run twice. It only RELAXES one rule: before, a transfer had to go to a different
-- account; now origin and destination may be the same. No data is touched.
-- Run it in the SQL Editor of BOTH Supabase projects (the real one and the demo one),
-- BEFORE merging the code.
begin;

alter table public.movements drop constraint if exists movements_transfer_check;
alter table public.movements add constraint movements_transfer_check CHECK ((((type = 'transfer'::text) AND (target_account_id IS NOT NULL)) OR ((type <> 'transfer'::text) AND (target_account_id IS NULL))));

commit;

-- Check (read only): the constraint must no longer mention "<>" between the two accounts.
select pg_get_constraintdef(oid) as definition
from pg_constraint
where conname = 'movements_transfer_check' and conrelid = 'public.movements'::regclass;
