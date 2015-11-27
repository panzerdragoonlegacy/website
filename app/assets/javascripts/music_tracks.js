$(document).on('ready page:load', function() {
  $('#music_track_category_id').select2();
  $('#music_track_contributor_profile_ids').select2({
    tags: true
  });
  $('#music_track_encyclopaedia_entry_ids').select2({
    tags: true
  });
});
