'use strict';
'require view';
'require fs';
'require uci';
'require ui';
'require poll';

/*
 * sing-box 轻量管理页
 * 服务与自启复用 sing-box 包自带的 /etc/init.d/sing-box 和 /etc/config/sing-box
 * 配置校验使用 sing-box check,支持 JSONC 注释语法
 */

return view.extend({
	load: function() {
		return Promise.all([
			L.resolveDefault(fs.exec('/etc/init.d/sing-box', ['status'])),
			L.resolveDefault(fs.exec_direct('/usr/bin/sing-box', ['version'])),
			uci.load('sing-box'),
			L.resolveDefault(fs.read('/etc/sing-box/config.json')),
			L.resolveDefault(fs.exec_direct('/sbin/logread', ['-e', 'sing-box']))
		]);
	},

	fetchStatus: function() {
		return L.resolveDefault(fs.exec('/etc/init.d/sing-box', ['status']), {});
	},

	render: function(data) {
		var self = this;
		var status = data[0];
		var version = data[1];
		var config = (data[3] == null) ? '' : data[3];
		var logs = data[4];

		var running = (status && status.code === 0);
		var enabled = (uci.get('sing-box', 'main', 'enabled') === '1');
		var verText = ((version || '').split('\n')[0] || '').trim() || _('未知');

		/* 状态徽标与日志区挂到this,供轮询/刷新使用 */
		this.badge = E('span', { 'class': 'label ' + (running ? 'label-success' : 'label-default') },
			running ? _('运行中') : _('已停止'));
		this.logPre = E('pre', {
			'style': 'max-height:20rem; overflow:auto; font-size:12px; padding:8px; margin:0; white-space:pre-wrap; word-break:break-all;'
		});
		this.logPre.textContent = logs || _('暂无日志');

		var autoChk = E('input', { 'type': 'checkbox', 'style': 'vertical-align:middle;' });
		autoChk.checked = enabled;
		var autoNote = E('span', { 'style': 'margin-left:8px; color:#888;' });
		autoChk.addEventListener('change', function(ev) {
			self.setAuto(ev.target.checked, autoNote);
		});

		var cfgArea = E('textarea', {
			'style': 'width:100%; min-height:26rem; font-family:monospace; font-size:13px; white-space:pre; overflow-wrap:normal; overflow-x:auto;',
			'spellcheck': 'false',
			'wrap': 'off'
		});
		cfgArea.value = config;
		var cfgNote = E('span', { 'style': 'margin-left:8px; color:#888;' });

		poll.add(L.bind(function() { return self.refreshStatus(); }, self), 5);

		return E([], [
			E('h2', {}, _('sing-box 管理')),
			E('div', { 'class': 'cbi-map-descr' },
				_('基于 sing-box 包自带的 init 脚本与 UCI 配置,修改配置后请保存并重启服务')),

			E('div', { 'class': 'cbi-section' }, [
				E('h3', {}, _('服务状态')),
				E('table', { 'class': 'table' }, [
					E('tr', {}, [
						E('td', { 'style': 'width:33%' }, _('运行状态')),
						E('td', {}, this.badge)
					]),
					E('tr', {}, [
						E('td', {}, _('程序版本')),
						E('td', {}, verText)
					]),
					E('tr', {}, [
						E('td', {}, _('开机自启')),
						E('td', {}, [autoChk, autoNote])
					])
				]),
				E('div', { 'style': 'margin-top:8px;' }, [
					E('button', {
						'class': 'btn cbi-button cbi-button-apply',
						'style': 'margin-right:8px;',
						'click': ui.createHandlerFn(self, 'doAction', 'start')
					}, _('启动')),
					E('button', {
						'class': 'btn cbi-button cbi-button-remove',
						'style': 'margin-right:8px;',
						'click': ui.createHandlerFn(self, 'doAction', 'stop')
					}, _('停止')),
					E('button', {
						'class': 'btn cbi-button cbi-button-action',
						'click': ui.createHandlerFn(self, 'doAction', 'restart')
					}, _('重启'))
				])
			]),

			E('div', { 'class': 'cbi-section' }, [
				E('h3', {}, _('配置管理')),
				E('div', { 'class': 'cbi-section-descr' },
					_('配置文件: /etc/sing-box/config.json (支持JSONC注释)。保存时会先用 sing-box check 校验,校验失败不会重启服务')),
				cfgArea,
				E('div', { 'style': 'margin-top:8px;' }, [
					E('button', {
						'class': 'btn cbi-button cbi-button-positive',
						'style': 'margin-right:8px;',
						'click': ui.createHandlerFn(self, 'saveConfig', cfgArea, false, cfgNote)
					}, _('保存')),
					E('button', {
						'class': 'btn cbi-button cbi-button-action',
						'click': ui.createHandlerFn(self, 'saveConfig', cfgArea, true, cfgNote)
					}, _('保存并重启')),
					cfgNote
				])
			]),

			E('div', { 'class': 'cbi-section' }, [
				E('h3', {}, [
					_('运行日志'),
					E('button', {
						'class': 'btn cbi-button',
						'style': 'margin-left:12px;',
						'click': ui.createHandlerFn(self, 'refreshLog')
					}, _('刷新日志'))
				]),
				this.logPre
			])
		]);
	},

	doAction: function(action) {
		var self = this;
		return fs.exec('/etc/init.d/sing-box', [action])
			.then(function() {
				ui.addNotification(null, E('p', {}, _('已执行: %s').format(action)));
				self.refreshStatus();
				self.refreshLog();
			})
			.catch(function(e) {
				ui.addNotification(null, E('p', {}, _('执行失败: %s').format((e && e.message) || e)), 'error');
			});
	},

	setAuto: function(on, note) {
		var self = this;
		note.textContent = _('应用中…');
		uci.set('sing-box', 'main', 'enabled', on ? '1' : '0');
		uci.save()
			.then(function() { return uci.apply(); })
			.then(function() { return fs.exec('/etc/init.d/sing-box', [on ? 'enable' : 'disable']); })
			.then(function() {
				note.textContent = on ? _('已开启开机自启') : _('已关闭开机自启');
				self.refreshStatus();
			})
			.catch(function(e) {
				note.textContent = '';
				ui.addNotification(null, E('p', {}, _('设置失败: %s').format((e && e.message) || e)), 'error');
			});
	},

	saveConfig: function(cfgArea, restart, note) {
		var self = this;
		var text = cfgArea.value;
		note.textContent = _('保存中…');
		fs.write('/etc/sing-box/config.json', text)
			.then(function() {
				return fs.exec('/usr/bin/sing-box', ['check', '-c', '/etc/sing-box/config.json']);
			})
			.then(function(res) {
				if (res.code !== 0) {
					note.textContent = _('校验失败(文件已保存,未重启): ') + (res.stderr || res.stdout || '');
					return null;
				}
				if (!restart) {
					note.textContent = _('已保存,校验通过');
					return null;
				}
				return fs.exec('/etc/init.d/sing-box', ['restart']).then(function() {
					note.textContent = _('已保存,校验通过,服务已重启');
					self.refreshStatus();
					self.refreshLog();
				});
			})
			.catch(function(e) {
				note.textContent = '';
				ui.addNotification(null, E('p', {}, _('保存失败: %s').format((e && e.message) || e)), 'error');
			});
	},

	refreshLog: function() {
		var self = this;
		return L.resolveDefault(fs.exec_direct('/sbin/logread', ['-e', 'sing-box']), '')
			.then(function(out) {
				self.logPre.textContent = out || _('暂无日志');
			});
	},

	refreshStatus: function() {
		var self = this;
		return this.fetchStatus().then(function(res) {
			var running = (res && res.code === 0);
			self.badge.textContent = running ? _('运行中') : _('已停止');
			self.badge.className = 'label ' + (running ? 'label-success' : 'label-default');
		});
	}
});
