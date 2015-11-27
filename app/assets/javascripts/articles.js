$(document).on('ready page:load', function() {
	$('#article_category_id').select2();
  $('#article_contributor_profile_ids').select2({
    tags: true
  });
  $('#article_encyclopaedia_entry_ids').select2({
    tags: true
  });
});
