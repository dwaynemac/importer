task :delegate_ready_imports => :environmend do
  Rails.logger.info 'starting delegate_ready_imports'
  ImportModule.delegate_ready_imports
end
