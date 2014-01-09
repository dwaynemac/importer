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

  def failed_files
    im = ImportModule.find params[:id]
    failed_contacts_response = RestClient.get "#{im.status_url}/failed_contacts",
                                              params: im.status_params
    
    failed_contacts_ids = JSON.parse(failed_contacts_response)[:failed_contacts]

    response = RestClient.post  Kshema::HOST + '/pws/v1/files_export',
                                key: Kshema::API_KEY,
                                account_name: im.import.account.name,
                                contacts_ids: failed_contacts_ids
    if response.code == 201
      im.update_attributes(status_url: Kshema::HOST + '/pws/v1/files_export/' + JSON.parse(response)['id'])
    end

    respond_to do |format|
      format.html { redirect_to im.import }
    end
  end

  private

  def import_module_params
    params.require( :import_module ).permit(:ignore_failed_rows, :status)
  end

end
