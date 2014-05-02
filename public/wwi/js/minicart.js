$(document).ready(function () {
    $('#minicart-outer').mouseover(function() {
		var $popup = $('#minicart_popup');
		$popup.fadeIn('fast');
		$(this).mouseleave(function() {
			$popup.fadeOut('fast');
		});
	});
});