using PGA3D
using Documenter

DocMeta.setdocmeta!(PGA3D, :DocTestSetup, :(using PGA3D); recursive=true)

makedocs(;
    modules=[PGA3D],
    authors="Aperiodic Laboratories",
    repo="https://github.com/zoemcc/PGA3D.jl/blob/{commit}{path}#{line}",
    sitename="PGA3D.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://zoemcc.github.io/PGA3D.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/zoemcc/PGA3D.jl",
    devbranch="main",
)
