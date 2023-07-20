using Test, SafeTestsets, Logging

@safetestset "Constructor" begin
    using Test, SafeTestsets, Logging


    @safetestset "Default Constructor" begin
        using PGA3D, Test, SafeTestsets, Logging, StaticArrays, Random, LinearAlgebra

        @testset "Point Int" begin
            testpoint = Point3D(1, 2, 3)
            @test testpoint isa Point3D{Int}
            @test get_e032(testpoint) === 1
            @test get_e013(testpoint) === 2
            @test get_e021(testpoint) === 3
            @test get_e123(testpoint) === 1
        end

        @testset "Point Double" begin
            testpoint = Point3D(1.0, 2.0, 3.0)
            @test testpoint isa Point3D{Float64}
            @test get_e032(testpoint) === 1.0
            @test get_e013(testpoint) === 2.0
            @test get_e021(testpoint) === 3.0
            @test get_e123(testpoint) === 1.0
        end

        @testset "Point Float" begin
            testpoint = Point3D(1.0f0, 2.0f0, 3.0f0)
            @test testpoint isa Point3D{Float32}
            @test get_e032(testpoint) === 1.0f0
            @test get_e013(testpoint) === 2.0f0
            @test get_e021(testpoint) === 3.0f0
            @test get_e123(testpoint) === 1.0f0
        end

        @testset "Point Promoted" begin
            testpoint = Point3D(1, 2.0f0, 3.0)
            @test testpoint isa Point3D{Float64}
            @test get_e032(testpoint) === 1.0
            @test get_e013(testpoint) === 2.0
            @test get_e021(testpoint) === 3.0
            @test get_e123(testpoint) === 1.0
        end

        @testset "Point StaticArray" begin
            testpoint = Point3D(SA[1, 2.0f0, 3.0, 1])
            @test testpoint isa Point3D{Float64}
            @test get_e032(testpoint) === 1.0
            @test get_e013(testpoint) === 2.0
            @test get_e021(testpoint) === 3.0
            @test get_e123(testpoint) === 1.0
        end

        @testset "Point StaticArray" begin
            testpoint = Point3D(SA[1, 2.0f0, 3.0])
            @test testpoint isa Point3D{Float64}
            @test get_e032(testpoint) === 1.0
            @test get_e013(testpoint) === 2.0
            @test get_e021(testpoint) === 3.0
            @test get_e123(testpoint) === 1.0
        end

    end

end
