# Architecture and implementation map

## Current implementation
- Next.js landing page and a disabled login placeholder.
- Supabase browser/server client helpers.
- Initial PostgreSQL schema for profiles, listings, bookings, ledgers and reports.
- Database exclusion constraint to prevent overlapping active companion bookings.
- RLS baseline; sensitive mutations intentionally have no client-write policy.

## Still required before launch
1. Supabase phone OTP configuration, SMS provider and rate limits.
2. Secure profile onboarding, age/identity verification and account deletion.
3. Server-only booking hold/confirm/cancel/reschedule RPCs with transaction tests.
4. Payment provider integration and verified webhook handling (after legal approval).
5. Moderation console, report/block flows, incident response and support tooling.
6. Calendar integration, notifications, reminders and timezone/DST tests.
7. LiveKit token service with short-lived grants, participant authorization and billing only after explicit disclosure/consent.
8. Automated tests, accessibility, penetration test and privacy review.

## Money and token boundary
The starter does not implement real-money deposits, withdrawals, token purchase or companion payouts. Keep token accounting separate from booking GMV, platform revenue, gateway collections, tax and companion payable records.
