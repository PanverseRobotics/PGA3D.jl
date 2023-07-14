using PGA3D, Test, SafeTestsets, Logging, PrettyPrinting, StaticArrays, Random

@safetestset "Point3D" begin
    using PGA3D, Test, SafeTestsets, Logging, PrettyPrinting, StaticArrays, Random

    @safetestset "Identity" begin
        using PGA3D, Test, SafeTestsets, Logging, PrettyPrinting, StaticArrays, Random
        for i in 1:100
            testpoint = Point3D(randn(3)...)
            motoridentity = identity_motor()
            @test transform(testpoint, motoridentity) ≈ testpoint
        end
    end

    @safetestset "Motor From To" begin
        using PGA3D, Test, SafeTestsets, Logging, PrettyPrinting, StaticArrays, Random, LinearAlgebra
        for i in 1:100
            testfrom = Point3D(randn(3)...)
            testto = Point3D(randn(3)...)
            mft = motor_fromto(testfrom, testto)
            @test transform(testfrom, mft) ≈ testto
        end
    end

    @safetestset "Motor Screw Displacement" begin
        using PGA3D, Test, SafeTestsets, Logging, PrettyPrinting, StaticArrays, Random, LinearAlgebra
        for i in 1:100
            testfrom = Point3D(randn(3)...)
            testto = Point3D(randn(3)...)
            dist = norm(internal_vec(testfrom) - internal_vec(testto))
            testline = unitize(line_fromto(testfrom, testto))
            mft = motor_screw(testline, 0, dist)
            @test transform(testfrom, mft) ≈ testto
        end
    end

    @safetestset "Motor Screw Rotation" begin
        using PGA3D, Test, SafeTestsets, Logging, PrettyPrinting, StaticArrays, Random, LinearAlgebra
        for i in 1:100
            testfrom = Point3D(normalize(randn(3))...)
            testto = Point3D(normalize(randn(3))...)
            testfromar = SA[testfrom[1], testfrom[2], testfrom[3]]
            testtoar = SA[testto[1], testto[2], testto[3]]
            y = cross(testfromar, testtoar)
            x = dot(testfromar, testtoar)
            angle = atan(norm(y), x)
            testline = unitize(line_fromto(Point3D(0.0, 0.0, 0.0), Point3D(y...)))
            mft = motor_screw(testline, angle, 0)
            rotatedfrom = transform(testfrom, mft)
            @test rotatedfrom ≈ testto
        end
    end
end