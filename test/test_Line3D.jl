using PGA3D
using SafeTestsets, Test

@safetestset "Constructor" begin
    Line3D(1, 2, 3, 4, 5, 6)
end
