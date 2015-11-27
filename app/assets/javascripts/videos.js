$(document).on('ready page:load', function() {
  $('#video_category_id').select2();
  $('#video_contributor_profile_ids').select2({
    tags: true
  });
  $('#video_encyclopaedia_entry_ids').select2({
    tags: true
  });
});
