#!/bin/bash

# Gitlab token needed for downloading bb release artifacts
# dev cluster needed for testing packages
# IB creds required to create imagePullSecrets
if [ -z $GITLAB_TOKEN ]; then echo "Error: Please set a GitLab token for Repo1 using the GITLAB_TOKEN environment variable."; exit 1; fi
if [ -z $KUBECONFIG ]; then echo "Error: No Kubeconfig found. Please configure a Kubernetes cluster and try again."; exit 1; fi
if [ -z $REGISTRY1_USER ]; then echo "Error: REGISTRY1_USER env var is not set. Please assign a value and try again."; exit 1; fi
if [ -z $REGISTRY1_PASS ]; then echo "Error: REGISTRY1_PASS env var is not set. Please assign a value and try again."; exit 1; fi


#all bb packages, including core and addon
#CHARTS=("anchore-enterprise" "argocd" "authservice" "fluentbit" "policy" "gitlab" "grafana" "haproxy" "harbor" "istio-operator" "istio-controlplane" "jaeger" "keycloak" "kiali" "kyverno" "loki" "mattermost" "monitoring" "neuvector" "promtail" "sonarqube" "tempo" "thanos" "twistlock" "vault" "velero" "wrapper" "cluster-auditor" "eck-operator" "elasticsearch-kibana" "fortify" "gitlab-runner" "kyverno-policies" "kyverno-reporter" "mattermost-operator" "metrics-server" "minio-operator" "nexus")
BB_URL="https://repo1.dso.mil/api/v4/projects/2872/releases"
BB_TAG=`curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" $BB_URL | jq '.[0].tag_name' | tr -d '"'`
REPOSITORIES="https://umbrella-bigbang-releases.s3-us-gov-west-1.amazonaws.com/umbrella/${BB_TAG}/repositories.tar.gz"

#help options
help() {
  echo ""
  echo "BigBang Package Validator for Kyverno Policies. Intended to assist developers when investigating Kyverno policy violations for BigBang packages."
  echo "Validates packages from the latest BigBang release against the specified Kyverno policy."
  echo ""
  echo "Requires the following environment vars to be set: GITLAB_TOKEN, KUBECONFIG, REGISTRY1_USER, REGISTRY1_PASS"
  echo "Note: This tool assumes that you have already run the 'k3d-dev.sh' script with nothing else installed afterwards, including flux and BigBang."
  echo ""
  echo "Usage: ./bb-validate.sh [-p <policy>][-c <chart>][-h]"
  echo ""
  echo "Example: Lint a specific chart against a specific policy:"
  echo "        ./bb-validate.sh -p require-image-signature -c elasticsearch-kibana"
  echo ""
  echo "Is all testing complete? Remove all the packages from your repository by running:"
  echo "        rm -rf ./docs/tools/repos"
  echo ""
}

#image pull secret is required in each namespace to pull IB images
create_pull_secret () {
  kubectl create namespace $1 >/dev/null 2>&1
  kubectl create secret -n $1 docker-registry private-registry --docker-server=registry1.dso.mil --docker-username=$REGISTRY1_USER --docker-password=$REGISTRY1_PASS >/dev/null 2>&1
  kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "private-registry"}]}' -n $1 >/dev/null 2>&1
}

#download bigbang source packages
download_artifact () {
  if [[ ! -d ./repos ]]; then
    echo "[*] Downloading BigBang $BB_TAG packages..."
    curl -s $REPOSITORIES -o repositories.tar.gz; if [ $? -ne 0 ]; then echo "Error: Could not download artifacts for BigBiang release $BB_TAG"; exit 1; fi; tar -xvf ./repositories.tar.gz >/dev/null 2>&1; rm -rf ./repositories.tar.gz
    CHARTS=(`ls ./repos`)
    echo "[*] Extracting Charts..."
    for CHART in ${CHARTS[@]}; do
      # extract each chart
      git -C ./repos/$CHART restore chart --staged >/dev/null 2>&1 && git -C ./repos/$CHART restore chart
      git -C ./repos/$CHART restore tests --staged >/dev/null 2>&1 && git -C ./repos/$CHART restore tests
      VERSION=`yq '.version' ./repos/$CHART/chart/Chart.yaml`
      echo "Found $CHART-$VERSION"
    done
  echo ""
  fi
}

