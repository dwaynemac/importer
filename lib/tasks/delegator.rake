desc 'updates status of all ImportModules'
task :update_statuses => :environment do
  puts "updating statuses"
  ImportModule.update_statuses
end

desc 'it delegates importation'
task :delegate_ready_imports => [:environment, :update_statuses] do
  puts 'starting delegate_ready_imports'
  ImportModule.delegate_ready_imports
end
