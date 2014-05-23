$(document).ready(function() {

	var arrayIds = [];

	$.each(ids, function(index, value) {
		arrayIds.push(value.toString());
	});


	$('.multiselect').multiselect('select', arrayIds);
});