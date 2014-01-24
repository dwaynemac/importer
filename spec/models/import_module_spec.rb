require 'spec_helper'

describe ImportModule do

  before do
    ImportModule.delete_all
  end

  let(:import_module){create(:import_module)}

  describe "#processed_lines" do
    before do
      RestClient.stub(:get).and_return({import: {:status => 'working',
                             :failed_rows => '1',
                             :imported_rows => '2'}}.to_json)
    end

    it "returns integer" do
      im = create(:contacts_import_module)
      im.processed_lines.should be_a Integer
    end
    it "returns count of processed lines" do
      im = create(:contacts_import_module)
      im.processed_lines.should == 3
    end
  end

  describe "#realtime_status" do
    describe "if status_url is nil" do
      it "returns waiting" do
        import_module.realtime_status.should == 'waiting'
      end
      it "returns ready if ready?" do
        ImportModule.any_instance.stub(:ready?).and_return(true)
        import_module.realtime_status.should == 'ready'
      end
    end
  end

  describe "#ignore_failed_rows" do
    describe "when status is not 'pending'" do
      before { import_module.update_attribute :status, 'ready' }
      it "doesn't change status" do
        import_module.ignore_failed_rows='true'
        import_module.reload.status.should == 'ready'
      end
    end
    describe "when status is 'pending'" do
      before { import_module.update_attribute :status, 'pending' }
      it "sets status :finished if 'true' if given" do
        import_module.ignore_failed_rows='true'
        import_module.reload.status.should == 'finished'
      end
      it "sets status :failed if other value if given" do
        import_module.ignore_failed_rows='false'
        import_module.reload.status.should == 'failed'
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
