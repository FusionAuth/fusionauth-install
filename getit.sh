#!/bin/sh

# Copyright (c) 2018-2024, FusionAuth, All Rights Reserved
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
# either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

#
# You can install FusionAuth by running:
#
# curl -s https://fusionauth.io/getit | sh -s - --docker-compose
#

# Useful colors
if test -t 1; then
    color_reset="\e[0m"
    color_red="\e[31m"
    color_green="\e[32m"
    color_yellow="\e[33m"
    color_cyan="\e[36m"
else
    color_reset=""
    color_red=""
    color_green=""
    color_yellow=""
    color_cyan=""
fi

kickstart_link="\e]8;;https://fusionauth.io/docs/get-started/download-and-install/development/kickstart\aKickstart\e]8;;\a"
erase_line="\e[2K"
icon_success=" ${color_green}✔${color_reset}"
icon_error=" ${color_red}×${color_reset}"
icon_pending=" ${color_cyan}•${color_reset}"

# Displays help menu
display_help() {
  printf "%bDescription:%b\n" "$color_yellow" "$color_reset"
  printf "  Downloads the necessary files to easily spin up a %bFusionAuth%b instance\n\n" "$color_cyan" "$color_reset"

  printf "%bUsage:%b\n" "$color_yellow" "$color_reset"
  printf "  %b$0%b [options]%b\n\n" "$color_green" "$color_yellow" "$color_reset"

  printf "%bOptions:%b\n" "$color_yellow" "$color_reset"
  printf "  %b--docker-compose%b            Downloads files to use with Docker Compose\n" "$color_green" "$color_reset"
  printf "  %b--docker-compose-kickstart%b  Downloads Docker Compose files powered with\n" "$color_green" "$color_reset"
  printf "                              %b capabilities\n" "$kickstart_link"
}

# Downloading files
download() {
  printf "  ${icon_pending} Downloading %b%s%b..." "$color_yellow" "$1" "$color_reset"
  curlError=$(curl --no-progress-meter --fail -o "$1" "$2" 2>&1)
  # shellcheck disable=SC2181
  if [ $? -ne 0 ]; then
    printf "%b  ${icon_error} Downloading %b%s%b %bFAILED%b\n" "$erase_line\r" "$color_yellow" "$1" "$color_reset" "$color_red" "$color_reset"
    printf "  ${icon_error} %bError: %s%b\n" "$color_red" "$curlError" "$color_reset"
    exit 1
  fi
  printf "%b  ${icon_success} Downloaded %b%s%b\n" "$erase_line\r" "$color_yellow" "$1" "$color_reset"
}

# Files to download
case "$1" in
"--docker-compose")
  printf "${icon_pending} Downloading Docker Compose files...\n"
  download "docker-compose.yml" "https://raw.githubusercontent.com/FusionAuth/fusionauth-containers/master/docker/fusionauth/docker-compose.yml"
  download ".env" "https://raw.githubusercontent.com/FusionAuth/fusionauth-containers/master/docker/fusionauth/.env"
  ;;

"--docker-compose-kickstart")
  printf "${icon_pending} Downloading Docker Compose files with %b capabilities\n" "$kickstart_link"
  download "docker-compose.yml" "https://raw.githubusercontent.com/FusionAuth/fusionauth-example-template/master/docker-compose.yml"
  download ".env" "https://raw.githubusercontent.com/FusionAuth/fusionauth-example-template/master/.env"
  ;;

**)
  display_help
  exit 1
  ;;
esac

printf "${icon_success} %bAll files downloaded successfully%b\n" "$color_green" "$color_reset"
printf "${icon_success} %bYou can start your FusionAuth instance by running %bdocker compose up -d%b\n" "$color_reset" "$color_cyan" "$color_reset"
