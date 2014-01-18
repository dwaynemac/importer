require 'spec_helper'

describe ImportModule do

  before do
    ImportModule.delete_all
  end

  let(:import_module){create(:import_module)}

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

  describe "#open_tmp_file" do
    let(:url){"https://s3.amazonaws.com/importer-staging/uploads/import/import_file/2/time_slots.csv"}
    let(:im){ImportModule.new}
    let(:ret){im.open_tmp_file(url)}
    it "returns not nil" do
      ret.should_not be_nil
    end
    it "returns a File" do
      ret.should be_a File
    end
    it "keeps same size" do
      ret.size.should == 372391
    end
    it "keeps same content" do
      IO.read(ret).should == open(url).read
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
