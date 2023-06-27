module PGA3D

include("abstract_types.jl")
include("vector4D.jl")
include("point3D.jl")
include("line3D.jl")
include("motor3D.jl")

export AbstractPGA3Element
export AbstractVector4D
export Vector4D, Point3D # , Line3D, Motor3D
export get_x, get_y, get_z, get_w

end
