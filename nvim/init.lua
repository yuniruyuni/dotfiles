dir = debug.getinfo(1).source:match("@?(.*/)")

package.path = package.path .. ";" .. dir .. "/?.lua"
require("config.lazy")
require("config.basic")