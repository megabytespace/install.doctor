#!/usr/bin/env bash
# @file GitLab Runner Configuration
# @brief Registers GitLab Runner(s) with the given GitLab instance
# @description
#     This script registers the runner(s) with the given GitLab instance. SaaS GitLab can also be provided as the GitLab instance to register
#     the runners with. The script configures the runners to use either Docker or VirtualBox Executor. Refer to
#     [this page](https://docs.gitlab.com/runner/executors/docker.html) and [this page](https://docs.gitlab.com/runner/executors/virtualbox.html)
#     for details about the available configuration settings.
#
#     Runners are always tagged with these 2 values: `hostname` and `docker`/`virtualbox` depending on the type of executor. If a list of tags is provided,
#     the runner is tagged with these values in addition to the above mentioned values. If the list of tags is empty, no additonal tags are added and the
#     runner is configured to pickup `untagged` jobs.
#
#     Configuring other type of executors is not supported by this script.
#
#     ## Secrets
#
#     The following chart details the secret(s) that are needed to configure the runner:
#
#     | Secret                 | Description                                                |
#     |------------------------|------------------------------------------------------------|
#     | `GITLAB_RUNNER_TOKEN`  | The token generated when the runner was created in GitLab  |
#
#     For more information about storing secrets like SSH keys and API keys, refer to our Secrets documentation provided below
#
#     ## Configuration Variables
#
#     The following chart details the input variable(s) that are used to determine the configuration of the runner:
#
#     | Variable            | Description                                                                                              |
#     |---------------------|----------------------------------------------------------------------------------------------------------|
#     | `glurl`             | The URL of the Gitlab instance to associate the Runner with                                              |
#     | `runnerImage`       | Docker image to use to configure the runner. Needed only when configuring `Docker` executor              |
#     | `runnerDescription` | Description of this runner                                                                               |
#     | `runnerTags`        | Comma separated list of tags for this runner. See details in the description for more info               |
#     | `baseVM`            | Name of the VirtualBox VM to use for creating runner. Needed only when configuring `VirtualBox` executor |
#
#     ## Links
#
#     * [Secrets / Environment variables documentation](https://install.doctor/docs/customization/secrets)

### Check if Docker is installed and operational so Docker executor(s) can be registered
if command -v docker > /dev/null && docker run --rm hello-world > /dev/null; then
  HAS_DOCKER=1
else
  HAS_DOCKER=0
  gum log -sl warn 'Docker is not installed or it is not operational'
fi
### Check if VirtualBox is installed and operational so VirtualBox executor(s) can be registered
if command -v VirtualBox > /dev/null; then
  HAS_VIRTUALBOX=1
else
  HAS_VIRTUALBOX=0
  gum log -sl warn 'VirtualBox is not installed'
fi
### Configure runners if Docker or VirtualBox is installed
if [ $HAS_DOCKER -eq 0 ] && [ $HAS_VIRTUALBOX -eq 0 ]; then
  gum log -sl warn 'Docker and VirtualBox are not installed. Not registering runner(s).'
