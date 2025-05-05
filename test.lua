---@diagnostic disable

a = {1, 2, 3}
mt = {__index = a}
b = {10, 12, 16}
setmetatable(b, mt)

function a.go(k)
    k[1] = 3
end

b:go()
print(a[1])
print(b[1])