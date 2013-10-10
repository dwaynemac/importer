class AddStatusUrlToImportModules < ActiveRecord::Migration
  def change
    add_column :import_modules, :status_url, :string
  end
end
