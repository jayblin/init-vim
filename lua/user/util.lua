
local _utils = {
	os = {
		LINUX = 0,
		MACOS = 1,
		WINDOWS = 2,
		UNKNOWN = -1,
		query = function(self)
			local home_path = os.getenv('HOME')

			if home_path == nil then home_path = "" end

			if string.find(home_path, '/home') then
				return self.LINUX
			end

			if string.find(home_path, '/Users') then
				return self.MACOS
			end

			if string.find(home_path, 'C:') then
				return self.WINDOWS
			end

			return self.UNKNOWN
		end
	},
}

return _utils
