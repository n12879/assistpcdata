#!/usr/bin/env lua

-- chitaem ispolnyaemiy fayl
local fd = assert(io.open("main", "rb"))
local maindata = assert(fd:read("*a"))
fd:close()

-- chitaem danniye dlya vstraivaniya
local fd = assert(io.open("data.txt", "rb"))
local data = assert(fd:read("*a"))
fd:close()

-- vichislyaem razmer ispolnyaemogo fayla
local mainsize = #maindata
local mainsizestr = string.format("%6d", mainsize)

-- obnovlyaem informacijy o razmere exe-fayla
-- v nem samom (programma ozhidaet etogo)
local fixedmaindata = string.gsub(
  maindata,
  "mysizeis %d+",
  "mysizeis " .. mainsizestr
)

-- soedinyaem exe-fayl i danniye
fixedmaindata = fixedmaindata .. data

-- zapisivaem izmeneniya v rezultirujushiy fayl
local fd = assert(io.open("main_out", "wb"))
assert(fd:write(fixedmaindata))
fd:close()

-- delaem rezultirujushiy fayl ispolnyaemym
os.execute("chmod +x main_out")

