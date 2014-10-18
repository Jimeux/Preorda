// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var $searchButton = $($("#search-button")[0]);

var searchGoEvent = function(e)
{
    var $qInput = $($("#q")[0]);
    var $searchForm = $qInput.parent();

    //console.log("reached search go event");
    e.preventDefault();
    var qString = $qInput.val().trim();

    if(qString.length != 0)
    {
        $searchForm.submit();
    }
};

$(document).on('click', '#search-button', searchGoEvent);


