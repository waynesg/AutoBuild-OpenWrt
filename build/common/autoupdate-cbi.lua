require("luci.sys")
require("luci.dispatcher")

m=Map("autoupdate",translate("AutoUpdate"),translate("AutoUpdate LUCI supports one-click firmware upgrade and scheduled upgrade"))

s=m:section(TypedSection,"login","")
s.addremove=false
s.anonymous=true

o = s:option(Flag, "enable", translate("Enable AutoUpdate"),translate("Automatically update firmware during the specified time"))
o.default = 0
o.optional = false

week=s:option(ListValue,"week",translate("xWeek Day"))
week:value(7,translate("Everyday"))
week:value(1,translate("Monday"))
week:value(2,translate("Tuesday"))
week:value(3,translate("Wednesday"))
week:value(4,translate("Thursday"))
week:value(5,translate("Friday"))
week:value(6,translate("Saturday"))
week:value(0,translate("Sunday"))
week.default=0

hour=s:option(Value,"hour",translate("xHour"))
hour.datatype = "range(0,23)"
hour.rmempty = false

pass=s:option(Value,"minute",translate("xMinute"))
pass.datatype = "range(0,59)"
pass.rmempty = false

local github_url = luci.sys.exec("grep Github= /bin/openwrt_info | cut -c8-100")
o=s:option(Value,"github",translate("Github Url"))
o.default=github_url

luci.sys.call ( "/usr/share/autoupdate/Check_Update.sh > /dev/null")
local cloud_version = luci.sys.exec("cat /tmp/cloud_version")
local current_version = luci.sys.exec("grep CURRENT_Version= /etc/openwrt_ver | cut -c17-100")
local current_model = luci.sys.exec("jsonfilter -e '@.model.id' < /etc/board.json | tr ',' '_'")
local firmware_type = luci.sys.exec("grep CURRENT_Model= /etc/openwrt_ver | cut -c15-100")
local luci_edition = luci.sys.exec("grep NEI_Luci= /etc/openwrt_ver | cut -c10-100")
local upgrade_status = luci.sys.exec("cat /tmp/autoupdate_status 2>/dev/null")
local status_url = luci.dispatcher.build_url("admin", "system", "autoupdate", "status")

status = s:option(DummyValue, "_upgrade_status", translate("升级状态"))
status.rawhtml = true
status.cfgvalue = function()
	local initial_status = upgrade_status
	if initial_status == nil or initial_status == "" then
		initial_status = "未开始升级"
	end
	return string.format([[
<div id="autoupdate-status" style="padding:10px 12px;border-left:4px solid #2d8cf0;background:#f5f9ff;line-height:1.7;white-space:pre-wrap;">%s</div>
<script type="text/javascript">
(function() {
	var box = document.getElementById("autoupdate-status");
	var statusUrl = "%s";
	function setStatus(text) {
		if (box) {
			box.textContent = text && text.trim() ? text.trim() : "未开始升级";
		}
	}
	function refreshStatus() {
		if (!window.fetch) {
			return;
		}
		fetch(statusUrl, { cache: "no-store" }).then(function(response) {
			return response.text();
		}).then(setStatus).catch(function() {});
	}
	document.addEventListener("click", function(event) {
		var target = event.target;
		if (!target) {
			return;
		}
		var name = target.name || "";
		if (name.indexOf("_button_upgrade_firmware") !== -1) {
			setStatus("已开始后台升级，正在下载并校验固件。请等待路由器自动重启，期间不要断电。");
			if ("value" in target) {
				target.value = "升级中...";
			}
			window.setTimeout(function() {
				target.disabled = true;
			}, 200);
		}
	}, true);
	refreshStatus();
	window.setInterval(refreshStatus, 2000);
})();
</script>]], initial_status, status_url)
end

button_upgrade_firmware = s:option (Button, "_button_upgrade_firmware", translate("升级到最新版本"),
translatef("若有更新可点击上方 手动更新 后请耐心等待至路由器重启.") .. "<br><br>当前固件版本: " .. current_version .. "<br>云端固件版本: " .. cloud_version.. "<br><br>设备名称: " .. current_model .. "<br>内核版本: " .. luci_edition .. "<br>固件类型: " .. firmware_type)
button_upgrade_firmware.inputtitle = translate ("Do Upgrade")
button_upgrade_firmware.write = function()
	luci.sys.call ("echo '已开始后台升级，正在下载并校验固件。请等待路由器自动重启，期间不要断电。' >/tmp/autoupdate_status")
	luci.sys.call ("nohup bash /bin/AutoUpdate.sh -F >/tmp/AutoUpdate.luci.log 2>&1 &")
end

local e=luci.http.formvalue("cbi.apply")
if e then
	io.popen("/etc/init.d/autoupdate restart")
end

return m
