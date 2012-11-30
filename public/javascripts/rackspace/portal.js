$(document).ready(function() {

	/* Switcher Submit */
	
	(function(){
		var switchers = $('.myrs-switcher');
		switchers.find('.myrs-form-actions').hide();
		
		switchers.each(function() {
			var switcher = $(this);
			switcher.find('select').change(function() {
				switcher.submit();
			});
		});

	})();


	/* Tabs */
	
	$('.myrs-tabs-toggle').each(function() {
		var container = $(this);

		var fieldsets = container.find('fieldset');
		fieldsets.each(function() {
			var content = $('<div class="myrs-tabs-content"></div>');

			var legend = $(this).find('legend');
			legend.find('input').remove();

			content.append('<p class="myrs-tabs-legend">' + legend.text() + '</p>');
			legend.remove();

			content.append($(this).html());
			$(this).remove();

			container.append(content);
		});

		var nav = $('<ul class="myrs-tabs-nav clearfix"></ul>');
		var selected = $('<input type="hidden" name="'+ container.attr('id') +'" value="" />');

		var contents = container.find('.myrs-tabs-content');
		contents.each(function() {
			var content = $(this);
			var legend = content.find('.myrs-tabs-legend');
			var tab = $('<li><a href="##">' + legend.html() + '</a></li>');

			tab.click(function() {
				contents.hide();
				content.show();
				selected.val($(this).text());
				selected.trigger('change');
				return false;
			});

			nav.append(tab);			
			legend.remove();

		});

		container.prepend(nav);
		container.prepend(selected);

		var tabs = container.find('.myrs-tabs-nav li');
		tabs.click(function() {
			tabs.removeClass('selected');
			$(this).addClass('selected');
			return false;
		}).filter(':first').click();

	});


	/* Action Confirm */
	
	$('.myrs-confirm').each(function() {
		$(this).attr('confirm',$(this).attr('title'));
		$(this).removeAttr('title');		
		$(this).click(function() {
			return confirm($(this).attr('confirm').replace(/\\n/g,'\n'));
		});
	});


	/* Navigation Menus */

	(function(){

		switch(true) {
			case $('body').hasClass('home'):
				var defaultMenu = 'home';
				break;
			case $('body').hasClass('support'):
				var defaultMenu = 'support';
				break;
			case $('body').hasClass('products'):
				var defaultMenu = 'products';
				break;
			case $('body').hasClass('services'):
				var defaultMenu = 'services';
				break;
			case $('body').hasClass('network'):
				var defaultMenu = 'network';
				break;
			case $('body').hasClass('account'):
				var defaultMenu = 'account';
				break;
			case $('body').hasClass('community'):
				var defaultMenu = 'community';
				break;
			default:
				var defaultMenu = 'home';
				break;
		}

		var activeMenu = defaultMenu;

		$('#myrs-nav-main > li > a').each(function() {

			$(this).hoverIntent(function() {
				hoverMenu = $(this).parent().attr('id').replace('myrs-nav-','');
				if(activeMenu != hoverMenu) {
					$('body').removeClass(activeMenu).addClass(hoverMenu);
					activeMenu = hoverMenu;
				}
			}, function() {
				// return false;
			});

		});
		
		$('#myrs-nav-main > li:has(div) > a').each(function() {

			$(this).click(function() {
				hoverMenu = $(this).parent().attr('id').replace('myrs-nav-','');
				if(activeMenu != hoverMenu) {
					$('body').removeClass(activeMenu).addClass(hoverMenu);
					activeMenu = hoverMenu;
				}
				return false;
			});

		});

	})();


	/* Sidebar Toggle */

	(function(){

		var sidebar = $('#myrs-sidebar');
		var main = $('#myrs-main');

		if(sidebar.length > 0) {

			if($.cookie('sidebarToggleStatus') == null) {
				$.cookie('sidebarToggleStatus','expanded',{ expires: 365, path: '/' });
			}

			var sidebarToggleStatus = $.cookie('sidebarToggleStatus');

			var mainExpanded = '180px';
			var mainCollapsed = '0px';

			var sidebarToggleImageCollapsed = '/portal/images/layouts/portal/myrs-sidebar-expand.png';
			var sidebarToggleImageExpanded = '/portal/images/layouts/portal/myrs-sidebar-collapse.png';

			var sidebarCollapse = function() {
				sidebar.fadeOut('fast');
				main.animate({marginRight: mainCollapsed},250);
				$(this).attr('src',sidebarToggleImageCollapsed);
				$.cookie('sidebarToggleStatus','collapsed',{ expires: 365, path: '/' });
			}

			var sidebarExpand = function() {
				main.animate({marginRight: mainExpanded},250);
				sidebar.fadeIn('fast');
				$(this).attr('src',sidebarToggleImageExpanded);
				$.cookie('sidebarToggleStatus','expanded',{ expires: 365, path: '/' });
			}


			var sidebarToggle = $('<img width="16" height="16" alt="Toggle Sidebar" title="Toggle Sidebar" class="myrs-tooltip-nowrap" />');
			if(sidebarToggleStatus == 'expanded') {
				sidebarToggle.attr('src',sidebarToggleImageExpanded).toggle(sidebarCollapse,sidebarExpand);
			} else {
				sidebarToggle.attr('src',sidebarToggleImageCollapsed).toggle(sidebarExpand,sidebarCollapse);

				sidebar.hide();
				main.css('margin-right',mainCollapsed);
			}

			$('h1').append(sidebarToggle);
		}

	})();

	/* Sidebar Height */
	
	setTimeout(function() {
		var main = $('#myrs-main');
		var sidebar = $('#myrs-sidebar');
		var ie = $.browser.msie;

		if(sidebar.height() > main.height()) {
			if(ie) {
				main.css('height',sidebar.height());
			} else {
				main.css('min-height',sidebar.height());
			}
		}
	},250);

	/* Tooltips */
	
	$('body').myrsDatetime().myrsTime().myrsTooltip().myrsTooltipNowrap();
	
	/* Datetime Local */
	
	$('body').myrsDatetimeLocal();
	
	/* Max Value Widget */
	
	$('.myrs-pagination-maxvalue').show();
	$('.myrs-pagination-maxvalue-toggler').click(function() {
		$('.myrs-pagination-maxvalue-list').fadeIn('fast');
		return false;
	});

	$('.myrs-pagination-maxvalue').hoverIntent(function() {
		return false;
	}, function() {
		$('.myrs-pagination-maxvalue-list').fadeOut('fast');
	});


	/* Placeholder */
	
	(function() {
		if($.browser.safari == false) {
			var placeholders = $('[placeholder]');
			var placeholderColor = '#808080';

			placeholders.each(function() {
				var placeholder = $(this)
				var color = placeholder.css('color');
				var placeholderText = placeholder.attr('placeholder');

				if(placeholder.val() == '') {
					placeholder.css('color',placeholderColor).val(placeholderText);
				}

				placeholder.blur(function() {
					if(placeholder.val() == '') {
						placeholder.css('color',placeholderColor).val(placeholderText);
					}
				});

				placeholder.focus(function() {
					if(placeholder.val() == placeholderText) {
						placeholder.css('color',color).val('');
					}
				});

			});
		}
	})();
	

	/* Maintenance Message */
	(function() {
		$('#maintenance-message-toggler').click(function() {
			$('#maintenance-message-extended').toggle();
			return false;
		});
	})();

	
	/* Print */
	
	$('.myrs-print').click(function() {
		window.print();
		return false;
	});
	
	
	/* Filter */
	
	if($.browser.mozilla == true) {
		$('.myrs-filter').addClass('searchfield');
	}


	/* Disable Submit */
	
	$('form').submit(function() {
		$('.myrs-form-submit-disable').attr('disabled',true);
	});
	
	
	/* Select All / None */
	
	$('.myrs-select-all').change(function() {
		if($(this).is(':checked')) {
			$(this).parents('form').find('input[type=checkbox]').attr('checked',true);
		} else {
			$(this).parents('form').find('input[type=checkbox]').attr('checked',false);
		}
	});
	
	$('.myrs-phone-more-link').click(function() {
		$('#myrs-phone-more-modal').modal();
		return false;
	});

});


