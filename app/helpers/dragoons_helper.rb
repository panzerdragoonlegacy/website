module DragoonsHelper
  
  def news_entry_count(dragoon)
    return dragoon.news_entries.accessible_by(current_ability).count
  end
  
  def article_count(dragoon)
    return dragoon.articles.accessible_by(current_ability).count
  end
  
  def download_count(dragoon)
    return dragoon.downloads.accessible_by(current_ability).count
  end
  
  def link_count(dragoon)
    return dragoon.links.accessible_by(current_ability).count
  end
  
  def music_track_count(dragoon)
    return dragoon.music_tracks.accessible_by(current_ability).count
  end
  
  def picture_count(dragoon)
    return dragoon.pictures.accessible_by(current_ability).count
  end
  
  def poem_count(dragoon)
    return dragoon.poems.accessible_by(current_ability).count
  end
  
  def quiz_count(dragoon)
    return dragoon.quizzes.accessible_by(current_ability).count
  end
  
  def resource_count(dragoon)
    return dragoon.resources.accessible_by(current_ability).count
  end
  
  def story_count(dragoon)
    return dragoon.stories.accessible_by(current_ability).count
  end
  
  def video_count(dragoon)
    return dragoon.videos.accessible_by(current_ability).count
  end
  
  def discussion_count(dragoon)
    return dragoon.discussions.accessible_by(current_ability).count
  end
  
  def comment_count(dragoon)
    return dragoon.comments.accessible_by(current_ability).count
  end
  
  def website_contributions_count(dragoon)
    return news_entry_count(dragoon) + article_count(dragoon) + download_count(dragoon) + 
    link_count(dragoon) + music_track_count(dragoon) + picture_count(dragoon) + 
    poem_count(dragoon) + quiz_count(dragoon) + resource_count(dragoon) + story_count(dragoon) + 
    video_count(dragoon)
  end
  
  def community_contributions_count(dragoon)
    return discussion_count(dragoon) + comment_count(dragoon)
  end
  
end
