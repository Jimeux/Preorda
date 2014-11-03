$(document).on('ready page:load', hideLongDescriptions);

/*
 * Some simple (pretty messy) code found on code-tricks
 * http://code-tricks.com/jquery-read-more-less-example/
 * TODO: Extend to deal with lots of line breaks (height rather than length)
 */
function hideLongDescriptions() {
  var showChar = 545;
  var ellipses = "...";
  var moreText = "Show more >";
  var lessText = "< Show less";

  $('.item-desc').each(function() {
    if ($(this).find('.table').length != 0) return;

    var content = $(this).html();

    if(content.length > showChar) {

      var c = content.substr(0, showChar);
      var h = content.substr(showChar, content.length);
      var html = c + '<span class="moreellipses">' + ellipses + '&nbsp;</span>' +
                     '<span class="morecontent">' +
                       '<span style="display: none">' + h + '</span>&nbsp;&nbsp;' +
                       '<a href="" class="morelink" style="display: inline-block">' + moreText + '</a>' +
                     '</span>';
      $(this).html(html);
    }

  });

  $(".morelink").click(function(){
    if($(this).hasClass("less")) {
      $(this).removeClass("less");
      $(this).html(moreText);
    } else {
      $(this).addClass("less");
      $(this).html(lessText);
    }
    $(this).parent().prev().toggle();
    $(this).prev().toggle();
    return false;
  });
}