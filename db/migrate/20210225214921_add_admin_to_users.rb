# frozen_string_literal: true

class AddAdminToUsers < ActiveRecord::Migration[6.1]
  def change
    safety_assured do
      add_column :users, :admin, :boolean, null: false, default: false
    end
  end
end
