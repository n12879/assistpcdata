#!/usr/bin/env lua

-- convert special text file to html and markdown
-- files

local name = assert(arg[1])
local namemd = name .. ".md"
local namehtml = name .. ".html"

local function fappendl (fname, str)
  local fd = assert(io.open(fname, "ab"))
  assert(fd:write(str, "\n"))
  assert(fd:close())
  return true
end

function docstart ()
  os.remove(namemd)
  os.remove(namehtml)
  fappendl(namehtml,
    "<html><head>"
  ..'<meta http-equiv="Content-type" content="text/html;charset=UTF-8"></meta>'
  .."</head><body>"
  )
end

function docend ()
  fappendl(namehtml, "</body></html>")
end

function writetitle (str)
  fappendl(namemd, "# " .. str)
  fappendl(namehtml, "<h1>" .. str .. "</h1>")
end

function writetextline (str)
  fappendl(namemd, str .. "  ")
  fappendl(namehtml, "<p>" .. str .. "</p>")
end

function isspecialline (str)
  if string.match(str, "^@") then
    return true
  else
    return false
  end
end

function isemptyline (str)
  if string.match(str, "^%s*$") then
    return true
  else
    return false
  end
end

function execspecial (str)
  local cmd, arg = string.match(str, "^@(%S+)%s(.+)$")
  assert(cmd, "wrong format")
  if cmd == "img" then
    fappendl(namemd, "![img](data/"..arg..".png)")
    local iname = "data/"..arg..".png"
    fappendl(namehtml,
        "<a href='"..iname.."'>"
        .."<img src="..iname.." width=90%>"
      .."</a>"
    )
  elseif cmd == "jimg" then
    fappendl(namemd, "![img](data/"..arg..".jpg)")
    local iname = "data/"..arg..".jpg"
    fappendl(namehtml,
        "<a href='"..iname.."'>"
        .."<img src="..iname.." width=90%>"
      .."</a>"
    )
  elseif cmd == "vspace" then
    fappendl(namemd, "  ")
    fappendl(namemd, "  ")
    fappendl(namehtml, string.rep("<br>", 4))
  else
    error("unknown special cmd: "..cmd)
  end
  return true
end

docstart()
local firstline = true
for l in io.lines(name) do
  if not isemptyline(l) then
    if not isspecialline(l) then
      if firstline then
        writetitle(l)
        firstline = false
      else
        writetextline(l)
      end
    else
      execspecial(l)
    end
  end
end
docend()

