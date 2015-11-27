$(document).on('ready page:load', function() {
  $('#story_category_id').select2();
  $('#story_contributor_profile_ids').select2({
    tags: true
  });
  $('#story_encyclopaedia_entry_ids').select2({
    tags: true
  });
});
