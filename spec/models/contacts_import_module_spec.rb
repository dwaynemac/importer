require 'spec_helper'

describe ContactsImportModule do

  before do
    ImportModule.delete_all
  end

  let(:im){create(:contacts_import_module)}

  describe "#rollback" do
    describe "if module failed" do
      before { im.update_attributes(status: 'failed', status_url: 'xxx') }
      describe "and has not been rollbacked" do
        it "delegates rollback" do
          RestClient.should_receive(:delete).and_return double code: 200
          im.rollback
        end
        it "sets status to rollbacked if remote is successfull" do
          RestClient.stub(:delete).and_return double code: 200
          im.rollback
        end
        it "doesnt changes status if remote fails" do
          RestClient.stub(:delete).and_return double code: 400
          im.rollback
        end
      end
      describe "and has been rollbacked" do
        before { im.update_attributes(status: 'rolledback', status_url: 'xxx') }
        it "won't rollback again" do
          RestClient.should_not_receive :delete
          im.rollback
        end
      end
    end
    describe "if modules finished" do
      it "won't rollback again" do
        RestClient.should_not_receive :delete
        im.rollback
      end
    end
  end
end
