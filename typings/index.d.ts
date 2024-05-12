// @ref https://dev.to/krzysztofzuraw/how-to-type-nextjs-env-variables-in-typescript-50cg
namespace NodeJS {
  interface ProcessEnv {
    NEXT_PUBLIC_VERSION: string;
    NEXT_PUBLIC_GIT_COMMIT_ID: string;
    NEXT_PUBLIC_ENV_FILE: string;
    NEXT_PUBLIC_BASE_URL: string;
  }
}
