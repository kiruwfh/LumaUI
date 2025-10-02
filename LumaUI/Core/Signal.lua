local Signal = {}
Signal.__index = Signal

function Signal.new()
	local self = setmetatable({}, Signal)
	self._handlers = {}
	self._dead = false
	return self
end

function Signal:Connect(fn)
	assert(type(fn) == "function", "Signal:Connect expects a function")
	if self._dead then return { Connected = false, Disconnect = function() end } end
	local connection = {
		Connected = true,
		_fn = fn,
		Disconnect = function(conn)
			if not conn.Connected then return end
			conn.Connected = false
			for i, h in ipairs(self._handlers) do
				if h == conn then
					table.remove(self._handlers, i)
					break
				end
			end
		end,
	}
	table.insert(self._handlers, connection)
	return connection
end

function Signal:Once(fn)
	local conn
	conn = self:Connect(function(...)
		if conn then conn:Disconnect() end
		fn(...)
	end)
	return conn
end

function Signal:Fire(...)
	if self._dead then return end
	-- copy to guard against mutations during iteration
	local snapshot = {}
	for i, h in ipairs(self._handlers) do
		snapshot[i] = h
	end
	for _, h in ipairs(snapshot) do
		if h.Connected then
			local ok, err = pcall(h._fn, ...)
			if not ok then
				warn("Signal handler error:", err)
			end
		end
	end
end

function Signal:Wait()
	if self._dead then return end
	local bindable = Instance.new("BindableEvent")
	local conn
	conn = self:Connect(function(...)
		bindable:Fire(...)
	end)
	local result = { bindable.Event:Wait() }
	conn:Disconnect()
	bindable:Destroy()
	return table.unpack(result)
end

function Signal:Destroy()
	if self._dead then return end
	self._dead = true
	for _, h in ipairs(self._handlers) do
		h.Connected = false
	end
	self._handlers = {}
end

return Signal
