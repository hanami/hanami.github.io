// back to top button - docs
$(function () {
  var $toc = $('#markdown-toc');
  if (!$toc[0]) return;

  var  url = $(location).attr('pathname');
  var $li  = $toc.find('a[href="' + url + '"]', 'a:first').closest('li');

  $li.addClass('active');

  $("select.mobile-guides").change(function() {
    window.location = $(this).find(":selected").val();
  });
})
;
