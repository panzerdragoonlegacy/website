module DragoonsHelper
    
  def article_count(dragoon)
    policy_scope(dragoon.articles).count
  end
  
  def download_count(dragoon)
    policy_scope(dragoon.downloads).count
  end
  
  def link_count(dragoon)
    policy_scope(dragoon.links).count
  end
  
  def music_track_count(dragoon)
    policy_scope(dragoon.music_tracks).count
  end

  def news_entry_count(dragoon)
    policy_scope(dragoon.news_entries).count
  end
  
  def picture_count(dragoon)
    policy_scope(dragoon.pictures).count
  end
  
  def poem_count(dragoon)
    policy_scope(dragoon.poems).count
  end
  
  def quiz_count(dragoon)
    policy_scope(dragoon.quizzes).count
  end
  
  def resource_count(dragoon)
    policy_scope(dragoon.resources).count
  end
  
  def story_count(dragoon)
    policy_scope(dragoon.stories).count
  end
  
  def video_count(dragoon)
    policy_scope(dragoon.videos).count
  end
  
  def website_contributions_count(dragoon)
    return news_entry_count(dragoon) + article_count(dragoon) + download_count(dragoon) + 
    link_count(dragoon) + music_track_count(dragoon) + picture_count(dragoon) + 
    poem_count(dragoon) + quiz_count(dragoon) + resource_count(dragoon) + story_count(dragoon) + 
    video_count(dragoon)
  end
  
end
