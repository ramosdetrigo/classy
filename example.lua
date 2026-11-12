Classy = require "classy"

---@class Vec2: Class
---@field x number
---@field y number
local vec2 = Classy.class("Vec2")

function vec2:init(x, y)
  self.x = x
  self.y = y
end

function vec2:__add(rhs)
  return vec2(self.x + rhs.x, self.y + rhs.y)
end

function vec2:__unm()
  return vec2(self.y, self.x)
end

function vec2:to_string()
  return ("(%f, %f)"):format(self.x, self.y)
end

---@type Vec2
local my_vec = vec2(1, 3)

print((my_vec + (-my_vec)):to_string())
print()
