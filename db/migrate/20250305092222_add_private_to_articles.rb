class AddPrivateToArticles < ActiveRecord::Migration[8.0]
  def change
    add_column :articles, :private, :boolean
  end
end
