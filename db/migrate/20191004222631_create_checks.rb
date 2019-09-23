# frozen_string_literal: true

class CreateChecks < ActiveRecord::Migration[6.0]
  def change
    create_table :checks do |t|
      t.references :user, foreign_key: true, null: false
      t.references :integration, foreign_key: true, null: false
      t.string :name, null: false
      t.jsonb :data, null: false, default: {}
      t.string :type, null: false
      t.timestamps
    end

    add_index :checks, [:user_id, :name], unique: true
  end
end
