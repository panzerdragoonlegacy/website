$(document).on('ready page:load', function() {
  $('#resource_category_id').select2();
  $('#resource_contributor_profile_ids').select2({
    tags: true
  });
  $('#resource_encyclopaedia_entry_ids').select2({
    tags: true
  });
});
