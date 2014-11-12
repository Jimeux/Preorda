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
  var container = $('#featured'),
      limit     = 1,
      imgWidth  = 322,
      imgHeight = 150,
      imgRatio  = 2.2,
      pageWidth = $(window).width();

  if (pageWidth <= 440) {
    limit = 1;
    imgWidth = pageWidth;
  } else if (pageWidth > 440 && pageWidth < 640) {
    limit = 2;
    imgWidth = parseInt(pageWidth / 2, 10);
  } else if (pageWidth >= 640 && pageWidth < 960) {
    limit = 2;
  } else if (pageWidth >= 960)
    limit = 3;

  imgHeight = parseInt(imgWidth / imgRatio, 10);
  container.height(imgHeight);
  container.empty();

  var start = parseInt(page * limit, 10);

  $.each(features.slice(start, start+limit), function (index, feature) {
    var html = $(
        '<div>' +
          '<a href="' + feature.link_href + '">' +
            '<img width="' + imgWidth + '" height="' + imgHeight + '" src="' + feature.image_url + '">' +
          '</a>' +
        '</div>'
    );
    html.appendTo(container);
  });

  displayDots(limit, page);
}

function displayDots(limit, page) {
  var dotContainer = $('#dots');
  dotContainer.empty();

  var dotNum = parseInt(features.length / limit, 10);

  for (var i = 0; i < dotNum; i++) {
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
