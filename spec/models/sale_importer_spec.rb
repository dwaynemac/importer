require 'spec_helper'

describe SaleImporter do

  let(:si) { create(:sale_importer) }
  let(:cim) { create(:contacts_import_module, import: si.import) }
  let(:pi) {create(:product_importer, import: si.import)}

  describe "#ready?" do
    before do
      #because let is lazy
      cim
      pi
    end

    describe "when contact importer has not finished" do
      before do
        ContactsImportModule.any_instance.stub(:finished?) {false}
      end
      it "shouldn't be ready" do
        si.ready?.should == false
      end
    end

    describe "when product importer has not finished" do
      before do
        ProductImporter.any_instance.stub(:finished?) {false}
      end
      it "shouldn't be ready" do
        si.ready?.should == false
      end
    end

    describe "when contact importer and product importer have finished" do
      before do
        ContactsImportModule.any_instance.stub(:finished?) {true}
        ProductImporter.any_instance.stub(:finished?) {true}
      end
      it "should be ready" do
        si.ready?.should == true
      end
    end

  end

  describe "#delegate_import" do
    before do
      si.stub_chain(:import_file, :sales, :url).and_return("x_path")
      si.stub_chain(:open, :read) {"x_file"}
    end

    describe "if fnz-ws responds ok" do
      before do
        my_response = double("Response", code: 201, body: "{\"id\": \"1\"}")
        RestClient.stub(:post).and_return(my_response)
      end
      it "should set status_url" do
        si.delegate_import()
        si.status_url.should == "test/api/v0/imports/1"
      end
    end

  end

end
