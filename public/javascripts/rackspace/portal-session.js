$(document).ready(function() {

	(function() {
		var timeout = {
			secondsWarning: 1620, // 27 Minutes (1620)
			secondsLogout: 1740, // 29 Minutes (1740)
			secondsCountdown: null,

			lastActivity: null,

			timeoutWarning: null,
			timeoutLogout: null,
			intervalCountdown: null,

			title: null,

			selectorWarning: '#myrs-session-warning',
			selectorResume: '#myrs-session-warning-resume',
			selectorCountdown: '#myrs-session-warning #seconds span',

			cookieLastActivityName: 'lastActivity',
			cookieLastActivityPath: '/',
			cookieSessionName: 'JSESSIONID',
			cookieSessionPath: '/portal',
			cookieInactivityName: 'inactivity',
			cookieInactivityPath: '/',

			urlSessionResume: '/portal/auth/resumeSession',

			init: function() {
				// Set Initial Values
				var now = new Date().getTime();
				this.lastActivity = now;
				$.cookie(this.cookieLastActivityName, now, { path: this.cookieLastActivityPath });
				this.secondsCountdown = this.secondsLogout - this.secondsWarning;
				$(this.selectorCountdown).text(this.secondsCountdown);
				
				this.title = document.title;

				this.start();
			},

			reset: function() {
				// Clear Any Running Timers
				clearTimeout(this.timeoutWarning);
				clearTimeout(this.timeoutLogout);
				clearInterval(this.intervalCountdown);

				// Update Last Activity
				this.lastActivity = $.cookie(this.cookieLastActivityName);

				// Reset Modal
				$.modal.close();
				$(this.selectorResume).attr('disabled',false);
				$(this.selectorCountdown).text(this.secondsCountdown);
				
				// Reset Title
				document.title = this.title;

				this.start();
			},

			start: function() {
				if(this.checkActivity() == true) {
					this.reset();
				} else {
					// Schedule Warning
					var that = this;
					var now = new Date().getTime();
					this.timeoutWarning = setTimeout(function() { that.warning(); }, (this.secondsWarning * 1000) - (now - this.lastActivity));
				}
			},

			warning: function() {
				if(this.checkActivity() == true) {
					this.reset();
				} else {
					var that = this;

					// Display Warning
					$(this.selectorWarning).modal({
						close: false,
						onShow: function() {
							// Resume Button
							$(that.selectorResume).click(function() {
								// Update cookie for other tabs
								var now = new Date().getTime();
								$.cookie(that.cookieLastActivityName, now, { path: that.cookieLastActivityPath });

								// Ping server to extend session
								$.getJSON(that.urlSessionResume);

								that.reset();
							});
						}
					});

					// Schedule Logout and Countdown
					this.intervalCountdown = setInterval(function() { that.countdown(); }, 1000);
					this.timeoutLogout = setTimeout(function() { that.logout(); }, (this.secondsLogout * 1000) - (this.secondsWarning * 1000));
				}
			},

			logout: function() {
				if(this.checkActivity() == true) {
					this.reset();
				} else {
					// Disable Resume Button
					$(this.selectorResume).attr('disabled',true);

					// Logout
					$.cookie(this.cookieInactivityName, 'true', { path: this.cookieInactivityPath });
					$.cookie(this.cookieSessionName, null, { path: this.cookieSessionPath });
					window.location.reload();
				}
			},

			countdown: function() {
				if(this.checkActivity() == true) {
					this.reset();
				} else {
					// Update Countdown
					var countdown = $(this.selectorCountdown);
					var t = countdown.text();
					t--;
					document.title = 'Warning: ' + t + ' Seconds Till Log Out - ' + this.title;
					countdown.text(t);

					// Clear Timer
					if(t == 0) {
						clearInterval(this.intervalCountdown);
					}
				}
			},

			checkActivity: function() {
				if(this.lastActivity == $.cookie(this.cookieLastActivityName)) {
					return false;
				} else {
					return true;
				}
			}
		}

		timeout.init();
	})();

});