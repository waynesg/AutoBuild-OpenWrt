'use strict';
'require view';
'require uci';

return view.extend({
	load: function() {
		return uci.load('cups-web');
	},

	render: function() {
		var listen = uci.get('cups-web', 'main', 'listen_addr') || '0.0.0.0:8080';
		var match = listen.match(/:(\d+)$/);
		var url = 'http://' + window.location.hostname + ':' + (match ? match[1] : '8080') + '/';
		window.location.replace(url);
		return E('div', { 'class': 'spinning' });
	},

	handleSaveApply: null,
	handleSave: null,
	handleReset: null
});