#install kyverno admission controller with package default values
install_kyverno () {
  KYVERNO_RELEASE=`helm ls -A | awk '{print $1}' | egrep -o '.*kyverno$'`
  if [[ $KYVERNO_RELEASE == "" ]]; then
    echo "[*] Installing Kyverno..."
    create_pull_secret "kyverno"
    helm upgrade -i kyverno ./repos/kyverno/chart -n kyverno >/dev/null 2>&1
    if [ $? -ne 0 ]; then echo "Error: Failed to install Kyverno."; exit 1; else echo "[*] Kyverno installed successfully."; fi
  fi
}

#get all policies, set to disable
get_policies() {
  DISABLED_VALUES="all-policies-disabled.yaml"
  if [[ ! -z  $DISABLED_VALUES ]]; then 
    POLICIES=(`yq '.policies[] | key' ./repos/kyverno-policies/chart/values.yaml`)
    #render a values file where all policies are disabled
    echo -n > $DISABLED_VALUES
    echo "policies:" >> $DISABLED_VALUES
    for POLICY in ${POLICIES[@]}; do
      echo -e "  $POLICY:\n    enabled: false" >> $DISABLED_VALUES
    done
  fi
}

#install kyverno-policies, enabling only the desired policy for testing
enable_policy () {
  #check that the provided policy is valid  
  if [[ $(echo ${POLICIES[@]} | tr -d '"'| egrep -o $1) == "" ]]; then echo "Error: Policy $1 not found. Please check that the policy name is valid and try again."; exit 1; fi
  echo "[*] Enabling policy $1..."
  #render kyverno-policies chart where just the desired policy is enabled
  helm template ./repos/kyverno-policies/chart -f ./$DISABLED_VALUES --set policies.$1.enabled=true --set policies.$1.validationFailureAction=Enforce| kubectl apply -f - >/dev/null 2>&1
  if [ $? -ne 0 ]; then echo "Error: Failed to enable policy $1."; exit 1; fi
  rm -rf ./$DISABLED_VALUES
}

disable_policy () {
  kubectl delete cpol $1 >/dev/null 2>&1
}

validate_package() {
  CHARTS=(`ls ./repos`)
  if [[ $(echo ${CHARTS[@]} | tr -d '"'| egrep -o $1) == "" ]]; then echo "Error: Chart $1 not found. Please check the chart name and try again. Valid charts can be seen by running \`ls ./repos\`."; exit 1; fi
  if [ $(helm show crds ./repos/$1/chart | yq 'length') -gt 0 ]; then echo "Warn: Package $1 contains CustomResourceDefinitions. Packages that use this CustomResource will need to be validated separately."; fi
  if [ -f ./repos/$1/tests/wait.sh ]; then echo "Warn: Package $1 relies on resources managed by an operator. Resources managed by operators are not validated by this script."; fi
  echo "[*] Running dry-run apply of package $1..."
  helm template $1 ./repos/$1/chart | kubectl apply -f - --dry-run=server  > /dev/null 2> ./$1-$2-output; 
  cat ./$1-$2-output | sed -n -e '/validate.kyverno/,$p' > ./$1-$2-violations;
  if [ ! -s ./$1-$2-violations ]; then rm -rf ./$1-$2-violations; echo "[*] No violations found for $1."
  else echo "[*] Violations for $1 logged to ./$1-$2-violations"; fi
  rm ./$1-$2-output;
  echo
}

while getopts "hc:p:" flag; do
  case "${flag}" in
    p) p=${OPTARG};;
    c) c=${OPTARG};;
    h | *) help; exit 0 ;;
  esac
done

cleanup () {
  echo "[*] Running cleanup of package $1..."
  rm -rf ./docs/tools/repos
}

download_artifact
install_kyverno
get_policies
enable_policy $p
validate_package $c $p
disable_policy $p