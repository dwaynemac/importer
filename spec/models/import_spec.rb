require 'spec_helper'

describe Import do

  let(:import) { create(:import) }
  let(:cim) { create(:contacts_import_module, import: import) }
  let(:tsi) { create(:time_slot_importer, import: import) }

  describe "#finished?" do
    before do
      cim
      tsi
    end
    it "is finished if all importers related to him are finished" do
      ContactsImportModule.any_instance.stub(:finished?).and_return(true)
      TimeSlotImporter.any_instance.stub(:finished?).and_return(true)
      import.finished?.should == true
    end
    it "isn't finished if at least one importer related to him isn't finished" do
      ContactsImportModule.any_instance.stub(:finished?).and_return(true)
      TimeSlotImporter.any_instance.stub(:finished?).and_return(false)
      import.finished?.should == false
    end
  end

end
