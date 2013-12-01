require 'spec_helper'

describe ContactsImportModule do

  before do
    ImportModule.delete_all
  end

  let(:import_module){create(:contacts_import_module)}

  describe "#rollback" do
    describe "if remote rollback is successfull" do
      before do
        import_module
        RestClient.should_receive(:delete).and_return double(code: 200)
      end
      it "destroys it self" do
        id = import_module.id
        import_module.rollback
        ImportModule.exists?(id: id).should be_false
      end
    end
    describe "if remote rollback fails" do
      before do
        import_module
        RestClient.should_receive(:delete).and_return double(code: 400)
      end
      it "doesn't destroy it self" do
        id = import_module.id
        import_module.rollback
        ImportModule.exists?(id: id).should be_true
      end
    end
  end
end
