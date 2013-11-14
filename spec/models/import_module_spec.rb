require 'spec_helper'

describe ImportModule do

  before do
    ImportModule.delete_all
  end

  let(:import_module){create(:import_module)}

  describe "#realtime_status" do
    describe "if status_url if nil" do
      it "returns nil" do
        import_module.realtime_status.should be_nil
      end
    end
  end

  describe ".update_statuses" do
    before do
      ImportModule.any_instance.stub(:realtime_status).and_return(true)
    end
    it "calls realtime_status on unfinished and delegated import_modules" do
      import_module.update_attributes(status: 'pending', status_url: 'www')
      ImportModule.any_instance.should_receive(:realtime_status)
      ImportModule.update_statuses
    end
    it "won't call realtime_status on finished import_modules" do
      import_module.update_attributes(status: 'finished', status_url: 'www')
      ImportModule.any_instance.should_not_receive(:realtime_status)
      ImportModule.update_statuses
    end
    it "won't call realtime_status on not-delegated import_modules" do
      import_module.update_attributes(status: 'pending', status_url: nil)
      ImportModule.any_instance.should_not_receive(:realtime_status)
      ImportModule.update_statuses
    end
  end

  describe ".delegate_ready_imports" do
    it "calls delegate_import on import_modules that are ready" do
      import_module
      ImportModule.any_instance.stub(:ready?).and_return(true)
      ImportModule.any_instance.should_receive(:delegate_import)
      ImportModule.delegate_ready_imports
    end
    it "wont call delegate_import on import_modules not ready" do
      import_module
      ImportModule.stub(:ready?).and_return(false)
      ImportModule.any_instance.should_not_receive(:delegate_import)
      ImportModule.delegate_ready_imports
    end
    it "ignores import_modules that have already delegated" do
      import_module.update_attribute :status_url, 'asdf/12'
      ImportModule.any_instance.should_not_receive(:ready?)
      ImportModule.delegate_ready_imports
    end
    it "ignores finished import_modules" do
      import_module.update_attribute :status, 'finished'
      ImportModule.any_instance.should_not_receive(:ready?)
      ImportModule.delegate_ready_imports
    end
  end
end