else
  ### Run logic if gitlab-runner is installed
  if command -v gitlab-runner > /dev/null; then
    ### Populate appropriate token
    case "$OSTYPE" in
      solaris*) echo "TODO" ;;
      darwin*)  GITLAB_RUNNER_TOKEN="{{ if (stat (joinPath .chezmoi.sourceDir ".chezmoitemplates" (printf "%s%s" "secrets-" .chezmoi.hostname) "GITLAB_RUNNER_TOKEN_DARWIN")) }}{{ includeTemplate (printf "%s%s" (printf "%s%s" "secrets-" .chezmoi.hostname) "/GITLAB_RUNNER_TOKEN_DARWIN") | decrypt | trim }}{{ else }}{{ env "GITLAB_RUNNER_TOKEN_DARWIN" }}{{ end }}" ;;
      linux*)   GITLAB_RUNNER_TOKEN="{{ if (stat (joinPath .chezmoi.sourceDir ".chezmoitemplates" (printf "%s%s" "secrets-" .chezmoi.hostname) "GITLAB_RUNNER_TOKEN_LINUX")) }}{{ includeTemplate (printf "%s%s" (printf "%s%s" "secrets-" .chezmoi.hostname) "/GITLAB_RUNNER_TOKEN_LINUX") | decrypt | trim }}{{ else }}{{ env "GITLAB_RUNNER_TOKEN_LINUX" }}{{ end }}" ;;
      bsd*)     echo "TODO" ;;
      msys*)    GITLAB_RUNNER_TOKEN="{{ if (stat (joinPath .chezmoi.sourceDir ".chezmoitemplates" (printf "%s%s" "secrets-" .chezmoi.hostname) "GITLAB_RUNNER_TOKEN_WINDOWS")) }}{{ includeTemplate (printf "%s%s" (printf "%s%s" "secrets-" .chezmoi.hostname) "/GITLAB_RUNNER_TOKEN_WINDOWS") | decrypt | trim }}{{ else }}{{ env "GITLAB_RUNNER_TOKEN_WINDOWS" }}{{ end }}" ;;
      cygwin*)  GITLAB_RUNNER_TOKEN="{{ if (stat (joinPath .chezmoi.sourceDir ".chezmoitemplates" (printf "%s%s" "secrets-" .chezmoi.hostname) "GITLAB_RUNNER_TOKEN_WINDOWS")) }}{{ includeTemplate (printf "%s%s" (printf "%s%s" "secrets-" .chezmoi.hostname) "/GITLAB_RUNNER_TOKEN_WINDOWS") | decrypt | trim }}{{ else }}{{ env "GITLAB_RUNNER_TOKEN_WINDOWS" }}{{ end }}" ;;
      *)        echo "unknown: $OSTYPE" ;;
    esac
    ### Check if Runner Token value is present before attempting to register runner(s)
    if [ $GITLAB_RUNNER_TOKEN != "" ]; then
      ### Registering runners
      {{ $cmd := `gitlab-runner register \
        --non-interactive \
        --token $GITLAB_RUNNER_TOKEN \` }}
      ### Register Docker based runners if Docker is installed and operational
      if [ $HAS_DOCKER -eq 1 ]; then
        gum log -sl info 'Registering GitLab Runner(s) that use Docker executor'
        {{- range .host.gitlabRunners }}
        {{- if index . "runnerImage" }}
        {{- $cmd }}
        --url {{ .glurl }} \
        --executor "docker" \
        --description "{{ .runnerDescription }} - on {{ $.chezmoi.hostname }}" \
        --docker-image {{ .runnerImage }} \
        {{ if and .runnerTags (gt (len .runnerTags) 0) }}--tag-list "{{ .runnerTags }},{{ $.chezmoi.hostname }},docker"
        {{- else }}--tag-list "{{ $.chezmoi.hostname }},docker" --run-untagged{{ end }} || echo 'Runner registration failed"
        {{ end -}}
        {{ end }}
      fi
      ### Register VirtualBox based runners if VirtualBox is installed
      if [ $HAS_VIRTUALBOX -eq 1 ]; then
        gum log -sl info 'Registering GitLab Runner(s) that use VirtualBox executor'
        {{- range .host.gitlabRunners }}
        {{- if index . "baseVM" }}
        {{- $cmd }}
        --url {{ .glurl }} \
        --executor "virtualbox" \
        --description "{{ .runnerDescription }} - on {{ $.chezmoi.hostname }}" \
        --virtualbox-base-name "{{ .baseVM }}" \
        {{ if and .runnerTags (gt (len .runnerTags) 0) }}--tag-list "{{ .runnerTags }},{{ $.chezmoi.hostname }},virtualbox"
        {{- else }}--tag-list "{{ $.chezmoi.hostname }},virtualbox" --run-untagged{{ end }} || echo 'Runner registration failed"
        {{ end -}}
        {{ end }}
      fi
    else
      gum log -sl warn 'GITLAB_RUNNER_TOKEN is not set. Not registering runner(s)'
    fi
  else
    gum log -sl warn 'gitlab-runner is not installed or is not available in PATH'
  fi
fi
