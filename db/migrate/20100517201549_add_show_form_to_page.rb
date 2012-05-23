class AddShowFormToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :show_form, :boolean, :default => false
  end

  def self.down
    remove_column :pages, :show_form
  end
end
