module ToneValueAverage

    using CSV, DataFrames, Images, ImageMagick, Pkg, Statistics

    filedir = dirname(@__FILE__)

    images = readdir(joinpath(filedir, "..", "images"))
    images = images[map(x -> !occursin(r"^\.(.)*", x), images)]

    averages = Float64[]
    for image in images
        tonevalue = load(joinpath(filedir, "..", "images", image))
        push!(averages, Float64(mean(channelview(tonevalue)[channelview(tonevalue) .!= 0])))
    end

    @show result = DataFrame(name = images, value = averages)
    result |> CSV.write(joinpath(filedir, "..", "out", "averages.csv"))

    averagematrix = fill(mean(result.value), 3, 300, 300)
    averagecolorimage = colorview(RGB, averagematrix)
    save(joinpath(filedir, "..", "out", "averageColor.png"), averagecolorimage)

end # module
