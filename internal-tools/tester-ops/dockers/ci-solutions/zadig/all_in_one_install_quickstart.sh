#!/bin/bash

DIR=.
DIST_URL="http://resource.koderover.com/installer_dist"
KR_UTILS_FILE="koderover-utils.tar.gz"
KR_HOME=${HOME}/.koderover

k8sVersion="1.19.3"


GREEN='\033[0;32m'
RED='\033[0;31m'
NOCOLOR='\033[0m'
LIGHT_BLUE='\033[0;34m'
YELLOW='\033[0;33m'

LOGPATH=${DIR}/installer.log

logSuccess() {
  printf "${GREEN} $1${NOCOLOR}\n" 1>&2
  printf "[SUCCESS] $1 \n" >> "${LOGPATH}"
}

logPrompt() {
  printf " $1\n" 1>&2
  printf "[PROMPT] $1\n" >> "${LOGPATH}"
}

logInfo() {
  printf "[INFO] $1\n" 1>&2
  printf "[INFO] $1\n" >> "${LOGPATH}"
}

logWarn() {
  printf "${YELLOW} $1${NOCOLOR}\n" 1>&2
  printf "[WARN] $1\n" >> "${LOGPATH}"
}

logError() {
  printf "${RED}[ERROR] $1${NOCOLOR}\n" 1>&2
  printf "[ERROR] $1\n" >> "${LOGPATH}"
}

RunCommandWithlog() {
  local cmd=$@
  $cmd 2>&1 | tee -a ${LOGPATH}
}

printLogo() {
  printf "${YELLOW} _____          _ _       \n"
  printf "${YELLOW}/ _  / __ _  __| (_) __ _ \n"
  printf "${YELLOW}\// / / _. |/ _. | |/ _. |\n"
  printf "${YELLOW} / //\ (_| | (_| | | (_| |\n"
  printf "${YELLOW}/____/\__,_|\__,_|_|\__, |\n"
  printf "${YELLOW}                    |___/\n"
}
bail() {
    logError "$@"
    exit 1
}

confirmDefaultNo() {
  promptTimeout "$@"
  if [ "$PROMPT_RESULT" = "y" ] || [ "$PROMPT_RESULT" = "Y" ]; then
    return 0
  fi
  return 1
}

confirmDefaultYes() {
  promptTimeout "$@"
  if [ "$PROMPT_RESULT" = "n" ] || [ "$PROMPT_RESULT" = "N" ]; then
    return 1
  fi
  return 0
}

if [ -z "$READ_TIMEOUT" ]; then
    READ_TIMEOUT="-t 20"
fi

promptTimeout() {
  set +e
  read ${READ_TIMEOUT} PROMPT_RESULT < /dev/tty
  set -e
}

getInput() {
  set +e
  read PROMPT_RESULT < /dev/tty
  set -e
}

checkCmdExists() {
  command -v "$@" > /dev/null 2>&1
}

checkForRoot() {
  local user="$(id -un 2>/dev/null || true)"
  if [ "$user" != "root" ]; then
    bail "this installer needs to be run as root."
  fi
  FLAG_ROOTCHECK=true
}

render_yaml_file() {
  eval "echo \"$(cat $1)\""
}

loadImages() {
  find "$1" -type f | xargs -I {} bash -c "docker load < {}"
}

cleanUp() {
  logInfo "Cleaning up all the installation package..."
  logSuccess "Clean up success!"
}
getSystemInfos() {
  getDockerVersion
  getLsbInfo
  getPublicIp
  getPrivateIp
  #TODO: system spec verification

  KERNEL_MAJOR=$(uname -r | cut -d'.' -f1)
  KERNEL_MINOR=$(uname -r | cut -d'.' -f2)
}

getDockerVersion() {
  if ! checkCmdExists "docker" ; then
    return
  fi
  DOCKER_VERSION=$(docker -v | awk '{gsub(/,/, "", $3); print $3}')
}

