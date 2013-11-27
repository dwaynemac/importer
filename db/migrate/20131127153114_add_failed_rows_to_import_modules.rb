class AddFailedRowsToImportModules < ActiveRecord::Migration
  def change
    add_column :import_modules, :failed_rows, :boolean
  end
end
