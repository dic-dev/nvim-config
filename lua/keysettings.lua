local utf8 = require('utf8')

local function Pair(str)
  if str == '(' then
    return '()<Left>'
  elseif str == '{' then
    return '{}<Left>'
  elseif str == '[' then
    return '[]<Left>'
  elseif str == '<' then
    return '<><Left>'
  elseif str == '\'' then
    return '\'\'<Left>'
  elseif str == '\"' then
    return '\"\"<Left>'
  end
end

local function Trim(line)
  local indent = ''
  local text = ''
  local trail = ''
  local s = 0
  local e = 0
  for i = 1, #line do
    if string.sub(line, i, i) == ' ' then
      indent = indent .. ' '
      if i == #line then
        return indent, text, trail
      end
    else
      s = i
      break
    end
  end
  for i = 1, #line do
    if string.sub(line, -i, -i) == ' ' then
      trail = trail .. ' '
    else
      e = #line - i + 1
      break
    end
  end
  text = string.sub(line, s, e)
  return indent, text, trail
end

local function is_space(str)
  local flag = true
  for i = 1, #str do
    if not(string.sub(str, i, i) == ' ') then
      flag = false
      break
    end
  end
  return flag
end

local function FindLetter(str, letter)
  local n = 0
  for i = 1 , #str do
    if string.sub(str, i, i) == letter then
      n = i
      break
    end
  end
  return n
end

local function SmartTrim(str)
  local indent, text, trail = Trim(str)
  if text == '' then
    indent = ''
  end
  return indent, text, trail
end

local function GetContext()
  local line = vim.fn.getline('.')
  local curpos = vim.fn.getcharpos('.')
  local position = 1
  if not(line == '') then
    position = utf8.offset(line, curpos[3])
  end
  local indent, text, trail = Trim(line)
  local left = string.sub(line, 1, position-1)
  local right = string.sub(line, position)
  return line, curpos, indent, left, right
end

local function GetFraction(indent)
  local fraction = #indent % vim.bo.tabstop
  return fraction
end

local function Expand(curpos, indent, left, right)
  local newcol = vim.bo.tabstop + #indent + 1
  local newindent = ''
  for i = 1, newcol-1 do
    newindent = newindent .. ' '
  end
  vim.fn.setline('.', indent .. left)
  vim.fn.append('.', {newindent, indent .. right})
  vim.fn.setpos('.', {curpos[1], curpos[2]+1, newcol, curpos[4], curpos[5]})
  return
end

local function GetOut(curpos, right, letter)
  local n = FindLetter(right, letter)
  local newcol = curpos[3] + n
  vim.fn.setpos('.', {curpos[1], curpos[2], newcol, curpos[4], curpos[5]})
  return
end

local function RightJump()
  local target = {'(', ')', '{', '}', '[', ']', '<', '>', "'", '"'}
  local line, curpos, indent, left, right = GetContext()
  local n = 0
  local l = ''
  local flag = true
  for i = 1, #right do
    for j = 1, #target do
      if string.sub(right, j, j) == target[j] then
        n = i
        l = target[j]
        flag = false
        break
      end
    end
  end
  local newcol = curpos[3] + n
  vim.fn.setpos('.', {curpos[1], curpos[2], newcol, curpos[4], curpos[5]})
  return
end

local function DestroyBracket(letter)
  local line, curpos, indent, left, right = GetContext()
  local newleft = string.sub(left, 1, -2)
  local n = FindLetter(right, letter)
  local newright = string.sub(right, n+1)
  local newline = newleft .. newright
  vim.fn.setline('.', newline)
  vim.fn.setpos('.', {curpos[1], curpos[2], curpos[3]-1, curpos[4], curpos[5]})
  return
end