LSB_DIST=
DIST_VERSION=
DIST_VERSION_MAJOR=
getLsbInfo() {
  _dist=
  if [ -f /etc/centos-release ] && [ -r /etc/centos-release ]; then
    # CentOS 6 & 7
    _dist="$(cat /etc/centos-release | cut -d" " -f1)"
    _version="$(cat /etc/centos-release | sed 's/Linux //' | cut -d" " -f3 | cut -d "." -f1-2)"
  elif [ -f /etc/os-release ] && [ -r /etc/os-release ]; then
    _dist="$(. /etc/os-release && echo "$ID")"
    _version="$(. /etc/os-release && echo "$VERSION_ID")"
  elif [ -f /etc/redhat-release ] && [ -r /etc/redhad-release ]; then
    # RHEL 6
    _dist="rhel"
    _major_version=$(cat /etc/redhat-release | cut -d" " -f7 | cut -d "." -f1)
    _minor_version=$(cat /etc/redhat-release | cut -d" " -f7 | cut -d "." -f2)
    _version=$_major_version
  else
    _err="Cannot determine what lsb is currently running."
  fi

  if [ -n "$_dist" ]; then
    _err="Detected lsb: ${_dist}"
    _dist="$(echo "$_dist" | tr '[:upper:]' '[:lower:]')"
    case "$_dist" in
      ubuntu)
        _err="$_err\nHowever detected version $_version is less than 12."
        oIFS="$IFS"; IFS=.; set -- $_version; IFS="$oIFS";
        [ $1 -ge 12 ] && LSB_DIST=$_dist && DIST_VERSION=$_version && DIST_VERSION_MAJOR=$1
        ;;
      debian)
        _err="$_err\nHowever detected version $_version is less than 7."
        oIFS="$IFS"; IFS=.; set -- $_version; IFS="$oIFS"
        [ $1 -ge 7 ] && LSB_DIST=$_dist && DIST_VERSION=$_version && DIST_VERSION_MAJOR=$1
        ;;
      centos)
        _error_msg="$_error_msg\nHowever detected version $_version is less than 6."
        oIFS="$IFS"; IFS=.; set -- $_version; IFS="$oIFS";
        [ $1 -ge 6 ] && LSB_DIST=$_dist && DIST_VERSION=$_version && DIST_VERSION_MAJOR=$1
        ;;
    esac
  fi

  if [ -z "$LSB_DIST" ]; then
    logError "$(echo | sed "i$_err")"
    logError "Quitting..."
    exit 1
  fi
}

getPrivateIp() {
    if [ -n "$PRIVATE_ADDRESS" ]; then
        return 0
    fi
    PRIVATE_ADDRESS=$(cat /etc/kubernetes/manifests/kube-apiserver.yaml 2>/dev/null | grep advertise-address | awk -F'=' '{ print $2 }')

    #This is needed on k8s 1.18.x as $PRIVATE_ADDRESS is found to have a newline
    PRIVATE_ADDRESS=$(echo "$PRIVATE_ADDRESS" | tr -d '\n')
}

getPublicIp() {
  PUBLIC_ADDRESS=$(dig +short myip.opendns.com @resolver1.opendns.com)
}

FLAG_ROOTCHECK=
FLAG_REQCHECK=
FLAG_DOCKER=
FLAG_KUBERNETES_INSTALLATION=
FLAG_CLUSTER_READY=
FLAG_KODEROVER=

trap reportStatus EXIT

