using PGA3D
using SafeTestsets, Test

@safetestset "Constructor" begin
    Point3D(1, 2, 3)
end
