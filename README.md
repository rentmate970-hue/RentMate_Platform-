# RentMate
**Meet. Connect. Experience.**

India-first, 18+ dating, friendship, communities and strictly non-sexual paid companionship for public/social activities.

## Status
This is a deployable development foundation, not a legally approved or commercially launch-ready marketplace. OTP delivery, identity verification, payment processing, LiveKit credentials, moderation operations and companion payouts require provider configuration, security testing and Indian legal review.

## Stack
- Next.js App Router + TypeScript
- Supabase Auth/Postgres
- SQL migrations with RLS baseline
- Render deployment configuration
- LiveKit integration points (not enabled until configured)

## Local setup
1. Install Node.js 20.6+.
2. `cp .env.example .env.local` and fill Supabase values.
3. `npm install`
4. `npm run dev`
5. Apply `supabase/migrations/0001_initial.sql` to a **new RentMate Supabase project**, after reviewing it.

## Deployment
See `docs/DEPLOYMENT.md`. Do not connect production payments or companion settlements until counsel and payment provider approve the model. Do not put service-role keys in browser variables.

## Non-negotiable product safeguards
- Adults 18+ only; do not enable paid bookings until verification and legal gates pass.
- Companion services are strictly non-sexual and limited to lawful public/social activities.
- No cash-value wallet, deposits, withdrawals or cash-out of member tokens in this starter.
- Keep token credits, booking value, platform revenue and companion payable accounting separate.
- Enforce booking conflicts and ownership on the server/database, not only in UI.
- No public identity documents, exact home addresses, or another buyer's booking details.
- Founder approval required for spending, hiring, production releases, payment activation and payouts.