/* MYRS Object */

var myrs = {};


/* Date Time */

Date.prototype.toISODateString = function () {
	var timeZoneOffset = (this.getTimezoneOffset()/-60);
	var timeZoneOffsetFormatted = '';
	if(timeZoneOffset < 0) {
		timeZoneOffsetFormatted = '(UTC' + timeZoneOffset + ')';
	}
	if(timeZoneOffset >= 0) {
		timeZoneOffsetFormatted = '(UTC+' + timeZoneOffset + ')';
	}	
	var year = this.getFullYear();
	var month = this.getMonth() + 1 > 9 ? this.getMonth() + 1 : '0' + (this.getMonth() + 1);
	var date = this.getDate() > 9 ? this.getDate() : '0' + this.getDate();
	var dateFormatted = year + '-' + month + '-' + date + ' ' + timeZoneOffsetFormatted;
	return  dateFormatted;
};

Date.prototype.toISODateTimeString = function() {
	var timeZoneOffset = (this.getTimezoneOffset()/-60);
	var timeZoneOffsetFormatted = '';
	if(timeZoneOffset < 0) {
		timeZoneOffsetFormatted = '(UTC' + timeZoneOffset + ')';
	}
	if(timeZoneOffset >= 0) {
		timeZoneOffsetFormatted = '(UTC+' + timeZoneOffset + ')';
	}	
	var year = this.getFullYear();
	var month = this.getMonth() + 1 > 9 ? this.getMonth() + 1 : '0' + (this.getMonth() + 1);
	var date = this.getDate() > 9 ? this.getDate() : '0' + this.getDate();
	var hour = this.getHours() > 9 ? this.getHours() : '0' + this.getHours();
	var minute = this.getMinutes() > 9 ? this.getMinutes() : '0' + this.getMinutes();
	var second = this.getSeconds() > 9 ? this.getSeconds() : '0' + this.getSeconds();
	var dateTimeFormatted = year + '-' + month + '-' + date + ' ' + hour + ':' + minute + ':' + second + ' ' + timeZoneOffsetFormatted;
	return  dateTimeFormatted;
}

