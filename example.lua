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

local my_vec = vec2(1, 3)

print((my_vec + (-my_vec)):to_string())

---@class Animal: Class
---@field name string
---@field voice string
local animal = Classy.class("Animal")

function animal:init(name)
  self.name = name
end

function animal:speak()
  print(self.voice)
end

-- You can use both the class name and the class itself for inheritance
---@class Dog: Animal
local dog = Classy.class("Dog", animal)
---@class Cat: Animal
local cat = Classy.class("Cat", "Animal")

print("Dog is animal: ", dog:is("Animal")) -- true
print("Cat is animal: ", cat:is(animal))   -- true
print("Dog is vec2: ", dog:is(vec2))       -- false
print("Cat is dog: ", cat:is(dog))         -- false

dog.voice = "Bark!"
cat.voice = "meow"

local my_dog = dog("Tita")
local my_cat = cat("Mia")
print(("%q speak:"):format(my_dog.name))
my_dog:speak()
print(("%q speak:"):format(my_cat.name))
my_cat:speak()
