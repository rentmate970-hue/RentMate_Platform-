# Security baseline

- Enforce 18+ eligibility server-side; UI age checkbox is not verification.
- Require verified phone and appropriate identity/age verification before listing/booking activation.
- Use MFA for administrators and server-enforced role checks.
- RLS on every user-owned table; test cross-user access denial.
- Never expose Supabase service-role key in browser code.
- Use short-lived signed URLs for private verification media; restrict access to authorized reviewers.
- Add rate limits for OTP, login, messaging, booking, reporting and search.
- Verify webhook signatures and idempotency before any financial mutation.
- Use immutable append-only ledger entries; corrections via compensating entries.
- Log privileged actions without logging OTPs, tokens, secrets or sensitive identity data.
- Provide report, block, moderation escalation and account deletion.
- Default meetings to public venues; do not publish exact residential addresses.
- Do not record calls without informed consent and clear controls.
