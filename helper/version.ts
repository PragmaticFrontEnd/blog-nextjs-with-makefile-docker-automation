export const getBuildVersionInfo = () => {
  return {
    latestGitCommitId: process.env.NEXT_PUBLIC_GIT_COMMIT_ID,
    version: process.env.NEXT_PUBLIC_VERSION,
    envFile: process.env.NEXT_PUBLIC_ENV_FILE,
  };
};

export function getProjectVersionId() {
  const { version, latestGitCommitId, envFile } = getBuildVersionInfo();
  const id = `${version || ''}-${latestGitCommitId || ''}-${envFile || ''}`;
  return id;
}

export function logProjectVersion() {
  // eslint-disable-next-line no-console
  console.log(`🚀 version: ${getProjectVersionId()}`);
}
