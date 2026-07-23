module("luci.controller.autoupdate", package.seeall)

function index()
	entry({"admin","system","autoupdate"}, cbi("autoupdate"), _("AutoUpdate"), 99)
	entry({"admin","system","autoupdate","status"}, call("action_status")).leaf = true
end

function action_status()
	local fs = require "nixio.fs"
	local http = require "luci.http"
	local status = fs.readfile("/tmp/autoupdate_status") or "未开始升级"

	http.prepare_content("text/plain; charset=utf-8")
	http.write(status)
end
