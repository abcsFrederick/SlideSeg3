#!/bin/bash

PREFIX="${SLURM_JOB_ID:-$(date +%s.%N)}"
N_PROC="${SLURM_CPUS_PER_TASK:-1}"

[ -d "/lscratch/${SLURM_JOB_ID}" ] && export TMPDIR="/lscratch/${SLURM_JOB_ID}"

if [[ -z "${TMPDIR}" ]]; then
    echo "no TMPDIR set"
    exit 1
fi

mkdir -p "${TMPDIR}/${PREFIX}"

if [[ ! -w "${TMPDIR}/${PREFIX}" ]]; then
    echo "${TMPDIR}/${PREFIX} not writable"
    exit 1
fi

echo "using directory ${TMPDIR}/${PREFIX}"
echo

echo "Data location"
echo "images:$1"
echo "xml:$2"
# check images/ xml/ folders 
if [[ -d "$1" ]] && [[ -d "$2" ]]; then
    echo "Found images and xml folder"
else
    echo "No images or xml folder"
    exit 1
fi

pushd .
# check and install openjpeg
echo "Install openjpeg..."
module load cmake
cd "${TMPDIR}/${PREFIX}"
git clone "https://github.com/uclouvain/openjpeg.git" openjpeg
cd openjpeg
mkdir -p "build"
cmake . -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="${PWD}/build"
make -j4
make install
make clean
echo "Export openjpeg..."
export OPENJPEG_PATH="${PWD}/build"
export C_INCLUDE_PATH="${PWD}/build/include:$C_INCLUDE_PATH"
export LD_LIBRARY_PATH="${PWD}/build/lib:$LD_LIBRARY_PATH"

# check and install openslide
echo "Install openslide..."
cd "${TMPDIR}/${PREFIX}"
wget "https://github.com/openslide/openslide/releases/download/v3.4.1/openslide-3.4.1.tar.gz"
tar xf "openslide-3.4.1.tar.gz"
echo "download and unpack openslide done"
cd openslide-3.4.1
mkdir -p "build"
./configure --prefix="${PWD}/build"  PKG_CONFIG_PATH="${OPENJPEG_PATH}/lib/pkgconfig"
make -j4
make install
echo "Export openslide..."
export LD_LIBRARY_PATH="${PWD}/build/lib:$LD_LIBRARY_PATH"

# check and install conda
echo "Install conda..."
cd "${TMPDIR}/${PREFIX}"
wget "https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh"
bash Miniconda3-latest-Linux-x86_64.sh -p "${PWD}/conda" -b
source ${PWD}/conda/etc/profile.d/conda.sh
conda activate base
which python
conda update conda -y

popd
# check and create SlideSeg3 env
echo "Create SlideSeg3 env..."
conda env create -f environment_slideseg3.yml
# activate SlideSeg3
conda activate SlideSeg3

# Changing parameters
python prm.py --slide_path=$1 --xml_path=$2 --output_dir="${TMPDIR}/${PREFIX}/output" --cpus=${N_PROC}
cat Parameters.txt

# run python main.py
python main.py
cp -r "${TMPDIR}/${PREFIX}/output" "/data/${USER}/SlideSeg-${PREFIX}"