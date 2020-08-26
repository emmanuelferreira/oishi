class ChangeEcoScoreToBeStringInProducts < ActiveRecord::Migration[6.0]
  def change
    change_column :products, :eco_score, :string
  end
end
