import { getBuildVersionInfo, getProjectVersionId } from '@/helper/version';
import styles from './page.module.css';

export default function Home() {
  // const { envFile, latestGitCommitId, version } = getBuildVersionInfo();

  return (
    <main className={styles.main}>
      <div className={styles.body}>
        <pre>Build Info: {JSON.stringify(getBuildVersionInfo(), null, 2)}</pre>
        <pre>Release: {getProjectVersionId()}</pre>
        <pre>NEXT_PUBLIC_BASE_URL: {process.env.NEXT_PUBLIC_BASE_URL}</pre>
      </div>
    </main>
  );
}
