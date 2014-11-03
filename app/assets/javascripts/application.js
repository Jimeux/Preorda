// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require_tree .

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