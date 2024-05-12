import { logProjectVersion } from '@/helper/version';

// @doc https://nextjs.org/docs/app/building-your-application/optimizing/instrumentation
// https://github.com/vercel/next.js/discussions/50198
// server hooks at bootstrap
export async function register() {
  logProjectVersion();
}
