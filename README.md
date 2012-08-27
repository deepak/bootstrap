bootstrap
=========

starter scripts to bootstrap a project. created it to optimize my workflow

== script

- rails_ui.rb
  rails application template to create a rails application for UI
  check http://guides.rubyonrails.org/generators.html#customizing-your-workflow-by-changing-generators-templates

== Other much better projects

- appscrolls: https://github.com/drnic/appscrolls
  might just use appscrolls later.
  for now wanted something that works for my small usecase

- rails_apps_composer:
  https://github.com/RailsApps/rails_apps_composer
  have not checked it

patches and feedback welcome

== Stuff i could not figure out
- how do it modify the rails CLI arguments inside the rails
  application template ?
- how do i change the rvm gemset inside the rails application template?

== Objectives
- use rvm. gemsets are quite good to isolate dependencies
- use application templates. could have committed an initial rails
  project, but can ask user feedback in an application template
- vendorize Gemfile.lock so that dependencies are locked
  and also because all the apps are on the same stack
- can document some stuff in the README
  eg. configure rubygems to not install rdoc and ri
  gems install are faster