reportStatus() {
  logPrompt "*****************************************"
  logPrompt "*    Koderover installer exit report    *"
  logPrompt "*****************************************"
  if [ -z "$FLAG_ROOTCHECK" ]; then
    logError "⚙ ROOT PRIVILEGE CHECK FAILED"
  else
    logSuccess "✔ ROOT PRIVILEGE CHECK SUCCESS"
  fi

  if [ -z "$FLAG_REQCHECK" ]; then
    logError "⚙ SYSTEM CHECK FAILED"
  else
    logSuccess "✔ SYSTEM CHECK SUCCESS"
  fi

  if [ -z "$FLAG_KUBERNETES_INSTALLATION" ]; then
    logError "⚙ DEPENDENCY INSTALLATION FAILED"
  else
    logSuccess "✔ DEPENDENCY INSTALLATION SUCCESS"
  fi

  if [ -z "$FLAG_CLUSTER_READY" ]; then
    logError "⚙ KUBERNETES CLUSTER INITIALIZATION FAILED"
  else
    logSuccess "✔ KUBERNETES CLUSTER INITIALIZATION SUCCESS"
  fi

  if [ -z "$FLAG_KODEROVER" ]; then
    logError "⚙ ZADIG INSTALLATION FAILED"
  else
    logSuccess "✔ ZADIG INSTALLATION SUCCESS"
  fi

  logPrompt "*****************************************"
  logPrompt "*            END OF REPORT              *"
  logPrompt "*****************************************"
}
reportTime() {
  local behavior=$1
  if (( $SECONDS > 3600 )) ; then
    let "hours=SECONDS/3600"
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    logSuccess "${behavior} completed in $hours hour(s), $minutes minute(s) and $seconds second(s)"
elif (( $SECONDS > 60 )) ; then
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    logSuccess "${behavior} completed in $minutes minute(s) and $seconds second(s)"
else
    logSuccess "${behavior} completed in $SECONDS seconds"
fi
}

TIMER_TIME=
setTimer() {
  TIMER_TIME=$SECONDS
}
preflightCheck() {
  check64Bit
  checkIfSupportedOS
  checkSwap
  checkIpv4Forwarding
  checkFirewalld
  checkSelinuxDisabled
  FLAG_REQCHECK=true
}

check64Bit() {
  case "$(uname -m)" in
    *64)
      ;;
    *)
      bail "This installer only works on 64 bit system"
      ;;
  esac
}

checkIfSupportedOS() {
  case "$LSB_DIST$DIST_VERSION" in
    ubuntu16.04|ubuntu18.04|ubuntu20.04|centos7.4|centos7.5|centos7.6|centos7.7|centos7.8|centos7.9|centos8.0|centos8.1|centos8.2|centos8.3)
      ;;
    *)
      bail "This installer does not support ${LSB_DIST} ${DIST_VERSION}"
      ;;
  esac
}

checkSwap() {
  if checkSwapOn || checkSwapEnabled ; then
    logWarn "The installer is incompatible with swap on, disable swap to continue installing? [y/N]"
    if confirmDefaultNo "t -20"; then
      logInfo "executing swapoff --all"
      swapoff --all
      if swapFstabEnabled; then
        disableSwapFstab
      fi
      if swapServiceEnabled; then
        disableSwapService
      fi
    fi
  fi
}

checkSwapOn() {
  swapon --summary | grep --quiet " "
}

checkSwapEnabled() {
  swapFstabEnabled || swapServiceEnabled
}

swapFstabEnabled() {
  cat /etc/fstab | grep --quiet --ignore-case --extended-regexp '^[^#]+swap'
}

swapServiceEnabled() {
  systemctl -q is-enabled temp-disk-swapfile 1>&/dev/null
}

disableSwapFstab() {
  logInfo "=> Commenting swap entries in /etc/fstab \n"
  sed --in-place=.bak '/\bswap\b/ s/^/#/' /etc/fstab
  logInfo "=> A backup of /etc/fstab has been made at /etc/fstab.bak\n\n"
  logInfo "\nChanges have been made to /etc/fstab. We recommend reviewing them after completing this installation to ensure mounts are correctly configured.${NC}\n\n"
  sleep 5
}

disableSwapService() {
  logInfo "Disabling temp-disk-swapfile service"
  systemctl disable temp-disk-swapfile
}

checkFirewalld() {
    if ! systemctl -q is-active firewalld; then
    return
  fi

  logWarn "Firewalld is active, do you want to disable it? [y/N]"
  if confirmDefaultNo; then
    systemctl stop firewalld
    systemctl disable firewalld
    return
  fi

  bail "The system cannot continue with firewalld on"
}

