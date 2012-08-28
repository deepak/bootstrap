# checks for existence of the gemset ruby-1.9.3-p194@rails_bootstrap
# and creates it with some base gems, if it does not exist
# note, removing a gemset does not delete the ~/.rvm/environments/$environment_id file
# so we grep the gemset name 
function _rails_new_create_gemset
{
    local gemset="rails_bootstrap"

    local old_gemset=`rvm-prompt`
    rvm use ruby-1.9.3-p194

    local gemset_exists=`rvm gemset list | grep ${gemset}`
    if [[ -z "$gemset_exists" ]]; then
        rvm gemset create ${gemset}
        rvm gemset use ${gemset}
        gem install bundler -v 1.1.5
        gem install rails -v 3.2.8
    fi
    rvm use ${old_gemset}
}

# steps:
# 1. create a rvm gemset ruby-1.9.3-p194@rails_bootstrap
#    if it does not exists, and install bundler and rails
#    inside it
# 2. get the existing gemset in use
# 3. use the gemset ruby-1.9.3-p194@rails_bootstrap as on step (1)
# 4. create a new rails project. can use an application template
# 5. switch back to the old gemset as on step (2)
function rails_new()
{
  local old_gemset=`rvm-prompt`
  _rails_new_create_gemset
  rvm use 1.9.3-p194@rails_bootstrap
  if [ -z "$1" ] #zero length?
  then
    echo "[ERROR] please provide app name. usage: rails_new <app-name>"
    return 1;
  else
    local app_name=$1;
    # --skip-bundle as we will do that after creating a .rvmrc
    # -d postgresql, use postgres as sqlite/mysql is the default
    # -T skip Test::Unit as will use rspec
    local cmd="rails new ${app_name} --skip-bundle --skip-gemfile -d postgresql -T"
    if [ -n "$2" ]; then #non-zero length?
        local template_path=$2;
        # --skip-bundle as we will do that after creating a .rvmrc
        # -d postgresql, use postgres as sqlite/mysql is the default
        # -T skip Test::Unit as will use rspec
        cmd="$cmd -m ${template_path}"
    fi
    echo $cmd
    $cmd
    wait
    rvm use ${old_gemset}
  fi
}
