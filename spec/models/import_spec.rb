require 'spec_helper'

describe Import do

  let(:import) { create(:import) }
  let(:cim) { create(:contacts_import_module, import: import) }
  let(:tsi) { create(:time_slot_importer, import: import) }
  before do
    cim
    tsi
  end

  describe "#destroy" do
    it "destroys all import_modules too" do
      ImportModule.exists?(id: cim.id).should be_true
      ImportModule.exists?(id: tsi.id).should be_true
      import.destroy
      ImportModule.exists?(id: cim.id).should be_false
      ImportModule.exists?(id: tsi.id).should be_false
    end
  end

  describe "#can_rollback?" do
    it "returns false" do
      import.can_rollback?.should be_false
    end
    describe "if ContactsModuleImport finished with failed rows" do
      before do
        cim.update_attribute :status, 'failed' 
        cim.update_attribute :status_url, 'xxx' 
      end
      describe "and no other modules started" do
        it "returns true" do
          pending "waiting for rollback to be implemented in modules" do
            import.can_rollback?.should be_true
          end
        end
      end
      describe "and other modules already started" do
        before do
          tsi.update_attribute :status, 'working'
        end
        it "returns false" do
          pending "waiting for rollback to be implemented in modules"
          import.can_rollback?.should be_false
        end
      end
    end
    describe "if ContactsModuleImport finished successfully" do
      before do
        cim.update_attribute :status, 'finished'
      end
      it "return false" do
        pending "waiting for rollback to be implemented in modules"
        import.can_rollback?.should be_false
      end
    end
    describe "if ContactsModuleImport hasnt started" do
      it "returns false" do
        pending "waiting for rollback to be implemented in modules"
        import.can_rollback?.should be_false
      end
    end
  end

  describe "#finished?" do
    it "has finished if all importers related to it had finished" do
      ContactsImportModule.any_instance.stub(:finished?).and_return(true)
      TimeSlotImporter.any_instance.stub(:finished?).and_return(true)
      import.finished?.should == true
    end
    it "has not finished if at least one importer related to it had not finished" do
      ContactsImportModule.any_instance.stub(:finished?).and_return(true)
      TimeSlotImporter.any_instance.stub(:finished?).and_return(false)
      import.finished?.should == false
    end
  end

  describe "#realtime_status" do
    it "should make a query if it has not finished" do
      ContactsImportModule.stub(:finished?) #this could be any class method of any class it's a hack
      ContactsImportModule.any_instance.stub(:finished?) { |*args| ContactsImportModule.finished?(*args) }
      ContactsImportModule.should_receive(:finished?).at_least(:once)
      import.realtime_status
    end
    it "shouldn't make a query if it has finished" do
      import.update_attribute(:status, 'finished')
      ContactsImportModule.any_instance.should_not_receive(:status)
      import.realtime_status
    end
    it "shouldn't make a query if it has failed" do
      import.update_attribute(:status, 'failed')
      ContactsImportModule.any_instance.should_not_receive(:status)
      import.realtime_status
    end
    it "should be failed if at least one has failed" do
      ContactsImportModule.any_instance.stub(:status).and_return('failed')
      TimeSlotImporter.any_instance.stub(:status).and_return('working')
      import.realtime_status.should == 'failed'
    end
    it "should be working if at least one is working (but no one failed)" do
      ContactsImportModule.any_instance.stub(:status).and_return('finished')
      TimeSlotImporter.any_instance.stub(:status).and_return('working')
      import.realtime_status.should == 'working'
    end
    it "should be pending if at least one is pending (but no one failed)" do
      ContactsImportModule.any_instance.stub(:status).and_return('pending')
      TimeSlotImporter.any_instance.stub(:status).and_return('working')
      import.realtime_status.should == 'pending'
    end
  end

  let(:import_file) do
    extend ActionDispatch::TestProcess
    fixture_file_upload("/files/belgrano_data.zip","application/zip")
  end

  describe "#save" do
    before do
      import.update_attribute(:import_file, import_file)
    end
    it "wont create additional import_modules on updates" do
      expect{import.save}.not_to change{import.import_modules.count} 
    end
  end

end
