class RenameIllustratableTypes < ActiveRecord::Migration
  def up
    illustrations = Illustration.where(illustratable_type: 'Page')
    illustrations.each do |illustration|
      illustration.illustratable_type = 'Special Page'
      illustration.save
    end
  end

  def down
    illustrations = Illustration.where(illustratable_type: 'Special Page')
    illustrations.each do |illustration|
      illustration.illustratable_type = 'Page'
      illustration.save
    end
  end
end
