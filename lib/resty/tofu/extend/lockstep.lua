--
-- 锁/同步执行
-- 

local _resty_lock = require 'resty.lock'
local _merge = require 'resty.tofu.util'.tab_merge

local _default = {
	timeout = 5,		-- 秒
	-- exptime = 6,		-- 秒
	shm = 'tofu_lockstep_dict',
}


return function(opts)
	opts = _merge(opts, _default)
	opts.exptime = opts.exptime or opts.timeout + 1

	return function (key, fn, ...)
		local lock, err = _resty_lock:new(opts.shm, opts)
		if not lock then
			error (err)
		end
		local elapsed, err =lock:lock('lock:' .. key)
		if not elapsed then
			error (err)
		end

		local ok, ret = pcall(fn, ...)

		lock:unlock()
		if not ok then
			return nil, ret
		end
		return ret
	end

end
