namespace :passenger do
  desc "Run Passenger tasks to release new version" 
  task :release do
    on roles(:web) do
      within "#{current_path}" do
        with rails_env: "production" do
          run "bash deploy.sh"
        end
      end
    end
  end
end
