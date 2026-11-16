return function(key, env)
    if key:release() or key:ctrl() or key:alt() or key:super() then
        return 2
    end

    local context = env.engine.context
    if context:get_option("ascii_mode") or context.input == "" then
        return 2
    end

    local code = key.keycode
    if code == 0x2d or code == 0x3d or code == 0x5b or code == 0x5d then
        return 2
    end
    if code > 0x20 and code < 0x7f and string.char(code):match("%p") then
        env.engine:commit_text(context.input)
        context:clear()
    end

    return 2
end
