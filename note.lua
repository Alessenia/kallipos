function Image(img)
  if img.classes:find('note',1) then
    local f = io.open("note/" .. img.src, 'r')
    local doc = pandoc.read(f:read('*a'))
    f:close()
    local caption = pandoc.utils.stringify(doc.meta.caption) or "caption has not been set"
    local student = pandoc.utils.stringify(doc.meta.student) or "Student has not been set"
    local id = pandoc.utils.stringify(doc.meta.id) or "Student ID has not been set"
    local comment = "> " .. caption .. " Student Name:" .. student .. " AM: " .. id
    return pandoc.RawInline('markdown',comment)
  end
end
