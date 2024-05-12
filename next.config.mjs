// @doc https://nextjs.org/docs/app/building-your-application/routing/redirecting
/** @type {import('next').NextConfig} */
const nextConfig = {
    experimental: {
      instrumentationHook: true,
    },
    env: {
      // build version control
      // inject through npm script
      // 当前版本号
      NEXT_PUBLIC_VERSION: process.env.NEXT_PUBLIC_VERSION,
      // 发布时 git commit hash
      NEXT_PUBLIC_GIT_COMMIT_ID: process.env.NEXT_PUBLIC_GIT_COMMIT_ID,
      // 发布的环境
      NEXT_PUBLIC_ENV_FILE: process.env.NEXT_PUBLIC_ENV_FILE,
    },
    publicRuntimeConfig: {},
    // @doc https://nextjs.org/docs/pages/api-reference/next-config-js/output
    output: 'standalone',
  };
  
  export default nextConfig;
  