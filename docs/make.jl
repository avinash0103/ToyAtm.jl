using ToyAtm
using Documenter

DocMeta.setdocmeta!(ToyAtm, :DocTestSetup, :(using ToyAtm); recursive=true)

makedocs(;
    modules=[ToyAtm],
    authors="Avinash Verma <avinash.verma@niser.ac.in> and contributors",
    sitename="ToyAtm.jl",
    format=Documenter.HTML(;
        canonical="https://avinash0103.github.io/ToyAtm.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/avinash0103/ToyAtm.jl",
    devbranch="main",
)
