module PGA3D

using StaticArrays
import Base: +, -, *, /, ==, zero, one, abs, convert, getindex, length, size

include("abstract_types.jl")
include("vector3D.jl")
include("vector4D.jl")
include("point3D.jl")
include("line3D.jl")
include("motor3D.jl")

export AbstractPGA3Element
# required interface for subtypes of AbstractPGA3Element:
export internal_vec

# basic PGA vector types:

export AbstractVector4D
# required interface for subtypes of AbstractVector4D:
export get_x, get_y, get_z, get_w
# basic concrete subtype
export Vector4D
# this one is a 3D homogenous point using a 4D static vector backend/subtype
export Point3D

export AbstractVector3D
# required interface for subtypes of AbstractVector3D:
# get_x, get_y, get_z (already exported above)
# concete subtype:
export Vector3D

#export Line
#export Motor

end