Date.prototype.toISODateUTCString = function (showTimeZone) {
	if (typeof showTimeZone == 'undefined' ) showTimeZone = true;
	var year = this.getUTCFullYear();
	var month = this.getUTCMonth() + 1 > 9 ? this.getUTCMonth() + 1 : '0' + (this.getUTCMonth() + 1);
	var date = this.getUTCDate() > 9 ? this.getUTCDate() : '0' + this.getUTCDate();
	var dateString = year + '-' + month + '-' + date;
	if(showTimeZone) {
		dateString += ' (UTC)';
	}
	return  dateString;
};

Date.prototype.toISODateTimeUTCString = function() {
	var year = this.getUTCFullYear();
	var month = this.getUTCMonth() + 1 > 9 ? this.getUTCMonth() + 1 : '0' + (this.getUTCMonth() + 1);
	var date = this.getUTCDate() > 9 ? this.getUTCDate() : '0' + this.getUTCDate();
	var hour = this.getUTCHours() > 9 ? this.getUTCHours() : '0' + this.getUTCHours();
	var minute = this.getUTCMinutes() > 9 ? this.getUTCMinutes() : '0' + this.getUTCMinutes();
	var second = this.getUTCSeconds() > 9 ? this.getUTCSeconds() : '0' + this.getUTCSeconds();
	return  year + '-' + month + '-' + date + ' ' + hour + ':' + minute + ':' + second + ' (UTC)';
}

Date.prototype.toISOTimeZoneOffsetString = function() {
	var timeZoneOffset = (this.getTimezoneOffset()/-60);
	var timeZoneOffsetFormatted = '';
	if(timeZoneOffset < 0) {
		timeZoneOffsetFormatted = '(UTC' + timeZoneOffset + ')';
	}
	if(timeZoneOffset >= 0) {
		timeZoneOffsetFormatted = '(UTC+' + timeZoneOffset + ')';
	}
	return timeZoneOffsetFormatted;
}

Date.prototype.toTimeZoneOffsetString = function() {
	var timeZoneOffset = (this.getTimezoneOffset()/-60);
	return timeZoneOffset;
}

jQuery.fn.myrsTime = function() {
	return this.each(function() {
		jQuery(this).find('.myrs-time').each(function() {
			var utcTime = jQuery(this).text().split(':');
			var date = new Date();
			date.setUTCHours(utcTime[0]);
			date.setUTCMinutes(utcTime[1]);
			var hour = date.getHours() > 9 ? date.getHours() : '0' + date.getHours();
			var minutes = date.getMinutes() > 9 ? date.getMinutes() : '0' + date.getMinutes();
			var localTime = hour + ':' + minutes;
			jQuery(this).attr('title','Local Time: '+ localTime + ' ' + date.toISOTimeZoneOffsetString()).removeClass('myrs-time').addClass('myrs-tooltip-nowrap');
		});
	});
};

jQuery.fn.myrsDatetime = function() {
	return this.each(function() {
		jQuery(this).find('.myrs-datetime').each(function() {
			jQuery(this).attr('title','Local Time: '+(new Date(parseInt($(this).attr('title')))).toISODateTimeString()).removeClass('myrs-datetime').addClass('myrs-tooltip-nowrap');			
		});
	});
};

jQuery.fn.myrsDatetimeLocal = function() {
	return this.each(function() {
		jQuery(this).find('.myrs-datetime-local').each(function() {
			jQuery(this).text(''+(new Date(parseInt($(this).text()))).toISODateTimeString());
		});
	});
};

jQuery.fn.myrsTooltip = function() {
	return this.each(function() {
		jQuery(this).find('.myrs-tooltip').tooltip({ 
			track: true,
			showURL: false,
			extraClass: 'myrs-tooltip-standard'
		});
	});
};

jQuery.fn.myrsTooltipNowrap = function() {
	return this.each(function() {
		var tooltips = jQuery(this).find('.myrs-tooltip-nowrap');
		tooltips.each(function() {
			jQuery(this).attr('title',jQuery(this).attr('title').replace(/,   /g,'<br />'));
		});
		tooltips.tooltip({
			track: true,
			showURL: false,
			extraClass: 'myrs-tooltip-standard-nowrap'
		});
	});
};

