# Deployment guide

## GitHub
1. Upload this project to `rentmate970-hue/RentMate-platform-`.
2. Keep `main` protected. Create a development branch for ongoing work.
3. Never commit `.env.local`, service-role keys, LiveKit secrets, OTP keys or payment secrets.

## Supabase
1. Create a separate RentMate project in the RentMate organization; choose Mumbai (`ap-south-1`) if available.
2. Review `supabase/migrations/0001_initial.sql` before applying.
3. Enable phone authentication only after configuring a verified SMS provider and abuse controls.
4. Keep service-role keys server-side only. Verify RLS with tests before adding real user data.

## Render
1. Create a Web Service connected to this repository.
2. Runtime: Node. Build: `npm ci && npm run build`. Start: `npm start`.
3. Add `NEXT_PUBLIC_APP_URL`, `NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY` as environment variables.
4. Do not add unused secrets. Do not enable automatic production deployment until founder approves.
5. Verify preview/staging before production.

## Launch gate
Do not enable paid bookings, payment settlement, companion payouts or public commercial launch until Indian counsel, CA, payment provider, security and safety reviews are complete.
