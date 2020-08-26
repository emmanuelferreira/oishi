class ChangeNutriScoreToBeStringInProducts < ActiveRecord::Migration[6.0]
  def change
    change_column :products, :nutri_score, :string
  end
end
