$(document).on('ready page:load', function() {

  $("a.popover").click(function(event) {
    var popover_caption, popover_height, popover_src, popover_width;
    event.preventDefault();
    popover_src = $(this).children("img").attr("data-popover-src");
    popover_caption = $(this).children("img").attr("alt");
    popover_width = $(this).children("img").attr("data-popover-width");
    popover_height = $(this).children("img").attr("data-popover-height");
    $("div#popover_illustration img").attr("src", popover_src);
    $("div#popover_illustration img").attr("alt", popover_caption);
    $("div#popover_illustration img").attr("width", popover_width);
    $("div#popover_illustration img").attr("height", popover_height);
    $("div#popover_illustration p").text(popover_caption);
    $("div#popover_illustration").fadeIn("fast");
  });

  $("div#popover_illustration button").click(function() {
    $("div#popover_illustration").fadeOut("fast");
  });

});
