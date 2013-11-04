class AddImportModuleType < ActiveRecord::Migration
  def change
    add_column :import_modules, :type, :string
  end
end
