# USAGE:
# rails_new some_app_name ~/.bootstrap/rails_ui.rb
# put the contents of this folder under ~/.bootstrap/

# TODO: am not able to change the rails CLI options
# encoding rails new <app_name> --skip-bundle -d postgresql -T"
# @options = @options.dup.merge("skip_bundle" => true,
#                               "database" => "postgresql",
#                               "skip_test_unit" => true,
#                               "skip_gemfile" => true)

# so have a bash wrapper function
# can be in ~/.bash_profile
# function rails_new()
# {
#   if [ -z "$1" ] #zero length?
#   then
#     echo "[ERROR] please provide app name. usage: rails_new <app-name>"
#     return 1;
#   else
#     app_name=$1;
#     if [ -z "$2" ] #zero length?
#     then
#         # --skip-bundle as we will do that after creating a .rvmrc
#         # -d postgresql, use postgres as sqlite/mysql is the default
#         # -T skip Test::Unit as will use rspec
#         cmd="rails new ${app_name} --skip-bundle --skip-gemfile -d postgresql -T"
#     else
#         template_path=$2;
#         # --skip-bundle as we will do that after creating a .rvmrc
#         # -d postgresql, use postgres as sqlite/mysql is the default
#         # -T skip Test::Unit as will use rspec
#         cmd="rails new ${app_name} --skip-bundle --skip-gemfile -d postgresql -T -m ${template_path}"
#     fi
#     echo $cmd
#     $cmd
#     wait
#   fi
# }

def silence_stream(out=STDOUT)
  f = File::open('/dev/null', 'w')
  orig = out.clone
  out.reopen(f)
ensure
  out.reopen(orig)
end

def git_commit msg
  silence_stream do
    git :commit => %Q{ -m #{msg} }
  end
  log :run, msg
end

say ">--------------------------------[ INFO ]---------------------------------<"
say "rails cmd line options"
say @options.inspect
say "app_name: #{app_name.inspect}"
say "pwd: #{Dir.pwd}"
say ">-------------------------------------------------------------------------<"

copy_file "~/.bootstrap/rails/base_ui/Gemfile", "Gemfile"
copy_file "~/.bootstrap/rails/base_ui/Gemfile.lock", "Gemfile.lock"
run "cp -f ~/.bootstrap/rails/base_ui/dot_gitignore .gitignore"

# TODO: cannot run "rvm --rvmrc" inside this script
# `rvm --rvmrc --create ruby-1.9.3-p194@#{app_name}`

copy_file "~/.bootstrap/rails/base_ui/dot_rvmrc", ".rvmrc"
gsub_file '.rvmrc', /GIVE_A_GEMSET/, app_name

run "mv README.rdoc doc/RAILS_README.rdoc"
create_file "README.md", <<-README
the .rvmrc has been changed (per project)

TODO:
1. check that rvm gemset should not exist or be empty
2. change ~/.gemrc to
   install: --no-rdoc --no-ri 
   update:  --no-rdoc --no-ri
3. gem install bundler
4. bundle install
5. git commit
5. rake db:migrate
6. git commit
7. vendorize the gems so subsequent gem installs are faster
8. add project specific README
README

git :init
git :add => "."
git_commit 'First commit'
# git :add => "onefile.rb", :rm => "badfile.cxx"
# # remove_file "public/index.html"

# TODO: cannot seem to reload rvmrc inside this script

# say "Running Bundler install"
# run 'bundle install'
# git :add => "."
# git_commit 'bundle install'

# say "Running db:migrate"
# rake("db:migrate")
# git :add => "."
# git_commit 'db migrate'
