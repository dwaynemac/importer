class CreateModules < ActiveRecord::Migration
  def change
    create_table :modules do |t|
      t.belongs_to :import
      t.string :name
      t.string :status
    end
  end
end
