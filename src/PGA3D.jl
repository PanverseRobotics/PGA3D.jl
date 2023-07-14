module PGA3D

import LinearAlgebra: ⋅, dot, norm
import Base: +, -, *, /, ==, zero, one, abs, convert, getindex, length, size

using StaticArrays
using LinearAlgebra
import LinearAlgebra: dot, norm, ⋅
import Base: +, -, *, /, ==, zero, one, abs, convert, getindex, length, size

include("abstract_types.jl")
include("vector3D.jl")
include("vector4D.jl")
include("point3D.jl")
include("line3D.jl")
include("motor3D.jl")
include("conversions.jl")
include("element_construction.jl")

export AbstractPGA3DElement
# required interface for subtypes of AbstractPGA3Element:
export internal_vec

# basic PGA vector types:

# abstract 4D vector supertype
export AbstractVector4D # <: AbstractPGA3Element
# required interface for subtypes of AbstractVector4D:
export get_x, get_y, get_z, get_w
# basic concrete subtype
export Vector4D # <: AbstractVector4D
# this one is a 3D homogenous point using a 4D static vector backend/subtype
export Point3D # <: AbstractVector4D

# abstract 3D vector supertype
export AbstractVector3D # <: AbstractPGA3Element
# required interface for subtypes of AbstractVector3D:
# get_x, get_y, get_z (already exported above)
# concete subtype:
export Vector3D # <: AbstractVector3D

#export Line
#export Motor

end
