$(document).ready(function() {

	$('#record-type').change(function() {
		
		$('#target').unautocomplete();

		if($(this).val() == 'a') {
			$('label[for=target] span').text('(IP Address)');
			
			$('#target').autocomplete('/portal/domain/fetch', {
				minChars: 1,
				max: 255,
				matchContains: true,
				autoFill: false,
				selectFirst: false,
				width: 'auto',
				extraParams: {type: 'ip'},
				formatResult: function(row) {
					return row[0];
				},
				formatItem: function(row) {
					return row[1];
				}
			}).result(function() {
				var field = $(this);
				setTimeout(function() {
					field.focus();
				},100);
			});
		}

		if($(this).val() == 'cname') {
			$('label[for=target] span').text('(Host Name)');
			
			$('#target').autocomplete('/portal/domain/fetch', {
				minChars: 1,
				max: 255,
				matchContains: true,
				autoFill: false,
				selectFirst: false,
				width: 'auto',
				extraParams: {
					type: 'a',
					id: function() {
						return $('#zoneId').val();
					}
				},
				formatResult: function(row) {
					return row[0];
				},
				formatItem: function(row) {
					return row[1];
				}
			}).result(function() {
				var field = $(this);
				setTimeout(function() {
					field.focus();
				},100);
			});
		}

	}).trigger('change');
	
	$('#editType').change(function() {
		
		$('#editTarget').unautocomplete();
		
		if($(this).val() == 'a') {
			$('label[for=editTarget] span').text('(IP Address)');
			
			$('#editTarget').autocomplete('/portal/domain/fetch', {
				minChars: 1,
				max: 255,
				matchContains: true,
				autoFill: false,
				selectFirst: false,
				extraParams: {type: 'ip'},
				formatResult: function(row) {
					return row[0];
				},
				formatItem: function(row) {
					return row[1];
				}
			}).result(function() {
				var field = $(this);
				setTimeout(function() {
					field.focus();
				},100);
			});
		}

		if($(this).val() == 'cname') {
			$('label[for=editTarget] span').text('(Host Name)');

			$('#editTarget').autocomplete('/portal/domain/fetch', {
				minChars: 1,
				max: 255,
				matchContains: true,
				autoFill: false,
				selectFirst: false,
				extraParams: {
					type: 'a',
					id: function() {
						return $('#zoneId').val();
					}
				},
				formatResult: function(row) {
					return row[0];
				},
				formatItem: function(row) {
					return row[1];
				}
			}).result(function() {
				var field = $(this);
				setTimeout(function() {
					field.focus();
				},100);
			});
		}

	}).trigger('change');


	$('#selectAll').click(function() {
		$(this).parents('form').find('input[type=checkbox]').attr('checked',true);
		return false;
	});
	
	$('#selectNone').click(function() {
		$(this).parents('form').find('input[type=checkbox]').attr('checked',false);
		return false;
	});


	$('.record-edit').click(function() {
		var record = $(this).parents('tr');

		var id = record.attr('id').split('-')[1];
		var host = record.find('.host');
		var ttl = record.find('.ttl');
		var target = record.find('.target');
		var comment = record.find('.comment');

		var editId = $('#editId');
		var editHost = $('#editHost');
		var editTtl = $('#editTtl');
		var editTarget = $('#editTarget');
		var editComment = $('#editComment');

		editId.val(id);
		editHost.val($.trim(host.text()));
		editTtl.val($.trim(ttl.text()));
		editTarget.val($.trim(target.text().replace(/\u00AD/g,''))); // Temporary fix to prevent <wbr> and soft hyphen unicode characters from being copied
		editComment.val($.trim(comment.text()));

		switch (true) {
			case $('#acname').length > 0:
				var type = record.find('.type');
				
				var editType = $('#editType');
				var recordType = $('#recordType');

				editType.val($.trim(type.text()));
				recordType.val($.trim(type.text()));

				editType.trigger('change');

                host.hasClass('locked') ? editHost.attr('disabled',true) : editHost.attr('disabled',false);
				type.hasClass('locked') ? editType.attr('disabled',true) : editType.attr('disabled',false);

                break;
			case $('#mx').length > 0:
				var priority = record.find('.priority');
				
				var editPriority = $('#editPriority');
				
				editPriority.val($.trim(priority.text()));

				break;
			case $('#txt').length > 0:
				break;
			case $('#srv').length > 0:
				var service = record.find('.service');
				var protocol = record.find('.protocol');
				var priority = record.find('.priority');
				var weight = record.find('.weight');
				var port = record.find('.port');
				
				var editService = $('#editService');
				var editProtocol = $('#editProtocol');
				var editPriority = $('#editPriority');
				var editWeight = $('#editWeight');
				var editPort = $('#editPort');
				
				editService.val($.trim(service.text()));
				editProtocol.val($.trim(protocol.text()));
				editPriority.val($.trim(priority.text()));
				editWeight.val($.trim(weight.text()));
				editPort.val($.trim(port.text()));
				
				break;
		}

		$('#record-edit').modal();
		return false;
	});
	
	$('#task-edit-link').click(function() {
		$('#task-edit').modal();
		return false;
	});

});