checkSelinuxDisabled() {
  if selinuxEnabled && selinuxEnforced; then
    logError "kubernetes is incompatible with selinux, disable it? [y/N]"
    if confirmDefaultNo; then
      setenforce 0
      sed -i s/^SELINUX=.*$/SELINUX=permissive/ /etc/selinux/config
    else
      bail "disable selinux to continue"
    fi
  fi
}

selinuxEnabled() {
  if checkCmdExists "selinuxenabled"; then
    selinuxenabled
    return
  elif checkCmdExists "sestatus"; then
    ENABLED=$(sestatus | grep 'SELinux status' | awk '{ print $3 }')
    echo "$ENABLED" | grep --quiet --ignore-case enabled
    return
  fi

  return 1
}

selinuxEnforced() {
  if checkCmdExists "getenforce"; then
    ENFORCED=$(getenforce)
    echo $(getenforce) | grep --quiet --ignore-case enforcing
    return
  elif checkCmdExists "sestatus"; then
    ENFORCED=$(sestatus | grep 'SELinux mode' | awk '{ print $3 }')
    echo "$ENFORCED" | grep --quiet --ignore-case enforcing
    return
  fi

  return 1
}

checkIpv4Forwarding() {
  if [ -n "$(cat /etc/sysctl.conf | grep net.ipv4.ip_forward)" ]; then
    logWarn "Installer cannot initialize kubernetes cluster with net.ipv4.ip_forward in your /etc/sysctl.conf, turn it on? [y/N]"
    if confirmDefaultNo "t -20"; then
      sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf
    else
      bail "set net.ipv4.ip_forward = 1 in your /etc/sysctl.conf file"
    fi
  fi
}

# TODO: currently only docker is supported, will include containerd if necessary
installCri() {
  if ! checkCmdExists docker; then
    logInfo "fetching docker..."
    installDocker
  fi
  printf "\n"
  FLAG_DOCKER=true
}

installDocker() {
  cgroupToSystemd
  downloadDockerPackage
  runDockerInstall
  systemctl enable docker
  systemctl start docker
}

