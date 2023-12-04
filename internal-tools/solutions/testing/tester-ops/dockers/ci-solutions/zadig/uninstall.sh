#!/bin/bash

KODEROVER_HOME=${HOME}/.koderover
KODEROVER_BIN=${KODEROVER_HOME}/bin
PATH=${KODEROVER_BIN}:$PATH

install_helm() {
  HELM_DIR=$KODEROVER_HOME/helm
  mkdir -p "$KODEROVER_BIN"
  mkdir -p "$HELM_DIR"

  if [ -x $KODEROVER_BIN/helm ]; then
    return
  fi

  echo "installing helm client..."
  if [ $(uname -s) == "Darwin" ]; then
    curl -fsSL -o $HELM_DIR/helm.tar.gz "https://resources.koderover.com/tools/helm-v3.6.1-darwin-amd64.tar.gz"
    tar -xzf $HELM_DIR/helm.tar.gz -C $HELM_DIR
  else
    curl -fsSL -o $HELM_DIR/helm.tar.gz "https://resources.koderover.com/tools/helm-v3.6.1-linux-amd64.tar.gz"
    tar -xzf $HELM_DIR/helm.tar.gz -C $HELM_DIR
  fi

  mv $(find ${HELM_DIR} -type f -name helm) $KODEROVER_BIN/helm
  chmod +x $KODEROVER_BIN/helm
  rm -rf $HELM_DIR
  echo "succeed to install helm client: $(helm version)"
}

checkCmdExists() {
  command -v "$@" > /dev/null 2>&1
}

cleanup() {
  rm -rf "${KODEROVER_HOME}"
}

DELETE_NAMESPACE=
main() {
  echo "Do you also want to delete the namespace zadig is in? [y/N]"
  set +e
  read DELETE_NAMESPACE < /dev/tty
  set -e

  if [ -z "${NAMESPACE}" ]; then
    echo "uninstall script requires a NAMESPACE ENV variable to work."
    exit 1
  fi

  if ! checkCmdExists "helm" ; then
    install_helm
  fi

  echo "Removing Zadig system ..."
  helm list --short -n "${NAMESPACE}" | xargs -L1 helm delete -n "${NAMESPACE}"

  if [ "$DELETE_NAMESPACE" = "y" ] || [ "$DELETE_NAMESPACE" = "Y" ]; then
    echo "Removing namespace ${NAMESPACE}..."
    kubectl delete ns "${NAMESPACE}"
  fi

  echo "Cleaning up ...."
  cleanup

  echo "Successfully deleted Zadig."
}

main