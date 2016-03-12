class CreateAndroidTokens < ActiveRecord::Migration
  def change
    create_table :android_tokens do |t|
      t.string :value

      t.timestamps null: false
    end
  end
end
