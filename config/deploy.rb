require 'mongrel_cluster/recipes'
task :live do
  set :application, "gallerydog"
  set :domain, "gallerydog.info"
  role :app, domain
  role :web, domain
  role :db, domain, :primary => true
  set :deploy_to, "/var/www/apps/#{application}"
  set :user, "root"
  set :password, "gallerydogAEjM123js"
  set :group, "root"
  set :keep_releases, 2 

  set :scm, "git"
  set :repository, "git@github.com:azwerner/gallerydog.git"
  set :branch, "release"
  set :deploy_via, :checkout
  set :git_shallow_clone, 1
  default_run_options[:pty] = true

  namespace :deploy do
    task :start, :roles => :app do
      run "touch #{current_release}/tmp/restart.txt"
    end

    task :stop, :roles => :app do
      # Do nothing.
    end

    desc "Restart Application"
    task :restart, :roles => :app do
      run "touch #{current_release}/tmp/restart.txt"
    end
  end


  after "deploy:update_code", :symlink_config_files,
                              'bundler:bundle_install',
                              :fix_public_dir_permission,
                              :fix_tmp_dir_permission,
                              "deploy:migrate",
                              :rebuild_sphinx,
                              :cleanup

  namespace :bundler do
    task :bundle_install, :roles => :app do
      run "cd #{release_path} && bundle install --without test"
    end
  end

  task :symlink_config_files do
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml"
    # run "ln -nfs #{deploy_to}/#{shared_dir}/config/production.sphinx.conf #{release_path}/config/production.sphinx.conf"
  end

  task :fix_public_dir_permission do
    run "chmod -R g+w #{release_path}/public"
  end


  task :fix_tmp_dir_permission do
    run "chmod -R a+rw #{release_path}/tmp"
  end

  desc "Rebuild sphinx"
  task :rebuild_sphinx , :roles => :app do
    run "cd #{release_path} && RAILS_ENV=production rake thinking_sphinx:rebuild"
  end

  desc "Rebuild sphinx index"
  task :index_sphinx, :roles => :app do
    run "cd #{release_path} && RAILS_ENV=production rake thinking_sphinx:index"
    run "cd #{release_path} && RAILS_ENV=production rake thinking_sphinx:rebuild"
  end

  desc <<-DESC
  Removes unused releases from the releases directory. By default, the last 5
  releases are retained, but this can be configured with the 'keep_releases'
  variable. This will use sudo to do the delete by default, but you can specify
  that run should be used by setting the :use_sudo variable to false.
  DESC
  task :cleanup do
    count = (self[:keep_releases] || 5).to_i
    if count >= releases.length
      logger.important "no old releases to clean up"
    else
      logger.info "keeping #{count} of #{releases.length} deployed releases"
      directories = (releases - releases.last(count)).map { |release| File.join(releases_path, release) }.join(" ")
      run "rm -rf #{directories}"
    end
  end
end

task :stage do
  set :application, "gallerydog_stage"
  set :domain, "ec2-50-16-125-233.compute-1.amazonaws.com"
  role :app, domain
  role :web, domain
  role :db, domain, :primary => true
  set :deploy_to, "/var/www/apps/#{application}"
  set :user, "root"
  set :password, "gallerydogAEjM123js"
  set :group, "admin"
  set :keep_releases, 2 

  set :scm, "git"
  set :repository, "git@github.com:azwerner/gallerydog.git"
  set :branch, "restore_r3"
  set :deploy_via, :checkout
  set :git_shallow_clone, 1
  default_run_options[:pty] = true

  namespace :deploy do
    task :start, :roles => :app do
      run "touch #{current_release}/tmp/restart.txt"
    end

    task :stop, :roles => :app do
      # Do nothing.
    end

    desc "Restart Application"
    task :restart, :roles => :app do
      run "touch #{current_release}/tmp/restart.txt"
    end
  end


  after "deploy:update_code", :symlink_config_files,
                              'bundler:bundle_install',
                              :fix_public_dir_permission,
                              :fix_tmp_dir_permission,
                              "deploy:migrate",
                              :index_sphinx,
                              :cleanup

  namespace :bundler do
    task :bundle_install, :roles => :app do
      run "cd #{release_path} && bundle install --without test"
    end
  end
  
  
  task :symlink_config_files do
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml"
    # run "ln -nfs #{deploy_to}/#{shared_dir}/config/production.sphinx.conf #{release_path}/config/production.sphinx.conf"
  end

  task :fix_public_dir_permission do
    run "chmod -R g+w #{release_path}/public"
  end


  task :fix_tmp_dir_permission do
    run "chmod -R a+rw #{release_path}/tmp"
  end

  desc "Rebuild sphinx"
  task :rebuild_sphinx , :roles => :app do
    run "cd #{release_path} && sudo RAILS_ENV=production rake thinking_sphinx:rebuild"
  end

  desc "Rebuild sphinx index"
  task :index_sphinx, :roles => :app do
    run "cd #{release_path} && sudo RAILS_ENV=production rake thinking_sphinx:index"
    run "cd #{release_path} && sudo RAILS_ENV=production rake thinking_sphinx:rebuild"
  end

  desc <<-DESC
  Removes unused releases from the releases directory. By default, the last 5
  releases are retained, but this can be configured with the 'keep_releases'
  variable. This will use sudo to do the delete by default, but you can specify
  that run should be used by setting the :use_sudo variable to false.
  DESC
  task :cleanup do
    count = (self[:keep_releases] || 5).to_i
    if count >= releases.length
      logger.important "no old releases to clean up"
    else
      logger.info "keeping #{count} of #{releases.length} deployed releases"
      directories = (releases - releases.last(count)).map { |release| File.join(releases_path, release) }.join(" ")
      run "rm -rf #{directories}"
    end
  end
end