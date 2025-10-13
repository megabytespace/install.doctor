# Visual Studio Code User Settings

## Deprecated Plugins

The following plugins were tested but removed because the `extensions.json` already includes about 200 plugins. The plugins were tested and removed if they added too much menu clutter, created unwieldly home folder additions, or were not deemed useful.

```json
{
    "aic.docify",
    "amazonwebservices.aws-toolkit-vscode",
    "antonreshetov.masscode-assistant",
    "appland.appmap",
    "azure-automation.vscode-azureautomation",
    "balazs4.gitlab-pipeline-monitor",
    "bridgecrew.checkov",
    "chiro2001.digital-ocean-manager",
    "circleci.circleci", // Unneeded (not using CircleCI currently)
    "dart-code.dart-code", // Creates a ~/.dart and ~/.dartServer folder. Does not respect XDG spec.
    "dart-code.flutter",
    "formulahendry.docker-explorer",
    "getporter.porter-vscode",
    "github.classroom", // Not currently using GH Classroom
    "gitlab.gitlab-workflow", // Does not work well with GitHub remote repositories
    "gitpod.gitpod-desktop",
    "gitpod.gitpod-remote-ssh", // Bunch of errors like this during install [gitpod-remote-ssh]: Couldn't find message for key openPreview.
    "google-home.google-home-extension",
    "htmlhint.vscode-htmlhint", // Couldn't start client HTML-hint on macOS GitHub remote repository
    "humao.rest-client", // Might be useful but uninstalling because Postman is already installed
    "ibm.codewind", // Creates a ~/.codewind folder. Does not respect XDG spec.
    "ibm.ibm-developer",
    "idered.npm",
    "infracost.infracost",
    "randomfractalsinc.vscode-data-preview", // Outside the scope of an IDE
    "ionic.ionic",
    "jasonn-porch.gitlab-mr",
    "jfrog.jfrog-vscode-extension", // Creates a ~/.jfrog-vscode-extension folder. Does not respect XDG spec.
    "jsayol.firebase-explorer",
    "leonardssh.vscord", // Discord presence plugin (requires embedding key in settings.json)
    "lightrun.lightrunplugin-saas", // Creates a ~/.lightrun folder. Does not respect XDG spec.
    "logerfo.gitlab-notifications",
    "lottiefiles.vscode-lottie",
    "mindaro-dev.file-downloader",
    "mindaro.mindaro",
    "mongodb.mongodb-vscode",
    "ms-kubernetes-tools.kind-vscode",
    "ms-toolsai.vscode-ai-remote", // Error encountered: [vscode-ai]: Couldn't find message for key azureml.internal.activate.title.
    "ms-toolsai.vscode-ai",
    "ms-vscode.cpptools-extension-pack",
    "ms-vscode.powershell",
    "msazurermtools.azurerm-vscode-tools",
    "nrwl.angular-console",
    "okteto.kubernetes-context",
    "okteto.remote-kubernetes",
    "orta.vscode-jest",
    "owenfarrell.vscode-vault",
    "platformio.platformio-ide", // Creates ~/.platformio folder. Does not respect XDG spec.
    "pwabuilder.pwa-studio",
    "rangav.vscode-thunder-client",
    "rapidapi.vscode-rapidapi-client",
    "redhat.vscode-openshift-connector",
    "redhat.vscode-redhat-account",
    "redhat.vscode-rsp-ui",
    "redhat.vscode-server-connector",
    "redhat.vscode-tekton-pipelines",
    "robocorp.robocorp-code", // Creates a ~/.robocorp and ~/.robocorp-code folder. Does not respect XDG spec.
    "robocorp.robotframework-lsp",
    "sapos.yeoman-ui",
    "saposs.app-studio-toolkit",
    "sidekick.sidekick-debugger",
    "sonarsource.sonarlint-vscode", // Creates a ~/.sonarlint folder. Does not respect XDG spec.
    "sprkldev.sprkl-vscode", // Creates a ~/.sprkl folder. Does not respect XDG spec.
    "statelyai.stately-vscode",
    "stepsize.stepsize",
    "teamhub.teamhub",
    "teamsdevapp.ms-teams-vscode-extension",
    "vscjava.vscode-java-debug", // Not typically coding with Java - might want to re-enable these for Android programming
    "vscjava.vscode-java-dependency",
    "vscjava.vscode-java-test",
    "vscjava.vscode-maven",
    "vscjava.vscode-spring-boot-dashboard",
    "wallabyjs.quokka-vscode", // Opening new tab on install
    "wallabyjs.wallaby-vscode", // Creating HOME directory dotfiles / folders
    "wallabyjs.console-ninja", // Creates ~/.console-ninja folder -- needs to respect XDG
    "wasteamaccount.webtemplatestudio-dev-nightly",
    "webhint.vscode-webhint"
}
```
