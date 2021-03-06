class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :title
      t.string :image_url
      t.string :url
      t.string :status
      t.datetime :started
      t.datetime :completed

      t.timestamps
    end
  end
end
