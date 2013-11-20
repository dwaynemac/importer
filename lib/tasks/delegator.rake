task :update_statuses => :environment do
  puts "updating statuses"
  ImportModule.update_statuses
end

task :delegate_ready_imports => [:environment, :update_statuses] do
  puts 'starting delegate_ready_imports'
  ImportModule.delegate_ready_imports
end
