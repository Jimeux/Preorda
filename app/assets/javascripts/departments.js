$(document).on('ready page:change', function () {
  $('#platform-select-no-js').hide();
  $('#platform-select-js').show();
});

$(document).on('ready page:change', loadFeatures);
$(window).resize(loadFeatures);

var features;    //TODO: Get rid of this global

function loadFeatures() {
  var featuredDiv = $('#featured');
  if (featuredDiv.length == 0) return;

  if (typeof features == 'undefined') {
    $.get('/features', function(data) {
      features = data;
      featuresLoaded(features, featuredDiv);
    });
  }
  else
    featuresLoaded(features, featuredDiv);
}

function featuresLoaded(features, container) {
  var limit = 1,
      imgWidth = 330,
      imgHeight = 150,
      imgRatio = 2.2,
      pageWidth = $(window).width();

  container.empty();

  if (pageWidth <= 440) {
    limit = 1;
    imgWidth = pageWidth;
  } else if (pageWidth > 440 && pageWidth < 640) {
    limit = 2;
    imgWidth = pageWidth / 2;
  } else if (pageWidth >= 640 && pageWidth < 960) {
    limit = 2;
  } else if (pageWidth >= 960)
    limit = 3;

  imgHeight = imgWidth / imgRatio;

  container.height(imgHeight);

  $.each(features.slice(0, limit), function (index, feature) {
    container.append(
        '<div>' +
          '<a href="">' +
            '<img width="' + imgWidth + '" height="' + imgHeight + '" src="' + feature.image + '">' +
          '</a>' +
        '</div>'
    );
  });
}