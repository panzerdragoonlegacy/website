class ChangePublishColumnDefaultValuesToFalse < ActiveRecord::Migration
  def up
    change_column_default :articles, :publish, false
    change_column_default :categories, :publish, false
    change_column_default :chapters, :publish, false
    change_column_default :downloads, :publish, false
    change_column_default :encyclopaedia_entries, :publish, false
    change_column_default :music_tracks, :publish, false
    change_column_default :news_entries, :publish, false
    change_column_default :pages, :publish, false
    change_column_default :pictures, :publish, false
    change_column_default :poems, :publish, false
    change_column_default :quizzes, :publish, false
    change_column_default :resources, :publish, false
    change_column_default :stories, :publish, false
    change_column_default :videos, :publish, false
  end

  def down
    change_column_default :videos, :publish, nil
    change_column_default :stories, :publish, nil
    change_column_default :resources, :publish, nil
    change_column_default :quizzes, :publish, nil
    change_column_default :poems, :publish, nil
    change_column_default :pictures, :publish, nil
    change_column_default :pages, :publish, nil
    change_column_default :news_entries, :publish, nil
    change_column_default :music_tracks, :publish, nil
    change_column_default :encyclopaedia_entries, :publish, nil
    change_column_default :downloads, :publish, nil
    change_column_default :chapters, :publish, nil
    change_column_default :categories, :publish, nil
    change_column_default :articles, :publish, nil
  end
end
