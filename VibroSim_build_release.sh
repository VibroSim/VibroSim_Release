# !/bin/bash
# Usage VibroSim_build_release.sh <VERSION>
#
# where <VERSION> is e.g. 1.0.0 and matches VibroSim-<VERSION> tags in each repo. 
#export DATE=`date -I`

# NOTE: This assumes the source trees are all
# in /usr/local/src on ahab.cnde.iastate.edu and
# generates archive with .git folders with upstream 
# marked as github or ssh://ahab.cnde.iastate.edu//usr/local/src/<repo>
# depending on the REPO_ROOT variables below. 

# Consider pre-generating a .mtblx of VibroSim_COMSOL; when doing this
# pre-adjust the version in the .prj to match the tagged version. 

export VERSION=$1

export VIBROSIM_REPOS="angled_friction_model closure_measurements crackclosuresim2 crackheat_surrogate2 tortuosity_tracing vibro_estparam VibroSim_COMSOL VibroSim_Simulator VibroSim_WelderModel crack_heatflow VibroSim_Release"

#export REPO_ROOT=ssh://ahab.cnde.iastate.edu//usr/local/src/
export REPO_ROOT=https://github.com/VibroSim

#export REPO_ROOT_LIMATIX=ssh://ahab.cnde.iastate.edu//usr/local/src
export REPO_ROOT_LIMATIX=https://github.com/limatix

#export REPO_ROOT_HEATSIM2=ssh://ahab.cnde.iastate.edu//usr/local/src
export REPO_ROOT_HEATSIM2=https://github.com/isuthermography

if test `hostname` != ahab.cnde.iastate.edu ; then 
  echo 'WARNING: Building VibroSim release from incorrect host'
  hostname
fi



for repo in $VIBROSIM_REPOS ; do 
  cd /usr/local/src/$repo
  git update-index --refresh
  
  if ! git diff-index --quiet HEAD -- ; then
    echo >&2 "Error in repository $repo$: There are uncommited changes"
  fi


  if test $(git rev-parse master) != $(git rev-parse VibroSim-$VERSION^{commit}); then
      echo "WARNING: Repository $repo: VibroSim-$VERSION does not match the current head of the master branch"
  fi

done

mkdir /tmp/VibroSim-$VERSION
cd /tmp/VibroSim-$VERSION

echo $VIBROSIM_REPOS

for repo in $VIBROSIM_REPOS ; do 
  git clone $REPO_ROOT/$repo 
done

git clone $REPO_ROOT_LIMATIX/limatix
git clone $REPO_ROOT_HEATSIM2/heatsim2

# handle limatix sub-repos
git clone $REPO_ROOT_LIMATIX/limatix/limatix/canonicalize_path limatix/limatix/canonicalize_path

git clone $REPO_ROOT_LIMATIX/limatix/limatix/dc_lxml_treesync limatix/limatix/dc_lxml_treesync

for repo in $VIBROSIM_REPOS ; do 
  cd /tmp/VibroSim-$VERSION/$repo
  git checkout VibroSim-$VERSION
  git submodule update
done

# Copy VibroSim_README.txt from VibroSim_Release archive
cp /usr/local/src/VibroSim_Release/VibroSim_README.txt /tmp/VibroSim-$VERSION/README.txt
cp /usr/local/src/VibroSim_Release/LICENSE.txt /tmp/VibroSim-$VERSION/LICENSE.txt

cp -a /usr/local/src/VibroSim_Release/docs /tmp/VibroSim-$VERSION/

cd /tmp
zip -r VibroSim-$VERSION.zip VibroSim-$VERSION
cp /tmp/VibroSim-$VERSION.zip /usr/local/src/

echo "It might be nice to also generate the .mltbx version of VibroSim_COMSOL and add that to the .ZIP file /usr/local/src/VibroSim-$VERSION"
