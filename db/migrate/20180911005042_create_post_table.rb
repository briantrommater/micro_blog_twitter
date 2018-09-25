class CreatePostTable < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.text :post
      t.datetime :posted_at
      end
  end
end
