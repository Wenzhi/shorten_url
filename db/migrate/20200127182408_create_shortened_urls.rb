class CreateShortenedUrls < ActiveRecord::Migration[6.0]
  def change
    create_table :shortened_urls do |t|
      t.string :actual_url
      t.string :short_url

      t.timestamps
    end

     add_index :shortened_urls, :short_url, unique: true
  end
end
