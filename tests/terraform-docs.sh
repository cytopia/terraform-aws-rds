#!/usr/bin/env bash

set -e
set -u

if [ "${#}" -ne "2" ]; then
	>&2 echo "Error, missing path argument"
	>&2 echo "Usage: ${0} <docker mount dir> <rel tf dir>"
	exit 1
fi

SCRIPTPATH="$( cd "$(dirname "$0")"; pwd -P )"
DOCKERPATH="$( cd "$(pwd)/${1}"; pwd -P )"
TARGETPATH="${2}"

# Get terraform-docs output
DOCS="$(
	docker run --rm \
		-v "${DOCKERPATH}:/docs" \
		cytopia/terraform-docs \
		--sort-inputs-by-required --with-aggregate-type-defaults md "${TARGETPATH}"
)"

# Create new README
grep -B 100000000 -F '<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->' "${DOCKERPATH}/${TARGETPATH}/README.md" > "${SCRIPTPATH}/README.md.tmp" || true
printf "${DOCS}\n\n" >> "${SCRIPTPATH}/README.md.tmp"
grep -A 100000000 -F '<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->' "${DOCKERPATH}/${TARGETPATH}/README.md" >> "${SCRIPTPATH}/README.md.tmp" || true

# Overwrite old README
mv -f "${SCRIPTPATH}/README.md.tmp" "${DOCKERPATH}/${TARGETPATH}/README.md"
