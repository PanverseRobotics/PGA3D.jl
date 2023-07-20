module PGA3D

using StaticArrays
using LinearAlgebra
import LinearAlgebra: dot, norm, ⋅, adjoint, cross, normalize
import Base: +, -, *, /, ==, zero, one, abs, convert, getindex, length, size, isapprox, isequal, sqrt, exp, log

include("utils.jl")
include("abstract_types.jl")
include("vector3D.jl")
include("vector4D.jl")
include("point3D.jl")
include("line3D.jl")
include("plane3D.jl")
include("motor3D.jl")
include("conversions.jl")
include("dual.jl")
include("outer_product.jl")
include("regressive_product.jl")
include("element_construction.jl")
include("transformations.jl")

export AbstractPGA3DElement
# required interface for subtypes of AbstractPGA3Element:
export internal_vec

# basic PGA vector types:

# abstract 4D vector supertype
export AbstractVector4D # <: AbstractPGA3DElement
# required interface for subtypes of AbstractVector4D:
#export get_x, get_y, get_z, get_w
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

export Plane3D

export Motor3D
export identity_motor, motor_fromto, transform, motor_screw, motor_translation
export get_transform_matrix, get_inv_transform_matrix, get_transform_and_inv_matrices
export get_position, motor_from_transform
export line_exp, motor_log

export bulk_norm, weight_norm, unitize
export dual, undual

export increment_bracket_numbers

export get_scalar, get_e0123
export get_e1, get_e2, get_e3, get_e0
export get_e23, get_e31, get_e12, get_e01, get_e02, get_e03
export get_e032, get_e013, get_e021, get_e123

export outer_product, ∧
export regressive_product, ∨

end
