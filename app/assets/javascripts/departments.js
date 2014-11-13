$(document).on('ready page:change', function () {
  $('#platform-select-no-js').hide();
  $('#platform-select-js').show();
});

$(document).on('page:change', loadFeatures);
$(window).resize(loadFeatures);

$(document).on('click', '.dot', function(e) {
  e.preventDefault();
  currentPage = $(e.target).data('page-num');
  displayPage(currentPage);
});

var features;    //TODO: Get rid of these globals
var currentPage = 0;

function loadFeatures() {
  var featuredDiv = $('#featured');
  if (featuredDiv.length == 0) return;

  if (typeof features == 'undefined') {
    $.get('/features', function(data) {
      features = data;
      displayPage(currentPage);
    });
  } else
    displayPage(currentPage);
}

function displayPage(page) {
  var imgLimit  = 1,
      imgWidth  = 322,
      pageWidth = $(window).width();

  if (pageWidth <= 440) {
    imgLimit = 1;
    imgWidth = pageWidth;
  } else if (pageWidth > 440 && pageWidth < 640) {
    imgLimit = 2;
    imgWidth = parseInt(pageWidth / 2, 10);
  } else if (pageWidth >= 640 && pageWidth < 960) {
    imgLimit = 2;
  } else if (pageWidth >= 960)
    imgLimit = 3;

  var pageCount = parseInt(features.length / imgLimit, 10);

  if (page >= pageCount)
    page = currentPage = pageCount-1;

  var start = parseInt(page * imgLimit, 10);

  displayFeatures(start, imgLimit, imgWidth);
  displayDots(page, pageCount);
}

function displayFeatures(start, limit, width) {
  var container = $('#featured'),
      ratio     = 2.2,
      height    = parseInt(width / ratio, 10);

  container.height(height);
  container.empty();

  $.each(features.slice(start, start+limit), function (index, feature) {
    var html = $(
      '<div>' +
        '<a href="' + feature.link_href + '">' +
          '<img width="' + width + '" height="' + height + '" src="' + feature.image_url + '">' +
        '</a>' +
      '</div>'
    );
    html.appendTo(container);
  });
}

function displayDots(page, pageCount) {
  var dotContainer = $('#dots');
  dotContainer.empty();

  for (var i = 0; i < pageCount; i++) {
    var dot = $('<a class="dot" href="#" data-page-num="' + i + '"></a>');
    if (i === page) dot.addClass('dot-active');
    dotContainer.append(dot);
  }
}

// animation = setInterval(function () { }, 7000);
//page = Math.floor(start / Math.floor(features.length / dotNum));

//if (start + limit >= features.length || features.length - (start + limit) < limit)
//clearInterval(animation); //
//start = 0;
//else
//start = start + limit;

/*
if('ontouchstart' in window) {
  featuredDiv.swipe({
    swipeLeft: function () {
      currentPage++;
      displayPage(currentPage);
    },
    swipeRight: function () {
      if (currentPage < 1) return;
      currentPage--;
      displayPage(currentPage)
    }
  });
}*/
