# by default, disallow conversions between types unless we explicitly allow them
#function Base.convert(T_to::Type{<:AbstractPGA3DElement}, from::T_from) where {T_from<:AbstractPGA3DElement}
#throw(error("Conversion not implemented from $(T_from) to $(T_to)."))
#end

