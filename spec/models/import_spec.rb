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
      #require 'byebug'; byebug
      ContactsImportModule.any_instance.should_receive(:finished?).once
      import.realtime_status
    end
    it "shouldn't make a query if it has finished" do
      import.update_attribute(:status, 'finished')
      ContactsImportModule.any_instance.should_not_receive(:finished?)
      import.realtime_status
    end
  end

end
