-- Right side of the 3x3 Door. See https://youtu.be/m66VWyxk20I.

--
-- NOTE! This code is orientation dependent! Choose the version based on where the "A" port of your lua controllers point in-game:) 
--

-- Running code in a sequence
function do_lap()
    interrupt(mem.laps[mem.as][mem.cl], "timer")
    -- current lap
    mem.cl = mem.cl + 1
end

function set_active_sequence(i)
    -- active sequence
    mem.as = i
end

if (event.type == "program") then
    mem.is_running = false
    opening_speed = 0.05
    closing_speed = 0.01

    mem.laps = {
        {0.01, -- Opening
            opening_speed,
            opening_speed,
            opening_speed,
            opening_speed,
            opening_speed,
            opening_speed,
            opening_speed,
            opening_speed,
            opening_speed,
            opening_speed,
            opening_speed,
            opening_speed,
            opening_speed,
            opening_speed
        },{0.01, -- Closing
            closing_speed,
            closing_speed,
            closing_speed,
            closing_speed,
            closing_speed,
            closing_speed,
            closing_speed
        }
    }
    mem.pins = {
        {{}, 
            {"A"},
            {},
            {"A"},
            {"B"},
            {"B"},
            {"C"},
            {},
            {"B"},
            {},
            {},
            {"B"},
            {},
            {},
            {}
        },{{},
            {"C"},
            {"A"},
            {"A"},
            {},
            {"B"},
            {"B"},
            {}
        }
    }
    mem.changes = {
        {{},
            {true},
            {},
            {false},
            {true},
            {false},
            {false},
            {},
            {true},
            {},
            {},
            {false},
            {},
            {},
            {} 
        },{{},
            {true},
            {true},
            {false},
            {},
            {true},
            {false},
            {}
        }
    }
    mem.cl = 1
end

if (event.type == "interrupt") then
    for i = 1, #mem.pins[mem.as][mem.cl], 1 do
        if (mem.pins[mem.as][mem.cl][i] == "A") then 
            port.a = mem.changes[mem.as][mem.cl][i] end
        if (mem.pins[mem.as][mem.cl][i] == "B") then 
            port.b = mem.changes[mem.as][mem.cl][i] end
        if (mem.pins[mem.as][mem.cl][i] == "C") then 
            port.c = mem.changes[mem.as][mem.cl][i] end
        if (mem.pins[mem.as][mem.cl][i] == "D") then 
            port.d = mem.changes[mem.as][mem.cl][i] end
    end

    if (mem.cl == #mem.laps[mem.as]) then
        mem.is_running = false
        mem.cl = 1
    else
        do_lap()
    end
end

if (
        event.type == "on" and 
        event.pin.name == "D" and 
        not mem.is_running
) then
    mem.is_running = true
    set_active_sequence(1)
    do_lap()
end

if (
        event.type == "off" and 
        event.pin.name == "D" and 
        not mem.is_running
) then
    mem.is_running = true
    set_active_sequence(2)
    do_lap()
end
