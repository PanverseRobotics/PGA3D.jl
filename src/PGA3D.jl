module PGA3D

using StaticArrays
using LinearAlgebra
import LinearAlgebra: dot, norm, ⋅, adjoint, cross
import Base: +, -, *, /, ==, zero, one, abs, convert, getindex, length, size, isapprox, isequal, sqrt

include("abstract_types.jl")
include("vector3D.jl")
include("vector4D.jl")
include("point3D.jl")
include("line3D.jl")
include("motor3D.jl")
include("conversions.jl")
include("element_construction.jl")
include("transformations.jl")

export AbstractPGA3DElement
# required interface for subtypes of AbstractPGA3Element:
export internal_vec

# basic PGA vector types:

# abstract 4D vector supertype
export AbstractVector4D # <: AbstractPGA3DElement
# required interface for subtypes of AbstractVector4D:
export get_x, get_y, get_z, get_w
# basic concrete subtype
export Vector4D # <: AbstractVector4D
# this one is a 3D homogenous point using a 4D static vector backend/subtype
export Point3D # <: AbstractVector4D

# abstract 3D vector supertype
export AbstractVector3D # <: AbstractPGA3DElement
# required interface for subtypes of AbstractVector3D:
# get_x, get_y, get_z (already exported above)
# concete subtype:
export Vector3D # <: AbstractVector3D

export Line3D
export line_fromto

export Motor3D
export get_vx, get_vy, get_vz, get_vw, get_mx, get_my, get_mz, get_mw
export identity_motor, motor_fromto, transform, motor_screw, motor_translation
export get_transform_matrix, get_inv_transform_matrix, get_transform_and_inv_matrices
export get_position, motor_from_transform

export bulk_norm, weight_norm, unitize

end
