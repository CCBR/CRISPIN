#!/usr/bin/env bash
set -euxo pipefail
version=$1

repo_path=/data/CCBR_Pipeliner/Pipelines/CRUISE/dev/
install_path=/data/CCBR_Pipeliner/Pipelines/CRUISE/${version}
bin_path=${install_path}/bin/

. "/data/CCBR_Pipeliner/db/PipeDB/Conda/etc/profile.d/conda.sh"
conda activate py311

# remove artifacts from prior builds
pushd ${repo_path}
rm -rf build/ *.egg-info
popd

echo "Installing CRUISE to ${install_path}"
pip install ${repo_path} --target ${install_path} --upgrade
chmod +x ${install_path}/cruise/bin/*.*
chmod -R a+r ${install_path}

if [[ ":$PATH:" != *":${bin_path}:"* ]];then
    export PATH="${PATH}:${bin_path}"
fi

if [[ ":$PYTHONPATH:" != *":${install_path}:"* ]];then
    export PYTHONPATH="${PYTHONPATH}:${install_path}"
fi