local function Enter()
  local line, curpos, indent, left, right = GetContext()
  local leftspace, lefttext, lefttrail = Trim(left)
  local rightspace, righttext, righttrail = Trim(right)

  -- Expand
  -- (|)
  if not(string.match(left, '^.*%(%s*$') == nil) and not(string.match(right, '^%s*%).*$') == nil) then
    Expand(curpos, indent, lefttext, righttext)
    return
  end
  -- {|}
  if not(string.match(left, '^.*%{%s*$') == nil) and not(string.match(right, '^%s*%}.*$') == nil) then
    Expand(curpos, indent, lefttext, righttext)
    return
  end 
  -- [|]
  if not(string.match(left, '^.*%[%s*$') == nil) and not(string.match(right, '^%s*%].*$') == nil) then
    Expand(curpos, indent, lefttext, righttext)
    return
  end
  -- <>|</>
  if not(string.match(left, '^.*<.*>%s*$') == nil) and not(string.match(right, '^%s*<%s*/.*>.*') == nil) then
    Expand(curpos, indent, lefttext, righttext)
    return
  end

  -- get out
  -- (a|)
  if not(string.match(left, '^.*%(.-%g.-$') == nil) and not(string.match(right, '^%s-%).*$') == nil) then
    GetOut(curpos, right, ')')
    return
  end
  -- {a|}
  if not(string.match(left, '^.*%{.-%g.-$') == nil) and not(string.match(right, '^%s-%}.*$') == nil) then
    GetOut(curpos, right, '}')
    return
  end
  -- [a|]
  if not(string.match(left, '^.*%[.-%g.-$') == nil) and not(string.match(right, '^%s-%].*$') == nil) then
    GetOut(curpos, right, ']')
    return
  end
  -- <a|>
  if not(string.match(left, '^.*%<.-%g.-$') == nil) and not(string.match(right, '^%s-%>.*$') == nil) then
    GetOut(curpos, right, '>')
    return
  end
  -- 'a|'
  if not(string.match(left, "^.*'.-$") == nil) and not(string.match(right, "^%s-'.*$") == nil) then
    GetOut(curpos, right, "'")
    return
  end
  -- "a|"
  if not(string.match(left, '^.*".-$') == nil) and not(string.match(right, '^%s-".*$') == nil) then
    GetOut(curpos, right, '"')
    return
  end

  -- normal
  if line == indent then
    -- vim.fn.setline('.', '')
    -- vim.fn.append('.', '')
    -- vim.fn.setpos('.', {curpos[1], curpos[2]+1, #indent+1, curpos[4], curpos[5]})
    vim.fn.setline('.', '')
    vim.fn.append('.', left)
    vim.fn.setpos('.', {curpos[1], curpos[2]+1, #left+1, curpos[4], curpos[5]})
    return
  elseif is_space(left) then
    vim.fn.setline('.', '')
  else
    vim.fn.setline('.', indent .. lefttext)
  end
  vim.fn.append('.', indent .. righttext)
  vim.fn.setpos('.', {curpos[1], curpos[2]+1, #indent+1, curpos[4], curpos[5]})
  return
end

local function BackSpace()
  local line, curpos, indent, left, right = GetContext()
  local leftspace, lefttext, lefttrail = Trim(left)
  local rightspace, righttext, righttrail = SmartTrim(right)
  local newline = ''
  local newcol = ''
  local newrow = ''

  -- delete bracket
  -- (a|)
  if not(string.match(left, '^.*%($') == nil) and not(string.match(right, '^%s-%).*$') == nil) then
    DestroyBracket(')')
    return
  end
  -- {a|}
  if not(string.match(left, '^.*%{$') == nil) and not(string.match(right, '^%s-%}.*$') == nil) then
    DestroyBracket('}')
    return
  end
  -- [a|]
  if not(string.match(left, '^.*%[$') == nil) and not(string.match(right, '^%s-%].*$') == nil) then
    DestroyBracket(']')
    return
  end
  -- <a|>
  if not(string.match(left, '^.*%<$') == nil) and not(string.match(right, '^%s-%>.*$') == nil) then
    DestroyBracket('>')
    return
  end
  -- 'a|'
  if not(string.match(left, "^.*'$") == nil) and not(string.match(right, "^%s-'.*$") == nil) then
    DestroyBracket("'")
    return
  end
  -- "a|"
  if not(string.match(left, '^.*"$') == nil) and not(string.match(right, '^%s-".*$') == nil) then
    DestroyBracket('"')
    return
  end


  if curpos[2] == 1 and curpos[3] == 1 then
    return
  end
  if left == '' then
    local prerow = vim.fn.getcharpos('.')[2]
    newrow = vim.fn.getcharpos('.')[2] - 1
    local preline = vim.fn.getline(newrow, newrow)[1]
    newcol = #preline + 1
    newline = preline .. rightspace .. righttext
    vim.fn.setline(newrow, newline)
    vim.fn.setpos('.', {curpos[1], newrow, newcol, curpos[4], curpos[5]})
    vim.fn.deletebufline('%', prerow)
    return
  elseif is_space(left) then
    local fraction = GetFraction(left)
    local newleft = ''
    if fraction == 0 then
      for i = 1, #left - vim.bo.tabstop do
        newleft = newleft .. ' '
      end
    else
      for i = 1, #left - fraction do
        newleft = newleft .. ' '
      end
    end
      newline = newleft .. rightspace .. righttext
      newcol = #newleft + 1
  else
    local newleft = ''
    if lefttrail == '' then
      local num = utf8.offset(line, curpos[3] - 1) - 1
      newleft = string.sub(left, 1, num)
    elseif lefttrail == ' ' then
      newleft = leftspace .. lefttext
    else
      newleft = leftspace .. lefttext
      if rightspace == '' and not(righttext == '') then
        newleft = leftspace .. lefttext .. ' '
      end
    end
    newline = newleft .. rightspace .. righttext
    newcol = #newleft + 1
  end
  vim.fn.setline('.', newline)
  vim.fn.setpos('.', {curpos[1], curpos[2], newcol, curpos[4], curpos[5]})
  return
end

local function Space()
  local line, curpos, indent, left, right = GetContext()
  local newcol = 2
  if not(line == '') then
    newcol = utf8.offset(line, curpos[3]) + 1
  end
  local newline = left .. ' ' .. right
  vim.fn.setline('.', newline)
  vim.fn.setpos('.', {curpos[1], curpos[2], newcol, curpos[4], curpos[5]})
  return
end

vim.keymap.set('i', '(', Pair('('))
vim.keymap.set('i', '{', Pair('{'))
vim.keymap.set('i', '[', Pair('['))
-- vim.keymap.set('i', '<', Pair('<'))
vim.keymap.set('i', '\'', Pair('\''))
vim.keymap.set('i', '\"', Pair('\"'))

vim.keymap.set('i', '<C-j>', Enter)
vim.keymap.set('i', '<C-h>', BackSpace)
vim.keymap.set('i', '<space>', Space)
