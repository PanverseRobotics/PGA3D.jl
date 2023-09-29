module PGA3D

using StaticArrays
using LinearAlgebra
import LinearAlgebra: dot, norm, ⋅, adjoint, cross, normalize
import Base: +, -, *, /, ==, zero, one, abs, convert, getindex, length, size, isapprox, isequal, sqrt, exp, log

include("utils.jl")
include("abstract_types.jl")
include("point3D.jl")
include("line3D.jl")
include("plane3D.jl")
include("motor3D.jl")
include("conversions.jl")
include("dual.jl")
include("outer_product.jl")
include("regressive_product.jl")
include("geometric_product.jl")
include("element_construction.jl")
include("transformations.jl")
include("transform_matrix.jl")

export AbstractPGA3DElement
# required interface for subtypes of AbstractPGA3Element:
export internal_vec

export Point3D
export raw_vec3

export Line3D
export line_fromto

export Plane3D

export Motor3D
export get_rotor
export identity_motor, motor_fromto, transform, motor_screw, motor_translation
export get_transform_matrix, get_inv_transform_matrix, get_transform_and_inv_matrices
export get_position, motor_from_transform

export Rotor3D
export get_rotation_matrix

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
