class ConvertToPages < ActiveRecord::Migration
  def up
    all_encyclopaedia_entries = EncyclopaediaEntry.all
    Tag.all.each do |tag|
      all_encyclopaedia_entries.each do |encyclopaedia_entry|
        if encyclopaedia_entry.name == tag.name
          puts "Changing tag picture for: #{tag.name}"
          tag.tag_picture = encyclopaedia_entry.encyclopaedia_entry_picture
          unless tag.save
            puts "Invalid tag: #{tag.name}"
            puts "Errors: #{tag.errors.full_messages}"
          end
        end
      end
    end

    category_types = %w[encyclopaedia_entry article poem story resource]

    CategoryGroup.all.each do |category_group|
      if category_group.category_group_type.in?(category_types)
        puts "Changing category group type for: #{category_group.name}"
        if category_group.category_group_type == :encyclopaedia_entry.to_s
          category_group.category_group_type = :encyclopaedia.to_s
        else
          category_group.category_group_type = :literature.to_s
        end
        unless category_group.save
          puts "Invalid category group: #{category_group.name}"
          puts "Errors: #{category_group.errors.full_messages}"
        end
      end
    end

    orphans_group = CategoryGroup.new
    orphans_group.category_group_type = :literature.to_s
    orphans_group.name = 'Fan Literature'
    orphans_group.save

    Category.all.each do |category|
      if category.category_type.in?(category_types)
        puts "Changing category type for: #{category.name}"
        if category.category_type == :encyclopaedia_entry.to_s
          category.category_type = :encyclopaedia.to_s
        else
          category.category_type = :literature.to_s
        end
        if category.category_group.blank?
          category.category_group = orphans_group
        end
        unless category.save
          puts "Invalid category: #{category.name}"
          puts "Errors: #{category.errors.full_messages}"
        end
      end
    end

    poem_category = Category.new
    poem_category.category_type = :literature.to_s
    poem_category.category_group = orphans_group
    poem_category.name = 'Fan Poems'
    poem_category.description = 'Poems inspired by Panzer Dragoon.'
    poem_category.short_name_for_saga = poem_category.name
    poem_category.short_name_for_media_type = poem_category.name
    poem_category.publish = true
    unless poem_category.save
      puts "Invalid category: #{poem_category.name}"
      puts "Errors: #{poem_category.errors.full_messages}"
    end

    admin_contributor_profile =
      ContributorProfile.where(name: 'Solo Wing').first

    klasses = [EncyclopaediaEntry, Article, Poem, Resource, Story, SpecialPage]
    klasses.each do |klass|
      klass.all.each do |old_page|
        puts "Creating page based on #{klass.to_s}: #{old_page.name}"
        page = Page.new
        page.old_model_type = klass.to_s
        page.old_model_id = old_page.id
        if klass == EncyclopaediaEntry
          page.page_type = :encyclopaedia.to_s
        elsif klass == SpecialPage
          page.page_type = :top_level.to_s
        else
          page.page_type = :literature.to_s
        end
        if klass == Poem
          page.category = poem_category
        elsif klass != SpecialPage
          page.category = Category.where(name: old_page.category.name).first
        end
        if klass != SpecialPage && old_page.contributor_profiles.count > 0
          old_page.contributor_profiles.each do |contributor_profile|
            page.contributor_profiles << contributor_profile
          end
        else
          page.contributor_profiles << admin_contributor_profile
        end
        page.name = old_page.name
        if klass == Resource
          if old_page.category.name.include? 'Fan Translations'
            page.description = 'An unofficial fan translation.'
          elsif old_page.category.name.include? 'Song Lyrics'
            page.description =
              'Official text from ' \
                "#{old_page.category.saga.name}'s soundtrack."
          else
            page.description =
              'Official text extracted from ' \
                "#{old_page.category.saga.name}."
          end
        elsif klass.in?([Article, Poem, Story])
          page.description = old_page.description
        end
        if klass == EncyclopaediaEntry
          page.information = old_page.information
          page.page_picture = old_page.encyclopaedia_entry_picture
        end
        page.content = old_page.content
        if klass != EncyclopaediaEntry && klass != SpecialPage
          old_page.tags.each { |tag| page.tags << tag }
        end
        unless klass == Poem
          old_page.illustrations.each do |illustration|
            page.illustrations << illustration
          end
        end
        page.publish = old_page.publish
        page.created_at = old_page.created_at
        page.updated_at = old_page.updated_at
        page.published_at = old_page.published_at
        unless page.save
          puts "Invalid page for #{old_page.name}"
          puts "Errors: #{page.errors.full_messages}"
        end
        if klass == EncyclopaediaEntry
          if Saga.where(encyclopaedia_entry_id: old_page.id).count > 0
            saga = Saga.where(encyclopaedia_entry_id: old_page.id).first
            puts "Setting page for saga: #{saga.name}"
            saga.page_id = page.id
            unless saga.save
              puts "Invalid saga: #{saga.name}"
              puts "Errors: #{saga.errors.full_messages}"
            end
          end
        end
        if klass == Story
          sequence_number = 1
          %w[prologue regular_chapter epilogue].each do |old_chapter_type|
            old_page
              .chapters
              .where(chapter_type: old_chapter_type)
              .order(:number)
              .each do |old_chapter|
                puts 'Creating Literature Chapter page based on ' \
                       "#{old_chapter.chapter_type} #{old_chapter.number} " \
                       "#{old_chapter.name}"
                chapter = Page.new
                chapter.old_model_type = 'Chapter'
                chapter.old_model_id = old_chapter.id
                chapter.page_type = :literature_chapter.to_s
                chapter.parent_page_id = page.id
                chapter.sequence_number = sequence_number
                old_page.contributor_profiles.each do |contributor_profile|
                  chapter.contributor_profiles << contributor_profile
                end
                if old_chapter_type.in?(%w[prologue epilogue])
                  if old_chapter.name.blank?
                    chapter.name = old_chapter_type.titleize
                  else
                    chapter.name = old_chapter.name
                  end
                end
                if old_chapter_type == :regular_chapter.to_s
                  if old_chapter.name.blank?
                    chapter.name = "Chapter #{old_chapter.number}"
                  else
                    chapter.name =
                      "Chapter #{old_chapter.number}: #{old_chapter.name}"
                  end
                end
                chapter.content = old_chapter.content
                old_chapter.illustrations.each do |illustration|
                  chapter.illustrations << illustration
                end
                chapter.publish = old_page.publish
                chapter.created_at = old_chapter.created_at
                chapter.updated_at = old_chapter.updated_at
                chapter.published_at = old_chapter.created_at
                unless chapter.save
                  puts "Invalid literature chapter page for #{old_chapter.name}"
                  puts "Errors: #{chapter.errors.full_messages}"
                end
                sequence_number = sequence_number + 1
              end
          end
        end
      end
    end

    page_klasses = [NewsEntry, Page]
    info_klasses = [Page, Picture, MusicTrack, Video, Download]
    klasses_to_update = [NewsEntry, Page, Picture, MusicTrack, Video, Download]
    old_klasses = [EncyclopaediaEntry, Article, Poem, Resource, Story]

    klasses_to_update.each do |klass_to_update|
      klass_to_update.all.each do |updateable|
        old_klasses.each do |old_klass|
          if old_klass == EncyclopaediaEntry
            old_section_slug = 'encyclopaedia'
            new_section_slug = 'encyclopaedia'
          elsif old_klass.in? [Article, Poem, Resource, Story]
            old_section_slug = old_klass.to_s.pluralize.downcase
            new_section_slug = 'literature'
          end
          old_klass.all.each do |old_page|
            %w[content information].each do |field|
              if (
                   (
                     (
                       field == 'content' && klass_to_update.in?(page_klasses)
                     ) ||
                       (
                         field == 'information' &&
                           klass_to_update.in?(info_klasses)
                       )
                   ) &&
                     (
                       updateable.send(field).present? &&
                         (
                           updateable
                             .send(field)
                             .include?(
                               "](/#{old_section_slug}/#{old_page.url})"
                             ) ||
                             updateable
                               .send(field)
                               .include?(
                                 "](/#{old_section_slug}/#{old_page.id}-#{old_page.url})"
                               ) ||
                             (
                               old_klass == EncyclopaediaEntry &&
                                 updateable
                                   .send(field)
                                   .include?("](#{old_page.url})")
                             )
                         )
                     )
                 )
                puts "Replacing URL for #{old_klass} #{old_page.url} in " \
                       "#{klass_to_update} #{updateable.name}'s #{field} field"
                page =
                  Page.where(
                    old_model_type: old_klass.to_s,
                    old_model_id: old_page.id
                  ).first
                if page
                  updateable
                    .send(field)
                    .gsub!(
                      %r{]\(\/#{old_section_slug}\/#{old_page.url}\)},
                      "](/#{new_section_slug}/#{page.id}-#{page.url})"
                    )
                  updateable
                    .send(field)
                    .gsub!(
                      %r{]\(\/#{old_section_slug}\/#{old_page.id}-#{old_page.url}\)},
                      "](/#{new_section_slug}/#{page.id}-#{page.url})"
                    )
                  if old_klass == EncyclopaediaEntry
                    updateable
                      .send(field)
                      .gsub!(
                        /]\(#{old_page.url}\)/,
                        "](#{page.id}-#{page.url})"
                      )
                  end
                  unless updateable.save
                    puts "Invalid #{klass_to_update} #{updateable.name}"
                    puts "Errors: #{updateable.errors.full_messages}"
                  end
                else
                  puts "Couldn't find page for #{old_page.name}. Manually fix?"
                end
              end
            end
          end
        end
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
