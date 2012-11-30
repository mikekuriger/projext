jQuery(document).ready(function() {
	$('#expandallpanes').click(function() {
		$('.panes .head').next().slideToggle();
	});
	
	$('.panes .head').click(function() {
		$(this).next().slideToggle();
		return false;
	}).next().hide();
});
