$(document).on('ready page:load', function() {
  $('#picture_id_of_picture_to_replace').select2();
  $('#picture_category_id').select2();
  $('#picture_album_id').select2();
  $('#picture_contributor_profile_ids').select2();
  $('#picture_tag_ids').select2();

  $('.edit_picture').submit(function(event) {
    if (
      $('#picture_id_of_picture_to_replace').val() &&
      $('#picture_publish').is(":checked")
    ) {
      if (!window.confirm(
        "Are you sure you want to publish this picture, replacing " +
        "'" + $('#picture_id_of_picture_to_replace option:selected').text() +
        "' in the process? This destructive action cannot be undone. If " +
        "you're sure, press the OK button for a new beginning..."
      )) {
        event.preventDefault();
      };
    }
  });
});
