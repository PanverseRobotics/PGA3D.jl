using Test, SafeTestsets, Logging, PrettyPrinting

@safetestset "Point3D" begin
    using Test, SafeTestsets, Logging, PrettyPrinting


    @safetestset "Default Constructor" begin
        using PGA3D
        using Test, SafeTestsets, Logging, PrettyPrinting

        @testset "Point Int" begin
            pointint = Point3D(1, 2, 3)
            @test pointint isa Point3D{Int}
            @test get_x(pointint) === 1
            @test get_y(pointint) === 2
            @test get_z(pointint) === 3
            @test get_w(pointint) === 1
        end

        @testset "Point Double" begin
            pointdouble = Point3D(1.0, 2.0, 3.0)
            @test pointdouble isa Point3D{Float64}
            @test get_x(pointdouble) === 1.0
            @test get_y(pointdouble) === 2.0
            @test get_z(pointdouble) === 3.0
            @test get_w(pointdouble) === 1.0
        end

        @testset "Point Float" begin
            pointfloat = Point3D(1.0f0, 2.0f0, 3.0f0)
            @test pointfloat isa Point3D{Float32}
            @test get_x(pointfloat) === 1.0f0
            @test get_y(pointfloat) === 2.0f0
            @test get_z(pointfloat) === 3.0f0
            @test get_w(pointfloat) === 1.0f0
        end

        @testset "Point Promoted" begin
            pointpromoted = Point3D(1, 2.0f0, 3.0)
            @test pointpromoted isa Point3D{Float64}
            @test get_x(pointpromoted) === 1.0
            @test get_y(pointpromoted) === 2.0
            @test get_z(pointpromoted) === 3.0
            @test get_w(pointpromoted) === 1.0
        end

    end

end
