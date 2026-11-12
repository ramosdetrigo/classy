---@class Class
---@field __super Class? The class' parent class
---@field __name string The name of the class
local Object = {}
Object.__super = nil
Object.__name = "Object"

local classy = {}
local class_db = { [Object.__name] = Object }
local format = string.format

-------------------------------------
----- BASE CLASS IMPLEMENTATION -----
-------------------------------------

--- The initialization function of the objects. You should override this for your own classes.
--- **This function will be used internally, you should not use this function manually. Only create new objects by calling the class as a function.**
---@param ...? any The optional parameters of the class creation function.
---@return nil
function Object:init(...)
end

--- Implement other classes' methods in this class.
---@param ...? Class|string The other classes
function Object:implement(...)
  local list = { ... }
  for i = 1, #list do
    local class = list[i]
    if type(class) == "string" then class = class_db[class] end

    if class == nil then goto continue end
    for k, v in pairs(class) do
      -- Do not copy meta fields
      if k:find("__", 1, true) ~= 1 and self[k] == nil then
        self[k] = v
      end
    end
    ::continue::
  end
end

--- Checks if a class or object inherits a certain class
---@param self Object|Class
---@param class (string|Class)? The name of the class
---@return boolean
function Object:is(class)
  local c = self.__class or self
  if type(class) == "string" then class = class_db[class]; end

  while c ~= nil do
    if c == class then
      return true
    end
    c = c.__super
  end

  return false
end

--- Returns the name of the class and its parents separated by dots.
---@return string
function Object:__name_tree()
  local name = self.__name
  local super = self.__super
  while super ~= nil do
    name = super.__name .. "." .. name
    super = super.__super
  end
  return name
end

---@return table
function Object:__call(...)
  ---@class Object: Class
  ---@field __class Class the class of the object
  local obj = setmetatable({ __class = self }, self)
  obj:init(...)
  return obj
end

-----------------------------
----- LIBRARY FUNCTIONS -----
-----------------------------

--- Class-creating function. The class creation and usage process should be as following:
--- 1. Create the new class with this function
--- 2. Create the object initialization function by overriding the new_class:init(...) function
--- 3. Create the class' methods
--- 4. Create new objects by calling the class as a function
---
--- # Example:
--- ```lua
--- local vec2 = class("Vec2")
---
--- function vec2:init(x, y)
---   self.x = x
---   self.y = y
--- end
---
--- function vec2:add(rhs)
---   return vec2(self.x + rhs.x, self.y + rhs.y)
--- end
---
--- local my_vec = vec2(1, 3)
--- ```
---@param class_name string? The name of the class - **Will throw an error if there already exists a class with that name.**
---@param super (string|Class)? Either the parent class or the name of the parent class. Leave empty to base it on Object. **Will throw an error if the parent class doesn't exist.**
---@param ... any Other classes to implement in this one
---@return Class
function classy.class(class_name, super, ...)
  if type(super) ~= "table" then
    super = assert(class_db[super or "Object"], format("Parent class %q doesn't exist.", super))
  end

  class_name = class_name or super.__name .. " (extended)"
  assert(class_db[class_name] == nil, format("A class named %q already exists.", class_name))

  local new_class = {}
  for k, v in pairs(super) do
    if k:find("__") == 1 then
      new_class[k] = v
    end
  end

  new_class.__name = class_name
  new_class.__super = super
  new_class.__class = new_class
  setmetatable(new_class, super)

  new_class:implement(...)
  class_db[class_name] = new_class

  return new_class
end

--- Returns the class with given name - Returns nil if the class doesn't exist.
---@param class_name string The name of the class
---@return Class?
function classy.get_class(class_name)
  return class_db[class_name]
end

--- Gets a class by name and creates an instance of it.
--- **Will throw an error if the class doesn't exist.**
---@param class_name string The name of the class to instantiate
---@param ... any
---@return table
function classy.instantiate(class_name, ...)
  assert(class_db[class_name], format("Class %q doesn't exist.", class_name))
  return class_db[class_name](...)
end

return classy
