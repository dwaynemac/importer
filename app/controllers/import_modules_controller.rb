class ImportModulesController < ApplicationController

  def failed_rows
    im = ImportModule.find(params[:id])
    contacts_response = RestClient.get  "#{im.status_url}/failed_rows.csv",
                                        :params => im.status_params 
    respond_to do |format|
      format.csv { send_data contacts_response, type: 'text/csv', disposition: "attachment; filename=import_errors.csv" }
    end
  end

  def update
    im = ImportModule.find(params[:id])
    im.update_attributes(import_module_params)
    respond_to do |format|
      format.html { redirect_to im.import }
    end
  end

  private

  def import_module_params
    params.require( :import_module ).permit(:ignore_failed_rows)
  end

end
