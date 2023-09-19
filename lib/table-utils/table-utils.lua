-- Utilty functions for manipulating tables.
local function map(tbl, f)
  local t = {}
  for k, v in pairs(tbl) do t[k] = f(v) end
  return t
end
local function filter(tbl, f)
  local t, i = {}, 1
  for _, v in ipairs(tbl) do
    if f(v) then t[i], i = v, i + 1 end
  end
  return t
end
local function push(tbl, ...)
  for _, v in ipairs({...}) do
    table.insert(tbl, v)
  end
end
local function keys(tbl)
  local keys_tbl = {}
  for k, _ in pairs(tbl) do
    table.insert(keys_tbl, k)
  end
  return keys_tbl
end
local function concat(...)
  local tbl = {}
  for _, t in ipairs({...}) do
    for _, v in ipairs(t) do
      table.insert(tbl, v)
    end
  end
  return tbl
end

function TableConcat(t1,t2)
  for k,v in pairs(t2) do
    t1[k] = v
  end
end