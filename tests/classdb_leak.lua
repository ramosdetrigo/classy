---@diagnostic disable
local Classy = require "classy"

local vec2 = Classy.class("Vec2")

print("Testing class_db...")
assert(Classy.get_class("Vec2") ~= nil)
assert(Classy.get_class("Object") ~= nil)

print("Testing weak class_db...")
vec2 = nil
collectgarbage("collect")
assert(Classy.get_class("Vec2") == nil)
assert(Classy.get_class("Object") ~= nil)

print("Test passed!")
