require 'spec_helper'

describe ProductImporter do

  let(:pi) { create(:product_importer) }
  let(:cim) { create(:contacts_import_module, import: pi.import) }

  describe "#ready?" do
    before do
      #because let is lazy
      cim
    end

    describe "when contact importer has not finished" do
      before do
        ContactsImportModule.any_instance.stub(:finished?) {false}
      end
      it "should be ready" do
        pi.ready?.should == true
      end
    end

  end

  describe "#delegate_import" do
    before do
      pi.stub_chain(:import_file, :products, :url).and_return("x_path")
      pi.stub_chain(:open, :read) {"x_file"}
    end

    describe "if fnz-ws responds ok" do
      before do
        my_response = double("Response", code: 201, body: "{\"id\": \"1\"}")
        RestClient.stub(:post).and_return(my_response)
      end
      it "should set status_url" do
        pi.delegate_import()
        pi.status_url.should == "test/api/v0/imports/1"
      end
    end

  end

end
