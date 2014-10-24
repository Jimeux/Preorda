var searchGoEvent = function(e)
{
    var $qInput = $($("#q")[0]);
    var $searchForm = $qInput.parent();

    //console.log("reached search go event");
    e.preventDefault();
    var qString = $qInput.val().trim();

    if(qString.length != 0 && qString.length >= 3)
    {
        $searchForm.submit();
    }
};

$(document).on('click', '#search-button', searchGoEvent);


