require 'spec_helper'

describe Import do

  let(:import) { create(:import) }
  let(:cim) { create(:contacts_import_module, import: import) }
  let(:tsi) { create(:time_slot_importer, import: import) }
  before do
    cim
    tsi
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
      ContactsImportModule.any_instance.should_receive(:finished?).once
      import.realtime_status
    end
    it "shouldn't make a query if it has finished" do
      import.update_attribute(:status, 'finished')
      ContactsImportModule.any_instance.should_not_receive(:finished?)
      import.realtime_status
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
