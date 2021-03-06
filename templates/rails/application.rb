# This needs to be called after one of the gemfile templates

apply 'http://datamapper.org/templates/rails/config.rb'
apply 'http://datamapper.org/templates/rails/database.yml.rb'
apply 'http://datamapper.org/templates/rails/gitignore.rb'

inject_into_file  'app/controllers/application_controller.rb',
                  "require 'dm-rails/middleware/identity_map'\n",
                  :before => 'class ApplicationController'

inject_into_class 'app/controllers/application_controller.rb',
                  'ApplicationController',
                  "  use Rails::DataMapper::Middleware::IdentityMap\n"

initializer 'jruby_monkey_patch.rb', <<-CODE
if RUBY_PLATFORM =~ /java/
  # ignore the anchor to allow this to work with jruby:
  # http://jira.codehaus.org/browse/JRUBY-4649
  class Rack::Mount::Strexp

    class << self
      alias :compile_old :compile
      def compile(str, requirements, separators, anchor)
        self.compile_old(str, requirements, separators)
      end
    end
  end
end
CODE

say ''
say '---------------------------------------------------------------------------'
say "Edit your Gemfile (do not forget to run 'bundle install' after doing that)"
say '---------------------------------------------------------------------------'
say 'If you want to use rspec for testing, you first need to uncomment the line'
say "that declares it in the Gemfile. The you need to run 'bundle install' again"
say "Once that's done, you need to actually install it into your app and update"
say "your spec_helper as shown in the dm-rails README"
say '---------------------------------------------------------------------------'
say 'Install rspec (optional):             script/rails g rspec:install'
say 'Have a look at the dm-rails README:   http://github.com/datamapper/dm-rails'
say '---------------------------------------------------------------------------'
say 'Have a look at available rake tasks:  rake -T'
say 'Generate a simple scaffold:           rails g scaffold Person name:string'
say 'Create, automigrate and seed the DB:  rake db:setup'
say 'Start the server:                     script/rails server'
say '---------------------------------------------------------------------------'
say 'After the sever booted, point your browser at http://localhost:3000/people'
say '---------------------------------------------------------------------------'
say ''
