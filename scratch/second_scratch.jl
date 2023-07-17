using PGA3D
using Symbolics, LinearAlgebra, StaticArrays, Logging, Random

@variables x y z
@variables vx vy vz vw mx my mz mw

p = Vector4D(0, 0, 0, 1)
m = Motor3D(vx, vy, vz, vw, mx, my, mz, mw)

tp = transform(p, m)

tp_str = string(tp)


function multi_replace(str::String, pairs::Vector{Pair{Regex,String}})
    for pair in pairs
        str = replace(str, pair)
    end
    return str
end

pairs = [r"vx" => "b[1]", r"vy" => "b[2]", r"vz" => "b[3]", r"vw" => "b[4]", r"mx" => "b[5]", r"my" => "b[6]", r"mz" => "b[7]", r"mw" => "b[8]", r"x" => "a[1]", r"y" => "a[2]", r"z" => "a[3]"]

comp_str = multi_replace(tp_str, pairs)