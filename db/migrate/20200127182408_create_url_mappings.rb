class CreateUrlMappings < ActiveRecord::Migration[6.0]
  def change
    create_table :url_mappings do |t|
      t.string :actual_url
      t.string :token

      t.timestamps
    end

     add_index :url_mappings, :token, unique: true
  end
end
