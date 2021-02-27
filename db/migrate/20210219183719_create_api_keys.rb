# frozen_string_literal: true

class CreateApiKeys < ActiveRecord::Migration[6.1]
  def change
    create_table :api_keys do |t|
      t.references(:user, foreign_key: true, null: false)
      t.string(:name, null: false)
      t.string(:value, null: false, index: { unique: true })

      t.timestamps
    end
  end
end
