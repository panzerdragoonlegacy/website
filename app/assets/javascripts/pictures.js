$(document).on('ready page:load', function() {
  $('#picture_category_id').select2();
  $('#picture_contributor_profile_ids').select2({
    tags: true
  });
  $('#picture_encyclopaedia_entry_ids').select2({
    tags: true
  });
});
