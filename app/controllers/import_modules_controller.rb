class ImportModulesController < ApplicationController

  def failed_rows
    im = ImportModule.find(params[:id])
    contacts_response = RestClient.get  "#{im.status_url}/failed_rows.csv",
                                        :params => im.status_params 
    respond_to do |format|
        format.csv { send_data contacts_response, type: 'text/csv', disposition: "attachment; filename=import_errors.csv" }
    end
  end

end
