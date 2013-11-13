task :delegate_ready_imports => :environment do
  Rails.logger.info 'starting delegate_ready_imports'
  ImportModule.delegate_ready_imports
end
