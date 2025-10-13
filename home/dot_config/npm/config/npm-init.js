/* eslint-disable no-secrets/no-secrets */
/* eslint-disable node/no-unsupported-features/es-syntax */
import { execSync } from 'node:child_process'

/**
 * Acquires latest version of GitSync and runs setup / maintainence tasks
 */
execSync(
  `
if command -v curl > /dev/null && command -v task > /dev/null; then
  if [ ! -d "\${XDG_DATA_HOME:-$HOME/.local/share}/gitsync/local" ]; then
    mkdir -p "\${XDG_DATA_HOME:-$HOME/.local/share}/gitsync/local"
  fi
  curl -sSL https://gitsync.org/init > "\${XDG_DATA_HOME:-$HOME/.local/share}/gitsync/local/Taskfile-init.yml"
  task --taskfile "\${XDG_DATA_HOME:-$HOME/.local/share}/gitsync/local/Taskfile-init.yml"
else
  echo 'Skipping NPM init script because curl and / or task are not in the PATH'
fi
`,
  { stdio: 'inherit' }
)

export default {
  main: 'index.js',
  scripts: {
    start: 'node index.js'
  },
  version: '0.0.1'
}
