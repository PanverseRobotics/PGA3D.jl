using PGA3D
using Symbolics, LinearAlgebra, StaticArrays, Logging, Random

@variables x y z
@variables vx vy vz vw mx my mz mw

p = Point3D(0, 0, 0, 1)
m = Motor3D(vw, vx, vy, vz, mx, my, mz, mw)

tp = transform(m, p)

tp_str = string(tp)


function multi_replace(str::String, pairs::Vector{Pair{Regex,String}})
    for pair in pairs
        str = replace(str, pair)
    end
    return str
end

pairs = [r"vx" => "a[2]", r"vy" => "a[3]", r"vz" => "a[4]", r"vw" => "a[1]", r"mx" => "a[5]", r"my" => "a[6]", r"mz" => "a[7]", r"mw" => "a[8]", r"x" => "a[1]", r"y" => "a[2]", r"z" => "a[3]"]

comp_str = multi_replace(tp_str, pairs)
