class DropKatexFields < ActiveRecord::Migration[5.2]
  def change
    %i[title_katex tldr_katex body_katex].each do |sym|
      remove_column :articles, sym
    end
  end
end