cgroupToSystemd() {
  if [ -f /var/lib/kubelet/kubeadm-flags.env ] || [ -f /etc/docker/daemon.json ]; then
    return
  fi

  mkdir -p /etc/docker
  cat > /etc/docker/daemon.json <<EOF
{
    "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

  mkdir -p /etc/systemd/system/docker.service.d
}

downloadDockerPackage() {
  local version="19.03.10"
  # TODO: add more docker dist package and make it available to customer choice
  curl -# -LO "$DIST_URL/docker-${version}.tar.gz" 2>&1
  tar xf docker-${version}.tar.gz
  rm docker-${version}.tar.gz
}

runDockerInstall() {
  local version="19.03.10"
  case "$LSB_DIST" in
  ubuntu)
    RunCommandWithlog dpkg --install --force-depends-version $DIR/packages/docker/${version}/ubuntu-${DIST_VERSION}/*.deb
    return 0
    ;;
  centos|rhel)
    RunCommandWithlog rpm --upgrade --force --nodeps $DIR/packages/docker/${version}/rhel-7/*.rpm
    return 0
    ;;
  esac

  bail "Docker installation is currently not supported on ${LSB_DIST} ${DIST_VERSION_MAJOR}"
}
## TODO: get local k8s version as a local variable
installKubernetesHost() {
  local k8sVersion="1.19.3"
  configKubernetesSysctl

  getKubernetesPackageOnline
  configKubernetesSysctl
  installKubernetesPackage
  loadImages $DIR/packages/kubernetes/${k8sVersion}/images
  printf "\n"

  FLAG_KUBERNETES_INSTALLATION=true
}

configKubernetesSysctl() {
  echo "net.ipv4.conf.all.rp_filter = 1" > /etc/sysctl.d/k8s.conf
  echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.d/k8s.conf
  case "$LSB_DIST" in
  centos|rhel)
    echo "net.bridge.bridge-nf-call-ip6tables = 1" >> /etc/sysctl.d/k8s.conf
    echo "net.bridge.bridge-nf-call-iptables = 1" >> /etc/sysctl.d/k8s.conf
    echo "net.ipv4.conf.all.forwarding = 1" >> /etc/sysctl.d/k8s.conf
    ;;
  esac
  RunCommandWithlog sysctl --system
}

getKubernetesPackageOnline() {
  logInfo "Downloading kubernetes binary....."
  curl -LO -# "$DIST_URL/kubernetes-${k8sVersion}.tar.gz" 2>&1
  tar xf kubernetes-${k8sVersion}.tar.gz
  rm kubernetes-${k8sVersion}.tar.gz
}

installKubernetesPackage() {
  logInfo "Installing kubelet, kubeadm, kubectl and cni host packages"
  if checkHostHasKubernetes "$k8sVersion"; then
    logSuccess "Kubernetes host packages already installed"
    return
  fi

  case "$LSB_DIST" in
  ubuntu)
    # TODO: what this env does?
    export DEBIAN_FRONTEND=noninteractive
    RunCommandWithlog dpkg --install --force-depends-version $DIR/packages/kubernetes/${k8sVersion}/ubuntu-${DIST_VERSION}/*.deb
    ;;
  centos)
    case "$LSB_DIST$DIST_VERSION_MAJOR" in
    centos8)
      RunCommandWithlog rpm --upgrade --force --nodeps $DIR/packages/kubernetes/${k8sVersion}/rhel-8/*.rpm
      ;;
    *)
      RunCommandWithlog rpm --upgrade --force --nodeps $DIR/packages/kubernetes/${k8sVersion}/rhel-7/*.rpm
      ;;
    esac
  ;;
  esac

  RunCommandWithlog systemctl enable kubelet && systemctl start kubelet
  logSuccess "kubernetes host packages installed"
}

prepareKubernetes() {
  RunCommandWithlog kubeadm init --kubernetes-version=${k8sVersion}
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
  RunCommandWithlog kubectl taint nodes --all node-role.kubernetes.io/master-
  RunCommandWithlog kubectl apply -f "https://resources.koderover.com/dist/weave-net.yaml"
  FLAG_CLUSTER_READY=true
}

checkHostHasKubernetes() {
  local k8sVersion="$1"
  if ! checkCmdExists kubelet; then
    logWarn "kubelet command missing"
    return 1
  fi
  if ! checkCmdExists kubeadm; then
    logWarn "kubeadm command missing"
    return 1
  fi
  if ! checkCmdExists kubectl; then
    logWarn "kubectl command missing"
    return 1
  fi
}

getKRInstallParam() {
  getDomain "-t 60"
}


# This script is meant for fast & easy installation of zadig
# The possible environment variables is listed below:
#|--------------------|--------------------------------------------------|---------------------|
#|      Key           |                   Description                    |      Default        |
#|--------------------|--------------------------------------------------|---------------------|
#|      NAMESPACE     | The namespace Zadig to be installed in.          | zadig               |
#|--------------------|--------------------------------------------------|---------------------|
#|        DOMAIN      | The hostname of Zadig system.                    | ""                  |
#|--------------------|--------------------------------------------------|---------------------|
#|                    | The ip of Zadig system, if domain is not         |                     |
#|         IP         | applicable. Note that either DOMAIN or IP must   | ""                  |
#|                    | be provided otherwise the installation WILL fail |                     |
#|--------------------|--------------------------------------------------|---------------------|
#|       PORT         | The port of Zadig system. This variable must be  | ""                  |
#|                    | set if IP is set                                 |                     |
#|--------------------|--------------------------------------------------|---------------------|
#|   INGRESS_CLASS    | If a custom ingress class is provided, use this  | zadig-nginx         |
#|                    | to set the default ingress class for ingress rule|                     |
#|--------------------|--------------------------------------------------|---------------------|
#|                    | If no custom ingress class is provided.          |                     |
#| NGINX_SERVICE_TYPE | NGINX_SERVICE_TYPE should be set. Only NodePort  | NodePort            |
#|                    | and LoadBalancer service type is supported.      |                     |
#|--------------------|--------------------------------------------------|---------------------|
#|  INSECURE_REGISTRY | Custom insecure registry address                 | ""                  |
#|--------------------|--------------------------------------------------|---------------------|
#|                    | The connection string of user-provide mongodb    |                     |
#|    MONGO_URI       | This shouldn't be set if the customer wants to   | ""                  |
#|                    | use the build-in mongodb                         |                     |
#|--------------------|--------------------------------------------------|---------------------|
#|     MONGO_DB       | The DB of the Zadig system                       | zadig               |
#|--------------------|--------------------------------------------------|---------------------|
#|                    | The host of user-provide mysql                   |                     |
#|    MYSQL_HOST      | This shouldn't be set if the customer wants to   | ""                  |
#|                    | use the build-in mysql                           |                     |
#|--------------------|--------------------------------------------------|---------------------|
#|    MYSQL_PORT      | The port of user-provide mysql                   | ""                  |
#|--------------------|--------------------------------------------------|---------------------|
#|  MYSQL_USERNAME    | The username of the given mysql                  | ""                  |
#|--------------------|--------------------------------------------------|---------------------|
#|   MYSQL_PASSWORD   | The password of the given mysql                  | ""                  |
#|--------------------|--------------------------------------------------|---------------------|
#|    STORAGE_SIZE    | The pvc size of the build-in mongodb             | 20Gi                |
#|--------------------|--------------------------------------------------|---------------------|
#|                    | The storage class for the pvc of the build-in    |                     |
#|    STORAGE_CLASS   | mongodb. If this is not provided, builtin mongodb| ""                  |
#|                    | WILL fail to start                               |                     |
#|--------------------|--------------------------------------------------|---------------------|
#|   ENCRYPTION_KEY   | The system-wide encryption key. If not provided, | ""                  |
#|                    | installer will randomize a key.                  |                     |
#|--------------------|--------------------------------------------------|---------------------|
#|     DRY_RUN        | Check install log without real installation      | ""                  |
#|--------------------|--------------------------------------------------|---------------------|
#|       EMAIL        | Email address of the initial user                | "admin@example.com" |
#|--------------------|--------------------------------------------------|---------------------|
#|      PASSWORD      | Password of the initial user                     | "zadig"             |
#|--------------------|--------------------------------------------------|---------------------|

MODE=quickstart

if [[ ${MODE} == "nightly"  ]]; then
  ZADIG_VERSION=nightly
else
  ZADIG_VERSION=1.7.1
fi

# Koderover bin path
KODEROVER_HOME=${HOME}/.koderover
KODEROVER_BIN=${KODEROVER_HOME}/bin
HELM_REPO=${HELM_REPO:-https://koderover.tencentcloudcr.com/chartrepo/chart}
PATH=${KODEROVER_BIN}:$PATH
EMAIL=${EMAIL:-admin@example.com}
PASSWORD=${PASSWORD:-zadig}

# logging color
RED='\033[0;31m'
NOCOLOR='\033[0m'
# helm install parameters
INSTALL_PARAMETER=

ensure_parameter() {
  # opensource version
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set tags.enterprise=false"
  ensure_api_gateway
  ensure_endpoint
  ensure_ingress
  ensure_mongodb
  ensure_mysql
  ensure_minio
  ensure_insecure_registry
  ensure_apiserver
  ensure_encryption_key
  ensure_default_user
  ensure_dex
  # dry-run if it is set
  if [ -n "${DRY_RUN}" ]; then
    INSTALL_PARAMETER="${INSTALL_PARAMETER} --dry-run"
  fi

  if [[ ${MODE} == "nightly"  ]]; then
    ensure_zadig_images_latest
  fi
}

ensure_dex() {
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set dex.fullnameOverride=zadig-${NAMESPACE:=zadig}-dex"
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set dex.config.issuer=http://zadig-${NAMESPACE:=zadig}-dex:5556/dex"
}

ensure_zadig_images_latest() {
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set frontend.image.tag=latest-amd64 --set frontend.image.pullPolicy=Always"

  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set microservice.aslan.image.tag=latest-amd64 --set microservice.aslan.image.pullPolicy=Always"
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set microservice.picket.image.tag=latest-amd64 --set microservice.picket.image.pullPolicy=Always"
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set microservice.user.image.tag=latest-amd64 --set microservice.user.image.pullPolicy=Always"
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set microservice.cron.image.tag=latest-amd64 --set microservice.cron.image.pullPolicy=Always"
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set microservice.podexec.image.tag=latest-amd64 --set microservice.podexec.image.pullPolicy=Always"
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set microservice.config.image.tag=latest-amd64 --set microservice.config.image.pullPolicy=Always"
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set microservice.policy.image.tag=latest-amd64 --set microservice.policy.image.pullPolicy=Always"
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set microservice.warpdrive.image.tag=latest-amd64 --set microservice.warpdrive.image.pullPolicy=Always"
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set microservice.resourceServer.image.tag=latest-amd64 --set microservice.resourceServer.image.pullPolicy=Always"
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set microservice.hubServer.image.tag=latest-amd64 --set microservice.hubServer.image.pullPolicy=Always"
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set microservice.jenkins.image.tag=latest-amd64"
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set microservice.predator.image.tag=latest-amd64"
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set microservice.reaperPlugin.image.tag=latest-amd64"

  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set dex.image.tag=latest-amd64 --set dex.image.pullPolicy=Always"
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set init.image.tag=latest-amd64 --set init.image.pullPolicy=Always"
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set ua.image.tag=latest-amd64 --set init.image.pullPolicy=Always"
}

ensure_api_gateway() {
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set global.extensions.extAuth.extauthzServerRef.namespace=${NAMESPACE:-zadig}"
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set gatewayProxies.gatewayProxy.service.type=${NGINX_SERVICE_TYPE:-NodePort}"
}

ensure_apiserver() {
  APISERVER=$(kubectl config view --minify | grep server | cut -f 2- -d ":" | tr -d " ")
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set kubernetes.server=${APISERVER}"
}

ensure_endpoint() {
  # Make sure only one of IP+PORT OR DOMAIN is provided
  if { { [ -z "${IP}" ] || [ -z "${PORT}" ];} && [ -z "${DOMAIN}" ]; } || { [ -n "${IP}" ] && [ -n "${DOMAIN}" ]; }; then
    printf "${RED}Either IP+PORT or DOMAIN shoule be provided${NOCOLOR}\n"
    exit 1
  fi

  # Set corresponding install parameters
  if [ -n "${IP}" ]; then
    INSTALL_PARAMETER="${INSTALL_PARAMETER} --set endpoint.type=IP --set endpoint.IP=${IP} --set ingress-nginx.controller.service.nodePorts.http=${PORT}"
    INSTALL_PARAMETER="${INSTALL_PARAMETER} --set dex.config.staticClients[0].redirectURIs[0]=http://${IP}:${PORT}/api/v1/callback,dex.config.staticClients[0].id=zadig,dex.config.staticClients[0].name=zadig,dex.config.staticClients[0].secret=ZXhhbXBsZS1hcHAtc2VjcmV0"
  else
    INSTALL_PARAMETER="${INSTALL_PARAMETER} --set endpoint.type=FQDN --set endpoint.FQDN=${DOMAIN}"
    INSTALL_PARAMETER="${INSTALL_PARAMETER} --set dex.config.staticClients[0].redirectURIs[0]=http://${DOMAIN}/api/v1/callback,dex.config.staticClients[0].id=zadig,dex.config.staticClients[0].name=zadig,dex.config.staticClients[0].secret=ZXhhbXBsZS1hcHAtc2VjcmV0"
  fi
}

ensure_ingress() {
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set ingress-nginx.controller.ingressClass=${INGRESS_CLASS:-zadig-nginx}"
  # if an ingress class is provided, then we do not install the built-in ingress nginx controller
  if [ -n "${INGRESS_CLASS}" ]; then
    INSTALL_PARAMETER="${INSTALL_PARAMETER} --set tags.ingressController=false"
  # otherwise we install it and set the type of the ingress controller service
  else
    INSTALL_PARAMETER="${INSTALL_PARAMETER} --set tags.ingressController=true --set ingress-nginx.controller.service.type=${NGINX_SERVICE_TYPE:-NodePort}"
  fi
}

ensure_mongodb() {
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set connections.mongodb.db=${MONGO_DB:-zadig}"
  # enable the installation of built-in mongodb
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set tags.mongodb=true"
  # disable persistence
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set mongodb.persistence.enabled=false"
}

ensure_mysql() {
  # enable the installation of built-in mysql
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set tags.mysql=true"
  # disable persistent volume
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set mysql.primary.persistence.enabled=false"
}

ensure_minio() {
  # built-in minio is required for opensource version of zadig to work
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set tags.minio=true"
  # disable persistent volume
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set minio.persistence.enabled=false"
}

ensure_insecure_registry() {
  if [ -n "${INSECURE_REGISTRY}" ]; then
    INSTALL_PARAMETER="${INSTALL_PARAMETER} --set insecureRegistry=${INSECURE_REGISTRY}"
  fi
}


ensure_encryption_key() {
  # if no encryption key is provided, the installer will generate a random encryption key.
  if [ -z "${ENCRYPTION_KEY}" ]; then
    ENCRYPTION_KEY=$(openssl enc -aes-128-cbc -k secret -P -md sha1 | grep key | cut -d "=" -f2-)
    printf "${RED}%s${NOCOLOR}\n" "NO ENCRYPTION KEY PROVIDED, ZADIG HAS GENERATED AN ENCRYPTION KEY" 1>&2
    printf "${RED}%s${NOCOLOR}\n" "${ENCRYPTION_KEY}"
    printf "${RED}%s${NOCOLOR}\n" "THIS KEY WILL BE USED FOR POSSIBLE FUTURE REINSTALLATION, PLEASE SAVE THIS KEY CAREFULLY\n"
  fi
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set global.encryption.key=${ENCRYPTION_KEY}"
}

ensure_default_user() {
  INSTALL_PARAMETER="${INSTALL_PARAMETER} --set init.adminPassword=${PASSWORD} --set init.adminEmail=${EMAIL}"
}

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

cleanup() {
  set +e
  rm -rf "${KODEROVER_HOME}"
  set -e
}

installZadig() {
  cleanup
  ensure_parameter
  if ! checkCmdExists "helm" ; then
    install_helm
  fi
  echo "installing zadig ..."
  helm repo add koderover-chart "${HELM_REPO}"
  helm repo update
  helm upgrade --timeout 15m --install --create-namespace -n "${NAMESPACE:-zadig}"${INSTALL_PARAMETER} --version="${ZADIG_VERSION}" "zadig-${NAMESPACE:-zadig}" koderover-chart/zadig
  cleanup
}

postInstallZadig() {
  logSuccess "Zadig installation complete."
  FLAG_KODEROVER=true
}
main() {
  printLogo
  logSuccess "Welcome to the Koderover Installer"
  logInfo "Checking system for requirements..."
  setTimer
  checkForRoot
  getSystemInfos
  preflightCheck
  reportTime "preflight check"
  setTimer
  mkdir -p ${KR_HOME}/mypkg
  reportTime "install preparation"
  setTimer
  installCri
  installKubernetesHost
  prepareKubernetes
  reportTime "infrastructure installation"
  setTimer
  installZadig
  postInstallZadig
  reportTime "zadig installation"
}

main
