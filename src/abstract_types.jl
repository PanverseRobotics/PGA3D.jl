
abstract type AbstractPGA3Element{T<:Real} <: Number end

"""
AbstractPGA3Element are backed by an internal StaticVector so that they can be isbits and leverage high performance deterministic subarrays.
"""
function internal_vec(::AbstractPGA3Element)
    throw("internal_vec is not implemented for type $(typeof(v)).  This function is required for subtypes of AbstractPGA3Element.")
end

# Provide an AbstractArray interface even though we're not subtyping it. 
# Most subtypes will override the size and length for ease of compiler constant propagation/inference but not the getindex.
getindex(v::AbstractPGA3Element, i::Int) = internal_vec(v)[i]
size(::AbstractPGA3Element) = size(internal_vec(v))
length(::AbstractPGA3Element) = length(internal_vec(v))

abstract type AbstractVector4D{T<:Real} <: AbstractPGA3Element{T} end

size(::AbstractVector4D) = (4,)
length(::AbstractVector4D) = 4

abstract type AbstractVector3D{T<:Real} <: AbstractPGA3Element{T} end

size(::AbstractVector3D) = (3,)
length(::AbstractVector3D) = 3
