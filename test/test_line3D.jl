using SafeTestsets, Test, Logging

@safetestset "Constructor" begin
    using Test, SafeTestsets, Logging

    @safetestset "Default Constructor" begin
        using PGA3D
        using Test, SafeTestsets, Logging, StaticArrays

        @testset "Line Int" begin
            testline = Line3D(1, 2, 3, 4, 5, 6)
            @test testline isa Line3D{Int}
            @test get_e23(testline) === 1
            @test get_e31(testline) === 2
            @test get_e12(testline) === 3
            @test get_e01(testline) === 4
            @test get_e02(testline) === 5
            @test get_e03(testline) === 6
        end

        @testset "Line Double" begin
            testline = Line3D(1.0, 2.0, 3.0, 4.0, 5.0, 6.0)
            @test testline isa Line3D{Float64}
            @test get_e23(testline) === 1.0
            @test get_e31(testline) === 2.0
            @test get_e12(testline) === 3.0
            @test get_e01(testline) === 4.0
            @test get_e02(testline) === 5.0
            @test get_e03(testline) === 6.0
        end

        @testset "Line Float" begin
            testline = Line3D(1.0f0, 2.0f0, 3.0f0, 4.0f0, 5.0f0, 6.0f0)
            @test testline isa Line3D{Float32}
            @test get_e23(testline) === 1.0f0
            @test get_e31(testline) === 2.0f0
            @test get_e12(testline) === 3.0f0
            @test get_e01(testline) === 4.0f0
            @test get_e02(testline) === 5.0f0
            @test get_e03(testline) === 6.0f0
        end

        @testset "Line Promoted" begin
            testline = Line3D(1, 2.0, 3.0f0, 4.0, 5.0, 6.0)
            @test testline isa Line3D{Float64}
            @test get_e23(testline) === 1.0
            @test get_e31(testline) === 2.0
            @test get_e12(testline) === 3.0
            @test get_e01(testline) === 4.0
            @test get_e02(testline) === 5.0
            @test get_e03(testline) === 6.0
        end

        @testset "Line StaticArray" begin
            testline = Line3D(SA[1, 2, 3, 4, 5, 6])
            @test testline isa Line3D{Int64}
            @test get_e23(testline) === 1
            @test get_e31(testline) === 2
            @test get_e12(testline) === 3
            @test get_e01(testline) === 4
            @test get_e02(testline) === 5
            @test get_e03(testline) === 6
        end

    end
end
