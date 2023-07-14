
abstract type AbstractPGA3DElement{T<:Real} <: Number end

"""
AbstractPGA3Element are backed by an internal StaticVector so that they can be isbits and leverage high performance deterministic arrays.
"""
function internal_vec(::AbstractPGA3DElement)
    throw("internal_vec is not implemented for type $(typeof(v)).  This function is required for subtypes of AbstractPGA3Element.")
end

# Provide an AbstractArray interface even though we're not subtyping it. 
# Most subtypes will override the size and length for ease of compiler constant propagation/inference but not the getindex.
getindex(el::AbstractPGA3DElement, i) = internal_vec(el)[i]
size(el::AbstractPGA3DElement) = size(internal_vec(el))
length(el::AbstractPGA3DElement) = length(internal_vec(el))

abstract type AbstractVector4D{T<:Real} <: AbstractPGA3DElement{T} end

size(::AbstractVector4D) = (4,)
length(::AbstractVector4D) = 4

abstract type AbstractVector3D{T<:Real} <: AbstractPGA3DElement{T} end

size(::AbstractVector3D) = (3,)
length(::AbstractVector3D) = 3

