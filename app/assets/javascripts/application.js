//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require_tree .

////=// require react

$(function() { ShareThisTurbolinks.reload(); });
$(document).on('page:load',    function() { ShareThisTurbolinks.reload();  });
$(document).on('page:restore', function() { ShareThisTurbolinks.restore(); });

ShareThisTurbolinks = {
  load: function () {
    if ($('#sharethis-container').length < 1) return;

    window.switchTo5x = false;
    $.getScript('https://ws.sharethis.com/button/buttons.js', function () {
      window.stLight.options({
        publisher:      "99f7fcde-b56a-41b7-8d82-c8ff566cda5a",
        doNotHash:      false,
        doNotCopy:      false,
        hashAddressBar: false
      });
    });
  },

  reload: function () {
    if ($('#sharethis-container').length < 1) return;

    if (typeof stlib !== 'undefined') stlib.cookie.deleteAllSTCookie();
    $('[src*="sharethis.com"], [href*="sharethis.com"]').remove();
    window.stLight = undefined;
    this.load();
  },

  restore: function () {
    if ($('#sharethis-container').length < 1) return;

    $('.stwrapper, #stOverlay').remove();
    this.reload();
  }
};