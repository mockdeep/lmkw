# frozen_string_literal: true

class CreateIntegrations < ActiveRecord::Migration[6.0]
  def change
    create_table :integrations do |t|
      t.references :user, foreign_key: true, null: false
      t.string :type, null: false
      t.jsonb :data, null: false, default: {}
      t.timestamps
    end
    add_index :integrations, [:user_id, :type], unique: true
    add_index :integrations, :type
  end
end
