task :update_statuses do
  puts "updating statuses"
  ImportModule.update_statuses
end

task :delegate_ready_imports => [:update_statuses] do
  puts 'starting delegate_ready_imports'
  ImportModule.delegate_ready_imports
end
