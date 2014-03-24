class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string    :title
      t.text      :description
      t.string    :summary
      t.boolean   :is_anonymous

      t.string    :category_ids
      t.boolean   :is_trial

      t.timestamps
    end
  end
end
